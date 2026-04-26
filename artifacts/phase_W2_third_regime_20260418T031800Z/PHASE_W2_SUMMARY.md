# Phase W2 — asym ≤ −3 Third Regime Characterization

Written: `2026-04-18`
Wallclock: `2026-04-18T02:18Z` → `2026-04-18T05:28Z` (3h 10m; includes parallel-experiment detour)
Device: Red Magic 10 Pro (FY25013101C8)

## Pre-registration

**H_W2-REGIME:** At asym ∈ {−5, −4, −3.5, −3, −2.5}, harmonic task produces
a basin structure distinguishable from the asym ∈ [−2, +2] regime on at
least one observable.
**H_W2-HOLO-MIRROR:** Holography shows no equivalent compression.

**Verdict classes:**
- **W2-THIRD-REGIME:** Statistically distinguishable from asym=0.
- **W2-CONTINUOUS:** Smooth deformation; same two-basin structure.
- **W2-NOISY:** No clear separation at N=10.

## Execution note

2× parallelization was attempted on cells H_m5 and H_m4; observed
per-process slowdown ~10× versus serial warm-cache. **Parallel scheme
discarded after this test.** Partial output retained (7/10 episodes per
cell) — the data is byte-identical to what serial would produce (the
binary is deterministic), only wallclock was slow. Remaining cells
(H_m35, H_m3, H_m25, HO_m5, HO_m3) ran serially.

## Results — Harmonic asym sweep

### Per-cell (E, Coh) clusters

| asym  | N  | LOW basin (E, Coh)       | HIGH basin (E, Coh)    | Outliers / third cluster           |
|-------|----|--------------------------|-------------------------|-------------------------------------|
| −2.5  | 10 | E=59.8, C=0.817 (n=7)    | E=73.4, C=0.749 (n=3)   | — clean bimodal                     |
| −3.0  | 10 | E=57.5, C=0.784 (n=8)    | E=73.0, C=0.737 (n=2)   | LOW tighter; one sub-cluster at E=56 |
| −3.5  | 10 | E=58.1, C=0.758 (n=5)    | E=73.3, C=0.726 (n=3)   | **emerging MID** at E=55, C=0.735 (n=2) |
| −4.0  | 7  | E=54.6, C=0.692 (n=3)    | E=74.4, C=0.717 (n=1)   | **MID cluster** at E=58, C=0.725 (n=3) |
| −5.0  | 7  | E=59.8, C=0.655 (n=2)    | E=77.7, C=0.693 (n=5)   | — HIGH occupation dominates         |

(Cells H_m5 and H_m4 at N=7 are from the 2× parallel run before kill.
Bit-deterministic binary means the per-episode values are still valid;
only wallclock was perturbed.)

### Coh trajectory across asym (principal finding)

| asym  | LOW Coh  | HIGH Coh |
|-------|----------|----------|
| 0     | 0.88     | 0.77     | (Session 4 baseline)
| −2    | 0.83     | 0.76     | (Session 5 P3)
| −2.5  | 0.82     | 0.75     |
| −3    | 0.78     | 0.74     |
| −3.5  | 0.76     | 0.73     |
| −4    | 0.69     | 0.72     |
| −5    | 0.66     | 0.69     |

**LOW basin Coh drops monotonically** from 0.88 → 0.66 across asym ∈
[0, −5]. **HIGH basin Coh drops** from 0.77 → 0.69. Neither trend is a
cliff; both are smooth deformations. At asym ≥ −3 the Session-4 locked
classifier (LOW Coh > 0.82) already breaks — LOW Coh drops below 0.82
between asym=−2.5 and −3. At asym = −5 both basins have Coh values
below any value seen in asym ∈ [−2, +2].

### Emerging mid-cluster at asym ∈ {−3.5, −4}

Visual inspection of episode-level (E, Coh) points at asym=−4 and
asym=−3.5 shows an **intermediate cluster**:

- asym=−3.5: 2 episodes at E≈55, Coh≈0.735 (between the "LOW" at E≈58
  and the "HIGH" at E≈73).
- asym=−4:   3 episodes at E≈58, Coh≈0.725 (between the "LOW" at E≈54
  and the "HIGH-outlier" at E≈74).

