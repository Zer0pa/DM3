# DM3 Claims Ledger

All live claims with status, date, evidence path, and kill criterion.
Each claim carries a pre-registered falsifier that, if met, forces a
retraction. Retractions remain visible; we do not delete past claims.

Status key:
- **SOLID**: confirmed across ≥ 2 sessions at N≥5 with retained packets
- **CONFIRMED**: confirmed in one session at N≥5 with retained packets
- **PROMOTED**: upgraded from suggestive to confirmed
- **WEAKENED**: prior-session claim found less robust in later replication
- **RETRACTED**: kill criterion met; evidence of failure recorded
- **PENDING**: under active test in the current session

---

## Claim α — Sri Yantra exact-rational 2D→3D construction

**Status:** SOLID (unchanged across Sessions 3–6)

**Statement:** The 3D Double Meru graph is constructed via an exact-
rational 2D Sri Yantra scaffolding plus a toroidal-twist lift into 3D,
producing a 380-vertex C3-symmetric graph.

**Evidence:** `docs/reference/GEOMETRY_FIRST_MANIFESTO.md` plus the
source-backed geometry re-probed on 2026-04-03 via `dual_cli`.

**Kill criterion:** Any re-derivation of the geometry that yields a
different vertex count or non-C3 topology. Never met.

---

## Claim β — Bistable relaxation on a C3-symmetric graph

**Status:** SOLID (strengthened across Sessions 3–6)

**Statement:** Under the `harmonic` task with default parameters, the
binary operates a bistable relaxation dynamical system. HIGH basin
(E ≈ 88, Coh ≈ 0.77) and LOW basin (E ≈ 75, Coh ≈ 0.88) are
reproducible. Basin selection per episode is stochastic and
IID Bernoulli with p(HIGH) ≈ 0.34 at default parameters.

**Evidence:**
- Session 3 Phase C (10+11 runs): bistable at 20% HIGH with transformer off
- Session 4 Phase H (70 eps at N=5): basin values replicated across 14 configs
- Session 5 Phase P2a (100 eps at N=100): IID Bernoulli confirmed
  - Transitions: P(H|H)=31%, P(H|L)=35%, marginal 34% — independence
  - Run-length distributions match geometric prediction
- `artifacts/phase_H_statistical_replication_20260416T143544Z/`,
  `artifacts/phase_P2a_intra_session_20260417T130742Z/`

**Kill criterion:** Basin centroids moving by > 5% across replicates at
fixed asym=0; OR transition matrix rows differing from marginal by
> 15 pp at N ≥ 50. Never met.

---

## Claim γ — Rotation × asymmetry C3-asymmetric coupling [RETRACTED]

**Status:** RETRACTED (killed 2026-04-17 in Session 5 P2b at N=10 pooled)

**Original statement (Session 4 Phase L):** At asym=+0.5, rot=60° gave
3/5 HIGH while rot=0° gave 0/5 and rot=120° gave 1/5. The rotation ×
asymmetry coupling is not C3-symmetric; rot=60° uniquely opens the
basin boundary.

**Killing evidence (Session 5 P2b):** Pooled N=10 at same conditions:
- rot=60°  × asym=+0.5: 5/10 HIGH
- rot=120° × asym=+0.5: 3/10 HIGH
- Fisher-exact rot=60° vs rot=120°: **p = 0.65** (not distinguishable)
- Only rot=0° × asym=+0.5 is distinguishable (0/10 HIGH; Fisher p = 0.033 vs rot=60°)

**Revised, weaker claim:** At asym = +0.5, zero rotation suppresses
HIGH basin access; any nonzero rotation restores baseline HIGH rate
(~34%). No evidence of C3-asymmetric coupling.

**Artifact:** `artifacts/phase_P2b_coupling/PHASE_P2b_SUMMARY.md`

---

## Claim δ — `exp_r1_r4_campaign` is a callable self-evaluating 6-gate surface

