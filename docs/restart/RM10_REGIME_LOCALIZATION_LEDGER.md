# RM10 Regime Localization Ledger

Last refreshed: `2026-04-16`

## Purpose

Test whether the low-regime shift seen in the failed confirmation replay is a
third-row effect or can already be present at row `cpu_a`.

## Localization Packet

Artifact:
`artifacts/phase_01_2_3_4_1_1_3_1_2_1_third_row_localization_20260415T231357Z_cpu_a_gpu_a_cpu_b`

Locked envelope:

- binary: `/data/local/tmp/dm3_runner`
- cwd: `/data/local/tmp`
- rows: `cpu_a,gpu_a,cpu_b`
- row timeout: `420` seconds
- periodic telemetry sampling: `15` seconds

Retained metrics:

- `cpu_a`: `delta_E=75.56963348388672`, `coherence=0.8767658472061157`,
  `duration_ms=200287`
- `gpu_a`: `delta_E=75.47908782958984`, `coherence=0.8773638606071472`,
  `duration_ms=200151`
- `cpu_b`: `delta_E=75.94017028808594`, `coherence=0.8773729205131531`,
  `duration_ms=199314`
- battery temperature: fixed at `26.0 C`
- thermal status: always `0`

## Comparison Against Prior Packets

- The repaired packet showed a mostly high regime with only `gpu_a` low.
- The failed confirmation replay showed a mixed packet: `cpu_a` high, then
  `gpu_b` and `cpu_b` low.
- This localization packet starts low at `cpu_a` and stays low.

## Rejections

- `third_row_only`: rejected
- `gpu_b_is_required_for_low_regime`: rejected
- `thermal_alarm_story`: rejected

## Surviving Interpretation

The decisive regime choice is already active before row `cpu_a` begins.

The branch is not blocked by packet width anymore. It is blocked by not yet
knowing which pre-run or start-state condition selects the high versus low
same-family regime.