These may represent a transitional regime where the bistable basin
structure is splitting, or a third attractor is emerging. At N=7-10 per
cell this is suggestive, not confirmed — formal cluster separation would
need more episodes.

## Results — Holography mirror

| asym  | N | E (mean ± sd)  | Coh (mean ± sd)  | Decision   |
|-------|---|----------------|-------------------|------------|
| −5.0  | 5 | 8.91           | 0.660             | Retry × 5  |
| −3.0  | 5 | 6.67           | 0.683             | Retry × 5  |

Holography remains monostable (Retry) but Coh has dropped below 0.68 at
asym=−5 — below the Session 4 RETRY cluster band [0.68, 0.78]. At
asym=−3 Coh=0.68 (at the lower band edge).

Extending the Session 5 P3 fit `E = 11.3 + 5.1 × asym`:
- Predicted at asym=−5: E = 11.3 + 5.1 × (−5) = −14.2 (unphysical)
- Observed at asym=−5: E = 8.91 — **saturates** well above the linear
  extrapolation.
- Predicted at asym=−3: E = 11.3 + 5.1 × (−3) = −4.0 (unphysical)
- Observed at asym=−3: E = 6.67 — **saturates** well above the linear
  extrapolation.

The holography E scale has a floor around E ≈ 7. The linear fit from
Session 5 P3 (asym ∈ [−2, +5]) is NOT valid below asym ≈ −2. This is
a scope correction to Session 5's P3 E-scale claim.

Coherence behavior for holography:
- asym=+5: Coh=0.723 (Session 5)
- asym=+2: Coh=0.726 (Session 5)
- asym=−2: Coh=0.725 (Session 5)
- asym=−3: **Coh=0.683** (this session) — boundary
- asym=−5: **Coh=0.660** (this session) — below asym=0 holography cluster

So **holography is NOT Coh-invariant at asym ≤ −3** either — it exits the
canonical RETRY cluster [0.68, 0.78]. H_W2-HOLO-MIRROR is **weakened**:
holography shows a similar Coh compression to harmonic at the extreme
negative edge, just less pronounced.

## Verdicts against pre-registered hypotheses

| Hypothesis              | Verdict          |
|-------------------------|------------------|
| H-W2-REGIME             | **CONFIRMED (partial).** Coh compression is measurable and monotone in asym. The Session 4 basin classifier (LOW Coh > 0.82) breaks between asym=−2.5 and −3. Emerging mid-cluster at asym ∈ {−3.5, −4} is suggestive of a third basin but not yet robust. |
| H-W2-HOLO-MIRROR        | **WEAKENED / PARTIAL.** Holography DOES show Coh compression at asym ≤ −3, though less pronounced than harmonic. Not a clean harmonic-specific effect. |

**Classification of the asym ≤ −3 regime: W2-CONTINUOUS with an
emerging mid-cluster.** The basin deformation is smooth, not a cliff.
Both basins and holography shift in (E, Coh) space as asym becomes more
negative. A possible third attractor appears around asym ∈ {−3.5, −4}
but at N=7-10 per cell the cluster separation is not conclusive. A
Session 7 probe with N=20+ per cell would resolve this.

## Revised basin classifier (for public repo)

Original Session 4: `HIGH iff E>82 AND Coh<0.82; LOW iff E<82 AND Coh>0.82`.
Valid only for asym ∈ [−2, +2].

W2-proposed classifier (valid asym ∈ [−5, +2]):

```
Basin = 'HIGH' if E > (avg of LOW_E_at_that_asym + HIGH_E_at_that_asym)
                   else 'LOW'
```

I.e., use E ordering within each cell rather than a fixed Coh threshold.
A full (asym, basin)-position table should be provided with the public
repo for calibrated lookup.

## Artifacts

- `phase_W2_third_regime_receipts/H_{m5,m4,m35,m3,m25}.jsonl` — 7-10 eps each harmonic
- `phase_W2_third_regime_receipts/HO_{m5,m3}.jsonl` — 5 eps each holography
- `phase_W2_third_regime_receipts/progress.txt` — timing
- `PHASE_W2_SUMMARY.md` — this writeup
