#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import shlex
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]


def utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def write_text(path: Path, content: str) -> None:
    ensure_dir(path.parent)
    path.write_text(content, encoding="utf-8")


def write_json(path: Path, payload: dict[str, Any] | list[Any]) -> None:
    ensure_dir(path.parent)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


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


def adb_prefix(serial: str | None) -> list[str]:
    prefix = ["adb"]
    if serial:
        prefix.extend(["-s", serial])
    return prefix


def run_command(
    command: list[str],
    *,
    check: bool = True,
    cwd: Path | None = None,
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        cwd=str(cwd) if cwd else None,
        check=check,
        capture_output=True,
        text=True,
    )


def adb(
    serial: str | None,
    *args: str,
    check: bool = True,
) -> subprocess.CompletedProcess[str]:
    return run_command(adb_prefix(serial) + list(args), check=check)


def adb_shell(
    serial: str | None,
    shell_command: str,
    *,
    check: bool = True,
) -> subprocess.CompletedProcess[str]:
    return adb(serial, "shell", shell_command, check=check)


def device_quote(value: str) -> str:
    return shlex.quote(value)


def command_string(command: str) -> str:
    return f"adb shell {shlex.quote(command)}"


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


def parse_sha256sum(output: str) -> str:
    token = output.strip().split()
    if not token:
        raise SystemExit("sha256sum returned no output.")
    return token[0]


def capture_shell_output(serial: str | None, command: str, destination: Path) -> None:
    result = adb_shell(serial, command)
    write_text(destination, result.stdout)


def create_manifest(
    *,
    name: str,
    tags: list[str],
    parameters: dict[str, Any],
    metrics: list[dict[str, Any]],
    others: dict[str, Any],
) -> dict[str, Any]:
    return {
        "name": name,
        "workspace": "zer0pa",
        "project_name": "dm3",
        "tags": tags,
        "parameters": parameters,
        "metrics": metrics,
        "others": others,
        "assets": [],
    }


def maybe_log_comet(
    manifest_path: Path,
    offline_dir: Path | None,
    key_path: Path,
    stdout_path: Path,
    stderr_path: Path,
) -> None:
    if offline_dir is None:
        return
    ensure_dir(offline_dir)
    command = [
        sys.executable,
        str(REPO_ROOT / "tools" / "comet_manifest_logger.py"),
        "--manifest",
        str(manifest_path),
        "--offline",
        "--write-key-file",
        str(key_path),
    ]
    result = run_command(command, check=False)
    record_process(result, stdout_path, stderr_path)


def device_props(serial: str | None) -> dict[str, str]:
    props = {
        "ro.product.model": adb_shell(serial, "getprop ro.product.model").stdout.strip(),
        "ro.build.fingerprint": adb_shell(
            serial, "getprop ro.build.fingerprint"
        ).stdout.strip(),
        "ro.hardware.vulkan": adb_shell(
            serial, "getprop ro.hardware.vulkan"
        ).stdout.strip(),
    }
    return props


def write_device_props(path: Path, props: dict[str, str]) -> None:
    content = "".join(f"{key}={value}\n" for key, value in props.items())
    write_text(path, content)


def load_receipt_json(path: Path) -> dict[str, Any]:
    raw = path.read_text(encoding="utf-8").strip()
    if not raw:
        raise SystemExit(f"Empty receipt: {path}")
    return json.loads(raw.splitlines()[0])


def detect_marker(stdout_text: str, lane: str) -> str:
    if lane == "cpu":
        if "Forcing CPU Mode (GPU Disabled)" in stdout_text:
            return "cpu_forced"
        return "cpu_marker_missing"
    if (
        "GPU MatMul Kernel Initialized" in stdout_text
        and "GPU Transformer Kernel Initialized" in stdout_text
    ):
        return "gpu_init"
    return "gpu_marker_missing"


