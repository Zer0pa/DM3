#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import shlex
import subprocess
import sys
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_PHASE = "01.2.3.4.1.1.4"
DEFAULT_PLAN = "npu-path-probe"
SEARCH_DIRS = (
    "/system/bin",
    "/system_ext/bin",
    "/vendor/bin",
    "/vendor/bin/hw",
    "/odm/bin",
)
EXECUTABLE_TOKENS = ("qnn", "snpe", "hexagon", "hta")
LIB_TOKENS = ("qnn", "snpe", "adsprpc", "cdsprpc", "hta", "hexagon", "fastrpc")
SERVICE_PATTERNS = "qnn|snpe|dsp|cdsp|adsp|adsprpc|cdsprpc|fastrpc|hexagon|hta"
HELP_FLAGS = {
    "qnn-net-run": ["--help"],
    "qnn-context-binary-generator": ["--help"],
    "qnn-profile-viewer": ["--help"],
    "snpe-net-run": ["--help"],
    "snpe-dlc-info": ["--help"],
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Probe the attached RM10 for a bounded callable user-space NPU path."
    )
    parser.add_argument("--artifact-root", required=True, help="Artifact root to create.")
    parser.add_argument("--phase", default=DEFAULT_PHASE, help=f"Phase label. Default: {DEFAULT_PHASE}.")
    parser.add_argument("--plan", default=DEFAULT_PLAN, help=f"Plan label. Default: {DEFAULT_PLAN}.")
    parser.add_argument(
        "--max-candidates",
        type=int,
        default=8,
        help="Maximum executable candidates to probe with bounded help invocations. Default: 8.",
    )
    return parser.parse_args()


def run_local(cmd: list[str], *, check: bool = True, timeout: int | None = None) -> subprocess.CompletedProcess[str]:
    completed = subprocess.run(cmd, capture_output=True, text=True, check=False, timeout=timeout)
    if check and completed.returncode != 0:
        raise SystemExit(
            f"Command failed ({completed.returncode}): {' '.join(shlex.quote(part) for part in cmd)}\n"
            f"STDOUT:\n{completed.stdout}\nSTDERR:\n{completed.stderr}"
        )
    return completed


def adb_shell(command: str, *, check: bool = True, timeout: int | None = None) -> subprocess.CompletedProcess[str]:
    return run_local(["adb", "shell", command], check=check, timeout=timeout)


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def write_json(path: Path, payload: Any) -> None:
    write_text(path, json.dumps(payload, indent=2, sort_keys=False) + "\n")


def repo_rel(path: Path) -> str:
    return path.resolve().relative_to(REPO_ROOT).as_posix()


def ensure_single_device() -> tuple[str, str]:
    devices = run_local(["adb", "devices", "-l"], check=True).stdout.strip().splitlines()
    live = [line for line in devices[1:] if line.strip() and " device " in f" {line} "]
    if len(live) != 1:
        raise SystemExit(f"Expected exactly one attached ADB device, found {len(live)}:\n" + "\n".join(live))
    serial = live[0].split()[0]
    model = adb_shell("getprop ro.product.model", check=True).stdout.strip()
    return serial, model


def detect_branch() -> str:
    return run_local(["git", "-C", str(REPO_ROOT), "branch", "--show-current"], check=True).stdout.strip()


def shell_lines(command: str) -> list[str]:
    completed = adb_shell(command, check=False)
    return [line.strip() for line in completed.stdout.splitlines() if line.strip()]


def token_pattern(tokens: tuple[str, ...]) -> re.Pattern[str]:
    return re.compile("|".join(re.escape(token) for token in tokens), re.IGNORECASE)


def filter_candidate_paths(paths: list[str], tokens: tuple[str, ...]) -> list[str]:
    pattern = token_pattern(tokens)
    return sorted(
        {
            path
            for path in paths
            if pattern.search(Path(path).name)
        }
    )


def list_candidate_executables() -> list[str]:
    parts = []
    for directory in SEARCH_DIRS:
        parts.append(
            f"if [ -d {shlex.quote(directory)} ]; then "
            f"find {shlex.quote(directory)} -maxdepth 1 -type f 2>/dev/null || true; fi"
        )
    command = "; ".join(parts) + ";"
    return filter_candidate_paths(shell_lines(command), EXECUTABLE_TOKENS)


def list_candidate_libs() -> list[str]:
    command = (
        "for d in /vendor/lib64 /system/lib64 /system_ext/lib64 /odm/lib64; do "
        "[ -d \"$d\" ] || continue; "
        "find \"$d\" -maxdepth 1 -type f 2>/dev/null || true; "
        "done"
    )
    return filter_candidate_paths(shell_lines(command), LIB_TOKENS)


def list_services() -> list[str]:
    return shell_lines(f"service list 2>/dev/null | grep -Ei '{SERVICE_PATTERNS}' || true")


def list_processes() -> list[str]:
    return shell_lines(f"ps -A -o PID,PPID,STAT,TIME,ARGS | grep -Ei '{SERVICE_PATTERNS}' | grep -v grep || true")


