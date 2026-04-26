# Phase H — Statistical Replication (Carving 1)

## Pre-Registration

See `PRE_REGISTRATION.md` (written 2026-04-16T14:35:44Z, BEFORE any run).

## Execution Record

- **Date/time range:** 2026-04-16T14:36:54Z — 2026-04-16T16:09:58Z
- **Device:** RM10 Pro FY25013101C8 (Mac-driven via adb)
- **Binary hash confirmed:** `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672` ✓
- **Device state pre:** battery=44%, thermal_zone0=0, loadavg=1.63
- **Device state post:** battery=80% (charging), thermal_zone0=0
- **Runs executed:** 14 / 14
- **Aborts / retries:** 0
- **Per-run RC:** all 0
- **All receipts pulled:** 14/14

Episode durations ran ~60-85s each, significantly faster than Session 3's ~195s. This is consistent with page-cache warmth and steady-state thermal dissipation. Does NOT invalidate receipts (identical JSONL schema and parameter values).

## Results

### Basin classification (thresholds locked: HIGH = E>82 ∧ Coh<0.82; LOW = E<82 ∧ Coh>0.82)

| # | Label | Config | HIGH rate | Notes |
|---|-------|--------|-----------|-------|
| H.1 | ham | `--use-layernorm false` | 1/5 (20%) | 4 LOW + 1 HIGH |
| H.2 | ln | `--use-layernorm true` | 1/5 (20%) | 4 LOW + 1 HIGH — lower than Session 3's 62.5% |
| H.3 | asym=-1 | `--asymmetry=-1.0` | 0/5 (0%) | Deep-LOW, E ∈ [68.95, 69.52] |
| H.4 | asym=-0.1 | `--asymmetry=-0.1` | **4/5 (80%)** | HIGH-dominant |
| H.5 | asym=+0.1 | `--asymmetry=0.1` | 1/5 (20%) | LOW-dominant |
| H.6 | asym=+1 | `--asymmetry=1.0` | 1/5 (20%) | max E=94.57 (elevated HIGH) |
| H.7 | rot=120 | `--rotation 120` | **0/5 (0%)** | Suppressed — contradicts Session 3 |
| H.8 | rot=60 | `--rotation 60` | 1/5 (20%) | — |
| H.9 | rot=0 | `--rotation 0` | 2/5 (40%) | Highest rotation HIGH rate |
| H.10 | freq=1.0 | `--freq 1.0` | 1/5 (20%) | Session 3's 2/2 was noise |
| H.11 | freq=0.033 | `--freq 0.033` | 2/5 (40%) | Mode-1 gave MORE HIGH than freq=1.0 |
| H.12 | holography | `--task holography` | 0/5 HIGH / 5/5 RETRY | E=15.2±0.4, Coh=0.74±0.005 |
| H.13 | truth default | `--enable-truth-sensor` | 2/5 (40%) | Did not suppress HIGH |
| H.14 | truth strong | `--enable-truth-sensor --sensor-threshold 0.1 --sensor-strength 0.9` | 2/5 (40%) | Did not suppress HIGH |

### Basin values (tight across ALL runs)

- HIGH: E = 88.00 to 89.54 (narrow), Coh = 0.7674 to 0.7770
- LOW: E = 74.57 to 76.51, Coh = 0.8765 to 0.8932
- DEEP-LOW (asym=-1 only): E = 68.95 to 69.52, Coh = 0.8648 to 0.8783
- ELEVATED-HIGH (asym=+1 only): E = 80.4–80.9 (OTHER) plus E=94.57 (HIGH)
- RETRY (holography only): E = 14.83 to 15.74, Coh = 0.7308 to 0.7460

## Verdict

**PARTIAL / MIXED.** Two Session 3 suggestive findings are PROMOTED to solid (asymmetry order parameter; holography third attractor). Three are KILLED (freq=1.0 HIGH lock; rot=120° preserves bistability; truth sensor unidirectional LOW bias). The H2 kill stands but WEAKENS — LN no longer shows a 3x enhancement over HAM; both are at 20% HIGH at N=5, making the transformer's basin-selection role smaller than Session 3 reported.

One-paragraph assessment: the object exhibits **cleaner, less parameter-responsive behavior** at N=5 than Session 3's 2-episode peeks suggested. The asymmetry axis is a genuine continuous order parameter. The holography task has a distinct monostable attractor. But rotation and frequency do NOT cleanly select basins the way Session 3 thought. The HIGH/LOW basin structure is itself a stable finding — E and Coh values replicate precisely — and basin selection appears to be dominated by per-episode initialization (consistent with the RNG-driven bistability finding), not by the control parameters Session 3 tried.

## Artifacts

- `artifacts/phase_H_statistical_replication_20260416T143544Z/` (pre-state, 14 receipts, log, progress, basin_summary, pre-registration, this writeup)
- `artifacts/phase_H_summary.json` (machine-readable)
