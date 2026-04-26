#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shlex
import subprocess
import sys
import threading
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_DEVICE_CWD = "/data/local/tmp"
DEFAULT_BINARY_PATH = "/data/local/tmp/dm3_runner"
DEFAULT_ALT_BINARY_PATH = "/data/local/tmp/dm3/dm3_runner"
DEFAULT_REQUIRED_FILES = (
    "/data/local/tmp/SriYantraAdj_v1.bin",
    "/data/local/tmp/RegionTags_v1.bin",
    "/data/local/tmp/RegionTags_v2.bin",
    "/data/local/tmp/RegionTags_v2.json",
    "/data/local/tmp/data/xnor_train.jsonl",
)
DEFAULT_PHASE = "01.2.3.4.1"
DEFAULT_PLAN = "f2-outlier-hardened-capture"
DEFAULT_COMET_WORKSPACE = "zer0pa"
DEFAULT_COMET_PROJECT = "dm3"
CPU_DELTA_TIGHT = 0.5
CPU_COHERENCE_TIGHT = 0.01
GPU_DELTA_NEAR = 0.5
GPU_COHERENCE_NEAR = 0.01


@dataclass(frozen=True)
class Row:
    name: str
    lane: str
    force_cpu: bool


ROWS = (
    Row(name="cpu_a", lane="cpu", force_cpu=True),
    Row(name="gpu_a", lane="gpu", force_cpu=False),
    Row(name="gpu_b", lane="gpu", force_cpu=False),
    Row(name="cpu_b", lane="cpu", force_cpu=True),
)
ROW_BY_NAME = {row.name: row for row in ROWS}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run the exact RM10 F2 outlier-localization diagnostic with hardened capture."
    )
    parser.add_argument(
        "--artifact-root",
        help="Artifact root to create. Defaults to artifacts/rm10_f2_outlier_<timestamp>.",
    )
    parser.add_argument(
        "--phase",
        default=DEFAULT_PHASE,
        help=f"Phase label for run identity and Comet metadata. Default: {DEFAULT_PHASE}.",
    )
    parser.add_argument(
        "--plan",
        default=DEFAULT_PLAN,
        help=f"Plan label for run identity and Comet metadata. Default: {DEFAULT_PLAN}.",
    )
    parser.add_argument(
        "--device-cwd",
        default=DEFAULT_DEVICE_CWD,
        help=f"Device working directory. Default: {DEFAULT_DEVICE_CWD}.",
    )
    parser.add_argument(
        "--binary-path",
        default=DEFAULT_BINARY_PATH,
        help=f"Primary residue binary path on device. Default: {DEFAULT_BINARY_PATH}.",
    )
    parser.add_argument(
        "--alt-binary-path",
        default=DEFAULT_ALT_BINARY_PATH,
        help=f"Alternate residue binary to note but not use. Default: {DEFAULT_ALT_BINARY_PATH}.",
    )
    parser.add_argument(
        "--row-timeout-seconds",
        type=int,
        default=180,
        help="Hard timeout for each device row command. Default: 180.",
    )
    parser.add_argument(
        "--sample-interval-seconds",
        type=int,
        default=0,
        help="Periodic telemetry sampling interval during each row. Set to 0 to disable. Default: 0.",
    )
    parser.add_argument(
        "--rows",
        default=",".join(row.name for row in ROWS),
        help="Comma-separated row names to execute in order. Default: cpu_a,gpu_a,gpu_b,cpu_b.",
    )
    parser.add_argument(
        "--comet-mode",
        choices=("offline", "skip"),
        default="offline",
        help="Offline Comet logging is the default. Use skip only when explicitly avoiding Comet.",
    )
    parser.add_argument(
        "--comet-python",
        help="Python interpreter to use for Comet logging. Defaults to .venv/bin/python when present, else the current interpreter.",
    )
    parser.add_argument(
        "--comet-workspace",
        default=DEFAULT_COMET_WORKSPACE,
        help=f"Comet workspace. Default: {DEFAULT_COMET_WORKSPACE}.",
    )
    parser.add_argument(
        "--comet-project",
        default=DEFAULT_COMET_PROJECT,
        help=f"Comet project. Default: {DEFAULT_COMET_PROJECT}.",
    )
    parser.add_argument(
        "--surface-probe-summary",
        help="Path to a retained rm10_f2_surface_probe summary.json. Defaults to the latest retained summary under artifacts/.",
    )
    return parser.parse_args()


def resolve_rows(rows_arg: str) -> tuple[Row, ...]:
    names = [name.strip() for name in rows_arg.split(",") if name.strip()]
    if not names:
        raise SystemExit("At least one row must be selected via --rows.")
    unknown = [name for name in names if name not in ROW_BY_NAME]
    if unknown:
        raise SystemExit(
            "Unknown row name(s): "
            + ", ".join(unknown)
            + ". Valid rows: "
            + ", ".join(ROW_BY_NAME)
        )
    return tuple(ROW_BY_NAME[name] for name in names)