**Status:** CONFIRMED (Session 5 discovery, quantified in Session 6)

**Statement:** The binary accepts `--task exp_r1_r4_campaign` and emits
a single JSON object (~3.7 kB) with six named pass/fail gates
(EPSILON_CRIT, R1, R2, R3, R4, WAKE_SLEEP_ALIGN). The campaign is
byte-deterministic up to a `run_sec` wallclock field. At defaults
(SriYantraAdj_v1 + RegionTags_v1 + asym=0), 3 gates PASS (EPSILON_CRIT,
R4, WAKE_SLEEP_ALIGN) and 3 FAIL (R1, R2, R3).

**Evidence:**
- Session 5 Phase O: 20 task-name probes; exp_r1_r4_campaign produced
  161-line pretty-printed JSON with nested r1/r2/r3/r4 blocks
- Session 6 Phase W1: bit-identical replication confirmed across 4
  replicates of SY default (canonical SHA `6317e82281cee0b0`)
- `artifacts/phase_O_hidden_tasks_20260417T120540Z/task_exp_r1_r4_campaign.jsonl`
- `artifacts/phase_W1_gate_flip_20260418T000305Z/json_receipts/SY_default.jsonl`

**Kill criterion:** Any receipted run that shows non-deterministic
gate verdicts at identical flag settings, OR any run that fails to
emit all 6 gates.

---

## Claim δ.1 — R1 gate flips with `--adj RandomAdj_v1.bin`

**Status:** CONFIRMED (Session 6 Phase W1 Tier C)

**Statement:** Invoking `exp_r1_r4_campaign` with
`--adj RandomAdj_v1.bin` instead of the default `SriYantraAdj_v1.bin`
flips `gates.R1` from false → true. The underlying metric
`r1.margin` moves from 0.0 to 0.5, crossing the gate threshold of
0.01.

**Evidence:** `artifacts/phase_W1_gate_flip_20260418T000305Z/json_receipts/RA_default.jsonl`
(canonical SHA `21ef856f094dff82`). Replicated in W1 Tier C
(`C_RA_det_r2`, `C_RA_asymn05`, `C_RA_asym05` all produce the same
canonical hash).

**Kill criterion:** Observing `gates.R1 == false` in any future run
with `--adj RandomAdj_v1.bin` at default asym, rot, steps, dataset,
tags. If this happens, the claim falls to "adjacency-dependent but not
determined by RandomAdj_v1.bin specifically" until a reproducible
configuration is identified.

---

## Claim δ.2 — R2 gate flips with `--tags RegionTags_v2.bin` (+ claim_level advance)

**Status:** CONFIRMED (Session 6 Phase W1 Tier C)

**Statement:** Invoking `exp_r1_r4_campaign` with
`--tags RegionTags_v2.bin` instead of the default
`RegionTags_v1.bin` flips `gates.R2` from false → true. Additionally
`claim_level` advances from "CL-0" to "CL-1" — the first observed
change on this meta-field.

**Evidence:** `artifacts/phase_W1_gate_flip_20260418T000305Z/json_receipts/SY_tags_v2.jsonl`
(canonical SHA `d15c551d4e537545`).

**Kill criterion:** Observing `gates.R2 == false` or
`claim_level == "CL-0"` in any future run with
`--tags RegionTags_v2.bin` at default everything else. Never met so far.

---

## Claim δ.3 — R3 gate is ROBUST-FAIL within tested surface, but payload-moving along `--steps`

**Status:** CONFIRMED (Session 6 Phase W1)

**Statement:** Across all tested configurations in Session 6 W1, the
`gates.R3` flag remains false. However, the underlying metric
`r3.k2_uplift` moves from 0.0070 at `--steps 1` to 0.0292 at
`--steps 20` (4× increase). R4 payload fields also move ~4× under the
same steps axis without R4 gate flipping.

