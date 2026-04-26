# Phase J — Holography Parameter Sweep (Carving 3)

## Pre-Registration

See `PRE_REGISTRATION.md` (written 2026-04-16T20:39:47Z, BEFORE any run).

## Execution Record

- **Date/time range:** 2026-04-16T20:40:21Z — 2026-04-17T00:50:50Z
- **Device:** RM10 Pro FY25013101C8
- **Binary hash:** confirmed ✓
- **Runs executed:** 9 / 9 (4 in first batch, 5 in continuation after background process recovery)
- **Additional data from Phase I.b:** holography at freq=1.0 and freq=2.0 (10 episodes, 2 configs)

## Results

### Asymmetry arm — THE KEY FINDING

| asym | E mean | E std | Coh mean | Basin |
|------|--------|-------|----------|-------|
| -1.0 | 10.62 | 0.30 | 0.723 | ALL below RETRY range |
| -0.5 | 12.86 | 0.67 | 0.724 | RETRY (low end) |
| 0.0  | 15.02 | 0.27 | 0.727 | RETRY (center) |
| +0.5 | 17.54 | 0.58 | 0.729 | RETRY (high end) |
| +1.0 | 20.17 | 0.66 | 0.748 | Pushing above RETRY |

**Monotonic linear trend**: E increases ~4.8 units per asymmetry unit. Coherence is insensitive (~0.72-0.75 throughout). No bistability observed at ANY setting (all 25 episodes are single-basin).

This matches harmonic's asymmetry response in DIRECTION (both monotone increasing E with increasing asymmetry) but at ~5x lower energy scale.

### Rotation arm — NO EFFECT

| rot | E mean | Coh mean |
|-----|--------|----------|
| 0   | 14.81  | 0.740    |
| 60  | 14.85  | 0.728    |
| 120 | 14.70  | 0.734    |

Rotation does not affect holography. Consistent with harmonic where rotation was also noise-dominated.

### Frequency arm — NO EFFECT (confirming Phase I.b)

Combined with Phase I.b data: E remains ~14.5-15 across freq=0.3, 0.5, 0.8, 1.0, 1.5, 2.0.

## Verdict

**TASK-PARAMETERIZED-SAME-FAMILY — CONFIRMED.**

The holography task is the SAME dynamical family as harmonic, operating at a lower energy scale. Evidence:

1. Asymmetry deforms the attractor monotonically in the SAME direction as in harmonic.
2. Rotation has no effect in either task.
3. Frequency has no effect in either task.
4. Both tasks are monostable under extreme parameters and (for harmonic) bistable near asym=0.

The `--task` flag is an **operating-point selector**, not a mode switch. Holography at asym=0 sits at E≈15 where the landscape has only one basin. Harmonic at asym=0 sits at E≈75-89 where the landscape has two basins. The bistability is an energy-scale phenomenon: at high enough E, the dynamical landscape bifurcates.

**Implication**: The 380-vertex graph supports **one dynamical family** with one control parameter (asymmetry) that can smoothly deform the energy landscape. The "third attractor" from Session 3 is not a separate computational object — it's the same object at a lower energy setting where bistability does not exist.

## Artifacts

- `artifacts/phase_J_holography_20260416T203947Z/` (pre-state, pre-reg, 9 receipts, log, progress, basin_summary, this writeup)
- `artifacts/phase_J_summary.json` (machine-readable)
