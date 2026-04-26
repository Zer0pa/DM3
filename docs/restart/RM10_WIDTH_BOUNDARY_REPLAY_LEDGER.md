# RM10 Width-Boundary Replay Ledger

Last refreshed: `2026-04-15`

## Purpose

Record the decisive same-family width-boundary replay on the top-level
`/data/local/tmp/dm3_runner` surface.

## Frozen Comparison Family

- family: `f2_harmonic_residue`
- surface: top-level `/data/local/tmp/dm3_runner`
- cwd: `/data/local/tmp`
- packet:
  [phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay)

## Replay Design

Primary replay only:

- rows: `cpu_a,gpu_a,gpu_b,cpu_b`
- timeout: `420` seconds per row
- periodic telemetry: `15` seconds

No follow-up replay was needed because the decisive `cpu_b` row completed with
a retained receipt.

## Results

| Row | Lane | Marker | Decision | delta_E | coherence | duration_ms | Receipt |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| `cpu_a` | `cpu` | `cpu_forced` | `Commit` | `88.8497` | `0.7699` | `154758` | present |
| `gpu_a` | `gpu` | `gpu_init` | `Commit` | `75.6872` | `0.8917` | `155030` | present |
| `gpu_b` | `gpu` | `gpu_init` | `Commit` | `88.3132` | `0.7681` | `154889` | present |
| `cpu_b` | `cpu` | `cpu_forced` | `Commit` | `89.0130` | `0.7691` | `154554` | present |

## Comparison With The Inherited Failure

This packet sharpens the old same-family story in two ways:

- the exact four-row packet now survives through `cpu_b`
- all four rows retained real receipts rather than missing or zero-byte output

So the earlier claim that the four-row packet necessarily collapses at the
closing row no longer survives as the active truth floor.

## What The Packet Did Not Settle

This packet does not prove that the old `180`-second timeout was the sole
cause of failure.

Why not:

- the repaired `cpu_b` row completed in `154554 ms`, which is below `180`
  seconds
- that means the stronger envelope repaired the packet, but the retained
  evidence does not isolate whether timeout, ambient state, or other
  environment factors were the decisive cause

## Thermal Note

- thermal status stayed `0` on all rows
- battery temperature remained in the `24.0 C` to `26.0 C` range

So this packet does not support a thermal-emergency explanation.
It does leave open a milder environment-sensitivity explanation because the
packet ran substantially cooler than the earlier `33.0 C` widened packet.

## Outcome Class

Primary outcome: `wrapper_ceiling_relaxed`

Operational meaning:

- the stronger replay envelope repaired the old closing-row collapse
- the same-family four-row observable now survives honestly
- causal localization remains open

## Strongest Surviving Structure

The packet is no longer dominated by missing receipts.
The strongest surviving behavioral feature is now a single GPU-backed outlier
row:

- `gpu_a` remains separated from the `cpu_a/gpu_b/cpu_b` cluster

That structure is interesting, but it is not yet a stable claim from one
packet alone.
