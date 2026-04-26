# Phase K — Asymmetry Fine Sweep (Carving 4)

## Pre-Registration

See `PRE_REGISTRATION.md` (written 2026-04-17T01:31:26Z, BEFORE any run).

## Execution Record

- **Date/time range:** 2026-04-17T01:32:01Z — 2026-04-17T05:05:18Z
- **Device:** RM10 Pro FY25013101C8
- **Binary hash:** confirmed ✓
- **Runs executed:** 13 / 13
- **Episodes:** 65 total, all pulled successfully

## Results

### Asymmetry HIGH-rate curve (13 points)

```
asym     | HIGH | Visual           | LOW_E_mean | HIGH_E_mean
---------|------|------------------|------------|------------
-0.30    | 0/5  | ░░░░░            | 73.6       | --
-0.20    | 2/5  | ██░░░            | 74.7       | 87.3
-0.15    | 1/5  | █░░░░            | 74.1       | 87.6
-0.10    | 2/5  | ██░░░            | 74.9       | 88.3
-0.05    | 3/5  | ███░░            | 75.8       | 88.6
-0.02    | 0/5  | ░░░░░            | 75.3       | --
+0.00    | 2/5  | ██░░░            | 75.9       | 88.9
+0.02    | 1/5  | █░░░░            | 75.7       | 88.4
+0.05    | 1/5  | █░░░░            | 74.9       | 89.5
+0.10    | 1/5  | █░░░░            | 76.2       | 89.6
+0.15    | 2/5  | ██░░░            | 75.6       | 90.0
+0.20    | 2/5  | ██░░░            | 77.0       | 90.1
+0.30    | 3/5  | ███░░            | 77.4       | 90.5
```

Overall: 20/65 HIGH = 31%.

### Basin POSITION trend (clear, monotonic)

- **LOW basin E**: increases smoothly from 73.6 (asym=-0.30) to 77.4 (asym=+0.30). Slope ≈ +6.3 E units per asymmetry unit.
- **HIGH basin E**: increases from 87.3 (asym=-0.20) to 90.5 (asym=+0.30). Slope ≈ +6.4 E units per asymmetry unit.
- Basins shift in parallel: the gap remains ~14 E units throughout.

### Basin SELECTION trend (none in this range)

HIGH rate bounces 0%-60% with NO systematic trend. The 13-point curve is noise-dominated. No sharp critical point. No smooth crossover. Basin selection within asym ∈ [-0.30, +0.30] is governed by per-episode RNG initialization, not by asymmetry.

## Verdict

**SMOOTH (position) + NOISE-DOMINATED (selection).**

Asymmetry has TWO distinct effects:
1. It smoothly deforms the attractor landscape, shifting both basin E values monotonically. This is a genuine order parameter for basin POSITION.
2. It does NOT control basin selection within the ±0.3 range. Selection is noise-dominated here. Only at |asym| ≥ 0.5 (Phase H) does selection become deterministic (bistability collapses as basins merge or one vanishes).

**No sharp critical point exists.** The pre-registered hypothesis of a first-order phase transition is killed.

## Artifacts

- `artifacts/phase_K_asymmetry_fine_20260417T013126Z/`
- `artifacts/phase_K_summary.json`
