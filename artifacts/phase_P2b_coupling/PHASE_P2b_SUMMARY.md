# Phase P2b — Coupling Sweet-Spot Fine Sweep

Written: `2026-04-17` (end of P2b)
Wallclock: `2026-04-17T18:50:30Z` → `2026-04-17T20:44:57Z` (1h 54m)
Device: Red Magic 10 Pro (FY25013101C8)

## Pre-registration

Seven cells at 5 episodes each = 35 episodes. Fine sweep of asymmetry
∈ {0.40, 0.45, 0.50, 0.55, 0.60} at rotation = 60°, plus controls
at rot = 0° (flat) and rot = 120° (C3 complement), both at asym = 0.50.

**Hypothesis under test (inherited from Session 4 Phase L):**
"rot=60° uniquely couples with asymmetry at the basin boundary;
rot=0° suppresses HIGH and rot=120° behaves like rot=0° (NOT
C3-symmetric). HIGH rate at rot=60° × asym=+0.5 ≈ 60%."

## Results

| Config                  | HIGH sequence | HIGH rate | E_LOW range  | E_HIGH range |
|-------------------------|---------------|-----------|--------------|--------------|
| rot=0,   asym=0.50      | `LLLLL`       | **0/5 = 0%**   | 77.6–79.2 | —            |
| rot=60,  asym=0.40      | `LHLLH`       | 2/5 = 40% | 76.6–78.5  | 91.3–91.4    |
| rot=60,  asym=0.45      | `LLLHL`       | 1/5 = 20% | 77.7–79.3  | 91.8         |
| rot=60,  asym=0.50      | `HHLLL`       | 2/5 = 40% | 77.4–79.4  | 91.8–92.2    |
| rot=60,  asym=0.55      | `HLLLL`       | 1/5 = 20% | 78.6–80.0  | 92.5         |
| rot=60,  asym=0.60      | `LHHHL`       | 3/5 = 60% | 78.4–80.2  | 92.1–92.5    |
| rot=120, asym=0.50      | `HLHLL`       | 2/5 = 40% | 77.9–79.1  | 91.5–92.0    |

## Key findings

### 1. Basin positions shift with asymmetry (REPLICATED from Phase K)

- HIGH basin centroid at asym = 0.40 is **E ≈ 91.4**; at asym = 0.60 is
  **E ≈ 92.5**. Phase K (no rotation) saw the same trend.
- LOW basin centroid shifts from **E ≈ 76.6** at asym = 0.40 to
  **E ≈ 80.2** at asym = 0.60.
- Coherence is essentially constant across cells: HIGH ≈ 0.77,
  LOW ≈ 0.88-0.89.

This replicates and extends Phase K's smooth-deformation result: basin
positions are continuous functions of asymmetry, independent of rotation.

### 2. rot=0° at asym=+0.5 **reliably suppresses HIGH** (CONFIRMED)

P2b: 0/5 HIGH. Phase L: 0/5 HIGH. Combined: **0/10 HIGH**.

Fisher-exact vs combined rot=60° result (5/10 HIGH): **p = 0.033**,
statistically distinguishable at α = 0.05.

This is a **solid finding**: at asym = +0.50, zero rotation accesses
only the LOW basin. Unlike session 4 Phase K where asym=+0.3 at
unspecified rotation showed bistability, the combination (asym=+0.5,
rot=0) does not.

### 3. rot=60° vs rot=120° at asym=+0.5 are NOT distinguishable

Phase L claimed rot=60° (3/5 HIGH) is uniquely effective vs rot=120°
(1/5 HIGH). At N=10 pooled across Phase L + P2b:

- rot=60°  × asym=0.50: **5/10 HIGH (50%)**
- rot=120° × asym=0.50: **3/10 HIGH (30%)**

Fisher-exact test: **p = 0.65** (not significant).

**The Phase L claim "rot=60° is uniquely effective / the coupling is
not C3-symmetric" is WEAKENED at N=10.** Both rot=60° and rot=120°
access the HIGH basin at rates indistinguishable from each other and
from the harmonic baseline (P(HIGH) ≈ 0.34 at default). Only rot=0°
robustly suppresses HIGH access.

### 4. No peak at asym = 0.50 in the rot=60° sweep

HIGH rate across asym = {0.40, 0.45, 0.50, 0.55, 0.60} at rot=60°:
**{2, 1, 2, 1, 3}/5**. The maximum is at asym = 0.60 (3/5 = 60%),
not at 0.50. The series looks like noise, not a boundary-localized
peak.

If one trusts the binomial model with p = 0.34 baseline (from P2a,
N=100), the expected HIGH rate is 1.7 / 5 per cell. Observed mean
across 5 rot=60° cells: (2+1+2+1+3)/25 = **9/25 = 36%**. This is
indistinguishable from the default harmonic baseline.

### 5. Revised "coupling" story

The interaction between rotation and asymmetry at the basin boundary,
as presented in Phase L, does not survive increased N.

- **Robust:** rot=0° × asym=+0.5 suppresses HIGH (0/10). Whatever
  the dynamical mechanism, zero-rotation at +0.5 asymmetry sits
  entirely in the LOW basin.
- **Not robust:** rot=60° vs rot=120° distinction. Both give
  approximately baseline HIGH rates (30–50%). Whatever signal Phase L
  extracted from 3/5 vs 1/5 was within noise.

## Verdict against pre-registered kill criteria

| Criterion                                       | Result          |
|-------------------------------------------------|-----------------|
| SMOOTH — monotone / bell-shape across asym      | **Not observed.** HIGH rate bounces without structure at N=5. |
| PEAKED at 0.50 — concentrated at a single asym  | **Not observed.** Max is at asym=0.60, not 0.50. |
| NOISY — bounces without structure               | **Observed.** Rate ∈ {20–60%} across 5 cells, no structure. |

**Verdict: Phase L's "coupling peaks at rot=60° × asym=+0.5" is
weakened to "rot=0° × asym=+0.5 suppresses HIGH; any nonzero rotation
gives baseline-rate HIGH access." The C3-asymmetry claim does not
replicate at N=10.**

## What remains solid from Phase L / P2b combined

- **Basin positions smoothly shift with asymmetry.** HIGH E moves
  88→92 across asym ∈ [0, 0.6]; LOW E moves 75→80 across the same
  range.
- **rot=0° × asym=+0.5 is a HIGH-basin null** (0/10).
- **Any nonzero rotation × asym=+0.5 restores baseline HIGH rate**
  (5/10 at rot=60°, 3/10 at rot=120°, both consistent with
  p(HIGH)=0.34 from P2a).

## What is WEAKENED

- **"rot=60° uniquely opens the basin boundary"** — not reproduced.
- **"The coupling is not C3-symmetric"** — at N=10, rot=60° and
  rot=120° are within noise of each other.

## Artifacts

- `phase_P2b_receipts/*.jsonl` — raw 6-field receipts (35 eps)
- `phase_P2b_receipts/progress.txt` — per-cell timing
- `phase_P2b_summary.json` — machine-readable classification summary
- `PHASE_P2b_SUMMARY.md` — this writeup
- `p2b_trimmed.sh` — the runner script deployed to device
