# RM10 Width-Boundary Replay Matrix

Last refreshed: `2026-04-15`

## Purpose

Freeze the exact replay design for the live same-family width-boundary phase.

## Primary Replay

Name: `full_replay`

- binary: `/data/local/tmp/dm3_runner`
- cwd: `/data/local/tmp`
- rows: `cpu_a,gpu_a,gpu_b,cpu_b`
- row timeout: increased above the old `180`-second ceiling
- periodic telemetry: enabled

Question:

- does the exact four-row packet now survive honestly?

## Bounded Follow-Up Replay

Name: `cpu_b_isolated`

Run only if the decisive `cpu_b` row still fails in `full_replay`.

- binary: `/data/local/tmp/dm3_runner`
- cwd: `/data/local/tmp`
- rows: `cpu_b`
- row timeout: same stronger timeout as `full_replay`
- periodic telemetry: enabled

Question:

- does `cpu_b` survive on a fresh isolated replay even though it failed as the
  closing row of the full packet?

## Interpretation Table

If `full_replay` completes through `cpu_b` with retained tuple and receipt:

- classify as `wrapper_ceiling_relaxed`

If `full_replay` still fails at `cpu_b` and `cpu_b_isolated` also fails:

- classify as `late_session_hang_retained` or `receipt_corruption_unresolved`
  based on retained receipt evidence

If `full_replay` fails at `cpu_b` but `cpu_b_isolated` completes:

- classify as `session_width_sensitive`

If both replays end without decisive tuple or receipt custody:

- classify as `unresolved`

## Forbidden Drift

Do not:

- switch to `F1`
- switch to legacy `/data/local/tmp/dm3/dm3_runner`
- add NPU or new lane probes
- widen into multi-variant parameter sweep
