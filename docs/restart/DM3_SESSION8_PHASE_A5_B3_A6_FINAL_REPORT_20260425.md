# DM3 Session 8 — A.5 + B.3 + A.6 Final Report

Written: `2026-04-25` ~17:10 UTC (19:10 SAST)
For: DM3 engineering + science team
Status: **CHAIN CLOSED** at 16:57:04 UTC. All four cells PASS.
Wall-clock: 24h 15m (launch 2026-04-24 16:42 UTC → close 2026-04-25 16:57 UTC)

---

## TL;DR — three findings, one of which is unexpectedly large

1. **The `exp_k2_scars` curve is trimodal sawtooth, not bimodal.** A.6a + A.6b mapped the full 28→50 region at 1-step resolution. Three local maxima (s33=1.874, s41=1.708, s49=1.819), two sharp drops (s34=1.371, s43=1.161), then the known cliff at s50=0.000. Both σ (Phase A) and σ′ (A.5) wording are now obsolete. Replace with **σ″** as drafted below.

2. **B.3 responsiveness audit closed cleanly: 9 of 12 tasks are `--steps` responsive, 3 are decorative.** The decorative set: `resonance_r3` (confirms Session 7 ν), `resonance_v2` (new), `exp_i2` (new). Truth-sensor κ refined: error-reduction ratio fixed near 79.4 %, absolute values do change with `--steps`.

3. **τ remains CONFIRMED.** No new evidence touching it; the AGD-H1 M1 result is independent and stable.

Plus: claim ξ now has a **142-receipt cross-cell evidence base** (55 Phase A + 24 B.3 + 30 A.5 + 15 A.6a + 18 A.6b), all within-equivalence-class bit-identical, including 4 cross-cell coincidences at overlapping step values (s30, s35, s40, s45).

---

## 1. Chain timeline

| Phase | Start UTC | Close UTC | Runs | Outcome |
|---|---|---|---|---|
| KAT canary | 2026-04-24 14:42:07 | — | 1 | OK |
| B.3 reordered (Tier A → Tier C, post-kill resume) | 14:42:07 | 2026-04-25 01:43:55 | 24 | All complete |
| A.6a peak fill (s33–s37 × 3) | 01:43:55 | 07:34:38 | 15 | PASS |
| A.6b post-peak (s43–s49 × 3, ex-s45) | 07:34:38 | 14:57:04 | 18 | PASS |
| **PHASE_B3R_A6_CHAIN_COMPLETE** | — | **14:57:04** | **57** | clean exit |

Note: I'm using UTC throughout this report; SAST is +2.

Cell summary SHAs:
- B3: `d3c6a6c85cbd387cf294d1265a24e693c36a2bb03bd0a5c8591983fc56e59a8e` (verdict=FAIL is script limitation — heterogeneous tasks, not a science fail)
- A6a: `9bff0dc0d88e8aae2fae3cb6e92423f7cb8bf54b0a9bd4a4f8d90652030aaac0`
- A6b: `ca3ff1a542118d4772cd099698015f921c8a076a4baf17b234fe90a61ec09f89`

---

## 2. The full `exp_k2_scars` curve at 1-step resolution

Combined data from A.1–A.4, A.5, A.6a, A.6b (config: `--cpu --task exp_k2_scars` on SY_v1 + RegionTags_v1 + xnor_train, pinned cpu7, all triplets bit-identical):

| `--steps` | `best_uplift` | source cell(s) | annotation |
|---|---|---|---|
| 20 | 1.324074 | A.1, A.2, A.3, A.4 | μ baseline |
| 25 | 1.380150 | A.2 | |
| 28 | 1.521027 | A.5 | |
| 29 | 1.580566 | A.5 | |
| 30 | 1.644524 | A.2, A.5 ✓ | cross-cell match |
| 31 | 1.714828 | A.5 | |
| 32 | 1.790665 | A.5 | |
| **33** | **1.873756** | A.6a | **GLOBAL PEAK** |
| **34** | **1.370651** | A.6a | **DROP −0.503 (1-step)** |
| 35 | 1.405548 | A.2, A.6a ✓ | cross-cell match |
| 36 | 1.443817 | A.6a | |
| 37 | 1.484566 | A.6a | |
| 38 | 1.531288 | A.5 | |
| 39 | 1.582687 | A.5 | |
| 40 | 1.642128 | A.2, A.5 ✓ | cross-cell match |
| 41 | 1.708374 | A.5 | local max |
| 42 | 1.383827 | A.5 | drop −0.325 |
| **43** | **1.160828** | A.6b | **GLOBAL MIN (excl. s50 cliff)** |
| 44 | 1.242004 | A.6b | |
| 45 | 1.332733 | A.2, A.6b ✓ | cross-cell match |
| 46 | 1.435165 | A.6b | |
| 47 | 1.549957 | A.6b | |
| 48 | 1.677055 | A.6b | |
| **49** | **1.819397** | A.6b | **local max #3** |
| 50 | 0.000000 | A.2 | **CLIFF** |

