# Phase I — Frequency Deep-Characterization (Carving 2)

## Pre-Registration

See `PRE_REGISTRATION.md` (written 2026-04-16T16:17:25Z, BEFORE any run).

## Execution Record

- **Date/time range:** 2026-04-16T17:05:28Z — 2026-04-16T19:37:13Z
- **Device:** RM10 Pro FY25013101C8
- **Binary hash:** `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672` ✓
- **Runs executed:** 15 / 15 (1 in original run, 14 in continuation after fixing adb-stdin-consumption bug in phase_runner.sh)
- **Episode duration:** mostly ~196 s (Session 3 baseline), with a few ~65s (cache-warm) at end
- **I.c SKIPPED** per PRD rule: freq=1.0 came in < 60% at Phase H, so coupling sweep of a non-effect is not warranted.

## Results Table

### I.a — Harmonic freq sweep (10 values × 5 ep)

| freq | HIGH rate | HIGH pct | E_high_mean | E_low_mean |
|------|-----------|----------|-------------|------------|
| 0.1  | 2/5 | 40% | 88.74 | 75.31 |
| 0.3  | 1/5 | 20% | 88.75 | 75.59 |
| 0.5  | 2/5 | 40% | 88.58 | 75.70 |
| **0.8** | **4/5** | **80%** | 88.85 | 76.32 |
| 1.0  | 1/5 | 20% | 88.73 | 74.65 |
| 1.2  | 2/5 | 40% | 88.84 | 76.16 |
| **1.5** | **4/5** | **80%** | 88.63 | 75.56 |
| 2.0  | 3/5 | 60% | 88.45 | 75.45 |
| 5.0  | 1/5 | 20% | 88.90 | 75.27 |
| 10.0 | 2/5 | 40% | 88.80 | 75.46 |

Aggregate: 22/50 HIGH = 44% overall.

### I.b — Holography freq subset (5 values × 5 ep)

All 25 episodes in RETRY cluster: E ∈ [13.71, 15.86], Coh ∈ [0.710, 0.768]. No basin-switching. Attractor unchanged by freq across 5 values.

## Pre-Registration Evaluation

- **Resonance peak near 1.0** — FAILED. freq=1.0 was a DIP (20%), not a peak.
- **Monotone amplitude** — FAILED. Non-monotone.
- **Multi-peaked** — WEAKLY HELD. Two apparent maxes at 0.8 and 1.5 (both 4/5). But these could be binomial noise (at p=0.44, N=5, std ≈ 1.1 episodes).
- **Null-effect** — PARTIAL. std(HIGH pct) = 21.2 across 10 points; not flat, but not a clear curve.

## Verdict

**KILLED / NULL-EFFECT with weak band-coupling suggestion.**

`--freq` is categorized as **NOISE-DOMINATED** at N=5 per point. It is not a clean resonance parameter, not a monotone amplitude, and does not cleanly map to graph-Laplacian modes. There is a weak hint of an elevated-HIGH band around freq ∈ [0.8, 2.0] (mean ~60%) vs edges (0.1, 0.3, 5.0, 10.0, mean ~30%), but with binomial noise at N=5 the difference is marginal.

**freq=1.0 is NOT a resonance peak.** It produced the joint-lowest HIGH rate (20%, tied with 0.3 and 5.0). Session 3's "freq=1.0 → 100% HIGH" finding is DEFINITIVELY killed.

The holography attractor (E ≈ 15, Coh ≈ 0.74, Retry) is **completely insensitive to --freq** across 5 values spanning 6.7x. Reinforces holography's monostable character.

**Basin values (E≈89 HIGH, E≈75 LOW) are freq-independent.** Only selection probability varies weakly. --freq does not deform the attractor landscape; it modestly biases selection.

## Artifacts

- `artifacts/phase_I_frequency_20260416T161725Z/` (pre-state, pre-reg, 15 receipts, log, progress, basin_summary, this writeup)
- `artifacts/phase_I_summary.json` (machine-readable)
