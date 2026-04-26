#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import shlex
import subprocess
from dataclasses import asdict, dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_VALIDATOR_BINARY = "/data/local/tmp/genesis_cli"
DEFAULT_VALIDATOR_CWD = "/data/local/tmp/SoC_runtime/workspace"
DEFAULT_HISTORICAL_REFERENCE = (
    "/data/local/tmp/snic_workspace_a83f/audit/RedMagic_T1-T7_20251028T093042Z/termux_protocol_run/run00"
)
DEFAULT_HISTORICAL_VERIFY = "e8941414a25c7c8e1aed6b3f5c032c00a69e85ae6964555301ff48dee44009e3"
DEFAULT_HISTORICAL_SOLVE = "62897b8c26de3af1a78433807c5607fb8c82f061d1457e9c43e2aa5d35fe7780"
DEFAULT_PHASE = "01.2.3.4.1"
DEFAULT_F2_ROOT_BINARY = "/data/local/tmp/dm3_runner"
DEFAULT_F2_LEGACY_BINARY = "/data/local/tmp/dm3/dm3_runner"
DEFAULT_F2_ROOT_CWD = "/data/local/tmp"
DEFAULT_F2_LEGACY_CWD = "/data/local/tmp/dm3"
DEFAULT_F2_SURFACE_TIMEOUT_SECONDS = 120


@dataclass(frozen=True)
class ProbeResult:
    name: str
    classification: str
    exit_code: int
    cwd: str
    binary_path: str
    command: str
    stdout: str
    stderr: str
    receipt_path: str
    receipt_text: str


def run_local(command: list[str], *, check: bool = True) -> subprocess.CompletedProcess[str]:
    completed = subprocess.run(command, capture_output=True, text=True, check=False)
    if check and completed.returncode != 0:
        raise SystemExit(
            f"Command failed ({completed.returncode}): {' '.join(shlex.quote(part) for part in command)}\n"
            f"STDOUT:\n{completed.stdout}\nSTDERR:\n{completed.stderr}"
        )
    return completed


def adb_prefix(serial: str | None) -> list[str]:
    prefix = ["adb"]
    if serial:
        prefix.extend(["-s", serial])
    return prefix