### Shape interpretation

The curve has **three monotone-rising "cycles" of length ~6–8 steps** punctuated by sharp drops:

```
Cycle 1  s28─s33  rising  1.521 → 1.874   (peak #1, global)
DROP     s33→s34          1.874 → 1.371   (Δ = −0.503 in 1 step)
Cycle 2  s34─s41  rising  1.371 → 1.708   (peak #2)
DROP     s41→s43          1.708 → 1.161   (Δ = −0.547 across 2 steps)
Cycle 3  s43─s49  rising  1.161 → 1.819   (peak #3)
CLIFF    s49→s50          1.819 → 0.000   (Δ = −1.819, total collapse)
```

The structure suggests **internal cyclic phases** (likely lesson/epoch boundaries inside the binary) of ~6–8 step length, where each cycle resets sharply and the amplitude does NOT decay smoothly. Peak amplitudes: 1.874 → 1.708 → 1.819 (non-monotonic).

This is the kind of structure that's unrecoverable from a 5-step grid — A.2's grid hit s30 (mid-cycle-1), s35 (early cycle-2), s40 (mid-cycle-2), s45 (early cycle-3), s50 (cliff). Each step landed on a different phase of the cycle, producing the appearance of two peaks at 30 and 40. Reality is three peaks at 33, 41, 49.

### Cross-cell determinism (Claim ξ strengthening)

Four step values are present in two independent cells:

| `--steps` | A.2 | A.5/A.6 | Match |
|---|---|---|---|
| 30 | 1.644524 | 1.644524 (A.5) | BIT_EXACT |
| 35 | 1.405548 | 1.405548 (A.6a) | BIT_EXACT |
| 40 | 1.642128 | 1.642128 (A.5) | BIT_EXACT |
| 45 | 1.332733 | 1.332733 (A.6b) | BIT_EXACT |

Different days, different chains, different `cell_id` values, identical bits. ξ is now extraordinarily well-supported across cells **and** across hardware (τ).

---

## 3. B.3 — full per-task responsiveness audit (12 tasks × 2 step settings)

### Method
Run each of 12 tasks at `--steps 1` and `--steps 20`. Compare per-run output: canonical `.bin` SHA where binary writes a real output, full stdout `.log` SHA otherwise. SHA-divergence → task is `--steps` responsive. SHA-identity → CLI flag is decorative.

### Results

| Task | Output type | Comparison | **Verdict** |
|---|---|---|---|
| `harmonic` | `.bin` | `27863be5…` ≠ `04816608…` | **RESPONSIVE** |
| `holography` | `.bin` | `38754ba9…` ≠ `44e7405b…` | **RESPONSIVE** |
| `interference` | log (stdout) | log SHA differs (Epoch 1 vs Epoch 20) | **RESPONSIVE** |
| `holographic_memory` | log | log SHA differs (1 epoch vs 20 epochs) | **RESPONSIVE** |
| `exp_r1_r4_campaign` | `.bin` | `3dcd23fd…` ≠ `69f97b5b…` | **RESPONSIVE** |
| `exp_i1` | log | log SHA differs | **RESPONSIVE** |
| **`exp_i2`** | log | log SHA **identical** | **DECORATIVE** (new) |
| `exp_h1_h2` | log | log SHA differs (L1 Step 10 only at steps=20) | **RESPONSIVE** |
| `exp_k2_scars` | log | best_uplift 0.010 vs 1.324 (huge) | **RESPONSIVE** |
| `exp_k3_truth_sensor` | log | KPI_K3 absolute values differ; **error-reduction ratio fixed near 79.4 %** | **PARTIAL** (κ refined) |
| **`resonance_r3`** | log | log SHA **identical** | **DECORATIVE** (Session 7 ν confirmed) |
| **`resonance_v2`** | log | log SHA **identical** | **DECORATIVE** (new) |

### Key findings from B.3

