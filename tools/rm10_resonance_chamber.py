#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import shlex
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

import rm10_capture as cap


REPO_ROOT = Path(__file__).resolve().parents[1]


@dataclass(frozen=True)
class ChamberRow:
    name: str
    surface_id: str
    lane: str
    task: str
    steps: int = 1
    gated: bool = False
    freq: float | None = None
    rotation: float = 0.0
    asymmetry: float = 0.0
    note: str = ""


PRESET_ROWS: dict[str, ChamberRow] = {
    "cpu_harmonic_a": ChamberRow(
        name="cpu_harmonic_a",
        surface_id="f2_root_chamber_candidate",
        lane="cpu",
        task="harmonic",
        note="CPU-only harmonic control row A.",
    ),
    "gpu_harmonic_a": ChamberRow(
        name="gpu_harmonic_a",
        surface_id="f2_root_chamber_candidate",
        lane="gpu",
        task="harmonic",
        note="GPU-coupled harmonic row A.",
    ),
    "cpu_harmonic_b": ChamberRow(
        name="cpu_harmonic_b",
        surface_id="f2_root_chamber_candidate",
        lane="cpu",
        task="harmonic",
        note="CPU-only harmonic control row B.",
    ),
    "gpu_harmonic_b": ChamberRow(
        name="gpu_harmonic_b",
        surface_id="f2_root_chamber_candidate",
        lane="gpu",
        task="harmonic",
        note="GPU-coupled harmonic row B.",
    ),
    "cpu_harmonic_gated": ChamberRow(
        name="cpu_harmonic_gated",
        surface_id="f2_root_chamber_candidate",
        lane="cpu",
        task="harmonic",
        gated=True,
        note="CPU-only harmonic row with strict resonance gating.",
    ),
    "gpu_harmonic_gated": ChamberRow(
        name="gpu_harmonic_gated",
        surface_id="f2_root_chamber_candidate",
        lane="gpu",
        task="harmonic",
        gated=True,
        note="GPU-coupled harmonic row with strict resonance gating.",
    ),
    "cpu_holography_a": ChamberRow(
        name="cpu_holography_a",
        surface_id="f2_root_chamber_candidate",
        lane="cpu",
        task="holography",
        note="CPU-only holography control row.",
    ),
    "gpu_holography_a": ChamberRow(
        name="gpu_holography_a",
        surface_id="f2_root_chamber_candidate",
        lane="gpu",
        task="holography",
        note="GPU-coupled holography row.",
    ),
}

DEFAULT_ROW_SET = [
    "cpu_harmonic_a",
    "gpu_harmonic_a",
    "cpu_harmonic_b",
    "gpu_harmonic_b",
    "cpu_harmonic_gated",
    "gpu_harmonic_gated",
]


def ensure_dirs(*paths: Path) -> None:
    for path in paths:
        cap.ensure_dir(path)


def row_names(requested: list[str] | None) -> list[str]:
    if not requested:
        return DEFAULT_ROW_SET
    missing = [name for name in requested if name not in PRESET_ROWS]
    if missing:
        raise SystemExit(f"Unknown chamber row(s): {', '.join(missing)}")
    return requested


def build_command(binary_path: str, cwd: str, output_path: str, row: ChamberRow, timeout: int) -> str:
    parts = [
        f"cd {shlex.quote(cwd)}",
        "&&",
        f"rm -f {shlex.quote(output_path)}",
        "&&",
        f"/system/bin/timeout {timeout}",
        shlex.quote(binary_path),
        "--mode train",
        f"--task {shlex.quote(row.task)}",
        f"--steps {row.steps}",
    ]
    if row.lane == "cpu":
        parts.append("--cpu")
    if row.gated:
        parts.append("--gated")
    if row.freq is not None:
        parts.append(f"--freq {row.freq}")
    if row.rotation:
        parts.append(f"--rotation {row.rotation}")
    if row.asymmetry:
        parts.append(f"--asymmetry {row.asymmetry}")
    parts.append(f"--output {shlex.quote(output_path)}")
    return " ".join(parts)


def receipt_head(path: Path) -> dict[str, Any]:
    if not path.is_file():
        return {}
    raw = path.read_text(encoding="utf-8").splitlines()
    if not raw:
        return {}
    return json.loads(raw[0])


def marker(stdout_text: str, lane: str) -> str:
    return cap.detect_marker(stdout_text, lane)


def write_summary_table(rows: list[dict[str, Any]], destination: Path) -> None:
    header = [
        "row_name",
        "lane",
        "task",
        "gated",
        "decision",
        "delta_E",
        "coherence",
        "duration_ms",
        "marker",
        "status",
    ]
    lines = ["\t".join(header)]
    for row in rows:
        lines.append(
            "\t".join(
                str(row.get(key, ""))
                for key in header
            )
        )
    cap.write_text(destination, "\n".join(lines) + "\n")


