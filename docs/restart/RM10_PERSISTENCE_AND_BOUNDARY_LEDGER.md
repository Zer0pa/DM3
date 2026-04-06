# RM10 Persistence And Boundary Ledger

Last refreshed: `2026-04-06`

## Purpose

Map the smallest admissible property result after the chamber battery failed to
preserve an interpretable four-row packet.

## Frozen Property Battery

One-variable sweep:

- variable: `window_count`
- fixed surface: `f2_root_chamber_candidate`
- fixed family: `f2_harmonic_residue`

Rows compared:

- baseline packet: two-window environment smoke
  - [phase_01_2_3_4_1_1_3_environment_smoke_20260406T003748Z](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_environment_smoke_20260406T003748Z)
- perturbed packet: four-window chamber battery
  - [phase_01_2_3_4_1_1_3_cpu_gpu_chamber_20260406T004242Z](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_cpu_gpu_chamber_20260406T004242Z)

Derived comparison packet:

- [phase_01_2_3_4_1_1_3_persistence_boundary_20260406T005022Z](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_persistence_boundary_20260406T005022Z)

## Anchor Observable

Same chamber tuple family on both sides:

- `decision`
- `delta_E`
- `coherence`
- `duration_ms`
- `marker`

## Drift Observable

- tuple survival versus receipt collapse as `window_count` increases

## Result

At `window_count = 2`:

- the environment smoke retained comparable CPU and GPU tuples

At `window_count = 4`:

- the chamber battery collapsed into signal exits plus missing or zero-byte
  receipts before comparable tuples survived

## Property Classification

Observed:

- `boundary sensitivity`

Not observed:

- `persistence`
- `hysteresis`
- stable recovery after the widened packet

The narrow honest statement is:

- this chamber surface is sensitive to session width
- whatever survives at two windows does not persist to four windows on the
  same family

## Thermal Note

The widened packet did not show an obvious thermal boundary:

- thermal status stayed `0`
- battery temperature stayed `33.0 C`

So the width boundary is not explained by a simple thermal shift in the
retained evidence.

## Verdict

Verdict: `boundary_sensitivity_without_persistence`

This is not a strong chamber-science win.
It is a real, narrow property result that later falsifier work must attack.
