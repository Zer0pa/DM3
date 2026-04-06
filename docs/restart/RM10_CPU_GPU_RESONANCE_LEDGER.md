# RM10 CPU GPU Resonance Ledger

Last refreshed: `2026-04-06`

## Purpose

Record the bounded Plan 03 chamber battery on the live resonance environment
without widening families or narrating runtime noise as chamber signal.

## Frozen Comparison Family

- comparison family: `f2_harmonic_residue`
- surface id: `f2_root_chamber_candidate`
- binary: `/data/local/tmp/dm3_runner`
- `cwd`: `/data/local/tmp`
- environment contract: [RM10_GEOMETRIC_ENVIRONMENT_SPEC.md](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_GEOMETRIC_ENVIRONMENT_SPEC.md)

This is not a cross-family comparison against `F1`.
`F1` remains the external governance anchor only.

## Anchor Observable

Per-row tuple:

- `decision`
- `delta_E`
- `coherence`
- `duration_ms`
- `marker`

## Drift Observable

- missing receipt
- zero-byte receipt
- CPU-to-GPU class loss
- exit-code collapse
- thermal-envelope mismatch

## Abstain Rules

Return `UNRESOLVED` if any of the following happen:

- retained tuples are not comparable across rows
- missing or zero-byte receipts dominate the packet
- control noise or execution collapse overwhelms any effect interpretation
- thermal mismatch is needed to explain the result

## Battery Design

Rows:

1. `cpu_harmonic_a`
2. `gpu_harmonic_a`
3. `cpu_harmonic_b`
4. `gpu_harmonic_b`

Packet:

- [phase_01_2_3_4_1_1_3_cpu_gpu_chamber_20260406T004242Z](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_cpu_gpu_chamber_20260406T004242Z)

## Results

| Row | Lane | Exit code | Marker | Receipt status | Tuple status |
| --- | --- | --- | --- | --- | --- |
| `cpu_harmonic_a` | `cpu` | `143` | `cpu_forced` | zero-byte receipt pulled | not comparable |
| `gpu_harmonic_a` | `gpu` | `137` | `gpu_marker_missing` | no pulled receipt | not comparable |
| `cpu_harmonic_b` | `cpu` | `137` | `cpu_forced` | zero-byte receipt pulled | not comparable |
| `gpu_harmonic_b` | `gpu` | `137` | `gpu_init` | zero-byte receipt pulled | not comparable |

## Thermal And Power Read

The collapse was not accompanied by an obvious thermal event:

- thermal status stayed `0` on all rows
- battery temperature stayed at `33.0 C`
- AC power stayed `true`

So the packet does not support a thermal-confound explanation as the primary
story.

## Interpretation

The family ceiling is not `FAMILY_GAP`.

Plan 02 already proved that the same top-level chamber family can emit
comparable CPU and GPU tuples in a minimal two-row smoke. The Plan 03 battery
used the same family and same controller surface, but the widened four-row
packet failed before preserving interpretable tuples.

That means the honest verdict is:

- `UNRESOLVED`

with the exact blocker:

- widening the chamber battery from the two-row environment smoke to the
  four-row repeated-window packet causes the top-level chamber surface to
  collapse into signal exits plus missing or zero-byte receipts before any
  behavioral comparison can be trusted

## Strongest Disconfirming Observation

The battery produced no retained comparable tuple on any of the four rows, so
there is no honest way to claim `no effect`, `weak effect`, or `structured
effect` from this packet.

## Verdict

Verdict: `UNRESOLVED`

Reason:

- common family was established
- behavioral comparison was not
- the widened packet collapsed under execution before a chamber effect could be
  classified
