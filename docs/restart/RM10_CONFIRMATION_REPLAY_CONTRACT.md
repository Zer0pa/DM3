# RM10 Confirmation Replay Contract

Last refreshed: `2026-04-16`

## Purpose

Freeze the exact confirmation replay that tests whether the repaired four-row
same-family packet is reproducible.

## Locked Envelope

- binary: `/data/local/tmp/dm3_runner`
- cwd: `/data/local/tmp`
- rows: `cpu_a,gpu_a,gpu_b,cpu_b`
- row timeout: `420` seconds
- periodic telemetry sampling: `15` seconds
- comparison anchor:
  `artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay`
- confirmation artifact:
  `artifacts/phase_01_2_3_4_1_1_3_1_2_confirmation_replay_20260415T225828Z_full_replay`

## Required Comparison Tuple

For each row retain:

- `decision`
- `delta_E`
- `coherence`
- `duration_ms`
- `receipt_sha256`
- battery temperature pre/post
- thermal status pre/post

## Outcome Classes

- `reproducible_repair`: the full packet completes with a stable CPU bracket and
  no widened drift class relative to the repaired packet
- `non_reproducible_repair`: the full packet completes but the CPU bracket
  diverges beyond the bounded tolerance, so the repaired packet is not stable
- `blocked`: any missing row, missing receipt, or surface drift that breaks the
  same-family comparison

## Gate Rule

Only `reproducible_repair` may open a bounded homeostasis battery.

Any other result keeps homeostasis blocked and returns the branch to narrower
environment or regime-localization engineering.