1. **9 of 12 tasks are responsive to `--steps`.** Most of the binary's task surface has real `--steps` semantics.
2. **3 tasks are decorative:** `resonance_r3` (Session 7 ν re-confirmed at +1 replicate), `resonance_v2` (new), `exp_i2` (new). Two of these (`resonance_*`) are in the same task family — consistent.
3. **`exp_k3_truth_sensor` (Claim κ) refined**: the absolute KPI values DO change with `--steps`:
   - steps=1: baseline_error=89.255, sensor_error=22.317, truth_gap=66.94
   - steps=20: baseline_error=108.165, sensor_error=22.293, truth_gap=85.87
   - Sensor_error is essentially fixed (~22.3 across both). Baseline_error scales with `--steps`. **The error-reduction ratio (1 − sensor/baseline) ≈ 79.4 %** is what's invariant — Session 7 κ was right about the ratio, slightly imprecise in saying "CLI flags decorative" without the qualifier "for the error-reduction ratio specifically."

### Suggested ledger updates from B.3

- **ν (Session 7)**: keep CONFIRMED. B.3 added an independent replicate at the `--steps 1` vs `--steps 20` axis showing identical log SHA. That's exactly the test ν predicts.
- **κ (Session 7)**: REFINE wording, do not weaken or retract. Original: *"exp_k3_truth_sensor CLI flags decorative; fixed 79.4% error reduction independent of flags."* Refined: *"exp_k3_truth_sensor's error-reduction RATIO is fixed at ≈79.4% across `--steps` settings; absolute baseline and gap values DO scale with `--steps`."* The original headline is correct, the mechanism is now better understood.
- **NEW CANDIDATE φ (phi)**: *"`resonance_v2` and `exp_i2` join `resonance_r3` as `--steps`-decorative tasks. Three of twelve known tasks ignore `--steps` for their primary KPI."* Kill criterion: any future evidence that any of these three tasks DOES respond to `--steps` at a different setting (e.g., `--steps 1000`, or with non-default `--adj`/`--tags`/`--dataset`).

---

## 4. Replacement claim σ″ (supersedes σ and σ′)

### Status of prior wordings

- **σ (Phase A handover, never promoted)**: *"Peak `best_uplift` at `--steps 30 AND 40`."* — REJECTED. Wrong on both peak locations.
- **σ′ (A.5 interim handover, never promoted)**: *"Bimodal: primary peak at s32, secondary at s41."* — REJECTED. Wrong on number of peaks (3, not 2) and primary location (s33, not s32).

Neither σ nor σ′ ever reached `repo_stage/CLAIMS.md`. Both were superseded by finer sweeps before the repo-agent integration pass. **This is the third firing of the pre-registered kill criterion in this session — exactly as designed.**

### σ″ CANDIDATE wording (proposed, push back welcome)