**Evidence:**
- `C_SY_s20.jsonl` (canonical SHA `06e5cf74d608fe4a`)
- Bit-identical SY hash at asym/rot/dataset/tags variants confirms
  R3 is independent of those axes.

**Kill criterion:** Observing `gates.R3 == true` at any tested config
retires this claim in favour of a specific "R3 flips with X" claim.

---

## Claim ε — Harmonic basin Coh signatures compress at asym ≤ −3

**Status:** CONFIRMED (Session 5 P3, strengthened in Session 6 W2)

**Statement:** At asym ≤ −3 (tested down to asym = −5), the harmonic
task's two-basin (E, Coh) signatures drift downward in coherence:
LOW basin Coh from 0.88 (asym=0) → 0.66 (asym=−5); HIGH basin Coh
from 0.77 → 0.69. The Session 4 locked classifier (LOW Coh > 0.82)
is therefore valid only on asym ∈ [−2, +2]. An emerging mid-cluster
at asym ∈ {−3.5, −4} is suggestive of a third attractor but not
robust at the current N.

**Evidence:**
- Session 5 P3: 7 cells, asym ∈ {-5, -3, -2, +2, +5} × N=5
- Session 6 W2: 5 cells, asym ∈ {-5, -4, -3.5, -3, -2.5} × N=7-10
- Monotone LOW Coh: 0.88 → 0.83 → 0.82 → 0.78 → 0.76 → 0.69 → 0.66
  across asym ∈ [0, -2, -2.5, -3, -3.5, -4, -5]
- `artifacts/phase_P3_escale/`, `artifacts/phase_W2_third_regime_20260418T031800Z/`

**Kill criterion:** Observing LOW Coh > 0.80 at any asym < −2 in a
future replicate run. Never met.

---

## Claim ζ — p(HIGH) is parameter-INVARIANT at |asym| ≤ 0.2

**Status:** CONFIRMED (Session 6 Phase W3 verdict: **W3-INVARIANT**)

**Statement:** Within the tested asymmetry range |asym| ≤ 0.2 and at
N=100 per arm, the per-episode HIGH-basin selection rate is consistent
with a single parameter-insensitive value. All three pairwise 95 %
Wilson CIs overlap.

**Evidence:**
- Arm 0 (asym=0, N=100): p(HIGH) = **34.0 %**, CI [25.5 %, 43.7 %]
- Arm A (asym=+0.2, N=100): p(HIGH) = **42.0 %**, CI [32.8 %, 51.8 %]
- Arm B (asym=−0.2, N=100): p(HIGH) = **32.0 %**, CI [23.7 %, 41.7 %]
- All pairwise CIs overlap. `artifacts/phase_W3_p_high_20260418T053010Z/PHASE_W3_SUMMARY.md`

**Secondary observation (kept as Session 7 seed):** Point estimates are
monotone in asymmetry (−0.2 → 32%, 0 → 34%, +0.2 → 42%), and Arm B
shows P(H\|H) − P(H\|L) = +13.8 pp (χ² p ≈ 0.17, not significant at
N=95 transitions). Both signals are within statistical noise at the
tested N but suggest a real underlying trend worth confirming at N ≥ 200
per arm or at |asym| ≥ 0.4. **These are NOT claims; they are seeds.**

**Kill criterion:** Any future run where an arm's Wilson 95 % CI at
N ≥ 100 is disjoint from the other two would retire this invariance
claim in favour of a parameter-dependent formulation.

---

## Claim η — 12 callable `--task` values (vocabulary claim)

**Status:** CONFIRMED (Session 6 Phase W0)

**Statement:** Beyond `harmonic` and `holography`, the binary accepts
10 additional task names via `--task`:
`interference`, `holographic_memory`, `exp_r1_r4_campaign`, `exp_i1`,
`exp_i2`, `exp_h1_h2`, `exp_k2_scars`, `exp_k3_truth_sensor`,
`resonance_r3`, `resonance_v2`. Total accepted: 12.