def write_row_definition(path: Path, row: ChamberRow, command_exact: str, output_path: str) -> None:
    payload = asdict(row)
    payload.update(
        {
            "command_exact": command_exact,
            "output_path": output_path,
        }
    )
    cap.write_json(path, payload)


def capture_runner_snapshot(serial: str, cwd: str, destination: Path) -> None:
    cap.capture_shell_output(
        serial,
        (
            f"cd {shlex.quote(cwd)} && "
            "ps -A -o PID,PPID,STAT,TIME,ARGS | grep dm3_runner | grep -v grep || true"
        ),
        destination,
    )


def cleanup_runner_surface(serial: str) -> None:
    cap.adb_shell(
        serial,
        "pkill -TERM dm3_runner 2>/dev/null || true; "
        "sleep 1; "
        "pkill -KILL dm3_runner 2>/dev/null || true",
        check=False,
    )


def run_matrix(args: argparse.Namespace) -> int:
    artifact_root = Path(args.artifact_root).resolve()
    identity_root = artifact_root / "identity"
    rows_root = artifact_root / "rows"
    comparisons_root = artifact_root / "comparisons"
    ensure_dirs(identity_root, rows_root, comparisons_root)

    branch = args.branch or cap.current_branch(REPO_ROOT)
    adb_devices = cap.adb(None, "devices", "-l")
    cap.write_text(identity_root / "adb_devices.txt", adb_devices.stdout)
    serial = cap.resolve_serial(args.serial, adb_devices.stdout)

    props = cap.device_props(serial)
    cap.write_device_props(identity_root / "device_props.txt", props)
    if args.expected_model and props["ro.product.model"] != args.expected_model:
        raise SystemExit(
            f"Device model mismatch: expected {args.expected_model}, got {props['ro.product.model']}"
        )

    cap.capture_shell_output(
        serial,
        f"cd {shlex.quote(args.device_cwd)} && env | sort",
        identity_root / "env.txt",
    )
    cap.capture_shell_output(serial, "dumpsys battery", identity_root / "battery_pre.txt")
    cap.capture_shell_output(serial, "dumpsys thermalservice", identity_root / "thermal_pre.txt")
    help_result = cap.adb_shell(serial, f"{shlex.quote(args.binary_path)} --help", check=False)
    cap.record_process(
        help_result,
        identity_root / "binary_help.txt",
        identity_root / "binary_help_stderr.txt",
    )
    binary_sha = cap.parse_sha256sum(
        cap.adb_shell(serial, f"sha256sum {shlex.quote(args.binary_path)}").stdout
    )
    cap.write_text(identity_root / "binary_sha256.txt", f"{binary_sha}  {args.binary_path}\n")

    rows = [PRESET_ROWS[name] for name in row_names(args.rows)]
    session_question = (
        "One bounded environment smoke: prove repeated windows can select the "
        "top-level chamber candidate's CPU-forced and accelerator-backed rows "
        "under one fixed identity and telemetry contract."
    )
    cap.write_text(identity_root / "session_question.txt", session_question + "\n")
    cap.write_text(identity_root / "checkpoint_policy.txt", "rerun-only\n")
    cap.write_json(
        identity_root / "row_set.json",
        {
            "phase": args.phase,
            "plan": args.plan,
            "run_prefix": args.run_prefix,
            "surface_id": rows[0].surface_id if rows else "",
            "binary_path": args.binary_path,
            "device_cwd": args.device_cwd,
            "rows": [asdict(row) for row in rows],
        },
    )

    if args.dry_run:
        preview = []
        for row in rows:
            output_path = f"{args.device_cwd}/{args.run_prefix}_{row.name}.jsonl"
            device_command = build_command(
                args.binary_path,
                args.device_cwd,
                output_path,
                row,
                args.row_timeout_sec,
            )
            preview.append(
                {
                    "row": row.name,
                    "surface_id": row.surface_id,
                    "command_exact": f"adb shell {shlex.quote(device_command)}",
                    "output_path": output_path,
                }
            )
        cap.write_json(identity_root / "dry_run_preview.json", preview)
        print(artifact_root)
        return 0

    comparison_rows: list[dict[str, Any]] = []
    checkpoint_rows: list[dict[str, Any]] = []
    capture_runner_snapshot(serial, args.device_cwd, identity_root / "runner_snapshot_pre_cleanup.txt")
    cleanup_runner_surface(serial)
    capture_runner_snapshot(serial, args.device_cwd, identity_root / "runner_snapshot_post_cleanup.txt")

    for row in rows:
        row_root = rows_root / row.name
        row_identity = row_root / "identity"
        row_logs = row_root / "logs"
        row_receipts = row_root / "receipts"
        row_telemetry = row_root / "telemetry"
        row_metrics = row_root / "metrics"
        ensure_dirs(row_identity, row_logs, row_receipts, row_telemetry, row_metrics)

        output_path = f"{args.device_cwd}/{args.run_prefix}_{row.name}.jsonl"
        device_command = build_command(
            args.binary_path,
            args.device_cwd,
            output_path,
            row,
            args.row_timeout_sec,
        )
        command_exact = f"adb shell {shlex.quote(device_command)}"
        cap.write_text(row_identity / "command.txt", command_exact + "\n")
        write_row_definition(row_identity / "row_definition.json", row, command_exact, output_path)

        cleanup_runner_surface(serial)
        capture_runner_snapshot(serial, args.device_cwd, row_identity / "runner_snapshot_before_command.txt")
        cap.capture_shell_output(serial, "dumpsys battery", row_telemetry / "battery_pre.txt")
        cap.capture_shell_output(serial, "dumpsys thermalservice", row_telemetry / "thermal_pre.txt")
        result = cap.adb_shell(serial, device_command, check=False)
        cap.record_process(
            result,
            row_logs / "stdout.txt",
            row_logs / "stderr.txt",
            row_logs / "exit_code.txt",
        )
        cap.capture_shell_output(serial, "dumpsys battery", row_telemetry / "battery_post.txt")
        cap.capture_shell_output(serial, "dumpsys thermalservice", row_telemetry / "thermal_post.txt")

        pull_result = cap.adb(serial, "pull", output_path, str(row_receipts), check=False)
        cap.record_process(
            pull_result,
            row_logs / "adb_pull_stdout.txt",
            row_logs / "adb_pull_stderr.txt",
            row_logs / "adb_pull_exit_code.txt",
        )

        local_receipt = row_receipts / f"{args.run_prefix}_{row.name}.jsonl"
        payload = receipt_head(local_receipt)
        row_marker = marker(result.stdout, row.lane)
        summary = {
            "row_name": row.name,
            "surface_id": row.surface_id,
            "lane": row.lane,
            "task": row.task,
            "gated": row.gated,
            "freq": row.freq,
            "rotation": row.rotation,
            "asymmetry": row.asymmetry,
            "marker": row_marker,
            "status": "ok" if payload else "receipt_missing",
            "exit_code": result.returncode,
            "command_exact": command_exact,
            "binary_path": args.binary_path,
            "device_cwd": args.device_cwd,
            "output_path": output_path,
            "receipt_path": str(local_receipt) if local_receipt.exists() else "",
            **payload,
        }
        if local_receipt.exists():
            summary["receipt_sha256"] = cap.sha256_file(local_receipt)
        cap.write_json(row_metrics / "summary.json", summary)
        comparison_rows.append(summary)
        checkpoint_rows.append(
            {
                "row_name": row.name,
                "surface_id": row.surface_id,
                "lane": row.lane,
                "command_path": str(row_identity / "command.txt"),
                "receipt_path": str(local_receipt) if local_receipt.exists() else "",
                "summary_path": str(row_metrics / "summary.json"),
                "exit_code": result.returncode,
            }
        )

    cap.capture_shell_output(serial, "dumpsys battery", identity_root / "battery_post.txt")
    cap.capture_shell_output(serial, "dumpsys thermalservice", identity_root / "thermal_post.txt")
    capture_runner_snapshot(serial, args.device_cwd, identity_root / "runner_snapshot_post_session.txt")
    cap.write_json(
        identity_root / "checkpoint_index.json",
        {
            "policy": "rerun-only",
            "rows": checkpoint_rows,
        },
    )
    cap.write_json(
        comparisons_root / "summary.json",
        {
            "phase": args.phase,
            "plan": args.plan,
            "branch": branch,
            "run_prefix": args.run_prefix,
            "session_question": session_question,
            "surface_id": rows[0].surface_id if rows else "",
            "device_cwd": args.device_cwd,
            "binary_path": args.binary_path,
            "binary_sha256": binary_sha,
            "observable_tuple_fields": [
                "decision",
                "delta_E",
                "coherence",
                "duration_ms",
                "marker",
            ],
            "rows": comparison_rows,
        },
    )
    write_summary_table(comparison_rows, comparisons_root / "summary.tsv")
    print(artifact_root)
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Run bounded repeated-window resonance chamber batteries on RM10."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    matrix = subparsers.add_parser("matrix", help="Run a repeated-window chamber matrix.")
    matrix.add_argument("--artifact-root", required=True)
    matrix.add_argument("--run-prefix", required=True)
    matrix.add_argument("--phase", default="01.2.3.4.1.1.3")
    matrix.add_argument("--plan", default="resonance-chamber")
    matrix.add_argument("--branch")
    matrix.add_argument("--serial")
    matrix.add_argument("--expected-model", default="NX789J")
    matrix.add_argument("--device-cwd", default="/data/local/tmp")
    matrix.add_argument("--binary-path", default="/data/local/tmp/dm3_runner")
    matrix.add_argument("--row-timeout-sec", type=int, default=180)
    matrix.add_argument("--rows", nargs="*")
    matrix.add_argument("--dry-run", action="store_true")
    matrix.set_defaults(func=run_matrix)
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