def run_local(
    cmd: list[str],
    *,
    check: bool = True,
    cwd: Path | None = None,
    env: dict[str, str] | None = None,
    timeout: int | None = None,
) -> subprocess.CompletedProcess[str]:
    try:
        completed = subprocess.run(
            cmd,
            cwd=str(cwd) if cwd else None,
            env=env,
            check=False,
            text=True,
            capture_output=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired as exc:
        raise TimeoutError(
            f"Command timed out after {timeout} seconds: {' '.join(shlex.quote(part) for part in cmd)}\n"
            f"STDOUT:\n{exc.stdout or ''}\nSTDERR:\n{exc.stderr or ''}"
        ) from exc
    if check and completed.returncode != 0:
        raise SystemExit(
            f"Command failed ({completed.returncode}): {' '.join(shlex.quote(part) for part in cmd)}\n"
            f"STDOUT:\n{completed.stdout}\nSTDERR:\n{completed.stderr}"
        )
    return completed


def adb_shell(
    command: str,
    *,
    check: bool = True,
    timeout: int | None = None,
) -> subprocess.CompletedProcess[str]:
    return run_local(["adb", "shell", command], check=check, timeout=timeout)


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def append_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        handle.write(content)


def write_json(path: Path, payload: Any) -> None:
    write_text(path, json.dumps(payload, indent=2, sort_keys=False) + "\n")


def write_blocked_packet(
    *,
    artifact_root: Path,
    args: argparse.Namespace,
    branch: str,
    question: str,
    reason: str,
    detail: str,
    surface_probe_gate: dict[str, Any],
    partial_results: list[dict[str, Any]] | None = None,
) -> None:
    identity_root = artifact_root / "identity"
    comparison_root = artifact_root / "comparisons"
    identity_root.mkdir(parents=True, exist_ok=True)
    comparison_root.mkdir(parents=True, exist_ok=True)
    write_text(identity_root / "checkpoint_policy.txt", "rerun-only\n")
    write_json(
        identity_root / "checkpoint_index.json",
        {
            "policy": "rerun-only",
            "attempts": partial_results or [],
        },
    )
    comparison_json = comparison_root / "index.json"
    comparison_tsv = comparison_root / "index.tsv"
    write_json(
        comparison_json,
        {
            "question": question,
            "status": "BLOCKED",
            "reason": reason,
            "detail": detail,
            "surface_probe_gate": surface_probe_gate,
            "rows": partial_results or [],
        },
    )
    lines = ["status\treason\tdetail"]
    lines.append("\t".join(["BLOCKED", reason, detail.replace("\n", " ")]))
    write_text(comparison_tsv, "\n".join(lines) + "\n")
    write_json(
        identity_root / "run_identity.json",
        {
            "run_id": artifact_root.name,
            "branch": branch,
            "phase": args.phase,
            "plan": args.plan,
            "run_kind": "feasibility_probe",
            "authority_status": "feasibility_only",
            "build_class": "exploratory_compiled_residue",
            "observable_family": "f2_harmonic_residue",
            "battery_family": "F2",
            "battery_class": "micro",
            "phase_outcome": "BLOCKED",
            "route_outcome": "root_surface_not_ready",
            "artifact_root": repo_rel(artifact_root),
            "question": question,
            "surface_probe_summary": surface_probe_gate.get("summary_path"),
        },
    )
    write_text(
        artifact_root / "OUTCOME.md",
        "\n".join(
            [
                "# F2 Outlier Outcome",
                "",
                "- outcome_class: `BLOCKED`",
                f"- reason: {reason}",
                f"- detail: {detail}",
                "- residue classification did not run because the top-level F2 root surface is not yet ready.",
                f"- surface_probe_summary: `{surface_probe_gate.get('summary_path') or 'none'}`",
                f"- comparison_index: `{repo_rel(comparison_tsv)}`",
            ]
        )
        + "\n",
    )


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def repo_rel(path: Path) -> str:
    return path.resolve().relative_to(REPO_ROOT).as_posix()


def detect_branch() -> str:
    completed = run_local(
        ["git", "-C", str(REPO_ROOT), "branch", "--show-current"],
        check=True,
    )
    return completed.stdout.strip()


def default_comet_python(args: argparse.Namespace) -> str:
    if args.comet_python:
        return args.comet_python
    venv_python = REPO_ROOT / ".venv" / "bin" / "python"
    if venv_python.exists():
        return str(venv_python)
    return sys.executable


def ensure_single_device() -> tuple[str, str]:
    devices = run_local(["adb", "devices", "-l"], check=True).stdout.strip().splitlines()
    live = [line for line in devices[1:] if line.strip() and " device " in f" {line} "]
    if len(live) != 1:
        raise SystemExit(f"Expected exactly one attached ADB device, found {len(live)}:\n" + "\n".join(live))
    serial = live[0].split()[0]
    model = adb_shell("getprop ro.product.model").stdout.strip()
    return serial, model


def capture_shell_text(command: str, path: Path) -> None:
    completed = adb_shell(command, check=False)
    write_text(path, completed.stdout)


def ensure_binary_exists(path: str) -> None:
    completed = adb_shell(f"test -f {shlex.quote(path)}", check=False)
    if completed.returncode != 0:
        raise SystemExit(f"Required device file is missing: {path}")


def ensure_device_files(paths: tuple[str, ...]) -> None:
    missing: list[str] = []
    for path in paths:
        completed = adb_shell(f"test -f {shlex.quote(path)}", check=False)
        if completed.returncode != 0:
            missing.append(path)
    if missing:
        joined = "\n".join(f"- {path}" for path in missing)
        raise SystemExit(f"Required device files are missing:\n{joined}")


def make_artifact_root(arg_value: str | None) -> Path:
    if arg_value:
        return (REPO_ROOT / arg_value).resolve() if not arg_value.startswith("/") else Path(arg_value).resolve()
    stamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
    return (REPO_ROOT / "artifacts" / f"rm10_f2_outlier_{stamp}").resolve()


def latest_surface_probe_summary() -> Path | None:
    candidates = sorted((REPO_ROOT / "artifacts").glob("rm10_f2_surface_probe_*/summary.json"))
    return candidates[-1] if candidates else None


def resolve_surface_probe_summary(path_arg: str | None) -> Path | None:
    if path_arg:
        path = Path(path_arg)
        return path.resolve() if path.is_absolute() else (REPO_ROOT / path).resolve()
    return latest_surface_probe_summary()


def load_surface_probe_gate(path: Path | None) -> dict[str, Any]:
    if path is None or not path.exists():
        return {
            "ready": False,
            "reason": "No retained F2 surface probe summary exists yet.",
            "summary_path": None,
            "root_cpu_default": None,
        }
    payload = json.loads(path.read_text(encoding="utf-8"))
    scenarios = {item["name"]: item for item in payload.get("scenarios", [])}
    root_default = scenarios.get("root_cpu_default")
    if root_default is None:
        return {
            "ready": False,
            "reason": "The retained F2 surface probe is missing the root_cpu_default scenario.",
            "summary_path": str(path),
            "root_cpu_default": None,
        }
    classification = root_default.get("classification")
    if classification != "callable":
        return {
            "ready": False,
            "reason": f"The retained F2 surface probe classifies root_cpu_default as `{classification}`.",
            "summary_path": str(path),
            "root_cpu_default": root_default,
        }
    return {
        "ready": True,
        "reason": "The retained F2 surface probe shows root_cpu_default as callable.",
        "summary_path": str(path),
        "root_cpu_default": root_default,
    }


def session_slug(artifact_root: Path) -> str:
    return artifact_root.name


def current_env_text(device_cwd: str) -> str:
    completed = adb_shell(f"cd {shlex.quote(device_cwd)} && env | sort", check=True)
    return completed.stdout


def current_device_props_text() -> str:
    return adb_shell("getprop | sort", check=True).stdout


def current_listing_text(device_cwd: str, alt_binary_path: str) -> str:
    command = (
        f"ls -la {shlex.quote(device_cwd)}; "
        f"echo; "
        f"echo '--- required residue files ---'; "
        f"ls -l /data/local/tmp/SriYantraAdj_v1.bin "
        f"/data/local/tmp/RegionTags_v1.bin "
        f"/data/local/tmp/RegionTags_v2.bin "
        f"/data/local/tmp/RegionTags_v2.json "
        f"/data/local/tmp/data/xnor_train.jsonl 2>/dev/null || true; "
        f"echo; "
        f"echo '--- alternate residue binary ---'; "
        f"ls -l {shlex.quote(alt_binary_path)} 2>/dev/null || echo 'missing'"
    )
    return adb_shell(command, check=False).stdout


def current_hash_text(binary_path: str, alt_binary_path: str) -> str:
    command = (
        f"sha256sum {shlex.quote(binary_path)} "
        f"{shlex.quote(alt_binary_path)} "
        f"/data/local/tmp/SriYantraAdj_v1.bin "
        f"/data/local/tmp/RegionTags_v1.bin "
        f"/data/local/tmp/RegionTags_v2.bin "
        f"/data/local/tmp/RegionTags_v2.json "
        f"/data/local/tmp/data/xnor_train.jsonl 2>/dev/null || true"
    )
    return adb_shell(command, check=False).stdout


def current_help_text(device_cwd: str, binary_path: str) -> tuple[str, str]:
    completed = adb_shell(
        f"cd {shlex.quote(device_cwd)} && {shlex.quote(binary_path)} --help",
        check=False,
    )
    return completed.stdout, completed.stderr


def current_runner_snapshot() -> str:
    return adb_shell(
        "ps -A -o PID,PPID,STAT,TIME,ARGS | grep dm3_runner | grep -v grep || true",
        check=False,
    ).stdout


def current_loadavg() -> str:
    return adb_shell("cat /proc/loadavg", check=False).stdout.strip()


def capture_telemetry(prefix: str, root: Path) -> dict[str, str]:
    battery_path = root / f"{prefix}_battery.txt"
    thermal_path = root / f"{prefix}_thermal.txt"
    meminfo_path = root / f"{prefix}_meminfo.txt"
    capture_shell_text("dumpsys battery", battery_path)
    capture_shell_text("dumpsys thermalservice", thermal_path)
    capture_shell_text("cat /proc/meminfo | sed -n '1,120p'", meminfo_path)
    return {
        "battery": repo_rel(battery_path),
        "thermal": repo_rel(thermal_path),
        "meminfo": repo_rel(meminfo_path),
    }


def parse_battery_temp(raw: str) -> float | None:
    for line in raw.splitlines():
        stripped = line.strip()
        if stripped.startswith("temperature:"):
            try:
                return int(stripped.split(":", 1)[1].strip()) / 10.0
            except ValueError:
                return None
    return None


def parse_battery_level(raw: str) -> int | None:
    for line in raw.splitlines():
        stripped = line.strip()
        if stripped.startswith("level:"):
            try:
                return int(stripped.split(":", 1)[1].strip())
            except ValueError:
                return None
    return None


def parse_thermal_status(raw: str) -> int | None:
    for line in raw.splitlines():
        stripped = line.strip()
        if stripped.startswith("Thermal Status:"):
            try:
                return int(stripped.split(":", 1)[1].strip())
            except ValueError:
                return None
    return None


def sample_row_telemetry(
    *,
    interval_seconds: int,
    destination: Path,
    stop_event: threading.Event,
) -> None:
    while not stop_event.is_set():
        timestamp = datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ")
        try:
            battery_raw = adb_shell("dumpsys battery", check=False).stdout
            thermal_raw = adb_shell("dumpsys thermalservice", check=False).stdout
            payload = {
                "timestamp_utc": timestamp,
                "battery_level": parse_battery_level(battery_raw),
                "battery_temp_c": parse_battery_temp(battery_raw),
                "thermal_status": parse_thermal_status(thermal_raw),
                "loadavg": current_loadavg(),
                "runner_snapshot": current_runner_snapshot().strip(),
            }
        except Exception as exc:  # pragma: no cover - best-effort capture
            payload = {
                "timestamp_utc": timestamp,
                "sample_error": str(exc),
            }
        append_text(destination, json.dumps(payload, sort_keys=False) + "\n")
        if stop_event.wait(interval_seconds):
            break


def detect_marker(stdout: str, stderr: str, lane: str) -> str:
    combined = f"{stdout}\n{stderr}"
    if "Forcing CPU Mode (GPU Disabled)" in combined:
        return "cpu_forced"
    if (
        "GPU MatMul Kernel Initialized" in combined
        or "GPU Transformer Kernel Initialized" in combined
        or "adapter max_compute_workgroup_storage_size" in combined
    ):
        return "gpu_init"
    return f"{lane}_marker_missing"


def build_device_command(
    *,
    device_cwd: str,
    binary_path: str,
    output_path: str,
    force_cpu: bool,
    row_timeout_seconds: int,
) -> str:
    cpu_flag = " --cpu" if force_cpu else ""
    return (
        f"cd {shlex.quote(device_cwd)} && "
        f"rm -f {shlex.quote(output_path)} && "
        f"/system/bin/timeout {int(row_timeout_seconds)} "
        f"{shlex.quote(binary_path)} --mode train --task harmonic --steps 1"
        f"{cpu_flag} --output {shlex.quote(output_path)}"
    )


def short_output_name(session_id: str, row_name: str) -> str:
    suffix = session_id.split("_")[-1]
    return f"f2_{suffix}_{row_name}.jsonl"


def kill_residue_runners() -> None:
    adb_shell("pkill -TERM dm3_runner 2>/dev/null || true", check=False)
    adb_shell("sleep 1", check=False)
    adb_shell("pkill -KILL dm3_runner 2>/dev/null || true", check=False)


def run_row(
    *,
    row: Row,
    artifact_root: Path,
    session_id: str,
    branch: str,
    args: argparse.Namespace,
    serial: str,
    model: str,
    binary_sha256: str,
    env_path: Path,
    device_props_path: Path,
    question: str,
) -> dict[str, Any]:
    row_root = artifact_root / "rows" / row.name
    identity_root = row_root / "identity"
    logs_root = row_root / "logs"
    telemetry_root = row_root / "telemetry"
    receipts_root = row_root / "receipts"
    metrics_root = row_root / "metrics"
    for directory in (identity_root, logs_root, telemetry_root, receipts_root, metrics_root):
        directory.mkdir(parents=True, exist_ok=True)

    run_id = f"{session_id}_{row.name}"
    output_name = short_output_name(session_id, row.name)
    device_output_path = f"{args.device_cwd}/{output_name}"
    command_text = build_device_command(
        device_cwd=args.device_cwd,
        binary_path=args.binary_path,
        output_path=device_output_path,
        force_cpu=row.force_cpu,
        row_timeout_seconds=args.row_timeout_seconds,
    )
    write_text(identity_root / "command.txt", f"adb shell {shlex.quote(command_text)}\n")
    write_text(identity_root / "env.txt", env_path.read_text(encoding="utf-8"))
    write_text(identity_root / "device_props.txt", device_props_path.read_text(encoding="utf-8"))
    write_text(identity_root / "checkpoint_policy.txt", "rerun-only\n")
    kill_residue_runners()
    write_text(identity_root / "runner_snapshot_before_command.txt", current_runner_snapshot())

    start_utc = datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ")
    write_text(identity_root / "start_utc.txt", start_utc + "\n")
    pre_paths = capture_telemetry("pre", telemetry_root)
    periodic_samples_path = telemetry_root / "periodic_samples.jsonl"
    sampler_stop = threading.Event()
    sampler_thread: threading.Thread | None = None
    if args.sample_interval_seconds > 0:
        sampler_thread = threading.Thread(
            target=sample_row_telemetry,
            kwargs={
                "interval_seconds": args.sample_interval_seconds,
                "destination": periodic_samples_path,
                "stop_event": sampler_stop,
            },
            daemon=True,
        )
        sampler_thread.start()
    try:
        completed = adb_shell(command_text, check=False, timeout=args.row_timeout_seconds)
    except TimeoutError as exc:
        sampler_stop.set()
        if sampler_thread is not None:
            sampler_thread.join(timeout=max(1, args.sample_interval_seconds + 2))
        kill_residue_runners()
        raise SystemExit(f"Row {row.name} timed out and residue runners were terminated.\n{exc}") from exc
    finally:
        sampler_stop.set()
        if sampler_thread is not None:
            sampler_thread.join(timeout=max(1, args.sample_interval_seconds + 2))
    write_text(logs_root / "stdout.txt", completed.stdout)
    write_text(logs_root / "stderr.txt", completed.stderr)
    post_paths = capture_telemetry("post", telemetry_root)
    end_utc = datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ")
    write_text(identity_root / "end_utc.txt", end_utc + "\n")

    pull = run_local(
        ["adb", "pull", device_output_path, str(receipts_root / output_name)],
        check=False,
    )
    write_text(logs_root / "pull.txt", pull.stdout + pull.stderr)
    if completed.returncode != 0:
        raise SystemExit(f"Row {row.name} failed with exit code {completed.returncode}")
    if pull.returncode != 0:
        raise SystemExit(f"Failed to pull receipt for row {row.name}: {pull.stderr}")

    receipt_path = receipts_root / output_name
    receipt_line = receipt_path.read_text(encoding="utf-8").strip()
    receipt_payload = json.loads(receipt_line)
    if not isinstance(receipt_payload, dict):
        raise SystemExit(f"Receipt payload for row {row.name} is not an object")

    marker = detect_marker(completed.stdout, completed.stderr, row.lane)
    battery_pre_raw = (telemetry_root / "pre_battery.txt").read_text(encoding="utf-8")
    battery_post_raw = (telemetry_root / "post_battery.txt").read_text(encoding="utf-8")
    thermal_pre_raw = (telemetry_root / "pre_thermal.txt").read_text(encoding="utf-8")
    thermal_post_raw = (telemetry_root / "post_thermal.txt").read_text(encoding="utf-8")

    metrics_payload = {
        "run_id": run_id,
        "lane": row.lane,
        "marker": marker,
        "decision": receipt_payload.get("decision"),
        "delta_E": receipt_payload.get("delta_E"),
        "coherence": receipt_payload.get("coherence"),
        "duration_ms": receipt_payload.get("duration_ms"),
        "episode": receipt_payload.get("episode"),
        "receipt_sha256": sha256_file(receipt_path),
        "exit_code": completed.returncode,
        "battery_temp_pre_c": parse_battery_temp(battery_pre_raw),
        "battery_temp_post_c": parse_battery_temp(battery_post_raw),
        "thermal_status_pre": parse_thermal_status(thermal_pre_raw),
        "thermal_status_post": parse_thermal_status(thermal_post_raw),
    }
    metrics_path = metrics_root / "metrics.json"
    write_json(metrics_path, metrics_payload)

    run_identity = {
        "run_id": run_id,
        "branch": branch,
        "phase": args.phase,
        "plan": args.plan,
        "hypothesis_branch": branch,
        "run_kind": "feasibility_probe",
        "authority_status": "feasibility_only",
        "build_class": "exploratory_compiled_residue",
        "observable_family": "f2_harmonic_residue",
        "battery_family": "F2",
        "battery_class": "micro",
        "device_lane": "rm10_root_hybrid_smoke",
        "compute_lane": row.lane,
        "machine_class": "rm10_device",
        "command_surface": "dm3_runner",
        "command_exact": command_text,
        "cwd": args.device_cwd,
        "artifact_root": repo_rel(row_root),
        "device_serial": serial,
        "device_model": model,
        "binary_path": args.binary_path,
        "binary_sha256": binary_sha256,
        "receipt_expected": True,
        "primary_receipt_path_or_none": repo_rel(receipt_path),
        "checkpoint_id": f"{run_id}:rerun-only",
        "checkpoint_parent": None,
        "phase_outcome": "PASS",
        "route_outcome": "NOT_APPLICABLE",
        "question": question,
        "env_path": repo_rel(env_path),
        "device_props_path": repo_rel(device_props_path),
        "logs": {
            "stdout": repo_rel(logs_root / "stdout.txt"),
            "stderr": repo_rel(logs_root / "stderr.txt"),
            "pull": repo_rel(logs_root / "pull.txt"),
        },
        "telemetry": {
            "battery_pre": pre_paths["battery"],
            "battery_post": post_paths["battery"],
            "thermal_pre": pre_paths["thermal"],
            "thermal_post": post_paths["thermal"],
            "meminfo_pre": pre_paths["meminfo"],
            "meminfo_post": post_paths["meminfo"],
            "periodic_samples": repo_rel(periodic_samples_path) if args.sample_interval_seconds > 0 else None,
        },
    }
    write_json(identity_root / "run_identity.json", run_identity)
    write_json(
        identity_root / "checkpoint_index.json",
        {
            "policy": "rerun-only",
            "attempts": [
                {
                    "name": row.name,
                    "run_id": run_id,
                    "lane": row.lane,
                    "exit_code": completed.returncode,
                    "device_receipt": device_output_path,
                    "receipt_sha256": metrics_payload["receipt_sha256"],
                    "command_path": repo_rel(identity_root / "command.txt"),
                    "start_utc": start_utc,
                    "end_utc": end_utc,
                }
            ],
        },
    )

    return {
        "row": row.name,
        "run_id": run_id,
        "lane": row.lane,
        "command_path": repo_rel(identity_root / "command.txt"),
        "run_identity_path": repo_rel(identity_root / "run_identity.json"),
        "receipt_path": repo_rel(receipt_path),
        "metrics_path": repo_rel(metrics_path),
        "device_output_path": device_output_path,
        "receipt_sha256": metrics_payload["receipt_sha256"],
        "marker": marker,
        "decision": metrics_payload["decision"],
        "delta_E": metrics_payload["delta_E"],
        "coherence": metrics_payload["coherence"],
        "duration_ms": metrics_payload["duration_ms"],
        "exit_code": metrics_payload["exit_code"],
        "battery_temp_pre_c": metrics_payload["battery_temp_pre_c"],
        "battery_temp_post_c": metrics_payload["battery_temp_post_c"],
        "thermal_status_pre": metrics_payload["thermal_status_pre"],
        "thermal_status_post": metrics_payload["thermal_status_post"],
        "periodic_samples_path": repo_rel(periodic_samples_path) if args.sample_interval_seconds > 0 else None,
        "start_utc": start_utc,
        "end_utc": end_utc,
    }


def write_summary(results: list[dict[str, Any]], summary_path: Path) -> None:
    lines = [
        "run_id\tlane\tdecision\tdelta_E\tcoherence\tduration_ms\tstdout_marker",
    ]
    for result in results:
        lines.append(
            "\t".join(
                [
                    result["run_id"],
                    result["lane"],
                    str(result["decision"]),
                    str(result["delta_E"]),
                    str(result["coherence"]),
                    str(result["duration_ms"]),
                    result["marker"],
                ]
            )
        )
    write_text(summary_path, "\n".join(lines) + "\n")


def write_comparison_index(
    *,
    artifact_root: Path,
    results: list[dict[str, Any]],
    question: str,
    session_row_order: list[str],
) -> tuple[Path, Path]:
    comparison_root = artifact_root / "comparisons"
    comparison_root.mkdir(parents=True, exist_ok=True)
    payload = {
        "question": question,
        "row_order": session_row_order,
        "rows": results,
    }
    json_path = comparison_root / "index.json"
    tsv_path = comparison_root / "index.tsv"
    write_json(json_path, payload)
    lines = ["run_id\tlane\treceipt_path\tmetrics_path\tquestion"]
    for result in results:
        lines.append(
            "\t".join(
                [
                    result["run_id"],
                    result["lane"],
                    result["receipt_path"],
                    result["metrics_path"],
                    question,
                ]
            )
        )
    write_text(tsv_path, "\n".join(lines) + "\n")
    return json_path, tsv_path


def write_checkpoint_index(path: Path, results: list[dict[str, Any]]) -> None:
    payload = {
        "policy": "rerun-only",
        "attempts": [
            {
                "name": result["row"],
                "run_id": result["run_id"],
                "lane": result["lane"],
                "exit_code": result["exit_code"],
                "device_receipt": result["device_output_path"],
                "receipt_sha256": result["receipt_sha256"],
                "command_path": result["command_path"],
            }
            for result in results
        ],
    }
    write_json(path, payload)


def classify_outcome(
    results: list[dict[str, Any]],
    session_row_order: list[str],
) -> tuple[str, str]:
    if session_row_order != [row.name for row in ROWS]:
        if len(results) == 1:
            return (
                "partial_replay",
                f"Executed bounded follow-up replay for {session_row_order[0]} only; no full bracket class comparison attempted.",
            )
        return (
            "partial_replay",
            "Executed a bounded subset replay; no full bracket class comparison attempted.",
        )

    cpu_rows = [result for result in results if result["lane"] == "cpu"]
    gpu_rows = [result for result in results if result["lane"] == "gpu"]
    if len(cpu_rows) != 2 or len(gpu_rows) != 2:
        return "uninterpretable", "Expected two CPU rows and two GPU-backed rows."

    cpu_delta_span = max(row["delta_E"] for row in cpu_rows) - min(row["delta_E"] for row in cpu_rows)
    cpu_coherence_span = max(row["coherence"] for row in cpu_rows) - min(row["coherence"] for row in cpu_rows)
    cpu_stable = cpu_delta_span <= CPU_DELTA_TIGHT and cpu_coherence_span <= CPU_COHERENCE_TIGHT
    if not cpu_stable:
        return (
            "whole_session_instability",
            "CPU bracket rows drifted beyond the bounded tolerance, so the session does not support a GPU-only story.",
        )

    cpu_delta_mean = sum(row["delta_E"] for row in cpu_rows) / len(cpu_rows)
    cpu_coherence_mean = sum(row["coherence"] for row in cpu_rows) / len(cpu_rows)

    def near_cpu(row: dict[str, Any]) -> bool:
        return (
            abs(row["delta_E"] - cpu_delta_mean) <= GPU_DELTA_NEAR
            and abs(row["coherence"] - cpu_coherence_mean) <= GPU_COHERENCE_NEAR
        )

    gpu_a, gpu_b = gpu_rows
    if near_cpu(gpu_a) and near_cpu(gpu_b):
        return (
            "startup_sensitive_gpu_outlier",
            "Both GPU-backed rows stayed within the bounded CPU neighborhood, so the earlier outlier does not reproduce as a persistent GPU-local effect.",
        )
    if not near_cpu(gpu_a) and near_cpu(gpu_b):
        return (
            "startup_sensitive_gpu_outlier",
            "The first GPU-backed row drifted while the second returned toward the CPU neighborhood under a locked session.",
        )
    return (
        "persistent_gpu_instability",
        "At least one GPU-backed row remained outside the bounded CPU neighborhood after a stable CPU bracket.",
    )


def build_comet_manifest(
    *,
    artifact_root: Path,
    branch: str,
    args: argparse.Namespace,
    serial: str,
    model: str,
    binary_sha256: str,
    session_id: str,
    question: str,
    outcome_class: str,
    summary_path: Path,
    comparison_index_json: Path,
    checkpoint_index_path: Path,
    session_row_order: list[str],
) -> dict[str, Any]:
    return {
        "name": f"dm3-{session_id}",
        "workspace": args.comet_workspace,
        "project_name": args.comet_project,
        "tags": [
            "restart",
            "dm3",
            branch.replace("/", "-"),
            f"phase-{args.phase}",
            "run-family-f2",
            "run-kind-feasibility_probe",
            "authority-feasibility_only",
            "build-exploratory_compiled_residue",
            "machine-rm10_device",
            "lane-rm10_root_hybrid_smoke",
            "outlier-localization",
        ],
        "parameters": {
            "run_id": session_id,
            "phase": args.phase,
            "plan": args.plan,
            "hypothesis_branch": branch,
            "observable_family": "f2_harmonic_residue",
            "battery_family": "F2",
            "battery_class": "micro",
            "command_surface": "dm3_runner",
            "cwd": args.device_cwd,
            "artifact_root": repo_rel(artifact_root),
            "device_serial": serial,
            "device_model": model,
            "binary_sha256": binary_sha256,
            "receipt_expected": True,
            "checkpoint_id": f"{session_id}:rerun-only",
            "checkpoint_parent": "none",
            "question": question,
            "outcome_class": outcome_class,
        },
        "metrics": [
            {"name": "run/receipt_complete", "value": 1},
            {"name": "run/rows", "value": len(session_row_order)},
        ],
        "others": {
            "artifact_root": repo_rel(artifact_root),
            "summary_path": repo_rel(summary_path),
            "comparison_index_path": repo_rel(comparison_index_json),
            "checkpoint_index_path": repo_rel(checkpoint_index_path),
            "row_order": session_row_order,
            "notes": "Residue classification only, not bridge progress.",
            "route_outcome": "NOT_APPLICABLE",
        },
        "assets": [],
    }


def run_comet_logger(
    *,
    args: argparse.Namespace,
    artifact_root: Path,
    manifest_path: Path,
    key_path: Path,
    stdout_path: Path,
    stderr_path: Path,
    bundle_hint_path: Path,
) -> None:
    if args.comet_mode == "skip":
        write_text(stdout_path, "Comet logging skipped by operator request.\n")
        write_text(stderr_path, "")
        write_text(bundle_hint_path, "SKIPPED\n")
        return

    python_bin = default_comet_python(args)
    env = os.environ.copy()
    offline_dir = artifact_root / "cometml-runs"
    offline_dir.mkdir(parents=True, exist_ok=True)
    env["COMET_OFFLINE_DIRECTORY"] = str(offline_dir)
    completed = run_local(
        [
            python_bin,
            str(REPO_ROOT / "tools" / "comet_manifest_logger.py"),
            "--manifest",
            str(manifest_path),
            "--offline",
            "--write-key-file",
            str(key_path),
        ],
        check=False,
        cwd=REPO_ROOT,
        env=env,
    )
    write_text(stdout_path, completed.stdout)
    write_text(stderr_path, completed.stderr)
    if completed.returncode != 0:
        write_text(bundle_hint_path, f"LOGGER_FAILED:{completed.returncode}\n")
        return

    zip_files = sorted(offline_dir.glob("*.zip"))
    if zip_files:
        write_text(bundle_hint_path, str(zip_files[0]) + "\n")
        return
    write_text(bundle_hint_path, str(offline_dir) + "\n")


def main() -> int:
    args = parse_args()
    selected_rows = resolve_rows(args.rows)
    session_row_order = [row.name for row in selected_rows]
    artifact_root = make_artifact_root(args.artifact_root)
    if artifact_root.exists():
        raise SystemExit(f"Artifact root already exists: {artifact_root}")
    artifact_root.mkdir(parents=True, exist_ok=False)
    branch = detect_branch()
    question = (
        "Does the earlier F2 GPU-backed drift localize to startup or order sensitivity under locked identity capture, "
        "or does the residue family remain too unstable to interpret even at the current feasibility ceiling?"
    )
    surface_probe_gate = load_surface_probe_gate(resolve_surface_probe_summary(args.surface_probe_summary))
    if not surface_probe_gate["ready"]:
        write_blocked_packet(
            artifact_root=artifact_root,
            args=args,
            branch=branch,
            question=question,
            reason="root_surface_not_ready",
            detail=surface_probe_gate["reason"],
            surface_probe_gate=surface_probe_gate,
            partial_results=[],
        )
        print(f"artifact_root={artifact_root}")
        print("outcome_class=BLOCKED")
        return 2

    try:
        ensure_binary_exists(args.binary_path)
        ensure_device_files(DEFAULT_REQUIRED_FILES)
        serial, model = ensure_single_device()
    except SystemExit as exc:
        write_blocked_packet(
            artifact_root=artifact_root,
            args=args,
            branch=branch,
            question=question,
            reason="preflight_failed",
            detail=str(exc),
            surface_probe_gate=surface_probe_gate,
            partial_results=[],
        )
        print(f"artifact_root={artifact_root}")
        print("outcome_class=BLOCKED")
        return 2

    binary_sha256 = adb_shell(f"sha256sum {shlex.quote(args.binary_path)}", check=True).stdout.split()[0]
    session_id = session_slug(artifact_root)

    identity_root = artifact_root / "identity"
    metrics_root = artifact_root / "metrics"
    identity_root.mkdir(parents=True, exist_ok=True)
    metrics_root.mkdir(parents=True, exist_ok=True)

    adb_devices_path = identity_root / "adb_devices.txt"
    device_props_path = identity_root / "device_props.txt"
    env_path = identity_root / "env.txt"
    listing_path = identity_root / "device_listing.txt"
    hash_path = identity_root / "binary_hashes.txt"
    help_path = identity_root / "dm3_runner_help.txt"
    help_stderr_path = identity_root / "dm3_runner_help_stderr.txt"
    runner_snapshot_pre_path = identity_root / "runner_snapshot_pre_cleanup.txt"
    runner_snapshot_post_path = identity_root / "runner_snapshot_post_cleanup.txt"
    session_manifest_path = identity_root / "run_manifest.json"
    checkpoint_policy_path = identity_root / "checkpoint_policy.txt"
    checkpoint_index_path = identity_root / "checkpoint_index.json"
    comet_manifest_path = identity_root / "comet_manifest.json"
    comet_key_path = identity_root / "comet_experiment_key.txt"
    comet_stdout_path = identity_root / "comet_logger_stdout.txt"
    comet_stderr_path = identity_root / "comet_logger_stderr.txt"
    comet_bundle_hint_path = identity_root / "comet_offline_bundle_path.txt"

    write_text(adb_devices_path, run_local(["adb", "devices", "-l"], check=True).stdout)
    write_text(device_props_path, current_device_props_text())
    write_text(env_path, current_env_text(args.device_cwd))
    write_text(listing_path, current_listing_text(args.device_cwd, args.alt_binary_path))
    write_text(hash_path, current_hash_text(args.binary_path, args.alt_binary_path))
    help_stdout, help_stderr = current_help_text(args.device_cwd, args.binary_path)
    write_text(help_path, help_stdout)
    write_text(help_stderr_path, help_stderr)
    write_text(runner_snapshot_pre_path, current_runner_snapshot())
    kill_residue_runners()
    write_text(runner_snapshot_post_path, current_runner_snapshot())
    write_text(checkpoint_policy_path, "rerun-only\n")

    session_manifest = {
        "question": question,
        "row_order": session_row_order,
        "device_cwd": args.device_cwd,
        "binary_path": args.binary_path,
        "alt_binary_path": args.alt_binary_path,
        "branch": branch,
        "phase": args.phase,
        "plan": args.plan,
        "artifact_root": repo_rel(artifact_root),
        "surface_probe_summary": surface_probe_gate["summary_path"],
    }
    write_json(session_manifest_path, session_manifest)

    results: list[dict[str, Any]] = []
    for row in selected_rows:
        try:
            results.append(
                run_row(
                    row=row,
                    artifact_root=artifact_root,
                    session_id=session_id,
                    branch=branch,
                    args=args,
                    serial=serial,
                    model=model,
                    binary_sha256=binary_sha256,
                    env_path=env_path,
                    device_props_path=device_props_path,
                    question=question,
                )
            )
        except SystemExit as exc:
            write_blocked_packet(
                artifact_root=artifact_root,
                args=args,
                branch=branch,
                question=question,
                reason=f"row_{row.name}_failed",
                detail=str(exc),
                surface_probe_gate=surface_probe_gate,
                partial_results=results,
            )
            print(f"artifact_root={artifact_root}")
            print("outcome_class=BLOCKED")
            return 2

    summary_path = metrics_root / "summary.tsv"
    write_summary(results, summary_path)
    comparison_index_json, comparison_index_tsv = write_comparison_index(
        artifact_root=artifact_root,
        results=results,
        question=question,
        session_row_order=session_row_order,
    )
    write_checkpoint_index(checkpoint_index_path, results)

    outcome_class, outcome_reason = classify_outcome(results, session_row_order)
    write_json(
        identity_root / "run_identity.json",
        {
            "run_id": session_id,
            "branch": branch,
            "phase": args.phase,
            "plan": args.plan,
            "hypothesis_branch": branch,
            "run_kind": "feasibility_probe",
            "authority_status": "feasibility_only",
            "build_class": "exploratory_compiled_residue",
            "observable_family": "f2_harmonic_residue",
            "battery_family": "F2",
            "battery_class": "micro",
            "device_lane": "rm10_root_hybrid_smoke",
            "compute_lane": "cpu_gpu_compare",
            "machine_class": "rm10_device",
            "command_surface": "dm3_runner",
            "command_exact": repo_rel(session_manifest_path),
            "cwd": args.device_cwd,
            "artifact_root": repo_rel(artifact_root),
            "device_serial": serial,
            "device_model": model,
            "binary_path": args.binary_path,
            "binary_sha256": binary_sha256,
            "alternate_binary_path": args.alt_binary_path,
            "receipt_expected": True,
            "primary_receipt_path_or_none": repo_rel(comparison_index_tsv),
            "checkpoint_id": f"{session_id}:rerun-only",
            "checkpoint_parent": None,
            "phase_outcome": outcome_class,
            "route_outcome": "residue_classification_only",
        },
    )
    outcome_path = artifact_root / "OUTCOME.md"
    write_text(
        outcome_path,
        "\n".join(
            [
                "# F2 Outlier Outcome",
                "",
                f"- outcome_class: `{outcome_class}`",
                f"- reason: {outcome_reason}",
                "- residue classification only, not bridge progress",
                f"- summary_tsv: `{repo_rel(summary_path)}`",
                f"- comparison_index: `{repo_rel(comparison_index_tsv)}`",
            ]
        )
        + "\n",
    )

    comet_manifest = build_comet_manifest(
        artifact_root=artifact_root,
        branch=branch,
        args=args,
        serial=serial,
        model=model,
        binary_sha256=binary_sha256,
        session_id=session_id,
        question=question,
        outcome_class=outcome_class,
        summary_path=summary_path,
        comparison_index_json=comparison_index_json,
        checkpoint_index_path=checkpoint_index_path,
        session_row_order=session_row_order,
    )
    write_json(comet_manifest_path, comet_manifest)
    run_comet_logger(
        args=args,
        artifact_root=artifact_root,
        manifest_path=comet_manifest_path,
        key_path=comet_key_path,
        stdout_path=comet_stdout_path,
        stderr_path=comet_stderr_path,
        bundle_hint_path=comet_bundle_hint_path,
    )

    print(f"artifact_root={artifact_root}")
    print(f"summary_tsv={summary_path}")
    print(f"outcome_class={outcome_class}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
