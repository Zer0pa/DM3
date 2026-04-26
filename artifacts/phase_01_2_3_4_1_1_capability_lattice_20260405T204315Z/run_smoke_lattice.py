#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import shlex
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[2]
ARTIFACT_ROOT = Path(__file__).resolve().parent
ROWS_ROOT = ARTIFACT_ROOT / "rows"
COMPARISONS_ROOT = ARTIFACT_ROOT / "comparisons"
BASELINE_CONFIG_SOURCE = (
    REPO_ROOT
    / "artifacts/phase_01_2_3_4_1_1_rescue_pack_20260405T202422Z/device_snapshot/f1_workspace/workspace/configs/CONFIG.json"
)

PHASE = "01.2.3.4.1.1"
PLAN = "02"
LIVE_LANE_ID = "rm10_f1_cleanup_control"
DEVICE_CWD = "/data/local/tmp/SoC_runtime/workspace"
BINARY_PATH = "/data/local/tmp/genesis_cli"
WRAPPER_SURFACE = "/data/local/tmp/SoC_Harness/bin"
EXPECTED_MODEL = "NX789J"
EXPECTED_SERIAL = "FY25013101C8"
LIVE_OUTPUT_ROOT = "audit"
SESSION_TIMESTAMP = "20260405T204315Z"


@dataclass(frozen=True)
class Row:
    row_id: str
    role: str
    config: str | None
    perturbation_family: str
    perturbation_summary: str
    expectation: str


ROW_SET = [
    Row(
        row_id="r00_control_default_a",
        role="control",
        config=None,
        perturbation_family="baseline",
        perturbation_summary="No config override; cleaned-lane reset baseline.",
        expectation="Control anchor for first-result gate.",
    ),
    Row(
        row_id="r01_control_default_b",
        role="control-repeat",
        config=None,
        perturbation_family="baseline",
        perturbation_summary="Repeated no-override baseline to test short-window persistence.",
        expectation="Should reproduce r00 semantically if the lane is stable.",
    ),
    Row(
        row_id="r10_priors_off_a",
        role="candidate",
        config="configs/CONFIG.no_priors.json",
        perturbation_family="priors",
        perturbation_summary="Disable Sanskrit adjacency and yantra priors.",
        expectation="First-result candidate row.",
    ),
    Row(
        row_id="r11_priors_off_b",
        role="candidate-repeat",
        config="configs/CONFIG.no_priors.json",
        perturbation_family="priors",
        perturbation_summary="Repeated priors-off row.",
        expectation="Tests whether any candidate response survives a repeat.",
    ),
    Row(
        row_id="r20_lpe_off",
        role="orthogonal-candidate",
        config="configs/CONFIG.m2_lpe_off.json",
        perturbation_family="state-initialization",
        perturbation_summary="Disable laplacian positional encoding while retaining harmonic family.",
        expectation="Orthogonal probe for encoding sensitivity.",
    ),
    Row(
        row_id="r30_nonharmonic",
        role="orthogonal-candidate",
        config="configs/CONFIG.m1_nonharmonic.json",
        perturbation_family="input-family",
        perturbation_summary="Swap harmonic drives to a nonharmonic set.",
        expectation="Orthogonal probe for family sensitivity.",
    ),
]


def utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def write_text(path: Path, content: str) -> None:
    ensure_dir(path.parent)
    path.write_text(content, encoding="utf-8")


def write_json(path: Path, payload: dict[str, Any] | list[Any]) -> None:
    ensure_dir(path.parent)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def hash_payload(payload: Any) -> str:
    body = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode("utf-8")
    return hashlib.sha256(body).hexdigest()


def current_branch(repo_root: Path) -> str:
    result = subprocess.run(
        ["git", "-C", str(repo_root), "branch", "--show-current"],
        check=True,
        capture_output=True,
        text=True,
    )
    branch = result.stdout.strip()
    if not branch:
        raise SystemExit("Unable to resolve current git branch.")
    return branch


def run_command(command: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=check, capture_output=True, text=True)


def adb_prefix(serial: str | None) -> list[str]:
    prefix = ["adb"]
    if serial:
        prefix.extend(["-s", serial])
    return prefix