**Evidence:**
- `artifacts/phase_O_hidden_tasks_20260417T120540Z/PHASE_O_SUMMARY.md` (5 names)
- `artifacts/phase_W0_vocabulary_20260417T230843Z/PHASE_W0_SUMMARY.md` (7 more)
- Rejected candidates logged in both summary files

**Kill criterion:** Any of the 12 names returning rc != 0 in a
subsequent run.

---

## Claim θ — Harmonic dynamics layer is substrate-invariant across the mirrored Session 7 battery

**Status:** CONFIRMED (Session 7 interim, mirrored in repo)

**Statement:** Under `--task harmonic --steps 5` with the canonical
SY / RegionTags_v1 graph surface and pinned Prime core, the per-episode
HIGH-basin rate remains statistically consistent across the mirrored
Session 7 substrate battery. Mirrored arms: S2H pinned baseline
35.6% [29.9%, 41.7%] at N=250, S7 COLD 36.0% [27.3%, 45.8%] at N=100,
S7 HOT 33.0% [24.6%, 42.7%] at N=100, S8 BATTERY 36.7% [21.9%, 54.5%]
at N=30, S8 BYPASS 28.6% [19.3%, 40.1%] at N=70. Every mirrored arm's
Wilson 95% CI overlaps the Session 5 baseline [25.5%, 43.7%].