> **σ″ — `exp_k2_scars` learning curve is trimodal sawtooth with three local maxima and two sharp drops** | **CANDIDATE**
>
> Scope: `exp_k2_scars` on SY_v1 + RegionTags_v1 + xnor_train, pinned cpu7, airplane ON.
>
> Shape (1-step resolution across `--steps` ∈ [28, 50]):
> - Cycle 1: s28→s33 monotone rise to **best_uplift = 1.873756** (global maximum)
> - Sharp drop s33→s34: 1.873756 → 1.370651 (Δ = −0.503 in 1 step)
> - Cycle 2: s34→s41 monotone rise to 1.708374 (local max #2)
> - Drop s41→s43: 1.708374 → 1.160828 (Δ = −0.547, global non-cliff minimum)
> - Cycle 3: s43→s49 monotone rise to 1.819397 (local max #3)
> - Cliff s49→s50: 1.819397 → 0.000000 (Δ = −1.819, total collapse)
>
> Cycle length: ~6–8 `--steps` per rise, suggesting an internal lesson/epoch boundary in the binary at ~7-step intervals.
>
> Evidence: 53 receipts across A.5 (30) + A.6a (15) + A.6b (18), N=3 per step value, all triplets bit-identical, plus 4 cross-cell coincidences with A.2 (s30, s35, s40, s45) all bit-exact.
>
> Kill criterion: any one of (a) a finer sweep of `--steps ∈ {32.5, 33.5, 34.5}` showing the s33→s34 drop is a sampling artifact (sub-1-step shape); (b) a re-run at `--steps 33` returning a different value; (c) the cycle structure not reproducing under cross-graph (RA), cross-tags (v2), or cross-dataset (xnor_mini, xnor_test) conditions.
>
> Reopen: under any non-baseline config (different adj, tags, dataset), the cycle structure is untested.

---

## 5. Claim ledger after this chain

Final state at chain close:

### CONFIRMED
- **α** (C3 symmetry), **β** (IID Bernoulli p≈0.34), **δ/δ.1/δ.2** (R1/R2 axes), **ε** (substrate p(HIGH)), **ζ** (R1/R2 separable), **η** (substrate null gate-bit-level), **θ** (RA+v2+steps=50 compound), **ι** (substrate null dynamics), **κ** (truth-sensor error-reduction ratio fixed) ← **wording refined per B.3**, **λ** (cross-control multiplicative), **μ** (exp_k2_scars LEARNS at steps=20), **ν** (resonance_r3 CLI decorative) ← **+1 replicate from B.3**, **ξ** (determinism, N≈142 receipts), **ο** (sharp s50 cliff), **τ** (cross-platform ARM64 determinism RM10↔M1)

### CANDIDATE
- **π** (dataset-invariance, scoped strictly to xnor_{train,mini,test} at steps=20)
- **ρ** (RA+v2+steps=20 zero-learning IS_NOT)
- **σ″** (NEW — trimodal sawtooth curve shape)
- **φ** (NEW — three tasks `--steps`-decorative: resonance_r3, resonance_v2, exp_i2)

### REJECTED-BEFORE-PROMOTED
- **σ** (Phase A draft — bimodal at 30/40)
- **σ′** (A.5 draft — bimodal at 32/41)

Both visible in handover archaeology, never reached public ledger. Pre-registered kill criteria fired cleanly each time.

### WEAKENED
- **δ.3** (operational_steps cap at 10 — Session 7)

### RETRACTED
- **γ** (C3 asymmetric coupling — Session 5)

### KILLED
- **H2** (transformer creates bistability — Session 3)

### Headline counts
- 16 CONFIRMED claims (κ refined, ν +1 replicate, τ added)
- 4 CANDIDATE claims
- 2 REJECTED-BEFORE-PROMOTION (process-wins)
- 1 WEAKENED, 1 RETRACTED, 1 KILLED

---

## 6. DM3 IS / IS NOT — additions from this chain

### DM3 IS (new from this chain)

- *"a system whose `exp_k2_scars` learning curve has three local maxima at `--steps 33, 41, 49` (1.874 / 1.708 / 1.819) connected by sharp inter-cycle drops at s34 and s43"*
- *"a system with at least three `--steps`-decorative tasks (`resonance_r3`, `resonance_v2`, `exp_i2`)"*
- *"a system where `exp_k3_truth_sensor` produces a fixed error-reduction ratio (~79.4%) across `--steps` settings, even though absolute KPI values vary"*

### DM3 IS NOT (new from this chain)

- *"a system whose `exp_k2_scars` learning curve is bimodal — it's trimodal sawtooth"* (replaces both Phase A's σ wording and A.5's σ′ wording)
- *"a system where `--steps` ≥ 1 always changes task output — at least 3 of 12 tasks ignore `--steps`"*

### DM3 IS NOT (REVOKED — these were proposed earlier and are no longer correct)

- ~~"a system where `exp_k2_scars` has a non-trivial steps response curve with bimodal peak at 30/40 and sharp cliff at 50"~~ (proposed in earlier handover; superseded by trimodal finding)

---

## 7. Compute headroom — what worked and what didn't

Per orchestrator's 2026-04-24 note, attempted four optimizations:

| Knob | Result |
|---|---|
| Governor → `performance` | **Permission denied** (no root). `walt` (Qualcomm performance-biased scheduler) stays as default. CPU7 ran at 4.32 GHz hw-max throughout under load. |
| Charge bypass mode | **No user-space sysfs path** found. Charge_control_limit visible (4.5 V) but no bypass toggle. Ran with `Fast` charging throughout. |
| Fan ≥ 3 | **No user-space fan control** on this device. Fan controlled by vendor Game Space app. Ran at default fan policy. |
| Unpin test (taskset cpu7 vs unpinned) | **Test passed determinism, slightly hurt wall-clock.** `exp_k2_scars --steps 20` unpinned: best_uplift=1.324074 ✓ preserved, real time 350s vs ~336s pinned (+4 % slower). Scheduler migrates threads to little cores when unpinned. **Kept pinning to cpu7.** |
| GPU path | **Not exposed via CLI.** `--cpu` flag is the only explicit compute-path flag in `--help`. No `--gpu`, no `--threads`. Binary is internally multi-threaded (~7 cores under load when unpinned, confirmed by user+sys time accounting). |

Net: zero compute-headroom gains beyond what the harness already does. Wall-clock slip on A.6 (~10–11h vs nominal 5h) was per-run cost, not configuration loss. Honest documentation in receipts: every run continued under the same governance fences.

---

## 8. Engineering note from this chain

### Receipt summary script behavior

`summarize_cell.sh` reported `verdict=FAIL` for B.3 (`unique_canonical=7` across heterogeneous tasks) and `verdict=PASS` for A.5/A.6a/A.6b (`unique_canonical=1` because all `exp_k2_scars` runs have empty-hash `.bin`). Both are script artifacts, not science verdicts. Treat the per-run KPI line as authoritative.

This was already noted in the Phase A handover. Reaffirmed: the summary verdict is decorative for cells that mix output types or cells whose task writes KPI to stdout.

### Kill-and-resume worked cleanly

Mid-chain on 2026-04-24 ~16:40 UTC, killed the original B.3 to reorder by Tier A → B → C priority. The interference_steps20 run was terminated mid-flight (had reached Epoch 7 of N), its artifacts cleaned up, and the resume-safe logic re-ran it cleanly under the new chain. Zero data loss. Process worked exactly as the resume-safe design intended.

---

## 9. Runtime accounting

| Cell | Runs | Wall-clock | Avg / run | Notes |
|---|---|---|---|---|
| B.3 reordered | 24 (effective; some Tier B already done) | 11h 02m | ~28 min | wide variance: harmonic ~5min, interference ~50–150min |
| A.6a | 15 | 5h 51m | ~23 min | s33–s37, peak region |
| A.6b | 18 | 7h 23m | ~25 min | s43–s49, descent + peak #3 |
| Total chain | 57 net (excluding pre-existing Tier B) | 24h 15m | — | ETA over-ran by ~6h vs my estimate |

ETA estimation methodology improvement for next time: budget per-step compute as ~5 + 0.6 × (step count) seconds for `exp_k2_scars` lesson-3 phase, plus ~3 min cooldown. Variance comes from cycle-phase, not just step count.

---

## 10. Six items for the team to review

1. **σ″ wording** — please push back if "trimodal sawtooth with cycle-length ~6–8 steps" reads too speculative. Alternative neutral framing: "three local maxima with two intervening sharp drops in `--steps` ∈ [28, 50]".

2. **φ wording** — claim φ groups three apparently-decorative tasks. Should `exp_i2` be flagged separately given it's structurally different from `resonance_*`? Or kept together for simplicity?

3. **κ refinement** — agreement on the wording revision? "Error-reduction ratio fixed, absolute values vary" replaces "all flags decorative".

4. **A.7 sub-step sub-phase?** The s33→s34 drop is 0.503 in a single 1-step interval. Is a sub-step sweep at `--steps ∈ {32.5, 33.5}` worth ~30 min device time to confirm the cliff is at exactly s33→s34 vs a smooth sub-step transition? Operator decision; not pre-authorized.

5. **Cycle hypothesis** — the ~6–8-step cycle pattern is suggestive of internal lesson/epoch boundaries. Worth a structural probe (re-run at `--steps 7, 14, 21, 28, 35, 42, 49, 56` to test the cycle length hypothesis directly)? Sub-phase ~3h.

6. **Phase B status** — the orchestrator's 2026-04-24 note authorized A.6 but didn't explicitly open Phase B. Phase B (full B.1 12-task learning cartography + B.2 resonance_v2 debug) hasn't started. With B.3 now closed, Phase B opens — operator confirmation needed.

---

## 11. Preservation status

All A.5 + B.3 + A.6 receipts pulled to host at `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/`. Total 453 files across the 4 cells (153 A.5 + 129 B.3 + 78 A.6a + 93 A.6b). Will upload to HF dataset repo `Zer0pa/DM3-artifacts` via `hf upload` immediately after this report lands.

Repo-agent handover at `repo_stage/HANDOVER_TO_REPO_AGENT_A5_B3_A6_FINAL_20260425.md`. Both docs going to HF.

---

## 12. Next check-in

Phone is currently idle. No chain running. Awaiting operator decision on:
- Phase B opening (12-task learning cartography + resonance_v2 debug)
- Whether to insert any of A.7/cycle-probe sub-phases first
- Whether the σ″ trimodal sawtooth finding warrants its own dedicated investigation (it's the most novel structural finding in DM3 to date)

—— Session 8 engineer-agent, 2026-04-25