def adb(serial: str | None, *args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return run_command(adb_prefix(serial) + list(args), check=check)


def adb_shell(serial: str | None, shell_command: str, *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return adb(serial, "shell", shell_command, check=check)


def record_process(
    result: subprocess.CompletedProcess[str],
    stdout_path: Path,
    stderr_path: Path,
    exit_code_path: Path | None = None,
) -> None:
    write_text(stdout_path, result.stdout)
    write_text(stderr_path, result.stderr)
    if exit_code_path is not None:
        write_text(exit_code_path, f"{result.returncode}\n")


def device_quote(value: str) -> str:
    return shlex.quote(value)


def parse_sha256sum(output: str) -> str:
    token = output.strip().split()
    if not token:
        raise SystemExit("sha256sum returned no output.")
    return token[0]


def resolve_serial(requested: str | None, adb_devices_output: str) -> str:
    if requested:
        return requested
    live = [
        line
        for line in adb_devices_output.splitlines()[1:]
        if line.strip() and " device " in f" {line} "
    ]
    if len(live) != 1:
        raise SystemExit("Specify --serial or attach exactly one adb device.")
    return live[0].split()[0]


def capture_shell_output(serial: str | None, command: str, destination: Path) -> None:
    result = adb_shell(serial, command)
    write_text(destination, result.stdout)


def device_props(serial: str | None) -> dict[str, str]:
    props = {
        "ro.product.model": adb_shell(serial, "getprop ro.product.model").stdout.strip(),
        "ro.build.fingerprint": adb_shell(serial, "getprop ro.build.fingerprint").stdout.strip(),
        "ro.hardware.vulkan": adb_shell(serial, "getprop ro.hardware.vulkan").stdout.strip(),
        "ro.hardware.egl": adb_shell(serial, "getprop ro.hardware.egl").stdout.strip(),
    }
    return props


def strip_config_echo(value: Any) -> Any:
    if isinstance(value, dict):
        cleaned = {}
        for key, item in value.items():
            if key in {"cfg_hash", "timestamp", "ts_utc"}:
                continue
            cleaned[key] = strip_config_echo(item)
        return cleaned
    if isinstance(value, list):
        return [strip_config_echo(item) for item in value]
    return value


def load_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def parse_battery_metrics(raw: str) -> dict[str, Any]:
    metrics: dict[str, Any] = {}
    for line in raw.splitlines():
        stripped = line.strip()
        if stripped.startswith("level:"):
            metrics["level"] = int(stripped.split(":", 1)[1].strip())
        elif stripped.startswith("temperature:"):
            raw_value = int(stripped.split(":", 1)[1].strip())
            metrics["temperature_raw"] = raw_value
            metrics["temperature_c"] = raw_value / 10.0
        elif stripped.startswith("AC powered:"):
            metrics["ac_powered"] = stripped.split(":", 1)[1].strip().lower() == "true"
    return metrics


def parse_thermal_metrics(raw: str) -> dict[str, Any]:
    metrics: dict[str, Any] = {}
    for line in raw.splitlines():
        stripped = line.strip()
        if stripped.startswith("Thermal Status:"):
            metrics["thermal_status"] = int(stripped.split(":", 1)[1].strip())
            break
    return metrics


def semantic_observables(
    verify_json: dict[str, Any],
    solve_json: dict[str, Any],
    summary_json: dict[str, Any],
) -> dict[str, Any]:
    verify_semantic = strip_config_echo(verify_json)
    solve_semantic = strip_config_echo(solve_json)
    summary_semantic = strip_config_echo(summary_json)

    solve_report = solve_semantic.get("report", {})
    solve_notes = solve_report.get("notes", {})
    verify_gates = verify_semantic.get("gate_summary", {})
    summary_gates = summary_semantic.get("gates", {})

    semantic_triplet = {
        "verify_digest": hash_payload(verify_semantic),
        "solve_digest": hash_payload(solve_semantic),
        "summary_digest": hash_payload(summary_semantic),
    }

    return {
        "semantic_triplet": semantic_triplet,
        "semantic_digest": hash_payload(semantic_triplet),
        "human_readable_anchor": {
            "verify_gates": verify_gates,
            "summary_gates": summary_gates,
            "solve_report_flags": {
                "delta_e_monotone": solve_report.get("delta_e_monotone"),
                "jac_spectral_bound_ok": solve_report.get("jac_spectral_bound_ok"),
                "mode_lock_pass": solve_report.get("mode_lock_pass"),
            },
            "solve_notes": solve_notes,
            "x_star_sample": solve_semantic.get("solution", {}).get("x_star_sample"),
        },
    }


def row_output_dir(row: Row) -> str:
    return f"{LIVE_OUTPUT_ROOT}/phase_01_2_3_4_1_1_capability_lattice_{SESSION_TIMESTAMP}_{row.row_id}"


def command_exact(row: Row) -> str:
    parts = [
        f"PATH={WRAPPER_SURFACE}:$PATH",
        device_quote(BINARY_PATH),
        "--protocol",
        "--runs",
        "1",
        "--output-dir",
        device_quote(row_output_dir(row)),
    ]
    if row.config:
        parts.extend(["--config", device_quote(row.config)])
    body = " ".join(parts)
    return f"adb shell {shlex.quote(f'cd {device_quote(DEVICE_CWD)} && {body}')}"


def selected_rows(args: argparse.Namespace) -> list[Row]:
    if not args.rows:
        return ROW_SET
    requested = set(args.rows)
    rows = [row for row in ROW_SET if row.row_id in requested]
    missing = sorted(requested - {row.row_id for row in rows})
    if missing:
        raise SystemExit(f"Unknown row ids: {', '.join(missing)}")
    return rows


def run_row(
    row: Row,
    serial: str,
    branch: str,
    props: dict[str, str],
    binary_sha: str,
) -> dict[str, Any]:
    row_root = ROWS_ROOT / row.row_id
    identity_root = row_root / "identity"
    telemetry_root = row_root / "telemetry"
    logs_root = row_root / "logs"
    receipts_root = row_root / "receipts"
    ensure_dir(identity_root)
    ensure_dir(telemetry_root)
    ensure_dir(logs_root)
    ensure_dir(receipts_root)

    run_id = Path(row_output_dir(row)).name
    if not BASELINE_CONFIG_SOURCE.is_file():
        raise SystemExit(f"Missing baseline config source: {BASELINE_CONFIG_SOURCE}")

    baseline_push = adb(
        serial,
        "push",
        str(BASELINE_CONFIG_SOURCE),
        f"{DEVICE_CWD}/configs/CONFIG.json",
        check=False,
    )
    record_process(
        baseline_push,
        logs_root / "baseline_push_stdout.txt",
        logs_root / "baseline_push_stderr.txt",
        logs_root / "baseline_push_exit_code.txt",
    )
    if baseline_push.returncode != 0:
        raise SystemExit(f"Failed to restore baseline config for {row.row_id}")
    restored_baseline_sha = parse_sha256sum(
        adb_shell(serial, f"cd {device_quote(DEVICE_CWD)} && sha256sum configs/CONFIG.json").stdout
    )

    write_text(identity_root / "command.txt", command_exact(row) + "\n")
    write_json(
        identity_root / "row_definition.json",
        {
            "row_id": row.row_id,
            "role": row.role,
            "perturbation_family": row.perturbation_family,
            "perturbation_summary": row.perturbation_summary,
            "expectation": row.expectation,
            "config": row.config,
            "device_output_dir": row_output_dir(row),
        },
    )
    write_json(
        identity_root / "run_identity.json",
        {
            "phase": PHASE,
            "plan": PLAN,
            "row_id": row.row_id,
            "run_id": run_id,
            "lane_id": LIVE_LANE_ID,
            "device_cwd": DEVICE_CWD,
            "binary_path": BINARY_PATH,
            "binary_sha256": binary_sha,
            "wrapper_surface": f"PATH={WRAPPER_SURFACE}:$PATH",
            "baseline_config_source": str(BASELINE_CONFIG_SOURCE),
            "baseline_config_sha256": restored_baseline_sha,
            "branch": branch,
            "device_model": props["ro.product.model"],
            "device_serial": serial,
            "started_at_utc": utc_now(),
        },
    )
    write_text(identity_root / "device_props.txt", "".join(f"{k}={v}\n" for k, v in props.items()))
    write_text(
        identity_root / "baseline_restore_sha256.txt",
        f"{restored_baseline_sha}  configs/CONFIG.json\n",
    )
    if row.config:
        config_sha = parse_sha256sum(
            adb_shell(serial, f"cd {device_quote(DEVICE_CWD)} && sha256sum {device_quote(row.config)}").stdout
        )
        write_text(identity_root / "config_sha256.txt", f"{config_sha}  {row.config}\n")
    else:
        write_text(identity_root / "config_sha256.txt", "baseline-reset-only\n")

    capture_shell_output(serial, f"cd {device_quote(DEVICE_CWD)} && env | sort", identity_root / "env.txt")
    capture_shell_output(serial, "dumpsys battery", telemetry_root / "battery_pre.txt")
    capture_shell_output(serial, "dumpsys thermalservice", telemetry_root / "thermal_pre.txt")
    capture_shell_output(serial, "cat /proc/meminfo | sed -n '1,80p'", telemetry_root / "meminfo_pre.txt")

    parts = [
        f"PATH={WRAPPER_SURFACE}:$PATH",
        device_quote(BINARY_PATH),
        "--protocol",
        "--runs",
        "1",
        "--output-dir",
        device_quote(row_output_dir(row)),
    ]
    if row.config:
        parts.extend(["--config", device_quote(row.config)])
    device_command = f"cd {device_quote(DEVICE_CWD)} && {' '.join(parts)}"
    run_result = adb_shell(serial, device_command, check=False)
    record_process(run_result, logs_root / "stdout.txt", logs_root / "stderr.txt", logs_root / "exit_code.txt")

    capture_shell_output(serial, "dumpsys battery", telemetry_root / "battery_post.txt")
    capture_shell_output(serial, "dumpsys thermalservice", telemetry_root / "thermal_post.txt")
    capture_shell_output(serial, "cat /proc/meminfo | sed -n '1,80p'", telemetry_root / "meminfo_post.txt")

    pull_result = adb(serial, "pull", f"{DEVICE_CWD}/{row_output_dir(row)}", str(receipts_root), check=False)
    record_process(
        pull_result,
        logs_root / "adb_pull_stdout.txt",
        logs_root / "adb_pull_stderr.txt",
        logs_root / "adb_pull_exit_code.txt",
    )

    local_receipt_root = receipts_root / run_id
    verify_path = local_receipt_root / "run00" / "artifacts" / "verify.json"
    solve_path = local_receipt_root / "run00" / "artifacts" / "solve_h2.json"
    summary_path = local_receipt_root / "run00" / "receipts" / "VERIFY_SUMMARY.json"
    if not verify_path.is_file() or not solve_path.is_file() or not summary_path.is_file():
        raise SystemExit(f"Missing comparable receipts under {local_receipt_root}")

    verify_sha = sha256_file(verify_path)
    solve_sha = sha256_file(solve_path)
    default_validate_command = (
        f"cd {device_quote(DEVICE_CWD)} && PATH={WRAPPER_SURFACE}:$PATH "
        f"{device_quote(BINARY_PATH)} --validate --reference-dir {device_quote(row_output_dir(row))}/run00"
    )
    default_result = adb_shell(serial, default_validate_command, check=False)
    record_process(
        default_result,
        logs_root / "validate_default_stdout.txt",
        logs_root / "validate_default_stderr.txt",
        logs_root / "validate_default_exit_code.txt",
    )
    explicit_result = adb_shell(
        serial,
        f"{default_validate_command} --verify-hash {verify_sha} --solve-hash {solve_sha}",
        check=False,
    )
    record_process(
        explicit_result,
        logs_root / "validate_explicit_stdout.txt",
        logs_root / "validate_explicit_stderr.txt",
        logs_root / "validate_explicit_exit_code.txt",
    )

    verify_json = load_json(verify_path)
    solve_json = load_json(solve_path)
    summary_json = load_json(summary_path)
    anchor = semantic_observables(verify_json, solve_json, summary_json)

    battery_pre = parse_battery_metrics((telemetry_root / "battery_pre.txt").read_text(encoding="utf-8"))
    battery_post = parse_battery_metrics((telemetry_root / "battery_post.txt").read_text(encoding="utf-8"))
    thermal_pre = parse_thermal_metrics((telemetry_root / "thermal_pre.txt").read_text(encoding="utf-8"))
    thermal_post = parse_thermal_metrics((telemetry_root / "thermal_post.txt").read_text(encoding="utf-8"))

    drift = {
        "device_model": props["ro.product.model"],
        "device_serial": serial,
        "binary_sha256": binary_sha,
        "cwd": DEVICE_CWD,
        "wrapper_surface": f"PATH={WRAPPER_SURFACE}:$PATH",
        "battery_pre": battery_pre,
        "battery_post": battery_post,
        "thermal_pre": thermal_pre,
        "thermal_post": thermal_post,
        "thermal_status_nominal": thermal_pre.get("thermal_status") == 0 and thermal_post.get("thermal_status") == 0,
        "battery_delta_c": round(
            battery_post.get("temperature_c", 0.0) - battery_pre.get("temperature_c", 0.0),
            3,
        ),
    }

    row_summary = {
        "row_id": row.row_id,
        "role": row.role,
        "phase": PHASE,
        "plan": PLAN,
        "lane_id": LIVE_LANE_ID,
        "config": row.config,
        "perturbation_family": row.perturbation_family,
        "perturbation_summary": row.perturbation_summary,
        "expectation": row.expectation,
        "command_exact": command_exact(row),
        "device_output_dir": row_output_dir(row),
        "protocol_exit_code": run_result.returncode,
        "adb_pull_exit_code": pull_result.returncode,
        "default_validate_exit_code": default_result.returncode,
        "explicit_validate_exit_code": explicit_result.returncode,
        "raw_hashes": {
            "verify_sha256": verify_sha,
            "solve_sha256": solve_sha,
            "summary_sha256": sha256_file(summary_path),
        },
        "anchor_observable": anchor,
        "drift_observable": drift,
        "receipt_paths": {
            "local_receipt_root": str(local_receipt_root),
            "verify_json": str(verify_path),
            "solve_h2_json": str(solve_path),
            "verify_summary_json": str(summary_path),
        },
        "captured_at_utc": utc_now(),
    }
    write_json(row_root / "summary.json", row_summary)
    return row_summary


def pairwise_matrix(row_summaries: list[dict[str, Any]]) -> list[dict[str, Any]]:
    matrix = []
    for left in row_summaries:
        for right in row_summaries:
            matrix.append(
                {
                    "left": left["row_id"],
                    "right": right["row_id"],
                    "same_semantic_digest": left["anchor_observable"]["semantic_digest"]
                    == right["anchor_observable"]["semantic_digest"],
                    "same_verify_semantic": left["anchor_observable"]["semantic_triplet"]["verify_digest"]
                    == right["anchor_observable"]["semantic_triplet"]["verify_digest"],
                    "same_solve_semantic": left["anchor_observable"]["semantic_triplet"]["solve_digest"]
                    == right["anchor_observable"]["semantic_triplet"]["solve_digest"],
                    "same_summary_semantic": left["anchor_observable"]["semantic_triplet"]["summary_digest"]
                    == right["anchor_observable"]["semantic_triplet"]["summary_digest"],
                }
            )
    return matrix


def collect_existing_summaries() -> list[dict[str, Any]]:
    summaries = []
    for path in sorted(ROWS_ROOT.glob("*/summary.json")):
        summaries.append(load_json(path))
    return summaries


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Run the Phase 01.2.3.4.1.1 Wave 2 capability smoke lattice.")
    parser.add_argument("--serial")
    parser.add_argument("--rows", nargs="*")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    ensure_dir(ROWS_ROOT)
    ensure_dir(COMPARISONS_ROOT)

    adb_devices = adb(None, "devices", "-l")
    write_text(ARTIFACT_ROOT / "adb_devices.txt", adb_devices.stdout)
    serial = resolve_serial(args.serial, adb_devices.stdout)
    branch = current_branch(REPO_ROOT)
    props = device_props(serial)
    if props["ro.product.model"] != EXPECTED_MODEL:
        raise SystemExit(
            f"Device model mismatch: expected {EXPECTED_MODEL}, got {props['ro.product.model']}"
        )
    if serial != EXPECTED_SERIAL:
        write_text(ARTIFACT_ROOT / "serial_note.txt", f"Observed serial {serial}; expected {EXPECTED_SERIAL}.\n")

    binary_sha = parse_sha256sum(adb_shell(serial, f"sha256sum {device_quote(BINARY_PATH)}").stdout)
    write_text(ARTIFACT_ROOT / "binary_sha256.txt", f"{binary_sha}  {BINARY_PATH}\n")
    write_json(
        ARTIFACT_ROOT / "session_manifest.json",
        {
            "phase": PHASE,
            "plan": PLAN,
            "lane_id": LIVE_LANE_ID,
            "device_cwd": DEVICE_CWD,
            "binary_path": BINARY_PATH,
            "binary_sha256": binary_sha,
            "wrapper_surface": f"PATH={WRAPPER_SURFACE}:$PATH",
            "selected_rows": [row.row_id for row in selected_rows(args)],
            "started_at_utc": utc_now(),
            "branch": branch,
        },
    )

    for row in selected_rows(args):
        run_row(row, serial, branch, props, binary_sha)

    summaries = collect_existing_summaries()
    write_json(COMPARISONS_ROOT / "row_summaries.json", summaries)
    write_json(COMPARISONS_ROOT / "semantic_matrix.json", pairwise_matrix(summaries))
    return 0


if __name__ == "__main__":
    sys.exit(main())