def run_f1_serious(args: argparse.Namespace) -> int:
    artifact_root = Path(args.artifact_root).resolve()
    identity_root = artifact_root / "identity"
    logs_root = artifact_root / "logs"
    telemetry_root = artifact_root / "telemetry"
    receipts_root = artifact_root / "receipts"
    ensure_dir(identity_root)
    ensure_dir(logs_root)
    ensure_dir(telemetry_root)
    ensure_dir(receipts_root)

    branch = args.branch or current_branch(REPO_ROOT)
    hypothesis_branch = args.hypothesis_branch or branch
    device_output_dir = args.device_output_dir or f"audit/{args.run_id}"

    adb_devices = adb(None, "devices", "-l")
    write_text(identity_root / "adb_devices.txt", adb_devices.stdout)
    resolved_serial = resolve_serial(args.serial, adb_devices.stdout)

    props = device_props(resolved_serial)
    write_device_props(identity_root / "device_props.txt", props)
    if args.expected_model and props["ro.product.model"] != args.expected_model:
        raise SystemExit(
            f"Device model mismatch: expected {args.expected_model}, got {props['ro.product.model']}"
        )

    env_command = f"cd {device_quote(args.device_cwd)} && env | sort"
    capture_shell_output(resolved_serial, env_command, identity_root / "env.txt")

    capture_shell_output(resolved_serial, "dumpsys battery", telemetry_root / "battery_pre.txt")
    capture_shell_output(
        resolved_serial, "dumpsys thermalservice", telemetry_root / "thermal_pre.txt"
    )
    capture_shell_output(
        resolved_serial,
        "cat /proc/meminfo | sed -n '1,80p'",
        telemetry_root / "meminfo_pre.txt",
    )

    binary_sha = parse_sha256sum(
        adb_shell(resolved_serial, f"sha256sum {device_quote(args.binary_path)}").stdout
    )
    write_text(identity_root / "genesis_sha256.txt", f"{binary_sha}  {args.binary_path}\n")

    command_body = (
        f"PATH=/data/local/tmp/SoC_Harness/bin:$PATH "
        f"{device_quote(args.binary_path)} --protocol --runs 1 "
        f"--output-dir {device_quote(device_output_dir)}"
    )
    device_command = f"cd {device_quote(args.device_cwd)} && {command_body}"
    command_exact = command_string(device_command)
    write_text(identity_root / "command.txt", command_exact + "\n")

    run_result = adb_shell(resolved_serial, device_command, check=False)
    record_process(
        run_result,
        logs_root / "stdout.txt",
        logs_root / "stderr.txt",
        logs_root / "exit_code.txt",
    )

    capture_shell_output(resolved_serial, "dumpsys battery", telemetry_root / "battery_post.txt")
    capture_shell_output(
        resolved_serial, "dumpsys thermalservice", telemetry_root / "thermal_post.txt"
    )
    capture_shell_output(
        resolved_serial,
        "cat /proc/meminfo | sed -n '1,80p'",
        telemetry_root / "meminfo_post.txt",
    )

    pull_result = adb(
        resolved_serial,
        "pull",
        f"{args.device_cwd}/{device_output_dir}",
        str(receipts_root),
        check=False,
    )
    record_process(
        pull_result,
        logs_root / "adb_pull_stdout.txt",
        logs_root / "adb_pull_stderr.txt",
        logs_root / "adb_pull_exit_code.txt",
    )

    local_receipt_root = receipts_root / Path(device_output_dir).name
    verify_path = local_receipt_root / "run00" / "artifacts" / "verify.json"
    solve_path = local_receipt_root / "run00" / "artifacts" / "solve_h2.json"
    primary_receipt = local_receipt_root / "run00" / "receipts" / "VERIFY_SUMMARY.json"

    if not verify_path.is_file() or not solve_path.is_file():
        raise SystemExit(
            f"Missing pulled Genesis artifacts under {local_receipt_root}"
        )

    verify_sha = sha256_file(verify_path)
    solve_sha = sha256_file(solve_path)

    validate_default_command = (
        f"cd {device_quote(args.device_cwd)} && PATH=/data/local/tmp/SoC_Harness/bin:$PATH "
        f"{device_quote(args.binary_path)} --validate --reference-dir "
        f"{device_quote(device_output_dir)}/run00"
    )
    default_result = adb_shell(resolved_serial, validate_default_command, check=False)
    record_process(
        default_result,
        logs_root / "validate_default_stdout.txt",
        logs_root / "validate_default_stderr.txt",
        logs_root / "validate_default_exit_code.txt",
    )

    validate_explicit_command = (
        f"{validate_default_command} --verify-hash {verify_sha} --solve-hash {solve_sha}"
    )
    explicit_result = adb_shell(resolved_serial, validate_explicit_command, check=False)
    record_process(
        explicit_result,
        logs_root / "validate_explicit_stdout.txt",
        logs_root / "validate_explicit_stderr.txt",
        logs_root / "validate_explicit_exit_code.txt",
    )

    checkpoint_policy = "rerun-only"
    write_text(identity_root / "checkpoint_policy.txt", f"{checkpoint_policy}\n")

    checkpoint_index = {
        "policy": checkpoint_policy,
        "runs": [
            {
                "run_id": args.run_id,
                "phase": args.phase,
                "plan": args.plan,
                "device_output_dir": device_output_dir,
                "local_receipt_root": str(local_receipt_root),
                "protocol_exit_code": run_result.returncode,
                "adb_pull_exit_code": pull_result.returncode,
                "validate_default_exit_code": default_result.returncode,
                "validate_explicit_exit_code": explicit_result.returncode,
                "verify_sha256": verify_sha,
                "solve_sha256": solve_sha,
                "primary_receipt_path": str(primary_receipt) if primary_receipt.exists() else None,
                "captured_at_utc": utc_now(),
            }
        ],
    }
    write_json(identity_root / "checkpoint_index.json", checkpoint_index)

    validation_mode = "default_hashes"
    if default_result.returncode != 0 and explicit_result.returncode == 0:
        validation_mode = "explicit_hash"

    run_identity = {
        "run_id": args.run_id,
        "branch": branch,
        "phase": args.phase,
        "plan": args.plan,
        "hypothesis_branch": hypothesis_branch,
        "run_kind": "serious_run",
        "authority_status": "governed_non_sovereign",
        "build_class": "prebuilt_stub",
        "observable_family": "genesis_protocol",
        "battery_family": "F1",
        "battery_class": "control",
        "device_lane": "rm10_soc_runtime_genesis",
        "compute_lane": "cpu",
        "machine_class": "rm10_device",
        "command_surface": "genesis_cli",
        "command_exact": command_exact,
        "cwd": args.device_cwd,
        "artifact_root": str(artifact_root),
        "device_serial": resolved_serial,
        "device_model": props["ro.product.model"],
        "binary_path": args.binary_path,
        "binary_sha256": binary_sha,
        "receipt_expected": True,
        "primary_receipt_path_or_none": str(primary_receipt) if primary_receipt.exists() else None,
        "checkpoint_id": args.run_id,
        "checkpoint_parent": None,
        "phase_outcome": "pass" if run_result.returncode == 0 else "fail",
        "route_outcome": validation_mode,
        "canonical_validation_mode": validation_mode,
    }
    write_json(identity_root / "run_identity.json", run_identity)

    manifest = create_manifest(
        name=f"dm3-{args.phase}-{args.run_id}-rm10-f1-serious",
        tags=[
            "restart",
            "dm3",
            f"phase-{args.phase}",
            "family-F1",
            "run-kind-serious_run",
            "authority-governed_non_sovereign",
            "build-prebuilt_stub",
            "surface-witness_floor",
            "machine-rm10_device",
            "lane-rm10_soc_runtime_genesis",
        ],
        parameters={
            "run_id": args.run_id,
            "phase": args.phase,
            "plan": args.plan,
            "hypothesis_branch": hypothesis_branch,
            "observable_family": "genesis_protocol",
            "battery_family": "F1",
            "battery_class": "control",
            "command_surface": "genesis_cli",
            "cwd": args.device_cwd,
            "artifact_root": str(artifact_root),
            "device_serial": resolved_serial,
            "device_model": props["ro.product.model"],
            "binary_sha256": binary_sha,
            "receipt_expected": True,
            "checkpoint_id": args.run_id,
            "checkpoint_parent": "",
            "canonical_validation_mode": validation_mode,
        },
        metrics=[
            {"name": "run/exit_code", "value": run_result.returncode},
            {"name": "validate/default_exit_code", "value": default_result.returncode},
            {"name": "validate/explicit_exit_code", "value": explicit_result.returncode},
        ],
        others={
            "command_text_path": str(identity_root / "command.txt"),
            "run_identity_path": str(identity_root / "run_identity.json"),
            "checkpoint_policy_path": str(identity_root / "checkpoint_policy.txt"),
            "checkpoint_index_path": str(identity_root / "checkpoint_index.json"),
            "telemetry_root": str(telemetry_root),
            "local_receipt_root": str(local_receipt_root),
            "primary_receipt_path": str(primary_receipt) if primary_receipt.exists() else "",
        },
    )
    manifest_path = identity_root / "comet_manifest.json"
    write_json(manifest_path, manifest)
    maybe_log_comet(
        manifest_path,
        Path(args.comet_offline_dir).resolve() if args.comet_offline_dir else None,
        identity_root / "comet_experiment_key.txt",
        identity_root / "comet_logger_stdout.txt",
        identity_root / "comet_logger_stderr.txt",
    )

    print(artifact_root)
    return 0