**Evidence:**
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S2H_harmonic/S2H_stat_summary.json`
  (summary SHA `7a644204f74eb365947080a3038a2efe0025e219e8446b65107337c70b4008cd`)
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S7_thermal_final/`
  (40 mirrored harmonic runs; arm-level p(HIGH) recomputed from `.bin` receipts)
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S8_final/`
  (20 mirrored harmonic runs; BATTERY/BYPASS p(HIGH) recomputed from `.bin` receipts)
- See `repo_stage/REPO_AGENT_FINDINGS.md` for why the helper summary verdicts
  in `S7_thermal_final/` and `S8_final/` are not the statistical authority surface.

**Kill criterion:** Any future pinned-substrate arm at N ≥ 30 on the
same binary / adj / tags / task / steps surface whose Wilson 95% CI is
disjoint from the Session 5 baseline CI or from another mirrored arm's
CI; OR basin centroids moving by > 5% at fixed parameters under a
substrate intervention.

---

## Claim ι — Gate-layer substrate-null battery on the default smoke surface [PENDING SYNC]

**Status:** PENDING (live Session 7 report; full mirror not present in this checkout)

**Statement:** The live Session 7 interim report states that the default
`exp_r1_r4_campaign` smoke surface stayed on canonical SHA
`9006df4ec02c8872...` across 40 invocations spanning pinned baseline,
airplane vs radios, Prime vs Performance core, and cold vs hot
conditions. In this checkout the smoke fingerprint itself is mirrored,
but the full per-cell gate battery is not yet present as a complete
local proof tree, so this claim remains pending sync rather than
promoted as closed.

**Evidence:**
- Mirrored smoke fingerprint:
  `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S1_smoke/S1_smoke_001.bin`
  (canonical SHA `9006df4ec02c8872b2037ce49ba9f2e9f27cfb7b92f62dfea5e7982d6be7d912`)
- Sync gap documented in `repo_stage/REPO_AGENT_FINDINGS.md`
- Live summary SHAs cited in the operator interim note:
  `b3c1c1bfa4bc024f...`, `e3d3f721c981f817...`,
  `f385a14ae533de04...`, `5195ef83fee34bec...`

**Kill criterion:** When the full gate-layer battery is mirrored, any
default-arm receipt on the same binary / adj / tags / task / steps
surface producing a canonical SHA other than `9006df4ec02c8872...` or a
changed gate vector retires this pending claim in favour of a narrower
environment-sensitive formulation.

---

## Claim κ — Combined-axis receipt flips R1 and R2 together at CL-1 [PARTIAL]

**Status:** PENDING (Session 7 S11 partial)

**Statement:** A mirrored partial Session 7 receipt shows that the
combined configuration
`--adj RandomAdj_v1.bin --tags RegionTags_v2.bin --steps 50`
flips **R1 and R2 together**, advances `claim_level` to `CL-1`, leaves
`R3 == false`, and raises `r4.transfer_ratio` to `2.67826509475708`.
The matched SY-default S11 step-sweep receipts at requested
steps = 20 / 50 / 100 all keep `R1 == false`, `R2 == false`,
`R3 == false`, and `operational_steps == 10`.

**Evidence:**
- Combined-axis receipt:
  `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_partial/S11_r3_flip_B_RA_tagsV2_s50_001.bin`
  (canonical SHA `6716b0ff5486da345068d87aaf78261095554ea828259e6acd25781814366981`)
- Matched SY-default receipts:
  `S11_r3_flip_A_s20_001.bin` (canonical SHA `f1b55cf6994d2109000ae5ef2276eaebd74a39a38d28b576c0d46025816bc09a`)
  `S11_r3_flip_A_s50_001.bin` (canonical SHA `30204676fe6d52d4124a6400c5c096709a3bb761d081a9ef28ac15895ed4182c`)
  `S11_r3_flip_A_s100_001.bin` (canonical SHA `14ab4fb791f21d1761c1a4ee86ff0d29533a20104c34d153bf6b06ace5fa034d`)
- Progress / missing final cell documented in
  `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_partial/progress.txt`

**Kill criterion:** The final combined-axis `steps=100` cell or an
immediate rerun at the same combined settings yielding `R1 == false`,
`R2 == false`, or `claim_level == "CL-0"` retires the compound-flip
formulation. A receipted `R3 == true` result on any of the S11 cells
would split this into a narrower compound-flip claim plus a separate
R3-flip claim.

---

## Claim λ — Default six-gate smoke surface has a reproducibility fingerprint at `--steps 5`

**Status:** CONFIRMED (Session 7 Phase 0 smoke)

**Statement:** On the Session 7 smoke surface
(`--cpu --mode train --task exp_r1_r4_campaign --steps 5` with default
SY adjacency and RegionTags_v1), the campaign emits canonical SHA
`9006df4ec02c8872b2037ce49ba9f2e9f27cfb7b92f62dfea5e7982d6be7d912`.
This is a reproducibility fingerprint for that exact gate surface.

**Evidence:** `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S1_smoke/S1_smoke_001.bin`
plus companion receipt
`S1_smoke_001.json` (receipt SHA
`97819a67557c97653c2f9c27f1bb020a86145b5a050e1e384534a5a0f5a7ff09`)
and `.bin.canonical.sha`.

**Kill criterion:** Any future run on the same binary / adj / tags /
task / steps surface producing a different canonical SHA or a changed
gate vector.

---

## Retired claims (killed or superseded)

- **"freq = 1.0 → 100% HIGH"** (Session 3, N=2) — KILLED in Session 4 at N=5 (freq = 1.0 gave 1/5 = 20%).
- **"rot = 120° preserves bistability"** (Session 3, N=2) — KILLED in Session 4 (rot = 120° gave 0/5 HIGH).
- **"truth sensor suppresses HIGH in harmonic"** (Session 3, N=2) — KILLED in Session 4 (default 2/5, strong 2/5). Note: the truth sensor DOES have a real effect inside `exp_k3_truth_sensor` — see IS_AND_IS_NOT.md, scope matters.
- **"transformer 3× HIGH bias"** (Session 3) — KILLED in Session 4 (HAM = LN = 20%).
- **"sharp asymmetry critical point"** (Session 3 suggestion) — KILLED in Session 4 Phase K (smooth position shift, no sharp critical point).
- **Claim γ** (Session 4 Phase L, C3-asymmetric coupling) — RETRACTED in Session 5 P2b as detailed above.
