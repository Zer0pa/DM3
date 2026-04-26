# RM10 Confirmation Replay Comparison Ledger

Last refreshed: `2026-04-16`

## Purpose

Compare the repaired width-boundary packet against the immediate confirmation
replay under the same stronger envelope.

## Packet A: Repaired Width-Boundary Replay

Artifact:
`artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay`

- `cpu_a`: `delta_E=88.84970092773438`, `coherence=0.769934356212616`,
  `duration_ms=154758`
- `gpu_a`: `delta_E=75.68717956542969`, `coherence=0.8916881084442139`,
  `duration_ms=155030`
- `gpu_b`: `delta_E=88.31316375732422`, `coherence=0.768072247505188`,
  `duration_ms=154889`
- `cpu_b`: `delta_E=89.01295471191406`, `coherence=0.7691243290901184`,
  `duration_ms=154554`
- battery range: `24.0 C` to `26.0 C`
- thermal status: always `0`

## Packet B: Confirmation Replay

Artifact:
`artifacts/phase_01_2_3_4_1_1_3_1_2_confirmation_replay_20260415T225828Z_full_replay`

- `cpu_a`: `delta_E=88.7163314819336`, `coherence=0.7701616287231445`,
  `duration_ms=201025`
- `gpu_a`: `delta_E=76.0736312866211`, `coherence=0.8917461633682251`,
  `duration_ms=201382`
- `gpu_b`: `delta_E=74.88800811767578`, `coherence=0.8780325055122375`,
  `duration_ms=201120`
- `cpu_b`: `delta_E=74.59822845458984`, `coherence=0.8928934335708618`,
  `duration_ms=200744`
- battery range: `26.0 C` to `28.0 C`
- thermal status: always `0`

## Comparison Verdict

- The packet completed with real receipts on all four rows.
- The repaired packet did not reproduce.
- `cpu_a` stayed in the earlier high-`delta_E` / lower-`coherence` regime.
- `gpu_b` and `cpu_b` moved together into the lower-`delta_E` / higher-
  `coherence` regime.
- The CPU bracket no longer stayed tight, so the helper classified the replay as
  `whole_session_instability`.

## What This Kills

- a stable repaired same-family surface
- homeostasis-gate reopening from one repaired packet
- a GPU-only explanation for the confirmation replay drift

## What Survives

- the four-row packet is callable under the stronger envelope
- the repaired packet was real
- regime selection is still unstable across sessions
- the next honest move is to localize how the session enters the high or low
  regime before reopening any behavior-class battery