def run_f2_harmonic(args: argparse.Namespace) -> int:
    artifact_root = Path(args.artifact_root).resolve()
    identity_root = artifact_root / "identity"
    comparisons_root = artifact_root / "comparisons"
    runs_root = artifact_root / "runs"
    ensure_dir(identity_root)
    ensure_dir(comparisons_root)
    ensure_dir(runs_root)

    branch = args.branch or current_branch(REPO_ROOT)
    hypothesis_branch = args.hypothesis_branch or branch

    adb_devices = adb(None, "devices", "-l")
    write_text(identity_root / "adb_devices.txt", adb_devices.stdout)
    resolved_serial = resolve_serial(args.serial, adb_devices.stdout)

    props = device_props(resolved_serial)
    write_device_props(identity_root / "device_props.txt", props)
    if args.expected_model and props["ro.product.model"] != args.expected_model:
        raise SystemExit(
            f"Device model mismatch: expected {args.expected_model}, got {props['ro.product.model']}"
        )

    env_command = f"cd {device_quote(args.device_cwd)} && env | sort"
    capture_shell_output(resolved_serial, env_command, identity_root / "env.txt")

    primary_sha = parse_sha256sum(
        adb_shell(resolved_serial, f"sha256sum {device_quote(args.binary_path)}").stdout
    )
    alternate_sha = parse_sha256sum(
        adb_shell(
            resolved_serial,
            f"sha256sum {device_quote(args.alternate_binary_path)}",
        ).stdout
    )
    write_text(identity_root / "primary_binary_sha256.txt", f"{primary_sha}  {args.binary_path}\n")
    write_text(
        identity_root / "alternate_binary_sha256.txt",
        f"{alternate_sha}  {args.alternate_binary_path}\n",
    )

    session_question = (
        "One bounded F2 outlier-localization pass: determine whether the GPU-backed "
        "harmonic row stays near the CPU family or diverges under fixed custody."
    )
    write_text(identity_root / "session_question.txt", session_question + "\n")
    write_text(identity_root / "checkpoint_policy.txt", "rerun-only\n")

    capture_shell_output(resolved_serial, "dumpsys battery", identity_root / "session_battery_pre.txt")
    capture_shell_output(
        resolved_serial, "dumpsys thermalservice", identity_root / "session_thermal_pre.txt"
    )
    capture_shell_output(
        resolved_serial,
        "cat /proc/meminfo | sed -n '1,80p'",
        identity_root / "session_meminfo_pre.txt",
    )
    capture_shell_output(
        resolved_serial,
        "ps -A -o PID,PPID,ETIME,NAME,ARGS | grep dm3_runner || true",
        identity_root / "stale_processes_pre.txt",
    )
    adb_shell(
        resolved_serial,
        "pkill -f 'dm3_runner --mode train --task harmonic' || true",
        check=False,
    )

    rows = [("cpu_a", "cpu"), ("gpu_a", "gpu"), ("cpu_b", "cpu"), ("gpu_b", "gpu")]
    checkpoint_rows: list[dict[str, Any]] = []
    summary_rows: list[dict[str, Any]] = []

    for suffix, lane in rows:
        run_id = f"{args.run_prefix}_{suffix}"
        run_dir = runs_root / run_id
        run_identity_root = run_dir / "identity"
        run_logs_root = run_dir / "logs"
        run_metrics_root = run_dir / "metrics"
        run_receipts_root = run_dir / "receipts"
        run_telemetry_root = run_dir / "telemetry"
        for path in (
            run_identity_root,
            run_logs_root,
            run_metrics_root,
            run_receipts_root,
            run_telemetry_root,
        ):
            ensure_dir(path)

        output_path = f"{args.device_cwd}/{run_id}.jsonl"
        cpu_flag = " --cpu" if lane == "cpu" else ""
        command_body = (
            f"rm -f {device_quote(output_path)} && /system/bin/timeout {args.row_timeout_sec} "
            f"./dm3_runner --mode train --task harmonic --steps 1{cpu_flag} "
            f"--output {device_quote(output_path)}"
        )
        device_command = f"cd {device_quote(args.device_cwd)} && {command_body}"
        command_exact = command_string(device_command)
        write_text(run_identity_root / "command.txt", command_exact + "\n")

        capture_shell_output(resolved_serial, "dumpsys battery", run_telemetry_root / "battery_pre.txt")
        capture_shell_output(
            resolved_serial, "dumpsys thermalservice", run_telemetry_root / "thermal_pre.txt"
        )
        capture_shell_output(
            resolved_serial,
            "cat /proc/meminfo | sed -n '1,80p'",
            run_telemetry_root / "meminfo_pre.txt",
        )
        write_text(run_identity_root / "start_utc.txt", utc_now() + "\n")

        run_result = adb_shell(resolved_serial, device_command, check=False)
        record_process(
            run_result,
            run_logs_root / "stdout.txt",
            run_logs_root / "stderr.txt",
            run_logs_root / "exit_code.txt",
        )

        write_text(run_identity_root / "end_utc.txt", utc_now() + "\n")
        capture_shell_output(resolved_serial, "dumpsys battery", run_telemetry_root / "battery_post.txt")
        capture_shell_output(
            resolved_serial, "dumpsys thermalservice", run_telemetry_root / "thermal_post.txt"
        )
        capture_shell_output(
            resolved_serial,
            "cat /proc/meminfo | sed -n '1,80p'",
            run_telemetry_root / "meminfo_post.txt",
        )

        pull_result = adb(resolved_serial, "pull", output_path, str(run_receipts_root), check=False)
        record_process(
            pull_result,
            run_logs_root / "adb_pull_stdout.txt",
            run_logs_root / "adb_pull_stderr.txt",
            run_logs_root / "adb_pull_exit_code.txt",
        )

        local_receipt_path = run_receipts_root / f"{run_id}.jsonl"
        if not local_receipt_path.is_file():
            raise SystemExit(f"Missing pulled receipt for {run_id}: {local_receipt_path}")

        receipt_payload = load_receipt_json(local_receipt_path)
        marker = detect_marker((run_logs_root / "stdout.txt").read_text(encoding="utf-8"), lane)
        metric_payload = {
            "run_id": run_id,
            "lane": lane,
            "marker": marker,
            **receipt_payload,
        }
        write_json(run_metrics_root / "summary.json", metric_payload)

        run_identity = {
            "run_id": run_id,
            "branch": branch,
            "phase": args.phase,
            "plan": args.plan,
            "hypothesis_branch": hypothesis_branch,
            "run_kind": "feasibility_probe",
            "authority_status": "feasibility_only",
            "build_class": "exploratory_compiled_residue",
            "observable_family": "harmonic",
            "battery_family": "F2",
            "battery_class": "bounded_diagnostic",
            "device_lane": "rm10_root_hybrid_smoke",
            "compute_lane": lane,
            "machine_class": "rm10_device",
            "command_surface": "dm3_runner",
            "command_exact": command_exact,
            "cwd": args.device_cwd,
            "artifact_root": str(run_dir),
            "device_serial": resolved_serial,
            "device_model": props["ro.product.model"],
            "binary_path": args.binary_path,
            "binary_sha256": primary_sha,
            "alternate_binary_path": args.alternate_binary_path,
            "alternate_binary_sha256": alternate_sha,
            "receipt_expected": True,
            "primary_receipt_path_or_none": str(local_receipt_path),
            "checkpoint_id": run_id,
            "checkpoint_parent": None,
            "phase_outcome": "pass" if run_result.returncode == 0 else "fail",
            "route_outcome": marker,
            "stdout_marker": marker,
        }
        write_json(run_identity_root / "run_identity.json", run_identity)

        checkpoint_rows.append(
            {
                "run_id": run_id,
                "lane": lane,
                "command_path": str(run_identity_root / "command.txt"),
                "receipt_path": str(local_receipt_path),
                "metric_path": str(run_metrics_root / "summary.json"),
                "stdout_path": str(run_logs_root / "stdout.txt"),
                "stderr_path": str(run_logs_root / "stderr.txt"),
                "exit_code": run_result.returncode,
                "receipt_sha256": sha256_file(local_receipt_path),
                "start_utc": (run_identity_root / "start_utc.txt").read_text(encoding="utf-8").strip(),
                "end_utc": (run_identity_root / "end_utc.txt").read_text(encoding="utf-8").strip(),
            }
        )
        summary_rows.append(metric_payload)

    capture_shell_output(resolved_serial, "dumpsys battery", identity_root / "session_battery_post.txt")
    capture_shell_output(
        resolved_serial, "dumpsys thermalservice", identity_root / "session_thermal_post.txt"
    )
    capture_shell_output(
        resolved_serial,
        "cat /proc/meminfo | sed -n '1,80p'",
        identity_root / "session_meminfo_post.txt",
    )
    capture_shell_output(
        resolved_serial,
        "ps -A -o PID,PPID,ETIME,NAME,ARGS | grep dm3_runner || true",
        identity_root / "stale_processes_post.txt",
    )

    checkpoint_index = {
        "policy": "rerun-only",
        "rows": checkpoint_rows,
    }
    write_json(identity_root / "checkpoint_index.json", checkpoint_index)

    comparison_index = {
        "question": session_question,
        "row_order": [row["run_id"] for row in checkpoint_rows],
        "rows": checkpoint_rows,
    }
    write_json(comparisons_root / "comparison_index.json", comparison_index)

    summary_lines = [
        "run_id\tlane\tdecision\tdelta_E\tcoherence\tduration_ms\tstdout_marker"
    ]
    for row in summary_rows:
        summary_lines.append(
            "\t".join(
                [
                    str(row["run_id"]),
                    str(row["lane"]),
                    str(row.get("decision", "")),
                    str(row.get("delta_E", "")),
                    str(row.get("coherence", "")),
                    str(row.get("duration_ms", "")),
                    str(row.get("marker", "")),
                ]
            )
        )
    write_text(comparisons_root / "summary.tsv", "\n".join(summary_lines) + "\n")

    manifest = create_manifest(
        name=f"dm3-{args.phase}-{args.run_prefix}-rm10-f2-harmonic",
        tags=[
            "restart",
            "dm3",
            f"phase-{args.phase}",
            "family-F2",
            "run-kind-feasibility_probe",
            "authority-feasibility_only",
            "build-exploratory_compiled_residue",
            "surface-archaeology",
            "machine-rm10_device",
            "lane-rm10_root_hybrid_smoke",
        ],
        parameters={
            "run_prefix": args.run_prefix,
            "phase": args.phase,
            "plan": args.plan,
            "hypothesis_branch": hypothesis_branch,
            "observable_family": "harmonic",
            "battery_family": "F2",
            "battery_class": "bounded_diagnostic",
            "command_surface": "dm3_runner",
            "cwd": args.device_cwd,
            "artifact_root": str(artifact_root),
            "device_serial": resolved_serial,
            "device_model": props["ro.product.model"],
            "binary_sha256": primary_sha,
            "alternate_binary_sha256": alternate_sha,
            "receipt_expected": True,
            "checkpoint_id": args.run_prefix,
            "checkpoint_parent": "",
        },
        metrics=[
            {"name": "run/count", "value": len(summary_rows)},
        ],
        others={
            "question_path": str(identity_root / "session_question.txt"),
            "checkpoint_index_path": str(identity_root / "checkpoint_index.json"),
            "comparison_index_path": str(comparisons_root / "comparison_index.json"),
            "summary_tsv_path": str(comparisons_root / "summary.tsv"),
        },
    )
    manifest_path = identity_root / "comet_manifest.json"
    write_json(manifest_path, manifest)
    maybe_log_comet(
        manifest_path,
        Path(args.comet_offline_dir).resolve() if args.comet_offline_dir else None,
        identity_root / "comet_experiment_key.txt",
        identity_root / "comet_logger_stdout.txt",
        identity_root / "comet_logger_stderr.txt",
    )

    print(artifact_root)
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Capture hardened RM10 F1 and F2 run packets."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    f1 = subparsers.add_parser("f1-serious", help="Run a hardened F1 Genesis packet.")
    f1.add_argument("--artifact-root", required=True)
    f1.add_argument("--run-id", required=True)
    f1.add_argument("--phase", default="01.2.3.2")
    f1.add_argument("--plan", default="bridge-qualification")
    f1.add_argument("--branch")
    f1.add_argument("--hypothesis-branch")
    f1.add_argument("--serial")
    f1.add_argument("--expected-model", default="NX789J")
    f1.add_argument("--device-cwd", default="/data/local/tmp/SoC_runtime/workspace")
    f1.add_argument("--device-output-dir")
    f1.add_argument("--binary-path", default="/data/local/tmp/genesis_cli")
    f1.add_argument("--comet-offline-dir")
    f1.set_defaults(func=run_f1_serious)

    f2 = subparsers.add_parser(
        "f2-harmonic", help="Run a hardened four-row F2 harmonic comparison."
    )
    f2.add_argument("--artifact-root", required=True)
    f2.add_argument("--run-prefix", required=True)
    f2.add_argument("--phase", default="01.2.3.2")
    f2.add_argument("--plan", default="bridge-qualification")
    f2.add_argument("--branch")
    f2.add_argument("--hypothesis-branch")
    f2.add_argument("--serial")
    f2.add_argument("--expected-model", default="NX789J")
    f2.add_argument("--device-cwd", default="/data/local/tmp")
    f2.add_argument("--binary-path", default="/data/local/tmp/dm3_runner")
    f2.add_argument("--alternate-binary-path", default="/data/local/tmp/dm3/dm3_runner")
    f2.add_argument("--row-timeout-sec", type=int, default=180)
    f2.add_argument("--comet-offline-dir")
    f2.set_defaults(func=run_f2_harmonic)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