def probe_help(path: str) -> dict[str, Any]:
    binary = Path(path).name
    flags = HELP_FLAGS.get(binary, ["--help"])
    command = (
        f"/system/bin/timeout 10 {shlex.quote(path)} " + " ".join(shlex.quote(flag) for flag in flags)
    )
    completed = adb_shell(command, check=False, timeout=15)
    return {
        "path": path,
        "binary": binary,
        "command": command,
        "exit_code": completed.returncode,
        "stdout": completed.stdout,
        "stderr": completed.stderr,
        "callable_hint": completed.returncode not in (126, 127) or bool(completed.stdout.strip() or completed.stderr.strip()),
    }


def classify_verdict(exec_candidates: list[str], help_results: list[dict[str, Any]], libs: list[str], services: list[str]) -> str:
    if any(result["callable_hint"] for result in help_results):
        return "callable_path_found"
    if exec_candidates or libs or services:
        return "inventory_only"
    return "no_npu_surface"


def outcome_markdown(verdict: str, exec_candidates: list[str], libs: list[str], services: list[str], help_results: list[dict[str, Any]]) -> str:
    lines = [
        "# RM10 NPU Path Probe Outcome",
        "",
        f"- verdict: `{verdict}`",
        f"- executable_candidates: `{len(exec_candidates)}`",
        f"- library_candidates: `{len(libs)}`",
        f"- matching_services: `{len(services)}`",
        f"- bounded_help_probes: `{len(help_results)}`",
    ]
    if help_results:
        first_callable = next((result for result in help_results if result["callable_hint"]), None)
        if first_callable is not None:
            lines.append(f"- strongest_callable_hint: `{first_callable['path']}`")
    lines.append("")
    if verdict == "callable_path_found":
        lines.append("A bounded user-space executable surface responded to a direct help probe. The lane is still experimental, but it is no longer inventory-only.")
    elif verdict == "inventory_only":
        lines.append("The device exposes accelerator-adjacent infrastructure, but no bounded help probe established a usable user-space execution path.")
    else:
        lines.append("The direct probe did not find meaningful user-space accelerator surfaces on the attached device.")
    lines.append("")
    lines.append("No claim beyond this verdict is justified from this packet.")
    return "\n".join(lines) + "\n"


def main() -> int:
    args = parse_args()
    artifact_root = Path(args.artifact_root).resolve()
    identity_root = artifact_root / "identity"
    logs_root = artifact_root / "logs"
    telemetry_root = artifact_root / "telemetry"
    probes_root = artifact_root / "probes"
    for directory in (identity_root, logs_root, telemetry_root, probes_root):
        directory.mkdir(parents=True, exist_ok=True)

    serial, model = ensure_single_device()
    branch = detect_branch()

    battery_pre = adb_shell("dumpsys battery", check=False).stdout
    thermal_pre = adb_shell("dumpsys thermalservice", check=False).stdout
    write_text(telemetry_root / "battery_pre.txt", battery_pre)
    write_text(telemetry_root / "thermal_pre.txt", thermal_pre)

    executables = list_candidate_executables()
    libs = list_candidate_libs()
    services = list_services()
    processes = list_processes()
    write_text(logs_root / "candidate_executables.txt", "\n".join(executables) + ("\n" if executables else ""))
    write_text(logs_root / "candidate_libs.txt", "\n".join(libs) + ("\n" if libs else ""))
    write_text(logs_root / "matching_services.txt", "\n".join(services) + ("\n" if services else ""))
    write_text(logs_root / "matching_processes.txt", "\n".join(processes) + ("\n" if processes else ""))

    help_results = [probe_help(path) for path in executables[: args.max_candidates]]
    for index, result in enumerate(help_results, start=1):
        write_json(probes_root / f"help_probe_{index:02d}.json", result)

    battery_post = adb_shell("dumpsys battery", check=False).stdout
    thermal_post = adb_shell("dumpsys thermalservice", check=False).stdout
    write_text(telemetry_root / "battery_post.txt", battery_post)
    write_text(telemetry_root / "thermal_post.txt", thermal_post)

    verdict = classify_verdict(executables, help_results, libs, services)
    summary = {
        "run_id": artifact_root.name,
        "phase": args.phase,
        "plan": args.plan,
        "branch": branch,
        "device_serial": serial,
        "device_model": model,
        "verdict": verdict,
        "executable_candidates": executables,
        "library_candidates": libs,
        "matching_services": services,
        "matching_processes": processes,
        "help_probe_count": len(help_results),
        "callable_hints": [result["path"] for result in help_results if result["callable_hint"]],
    }
    write_json(artifact_root / "summary.json", summary)
    write_json(
        identity_root / "run_identity.json",
        {
            "run_id": artifact_root.name,
            "phase": args.phase,
            "plan": args.plan,
            "branch": branch,
            "machine_class": "rm10_device",
            "device_serial": serial,
            "device_model": model,
            "authority_status": "feasibility_only",
            "question": "Does the attached RM10 expose a bounded callable user-space NPU path?",
            "artifact_root": repo_rel(artifact_root),
            "summary_path": repo_rel(artifact_root / "summary.json"),
        },
    )
    write_text(artifact_root / "OUTCOME.md", outcome_markdown(verdict, executables, libs, services, help_results))

    print(artifact_root)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