def adb(serial: str | None, *args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return run_local(adb_prefix(serial) + list(args), check=check)


def adb_shell(serial: str | None, script: str, *, check: bool = True) -> subprocess.CompletedProcess[str]:
    return adb(serial, "shell", script, check=check)


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def write_json(path: Path, payload: Any) -> None:
    write_text(path, json.dumps(payload, indent=2, sort_keys=False) + "\n")


def repo_rel(path: Path) -> str:
    return path.resolve().relative_to(REPO_ROOT).as_posix()


def utc_stamp() -> str:
    return datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")


def make_artifact_root(name: str, explicit: str | None) -> Path:
    if explicit:
        return (REPO_ROOT / explicit).resolve() if not explicit.startswith("/") else Path(explicit).resolve()
    return (REPO_ROOT / "artifacts" / f"{name}_{utc_stamp()}").resolve()


def ensure_single_device() -> tuple[str, str]:
    devices = run_local(["adb", "devices", "-l"], check=True).stdout.strip().splitlines()
    live = [line for line in devices[1:] if line.strip() and " device " in f" {line} "]
    if len(live) != 1:
        raise SystemExit(f"Expected exactly one attached ADB device, found {len(live)}:\n" + "\n".join(live))
    serial = live[0].split()[0]
    model = adb_shell(serial, "getprop ro.product.model", check=True).stdout.strip()
    return serial, model


def device_props(serial: str) -> dict[str, str]:
    return {
        "ro.product.model": adb_shell(serial, "getprop ro.product.model", check=True).stdout.strip(),
        "ro.build.fingerprint": adb_shell(serial, "getprop ro.build.fingerprint", check=True).stdout.strip(),
        "ro.board.platform": adb_shell(serial, "getprop ro.board.platform", check=True).stdout.strip(),
    }


def write_device_props(path: Path, props: dict[str, str]) -> None:
    content = "".join(f"{key}={value}\n" for key, value in props.items())
    write_text(path, content)


def kill_dm3_runners(serial: str) -> None:
    adb_shell(serial, "pkill -TERM dm3_runner 2>/dev/null || true", check=False)
    adb_shell(serial, "sleep 1", check=False)
    adb_shell(serial, "pkill -KILL dm3_runner 2>/dev/null || true", check=False)


def runner_snapshot(serial: str) -> str:
    return adb_shell(
        serial,
        "ps -A -o PID,PPID,STAT,TIME,ARGS | grep dm3_runner | grep -v grep || true",
        check=False,
    ).stdout


def device_sha256(serial: str, paths: list[str]) -> str:
    quoted = " ".join(shlex.quote(path) for path in paths)
    return adb_shell(serial, f"sha256sum {quoted} 2>/dev/null || true", check=False).stdout


def classify_probe(result: ProbeResult) -> str:
    if result.exit_code == 0 and result.receipt_text.strip():
        return "callable"
    if "No such file or directory" in result.stderr:
        return "missing_ambient_dependency"
    if result.exit_code in (124, 137, 143) and "Starting Resonance Training" in result.stdout:
        return "stalled_after_resonance_start"
    if result.exit_code in (124, 137, 143):
        return "timed_out_before_training"
    return "other_failure"


def scenario_lookup(rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    return {row["name"]: row for row in rows}


def interpretation_line(name: str, classification: str) -> str:
    if name == "cleanroom_minimal_cpu":
        if classification == "missing_ambient_dependency":
            return (
                "- `cleanroom_minimal_cpu` still isolates undeclared ambient dependencies away from the "
                "top-level `/data/local/tmp` working surface."
            )
        if classification == "callable":
            return (
                "- `cleanroom_minimal_cpu` is callable, so the root family no longer depends on undeclared "
                "ambient files from the top-level working surface."
            )
    if name == "cleanroom_regiontags_v1_cpu":
        if classification == "callable":
            return (
                "- `cleanroom_regiontags_v1_cpu` is callable, so `RegionTags_v1.bin` clears the cleanroom "
                "startup gate when the other retained assets are present."
            )
        if classification == "missing_ambient_dependency":
            return (
                "- `cleanroom_regiontags_v1_cpu` still hits a missing ambient dependency even with "
                "`RegionTags_v1.bin`, so the cleanroom surface remains under-specified."
            )
    if name == "root_cpu_default":
        if classification == "callable":
            return (
                "- `root_cpu_default` proves the live top-level `/data/local/tmp/dm3_runner` family is callable "
                "under an honest timeout on the real device surface."
            )
        if classification == "stalled_after_resonance_start":
            return (
                "- `root_cpu_default` still times out after resonance start, so the top-level family remains "
                "blocked for the official `F2` handoff."
            )
        return (
            f"- `root_cpu_default` remains `{classification}`, so the top-level family is still not ready for the "
            "official `F2` handoff."
        )
    if name == "root_cpu_explicit_assets":
        if classification == "callable":
            return (
                "- `root_cpu_explicit_assets` is also callable, so making the inferred assets explicit does not "
                "break the live top-level family."
            )
        return (
            f"- `root_cpu_explicit_assets` is `{classification}`, so explicit asset declaration still changes the "
            "top-level family behavior."
        )
    if name == "legacy_dm3_gpu_train":
        if classification == "callable":
            return (
                "- `legacy_dm3_gpu_train` remains callable as a separate older residue surface, but it stays fenced "
                "from the top-level root family."
            )
        return (
            f"- `legacy_dm3_gpu_train` is `{classification}`, so the older residue control surface is no longer "
            "available as a separate comparison point."
        )
    return f"- `{name}` classified as `{classification}`."


def write_comparison_index(artifact_root: Path, payload: dict[str, Any]) -> tuple[Path, Path]:
    comparison_root = artifact_root / "comparisons"
    comparison_root.mkdir(parents=True, exist_ok=True)
    json_path = comparison_root / "index.json"
    tsv_path = comparison_root / "index.tsv"
    write_json(json_path, payload)
    lines = ["name\tclassification\texit_code\tcwd\tbinary_path\treceipt_path"]
    for row in payload.get("rows", []):
        lines.append(
            "\t".join(
                [
                    str(row.get("name", "")),
                    str(row.get("classification", "")),
                    str(row.get("exit_code", "")),
                    str(row.get("cwd", "")),
                    str(row.get("binary_path", "")),
                    str(row.get("receipt_path", "")),
                ]
            )
        )
    write_text(tsv_path, "\n".join(lines) + "\n")
    return json_path, tsv_path


def write_checkpoint_index(path: Path, probes: list[dict[str, Any]]) -> None:
    write_json(
        path,
        {
            "policy": "retain-all",
            "attempts": [
                {
                    "name": probe["name"],
                    "classification": probe["classification"],
                    "exit_code": probe["exit_code"],
                    "cwd": probe["cwd"],
                    "binary_path": probe["binary_path"],
                    "receipt_path": probe["receipt_path"],
                }
                for probe in probes
            ],
        },
    )


def write_root_identity(
    *,
    artifact_root: Path,
    phase: str,
    plan: str,
    serial: str,
    model: str,
    branch: str,
    question: str,
    outcome_class: str,
    checkpoint_index_path: Path,
    comparison_index_path: Path,
    next_admissible_move: str,
) -> None:
    identity_root = artifact_root / "identity"
    identity_root.mkdir(parents=True, exist_ok=True)
    write_text(identity_root / "checkpoint_policy.txt", "retain-all\n")
    write_json(
        identity_root / "run_identity.json",
        {
            "run_id": artifact_root.name,
            "branch": branch,
            "phase": phase,
            "plan": plan,
            "run_kind": "engineering_readiness_probe",
            "authority_status": "engineering_only",
            "machine_class": "rm10_device",
            "device_serial": serial,
            "device_model": model,
            "artifact_root": repo_rel(artifact_root),
            "question": question,
            "phase_outcome": outcome_class,
            "checkpoint_id": f"{artifact_root.name}:retain-all",
            "checkpoint_parent": None,
            "comparison_index_path": repo_rel(comparison_index_path),
            "checkpoint_index_path": repo_rel(checkpoint_index_path),
            "next_admissible_move": next_admissible_move,
        },
    )


def run_probe(
    *,
    serial: str,
    name: str,
    cwd: str,
    binary_path: str,
    command_args: str,
    setup_script: str | None,
    receipt_path: str,
    artifact_root: Path,
    timeout_seconds: int,
) -> ProbeResult:
    probe_root = artifact_root / "probes" / name
    probe_root.mkdir(parents=True, exist_ok=True)
    kill_dm3_runners(serial)
    write_text(probe_root / "runner_snapshot_pre.txt", runner_snapshot(serial))
    command = f"{shlex.quote(binary_path)} {command_args}"
    script_parts = [setup_script] if setup_script else []
    script_parts.extend(
        [
            f"rm -f {shlex.quote(receipt_path)}",
            f"cd {shlex.quote(cwd)}",
            f"/system/bin/timeout {int(timeout_seconds)} {command}",
        ]
    )
    script = " && ".join(part for part in script_parts if part)
    write_text(probe_root / "command.txt", f"adb shell {shlex.quote(script)}\n")
    completed = adb_shell(serial, script, check=False)
    write_text(probe_root / "stdout.txt", completed.stdout)
    write_text(probe_root / "stderr.txt", completed.stderr)
    write_text(probe_root / "exit_code.txt", f"{completed.returncode}\n")
    receipt_text = adb_shell(
        serial,
        f"sed -n '1,5p' {shlex.quote(receipt_path)} 2>/dev/null || true",
        check=False,
    ).stdout
    write_text(probe_root / "receipt_head.txt", receipt_text)
    write_text(probe_root / "runner_snapshot_post.txt", runner_snapshot(serial))
    result = ProbeResult(
        name=name,
        classification="unclassified",
        exit_code=completed.returncode,
        cwd=cwd,
        binary_path=binary_path,
        command=command,
        stdout=completed.stdout,
        stderr=completed.stderr,
        receipt_path=receipt_path,
        receipt_text=receipt_text,
    )
    final = ProbeResult(**{**asdict(result), "classification": classify_probe(result)})
    write_json(
        probe_root / "result.json",
        {
            "name": final.name,
            "classification": final.classification,
            "exit_code": final.exit_code,
            "cwd": final.cwd,
            "binary_path": final.binary_path,
            "command": final.command,
            "receipt_path": final.receipt_path,
        },
    )
    return final


def add_common_identity(
    *,
    artifact_root: Path,
    serial: str,
    model: str,
    props: dict[str, str],
    extra_hash_paths: list[str],
) -> None:
    identity_root = artifact_root / "identity"
    identity_root.mkdir(parents=True, exist_ok=True)
    write_text(identity_root / "adb_devices.txt", run_local(["adb", "devices", "-l"], check=True).stdout)
    write_device_props(identity_root / "device_props.txt", props)
    write_text(identity_root / "runner_snapshot_initial.txt", runner_snapshot(serial))
    write_text(identity_root / "hashes.txt", device_sha256(serial, extra_hash_paths))
    write_json(
        identity_root / "device_identity.json",
        {
            "device_serial": serial,
            "device_model": model,
            "captured_at_utc": datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
    )


def capture_probe_telemetry(serial: str, root: Path, prefix: str) -> None:
    telemetry_root = root / "telemetry"
    telemetry_root.mkdir(parents=True, exist_ok=True)
    write_text(telemetry_root / f"{prefix}_battery.txt", adb_shell(serial, "dumpsys battery", check=False).stdout)
    write_text(
        telemetry_root / f"{prefix}_thermal.txt",
        adb_shell(serial, "dumpsys thermalservice", check=False).stdout,
    )


def capture_device_help(serial: str, binary_path: str, destination: Path) -> None:
    help_result = adb_shell(serial, f"{shlex.quote(binary_path)} --help", check=False)
    body = help_result.stdout
    if help_result.stderr:
        body = body + ("\n" if body and not body.endswith("\n") else "") + help_result.stderr
    if not body:
        body = f"exit_code={help_result.returncode}\n"
    write_text(destination, body)


def capture_device_listing(serial: str, paths: list[str], destination: Path) -> None:
    quoted = " ".join(shlex.quote(path) for path in paths)
    command = (
        "for target in "
        + quoted
        + "; do "
        + "if [ -e \"$target\" ]; then ls -ld \"$target\"; else printf 'missing %s\\n' \"$target\"; fi; "
        + "done"
    )
    write_text(destination, adb_shell(serial, command, check=False).stdout)


def validator_probe(args: argparse.Namespace) -> int:
    artifact_root = make_artifact_root("rm10_validator_probe", args.artifact_root)
    artifact_root.mkdir(parents=True, exist_ok=False)
    serial, model = ensure_single_device()
    branch = run_local(["git", "-C", str(REPO_ROOT), "branch", "--show-current"], check=True).stdout.strip()
    props = device_props(serial)
    add_common_identity(
        artifact_root=artifact_root,
        serial=serial,
        model=model,
        props=props,
        extra_hash_paths=[args.binary_path],
    )
    capture_probe_telemetry(serial, artifact_root, "pre")
    identity_root = artifact_root / "identity"
    logs_root = artifact_root / "logs"
    logs_root.mkdir(parents=True, exist_ok=True)
    capture_device_help(serial, args.binary_path, identity_root / "binary_help.txt")
    capture_device_listing(
        serial,
        [args.device_cwd, args.reference_dir, f"{args.reference_dir}/artifacts", f"{args.reference_dir}/receipts"],
        identity_root / "reference_listing.txt",
    )
    write_text(
        identity_root / "reference_hashes.txt",
        adb_shell(
            serial,
            "sha256sum "
            + " ".join(
                shlex.quote(path)
                for path in [
                    f"{args.reference_dir}/artifacts/verify.json",
                    f"{args.reference_dir}/artifacts/solve_h2.json",
                ]
            )
            + " 2>/dev/null || true",
            check=False,
        ).stdout,
    )
    default_command = (
        f"cd {shlex.quote(args.device_cwd)} && PATH=/data/local/tmp/SoC_Harness/bin:$PATH "
        f"{shlex.quote(args.binary_path)} --validate --reference-dir {shlex.quote(args.reference_dir)}"
    )
    explicit_command = f"{default_command} --verify-hash {args.verify_hash} --solve-hash {args.solve_hash}"
    write_text(identity_root / "default_command.txt", f"adb shell {shlex.quote(default_command)}\n")
    write_text(identity_root / "explicit_command.txt", f"adb shell {shlex.quote(explicit_command)}\n")
    strings_output = adb_shell(
        serial,
        f"strings {shlex.quote(args.binary_path)} 2>/dev/null | grep -E '97bd|e894|62897|f992|a33c' || true",
        check=False,
    ).stdout
    write_text(identity_root / "embedded_hash_strings.txt", strings_output)
    default_result = adb_shell(serial, default_command, check=False)
    explicit_result = adb_shell(serial, explicit_command, check=False)
    write_text(logs_root / "default_stdout.txt", default_result.stdout)
    write_text(logs_root / "default_stderr.txt", default_result.stderr)
    write_text(logs_root / "default_exit_code.txt", f"{default_result.returncode}\n")
    write_text(logs_root / "explicit_stdout.txt", explicit_result.stdout)
    write_text(logs_root / "explicit_stderr.txt", explicit_result.stderr)
    write_text(logs_root / "explicit_exit_code.txt", f"{explicit_result.returncode}\n")
    capture_probe_telemetry(serial, artifact_root, "post")
    verdict = "stale_default_validator_constant"
    if explicit_result.returncode != 0:
        verdict = "explicit_override_failed"
    elif default_result.returncode == 0:
        verdict = "default_validator_matches_reference"
    next_admissible_move = (
        "Keep fresh RM10 governed work under explicit-hash handling and localize the baked-in default validator target."
        if verdict == "stale_default_validator_constant"
        else "Repair validator handling before treating fresh RM10 governed packets as default-validated."
    )
    probes = [
        {
            "name": "default_validate",
            "classification": "failed" if default_result.returncode != 0 else "passed",
            "exit_code": default_result.returncode,
            "cwd": args.device_cwd,
            "binary_path": args.binary_path,
            "receipt_path": args.reference_dir,
        },
        {
            "name": "explicit_validate",
            "classification": "passed" if explicit_result.returncode == 0 else "failed",
            "exit_code": explicit_result.returncode,
            "cwd": args.device_cwd,
            "binary_path": args.binary_path,
            "receipt_path": args.reference_dir,
        },
    ]
    comparison_index_json, comparison_index_tsv = write_comparison_index(
        artifact_root,
        {
            "question": "Does the live RM10 validator fail only because its default canonical target is stale?",
            "rows": probes,
            "verdict": verdict,
            "next_admissible_move": next_admissible_move,
        },
    )
    checkpoint_index_path = artifact_root / "identity" / "checkpoint_index.json"
    write_checkpoint_index(checkpoint_index_path, probes)
    write_root_identity(
        artifact_root=artifact_root,
        phase=args.phase,
        plan=args.plan,
        serial=serial,
        model=model,
        branch=branch,
        question="Does the live RM10 validator fail only because its default canonical target is stale?",
        outcome_class=verdict,
        checkpoint_index_path=checkpoint_index_path,
        comparison_index_path=comparison_index_json,
        next_admissible_move=next_admissible_move,
    )
    write_text(
        artifact_root / "SUMMARY.md",
        "\n".join(
            [
                "# RM10 Validator Probe",
                "",
                f"- verdict: `{verdict}`",
                f"- reference_dir: `{args.reference_dir}`",
                f"- default_exit: `{default_result.returncode}`",
                f"- explicit_exit: `{explicit_result.returncode}`",
                f"- verify_hash: `{args.verify_hash}`",
                f"- solve_hash: `{args.solve_hash}`",
                "",
                "The retained historical RM10 parity bundle is the shortest live discriminator for whether",
                "the current device validator is just stale-default behavior or something deeper than hash comparison.",
            ]
        )
        + "\n",
    )
    write_text(
        artifact_root / "OUTCOME.md",
        "\n".join(
            [
                "# RM10 Validator Probe Outcome",
                "",
                f"- outcome_class: `{verdict}`",
                f"- comparison_index: `{repo_rel(comparison_index_tsv)}`",
                f"- next_admissible_move: {next_admissible_move}",
            ]
        )
        + "\n",
    )
    print(f"artifact_root={artifact_root}")
    return 0


def f2_surface_probe(args: argparse.Namespace) -> int:
    artifact_root = make_artifact_root("rm10_f2_surface_probe", args.artifact_root)
    artifact_root.mkdir(parents=True, exist_ok=False)
    serial, model = ensure_single_device()
    branch = run_local(["git", "-C", str(REPO_ROOT), "branch", "--show-current"], check=True).stdout.strip()
    props = device_props(serial)
    add_common_identity(
        artifact_root=artifact_root,
        serial=serial,
        model=model,
        props=props,
        extra_hash_paths=[
            args.root_binary,
            args.legacy_binary,
            "/data/local/tmp/SriYantraAdj_v1.bin",
            "/data/local/tmp/RegionTags_v1.bin",
            "/data/local/tmp/RegionTags_v2.bin",
            "/data/local/tmp/RegionTags_v2.json",
            "/data/local/tmp/PhonemePatterns_v1.bin",
            "/data/local/tmp/data/xnor_train.jsonl",
        ],
    )
    capture_probe_telemetry(serial, artifact_root, "pre")
    identity_root = artifact_root / "identity"
    capture_device_help(serial, args.root_binary, identity_root / "root_binary_help.txt")
    capture_device_help(serial, args.legacy_binary, identity_root / "legacy_binary_help.txt")
    capture_device_listing(
        serial,
        [
            args.root_cwd,
            args.legacy_cwd,
            args.root_binary,
            args.legacy_binary,
            "/data/local/tmp/SriYantraAdj_v1.bin",
            "/data/local/tmp/RegionTags_v1.bin",
            "/data/local/tmp/RegionTags_v2.bin",
            "/data/local/tmp/RegionTags_v2.json",
            "/data/local/tmp/PhonemePatterns_v1.bin",
            "/data/local/tmp/data/xnor_train.jsonl",
        ],
        identity_root / "required_path_listing.txt",
    )
    scenarios: list[ProbeResult] = []
    scenarios.append(
        run_probe(
            serial=serial,
            name="root_cpu_default",
            cwd=args.root_cwd,
            binary_path=args.root_binary,
            command_args="--mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/root_cpu_default.jsonl",
            setup_script=None,
            receipt_path="/data/local/tmp/root_cpu_default.jsonl",
            artifact_root=artifact_root,
            timeout_seconds=args.timeout_seconds,
        )
    )
    scenarios.append(
        run_probe(
            serial=serial,
            name="root_cpu_explicit_assets",
            cwd=args.root_cwd,
            binary_path=args.root_binary,
            command_args=(
                "--mode train --task harmonic --steps 1 --cpu "
                "--adj SriYantraAdj_v1.bin --tags RegionTags_v1.bin "
                "--output /data/local/tmp/root_cpu_explicit_assets.jsonl"
            ),
            setup_script=None,
            receipt_path="/data/local/tmp/root_cpu_explicit_assets.jsonl",
            artifact_root=artifact_root,
            timeout_seconds=args.timeout_seconds,
        )
    )
    cleanroom_minimal = "/data/local/tmp/f2_cleanroom_minimal_probe"
    scenarios.append(
        run_probe(
            serial=serial,
            name="cleanroom_minimal_cpu",
            cwd=cleanroom_minimal,
            binary_path=f"{cleanroom_minimal}/dm3_runner",
            command_args=(
                "--mode train --task harmonic --steps 1 --cpu "
                f"--output {cleanroom_minimal}/out.jsonl"
            ),
            setup_script=(
                f"SCR={shlex.quote(cleanroom_minimal)} && rm -rf \"$SCR\" && mkdir -p \"$SCR\"/data "
                "&& cp /data/local/tmp/dm3_runner \"$SCR\"/ "
                "&& cp /data/local/tmp/SriYantraAdj_v1.bin /data/local/tmp/RegionTags_v2.bin "
                "/data/local/tmp/RegionTags_v2.json \"$SCR\"/ "
                "&& cp /data/local/tmp/data/xnor_train.jsonl \"$SCR\"/data/"
            ),
            receipt_path=f"{cleanroom_minimal}/out.jsonl",
            artifact_root=artifact_root,
            timeout_seconds=args.timeout_seconds,
        )
    )
    cleanroom_rtags = "/data/local/tmp/f2_cleanroom_rtags_probe"
    scenarios.append(
        run_probe(
            serial=serial,
            name="cleanroom_regiontags_v1_cpu",
            cwd=cleanroom_rtags,
            binary_path=f"{cleanroom_rtags}/dm3_runner",
            command_args=(
                "--mode train --task harmonic --steps 1 --cpu "
                f"--output {cleanroom_rtags}/out.jsonl"
            ),
            setup_script=(
                f"SCR={shlex.quote(cleanroom_rtags)} && rm -rf \"$SCR\" && mkdir -p \"$SCR\"/data "
                "&& cp /data/local/tmp/dm3_runner \"$SCR\"/ "
                "&& cp /data/local/tmp/SriYantraAdj_v1.bin /data/local/tmp/RegionTags_v1.bin "
                "/data/local/tmp/RegionTags_v2.bin /data/local/tmp/RegionTags_v2.json \"$SCR\"/ "
                "&& cp /data/local/tmp/data/xnor_train.jsonl \"$SCR\"/data/"
            ),
            receipt_path=f"{cleanroom_rtags}/out.jsonl",
            artifact_root=artifact_root,
            timeout_seconds=args.timeout_seconds,
        )
    )
    scenarios.append(
        run_probe(
            serial=serial,
            name="legacy_dm3_gpu_train",
            cwd=args.legacy_cwd,
            binary_path=args.legacy_binary,
            command_args="--mode train --task harmonic --steps 1 -o /data/local/tmp/dm3/legacy_gpu_train.jsonl",
            setup_script=None,
            receipt_path="/data/local/tmp/dm3/legacy_gpu_train.jsonl",
            artifact_root=artifact_root,
            timeout_seconds=args.timeout_seconds,
        )
    )
    rows = [asdict(scenario) for scenario in scenarios]
    scenarios_by_name = scenario_lookup(rows)
    root_default = scenarios_by_name.get("root_cpu_default")
    root_explicit = scenarios_by_name.get("root_cpu_explicit_assets")
    surface_gate_ready = bool(root_default and root_default["classification"] == "callable")
    next_admissible_move = (
        "Repair or exact-localize the top-level /data/local/tmp/dm3_runner root surface before any official F2 outlier capture or heterogeneous brief."
    )
    if surface_gate_ready:
        next_admissible_move = (
            "The top-level /data/local/tmp/dm3_runner root surface is callable; the next admissible move is the official F2 outlier capture under hardened governance."
        )
    comparison_index_json, comparison_index_tsv = write_comparison_index(
        artifact_root,
        {
            "question": "Is the top-level F2 root residue surface ready for an official outlier-localization packet?",
            "rows": rows,
            "next_admissible_move": next_admissible_move,
        },
    )
    checkpoint_index_path = artifact_root / "identity" / "checkpoint_index.json"
    write_checkpoint_index(checkpoint_index_path, rows)
    write_root_identity(
        artifact_root=artifact_root,
        phase=args.phase,
        plan=args.plan,
        serial=serial,
        model=model,
        branch=branch,
        question="Is the top-level F2 root residue surface ready for an official outlier-localization packet?",
        outcome_class="surface_probe_complete",
        checkpoint_index_path=checkpoint_index_path,
        comparison_index_path=comparison_index_json,
        next_admissible_move=next_admissible_move,
    )
    capture_probe_telemetry(serial, artifact_root, "post")
    summary_lines = [
        "# RM10 F2 Surface Probe",
        "",
        "| Scenario | Classification | Exit | CWD | Binary |",
        "| --- | --- | --- | --- | --- |",
    ]
    for scenario in scenarios:
        summary_lines.append(
            f"| `{scenario.name}` | `{scenario.classification}` | `{scenario.exit_code}` | `{scenario.cwd}` | `{scenario.binary_path}` |"
        )
    summary_lines.extend(
        [
            "",
            "Interpretation:",
            interpretation_line("cleanroom_minimal_cpu", scenarios_by_name["cleanroom_minimal_cpu"]["classification"]),
            interpretation_line("cleanroom_regiontags_v1_cpu", scenarios_by_name["cleanroom_regiontags_v1_cpu"]["classification"]),
            interpretation_line("root_cpu_default", root_default["classification"]),
            interpretation_line("root_cpu_explicit_assets", root_explicit["classification"]) if root_explicit else "- `root_cpu_explicit_assets` did not retain a classification.",
            interpretation_line("legacy_dm3_gpu_train", scenarios_by_name["legacy_dm3_gpu_train"]["classification"]),
            "",
            f"Next admissible move: {next_admissible_move}",
        ]
    )
    write_text(artifact_root / "SUMMARY.md", "\n".join(summary_lines) + "\n")
    write_json(
        artifact_root / "summary.json",
        {
            "phase": args.phase,
            "plan": args.plan,
            "scenarios": rows,
            "surface_gate_ready": surface_gate_ready,
            "root_cpu_default_classification": root_default["classification"] if root_default else None,
            "next_admissible_move": next_admissible_move,
        },
    )
    write_text(
        artifact_root / "OUTCOME.md",
        "\n".join(
            [
                "# RM10 F2 Surface Probe Outcome",
                "",
                "- outcome_class: `surface_probe_complete`",
                f"- comparison_index: `{repo_rel(comparison_index_tsv)}`",
                f"- next_admissible_move: {next_admissible_move}",
            ]
        )
        + "\n",
    )
    print(f"artifact_root={artifact_root}")
    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="RM10 engineering-readiness probes for validator localization and residue surface repair."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    validator = subparsers.add_parser("validator-probe", help="Probe the live validator against a historical reference bundle.")
    validator.add_argument("--artifact-root")
    validator.add_argument("--phase", default=DEFAULT_PHASE)
    validator.add_argument("--plan", default="validator-stale-canonical-probe")
    validator.add_argument("--device-cwd", default=DEFAULT_VALIDATOR_CWD)
    validator.add_argument("--binary-path", default=DEFAULT_VALIDATOR_BINARY)
    validator.add_argument("--reference-dir", default=DEFAULT_HISTORICAL_REFERENCE)
    validator.add_argument("--verify-hash", default=DEFAULT_HISTORICAL_VERIFY)
    validator.add_argument("--solve-hash", default=DEFAULT_HISTORICAL_SOLVE)

    surface = subparsers.add_parser("f2-surface-probe", help="Probe the live F2 residue surfaces and hidden dependencies.")
    surface.add_argument("--artifact-root")
    surface.add_argument("--phase", default=DEFAULT_PHASE)
    surface.add_argument("--plan", default="f2-surface-repair-probe")
    surface.add_argument("--root-cwd", default=DEFAULT_F2_ROOT_CWD)
    surface.add_argument("--root-binary", default=DEFAULT_F2_ROOT_BINARY)
    surface.add_argument("--legacy-cwd", default=DEFAULT_F2_LEGACY_CWD)
    surface.add_argument("--legacy-binary", default=DEFAULT_F2_LEGACY_BINARY)
    surface.add_argument("--timeout-seconds", type=int, default=DEFAULT_F2_SURFACE_TIMEOUT_SECONDS)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.command == "validator-probe":
        return validator_probe(args)
    if args.command == "f2-surface-probe":
        return f2_surface_probe(args)
    raise SystemExit(f"Unknown command: {args.command}")


if __name__ == "__main__":
    raise SystemExit(main())
