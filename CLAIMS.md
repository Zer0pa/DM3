# DM3 Claims Ledger

All live claims with status, date, evidence path, and kill criterion.
Each claim carries a pre-registered falsifier that, if met, forces a
retraction. Retractions remain visible; we do not delete past claims.

Status key:
- **SOLID**: confirmed across ≥ 2 sessions at N≥5 with retained packets
- **CONFIRMED**: confirmed in one session at N≥5 with retained packets
- **PROMOTED**: upgraded from suggestive to confirmed
- **CANDIDATE**: receipted and worth carrying, but not promoted
- **WEAKENED**: prior-session claim found less robust in later replication
- **RETRACTED**: kill criterion met; evidence of failure recorded
- **PENDING**: under active test in the current session

Session 8 Phase A / A5-B3-A6 close note:
- `docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md` reports
  Phase A closed with 55 receipts across A.1/A.2/A.3/A.4
- the local host tree now mirrors the Phase A `cells/` directories and
  `device_snapshot/bin/run_cell.sh`
- local per-run anchors are 52 receipt JSON/log pairs:
  A.1=10, A.2=21, A.3=12, A.4=9
- the Phase A summary files report `total_runs = 55`; that count seam
  is kept visible in `REPO_AGENT_FINDINGS.md` rather than hidden
- `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`
  closes 57 additional A5/B3/A6 per-run receipts and supersedes the
  earlier coarse `σ` wording before promotion
- Claims `ξ`, `ο`, and `τ` are CONFIRMED; Claims `π`, `ρ`, `σ″`, and
  `φ` are CANDIDATE

Session 8 Phase G live-chain note (added 2026-04-28, updated 2026-04-28 16:00 UTC):
- Phase G v2 chain launched 2026-04-25 18:25:54 UTC under
  `phase_g_chain_v2.sh`; PRD at
  `docs/restart/DM3_PHASE_G_AUGMENTED_PRD_v2_REORDERED_20260425.md`.
- Closed cells with promotable verdicts: `G.0` PASS (pre-launch
  gates), `G.0.5` PASS (σ″ baseline determinism extension at
  `s30/s33`, 10/10 bit-exact; folded into `ξ`), `G.6` PASS
  (path-independence; new claim `χ`, CONFIRMED), `G.1` PASS (cycle
  probe; `s56 = 1.970840 > σ″ peak #1`; new claim `ψ`, CANDIDATE),
  `G.1.5` PARTIAL (multiplicity-7 sawtooth fits tighter than
  multiplicity-6 or -8; mechanism candidate, not promoted),
  **`G.2` PASS** (trimodal portability across 3/3 cross-controls;
  σ″ shape is geometry-independent; promotes `σ″` to CONFIRMED for
  shape, with magnitudes recorded as config-dependent).
- `G.7 cliff-class characterization` is IN FLIGHT at the time of
  this update. Promoted findings from G.7 land at chain close.
- Cells pending after G.7: `G.3` LEARNS cartography, `G.4`
  basin-coupling, `G.5`/`G.5+` forensic. Their findings are not
  promoted here.

Reconstruction (Tier-2 static) note (added 2026-04-28):
- An independent backwards-reconstruction lane authored at
  `dm3-runner-reconstruction-2026-04-27/` parses the Android aarch64
  ELF, the loaded fixtures, and the static-disassembly call graph.
- Eight pre-registered reconstruction hypotheses `R1..R8`. R1–R7 are
  PASS_STATIC_TIER2 or PASS_STATIC_TIER2_DYNAMIC_OPEN. R8 (Android
  argv / file-open / output trace) remains
  `OPEN_TIER3_BLOCKED` and is the sovereign remaining reconstruction
  gate. **No claim of complete reconstruction is promoted on this
  surface until R8 closes.**
- See `RECONSTRUCTION_TIER2_NOTE.md` for the full evidence table.

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

## Claim δ.3 — R3 gate is structurally unreachable from the exposed CLI [WEAKENED]

**Status:** WEAKENED (Session 6 claim revised in Session 7)

**Original statement (Session 6 Phase W1):** Across all tested
configurations in Session 6 W1, the `gates.R3` flag remained false, but
the underlying metric `r3.k2_uplift` moved from 0.0070 at `--steps 1`
to 0.0292 at `--steps 20`.

**Session 7 update:** The S11 A-cells at requested
`--steps ∈ {20, 50, 100}` showed that the SY-default surface saturates
internally at `operational_steps == 10`. Above `--steps 20`, the
payload no longer advances; Session 7 therefore weakens the Session 6
reading rather than silently carrying it forward.

**Revised statement:** On the currently exposed CLI surface,
`gates.R3` remains false and is structurally unreachable from the
requested `--steps` axis. The underlying `r3.k2_uplift` rises only up
to the internal cap and then saturates; requested `--steps > 20` does
not extend `operational_steps` above 10 on the SY-default gate surface.

**Evidence:**
- Session 6: `artifacts/phase_W1_gate_flip_20260418T000305Z/json_receipts/C_SY_s20.jsonl`
  (canonical SHA `06e5cf74d608fe4a`)
- Session 7: `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_final/`
  (`S11_r3_flip_A_s20_001.bin`, `S11_r3_flip_A_s50_001.bin`,
  `S11_r3_flip_A_s100_001.bin`)

**Kill criterion:** Observing `gates.R3 == true` on the exposed CLI
surface, or observing `operational_steps > 10` on the SY-default
surface at requested `--steps >= 20`.

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

## Claim θ — `exp_r1_r4_campaign` compound-axis flip doubles `r4.transfer_ratio`

**Status:** CONFIRMED (Session 7 S11 B-cell)

**Statement:** Invoking
`--task exp_r1_r4_campaign --adj RandomAdj_v1.bin --tags RegionTags_v2.bin --steps 50`
flips R1+R2 simultaneously, advances `claim_level` CL-0→CL-1, and
raises `r4.transfer_ratio` from 1.369 (default) to 2.678 (+95%).
`R3` remains false.

**Evidence:** `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_final/S11_r3_flip_B_RA_tagsV2_s50_001.bin`
plus `S11_r3_flip_summary.json`.

**Kill criterion:** Observing `gates.R1 == false` OR
`gates.R2 == false` OR `r4.transfer_ratio < 2.0` in a replicate run
with identical flags.

---

## Claim ι — Dynamics-layer p(HIGH) is substrate-invariant at tested granularity

**Status:** CONFIRMED (Session 7, 6 arms × 665 episodes)

**Statement:** The harmonic `--steps 5` basin selection rate does not
show a receipted coupling to the tested thermal (cold/hot), power-path
(battery/bypass), or run-count (N=23–250) variation. All six arm
Wilson 95% confidence intervals overlap the Session 5 baseline
`[25.5%, 43.7%]`.

**Evidence:**
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S2H_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S7_thermal_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S8_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S5_final/`
- See `repo_stage/REPO_AGENT_FINDINGS.md` for why the helper summary
  verdicts on harmonic cells are not the statistical authority surface.

**Kill criterion:** Any future arm's 95% Wilson CI at `N >= 50`
disjoint from the Session 5 baseline CI.

---

## Claim κ — Truth-sensor sensor-flag invariance, with `--steps` refinement

**Status:** CONFIRMED (Session 7 S10, refined by Session 8 B3)

**Statement:** `--task exp_k3_truth_sensor` emits identical KPIs
`{108.16, 22.29, 85.87}` across every tested `--sensor-strength`
(`0.0, 0.1, 0.25, 0.5, 0.75, 1.0`) and `--sensor-threshold`
(`0.01, 0.1, 1.0, 10.0`) value. The task's internal work is real and
reproducible, with a Session 7 error-reduction ratio near 79.4%.
Session 8 B3 refines the interpretation: `--steps` is not decorative
for this task's absolute baseline and gap values. At `--steps 1`,
`baseline_error = 89.255325`, `sensor_error = 22.317333`, and the
ratio is about 75.0%; at `--steps 20`, `baseline_error = 108.164818`,
`sensor_error = 22.292860`, and the ratio is about 79.4%. The stable
B3 component is the selected `sensor_error` near `22.3`, not a universal
`--steps`-invariant KPI triple.

**Evidence:**
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S10_final/`
  (`S10_truth_sensor_summary.json` plus the nine `.log` files)
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/`
  (`B3_cli_audit_exp_k3_truth_sensor_steps1.log` and
  `B3_cli_audit_exp_k3_truth_sensor_steps20.log`)

**Kill criterion:** A same-scope future invocation where the Session 7
fixed sensor-strength / sensor-threshold invariance fails, or where the
task stops showing a substantial selected-sensor error reduction on the
tested surface.

---

## Claim λ — R1/R2 cross-control axes are cleanly separable

**Status:** CONFIRMED (Session 7 T11, N=3 replicates)

**Statement:** Across the 2×2 cross-table `{SY, RA} × {v1, v2}` at
default steps, R1 flips only when `--adj` changes and R2 flips only
when `--tags` changes. No cross-contamination was observed. Determinism
is confirmed by 3 bit-identical canonical SHAs for `RA+v2`. However,
`r4.transfer_ratio` shows multiplicative interaction:
`0.658 (RA+v1), 1.369 (SY+v1 default), 1.442 (SY+v2), 2.133 (RA+v2 compound)`.

**Evidence:** `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/T11_cross_control/`
plus prior Session 6 gate receipts.

**Kill criterion:** Any replicate of `RA+v2` at default `--steps 1`
that shows `R1 == false` or `R2 == false` or `r4.transfer_ratio < 1.5`.

---

## Claim μ — `exp_k2_scars` task LEARNS-STRONG with operational step-budget

**Status:** CONFIRMED (Session 7 T2, 5 step values)

**Statement:** `best_uplift` for `--task exp_k2_scars` is a
monotone-increasing function of `--steps` over the window
`1 → 5 → 10 → 20`, rising from `0.010 → 0.075 → 0.273 → 1.324`.
At `--steps 20`, `best_uplift` is 26× the pre-registered LEARNS
threshold of `0.05`. At `--steps 50`, the task overfits and
`best_uplift` drops to `0`, with lesson-count-3 uplift falling to
`-0.28`. This is the first receipted positive learning finding in
DM3 Sessions 3–7.

**Evidence:** `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/T2_scars_scaling/`
(`T2_scars_scaling_summary.json` plus the five `.log` files).

**Kill criterion:** A replicate at `--steps 20` showing
`best_uplift < 0.5`.

**Session 8 Phase A refinement:**
`docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md` reports
that the Session 7 `--steps 20` anchor remains positive and replicated,
but is a shoulder rather than the peak. The follow-on
`docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`
maps the local curve at one-step resolution across the 28→50 region.
It finds a trimodal sawtooth curve with local maxima at `--steps 33`,
`41`, and `49`, and a cliff to `0.000000` at `--steps 50`. Local
anchors:
`artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A1_mu_replicate/`,
`A2_overfit_boundary/`, `A3_cross_graph/`, `A4_cross_dataset/`,
`A5_peak_finder/`, `A6a_peak_fill/`, and `A6b_post_peak/`.

---

## Claim ξ — `exp_k2_scars` fixed-config determinism

**Status:** CONFIRMED (Session 8 Phase A/A5/B3/A6 + τ + Phase G G.0.5, expanded evidence base)

**Statement:** At fixed `exp_k2_scars` configurations, the promoted KPI
outputs are deterministic across the mirrored Phase A equivalence
classes. Repeated configs emit identical `best_uplift` and
`max_scar_weight` values; `.bin` outputs are empty-hash by design.
The evidence base now includes the Phase A cells, A5 peak finder,
B3 audit, A6a/A6b fills, four cross-cell exact matches at steps
`30/35/40/45`, and the independent τ ARM64 cross-hardware match.

**Evidence:**
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A1_mu_replicate/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A2_overfit_boundary/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A3_cross_graph/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A4_cross_dataset/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A5_peak_finder/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6a_peak_fill/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6b_post_peak/`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/`
- Summary SHAs: A1 `be8e87e4...`, A2 `3b513c8f...`,
  A3 `1100f470...`, A4 `164d3003...`, A5 `7d1f960c...`,
  B3 `d3c6a6c...`, A6a `9bff0dc0...`, A6b `ca3ff1a...`

**Count seam:** The original Phase A mirror contains 52 local per-run
receipt/log pairs while its summaries report 55 total runs. The
expanded chain adds 57 further local A5/B3/A6 per-run receipts. The
engineer final report summarizes the combined determinism base as
approximately 142 receipts. See `repo_stage/REPO_AGENT_FINDINGS.md`.

**Phase G G.0.5 extension (2026-04-26):**
The Phase G v2 cell `G.0.5 determinism_recheck` reports `10/10`
bit-exact `best_uplift` reproduction at both `s30 = 1.644524` and
`s33 = 1.873756` on the σ″ baseline surface. This expands the ξ
evidence base into the Phase G era and is pulled to host with the rest
of the chain at chain close.

**Kill criterion:** A same-config future replicate returning a different
promoted KPI value for the same config.

---

## Claim ο — sharp overfit cliff at `--steps 49 -> 50`

**Status:** CONFIRMED (Session 8 Phase A, sharpened by A6b)

**Statement:** The `exp_k2_scars` overfit boundary is
sharp-and-discrete at the final mapped edge: `--steps 49` returns
`best_uplift = 1.819397` and `--steps 50` returns
`best_uplift = 0.000000`. The older 45→50 wording remains true as a
coarse bracket, but A6b localizes the cliff more tightly to 49→50.

**Evidence:**
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A2_overfit_boundary/`
  (`A2_overfit_boundary_s50_r{1,2,3}.log`)
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6b_post_peak/`
  (`A6b_post_peak_s49_r{1,2,3}.log`)

**Kill criterion:** A same-config replicate returning a nonzero
`best_uplift` at `--steps 50`, or a finer boundary sweep showing the
drop is gradual rather than discrete.

---

## Claim π — scoped dataset invariance at μ baseline

**Status:** CANDIDATE (Session 8 Phase A, three xnor datasets)

**Statement:** `exp_k2_scars` at
`--steps 20 / SriYantraAdj_v1.bin / RegionTags_v1.bin` is invariant
across `xnor_train`, `xnor_mini`, and `xnor_test`, each returning
`best_uplift = 1.324074`.

**Evidence:** `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A4_cross_dataset/`
(`xnor_train`, `xnor_mini`, and `xnor_test`, 3 logs each).

**Kill criterion:** A future dataset, including a non-XNOR or
adversarial dataset, returning a different `best_uplift` at the same
config.

---

## Claim ρ — RA+v2+steps=20 zero-learning IS_NOT

**Status:** CANDIDATE (Session 8 Phase A, scoped negative line)

**Statement:** `exp_k2_scars` at `--steps 20` with
`RandomAdj_v1.bin + RegionTags_v2.bin` returns
`best_uplift = 0.000000`, a scoped zero-learning result.

**Evidence:** `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A3_cross_graph/`
(`A3_cross_graph_RA_v2_r{1,2,3}.log`).

**Scope guard:** This is not a ceiling claim. RA+v2 is untested at
`--steps 30..45` on the local promoted surface.

**Kill criterion:** A future same-config replicate returning
`best_uplift >= 0.05`.

---

## Claim σ″ — `exp_k2_scars` learning curve is a trimodal sawtooth, geometry-independent in shape

**Status:** CONFIRMED for shape across cross-controls (Session 8 A5/A6 baseline + Phase G `G.2` close 2026-04-28). Magnitudes are config-dependent and explicitly NOT promoted as portable.

**Statement:** On the scoped baseline surface
`--cpu --task exp_k2_scars / SriYantraAdj_v1.bin / RegionTags_v1.bin /
xnor_train`, the one-step `--steps` map across the 28→50 region is a
trimodal sawtooth rather than a bimodal 30/40 peak. Local maxima are
`s33 = 1.873756` (global), `s41 = 1.708374`, and
`s49 = 1.819397`. Sharp drops occur at `s33 -> s34`
(`1.873756 -> 1.370651`), `s41 -> s43`
(`1.708374 -> 1.160828`), and `s49 -> s50`
(`1.819397 -> 0.000000`).

**Evidence:**
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A5_peak_finder/`
  (30 receipts)
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6a_peak_fill/`
  (15 receipts)
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6b_post_peak/`
  (18 receipts)
- cross-cell exact matches with A2 at `s30`, `s35`, `s40`, and `s45`

**Scope guard:** The cycle structure shape is now mapped across three
cross-control axes via `G.2`: graph (`SY_v1` ↔ `RandomAdj_v1`), tags
(`RegionTags_v1` ↔ `RegionTags_v2`), and dataset (`xnor_train` ↔
`xnor_mini`). Magnitudes scale differently per config; the σ″
**shape** claim is portable, the σ″ **values** claim is not. The
post-cliff cycle (claim `ψ`) and the cliff fine structure are still
the subject of `G.7 cliff-class characterization`, in flight at this
update.

**Rejected-before-promoted:** Earlier candidate wordings `σ`
(coarse 30/40 peak) and `σ′` (bimodal s32/s41 reading) are superseded
and should not be treated as active claims.

**Kill criterion:** Any one of: a sub-step sweep showing the s33→s34
drop is a sampling artifact; a rerun at `--steps 33`, `41`, or `49`
returning different KPI values; or cross-condition tests falsifying the
cycle structure under the claimed scope.

**Status update — Phase G G.2 close (2026-04-28 ~11:25 UTC):**
The σ″ trimodal sawtooth shape is now portable across all three
tested cross-controls: graph adjacency (cfg-A `RandomAdj_v1.bin`),
region-tag partition (cfg-B `RegionTags_v2.bin`), and dataset
(cfg-C `xnor_mini`). **`G.2 verdict = PASS, summary = "trimodal shape
preserved in 3/3 configs"`.** Reading this with the σ″ scope guard:
the cycle-structure shape is geometry-independent under the tested
axes, so σ″ promotes from CANDIDATE to CONFIRMED for shape. Status
header and statement updated accordingly above. **Magnitudes are
config-dependent and not portable** — see new IS_NOT line in
`IS_AND_IS_NOT.md`.

Cliff-at-`s50 = 0.000000` matches EXACTLY across all three configs.
The `49→50` cliff is the strongest universal feature on the tested
surface. The fine cliff-class structure is `G.7`'s next deeper test,
in flight as of this update. The post-cliff cycle (claim `ψ`) is
still CANDIDATE pending fine-resolution sweep.

Per-config G.2 metrics (from `cells/G2_trimodal_portability/outcome.json`):

```
cfg-A  RandomAdj_v1   p33=1.919380  p34=1.408173  p41=1.784622  p43=1.217201  p49=1.897110  p50=0.000000  shape_ok=1
cfg-B  RegionTags_v2  p33=0.995499  p34=0.000000  p41=0.477169  p43=0.000000  p49=0.543240  p50=0.000000  shape_ok=1
cfg-C  xnor_mini      p33=1.873756  p34=1.370651  p41=1.708374  p43=1.160828  p49=1.819397  p50=0.000000  shape_ok=1
```

---

## Claim ν — `resonance_r3` task ignores the `--steps` CLI flag

**Status:** CONFIRMED (Session 7 T3, strengthened by Session 8 B3)

**Statement:** `--task resonance_r3` produces identical stdout
(`Om_dE 1.2745 → 1.2741`, `delta = -0.0004`) across
`--steps ∈ {1, 5, 10, 20}`. The pre-registered LEARNS criterion
(`|ΔdE| >= 0.01`, monotone) is not met. This task hardcodes its own
10-episode training loop regardless of the requested `--steps`.

**Evidence:**
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/T3_plasticity/`
  (`T3_plasticity_summary.json` plus the four `.log` files)
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/`
  (`B3_cli_audit_resonance_r3_steps1.log` and
  `B3_cli_audit_resonance_r3_steps20.log`)

**Kill criterion:** Observing `|ΔdE| > 0.001` at any tested
`--steps` value.

---

## Claim τ — `exp_k2_scars` ARM64 cross-platform determinism

**Status:** CONFIRMED (Session 8 AGD-H1 external M1 lane)

**Statement:** The Android aarch64 `dm3_runner` binary emits bit-exact
`exp_k2_scars` KPI values on RM10 Snapdragon native Android and an
Apple M1 Android ARM64 emulator under Hypervisor.framework for the
tested baseline configs at `--steps {20,30,40,45,50}`. All five
`best_uplift` values and all five `max_scar_weight` values match.

**Evidence:**
- `repo_stage/CLAIM_TAU_CONFIRMED_20260424.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_ORCHESTRATOR_M1_TAU_20260424.md`
- `docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/`

**Kill criterion:** A same-input ARM64 platform replicate returning any
different emitted KPI value, after input SHA equality is verified.

---

## Claim φ — three known tasks are `--steps`-decorative on primary output

**Status:** CANDIDATE (Session 8 B3 CLI audit)

**Statement:** In the B3 12-task audit at `--steps 1` vs `--steps 20`,
three callable tasks ignore `--steps` on their primary emitted output:
`resonance_r3`, `resonance_v2`, and `exp_i2`. The audit also confirms
that most of the known task surface is not decorative: nine of twelve
tasks respond to `--steps`, while `exp_k3_truth_sensor` is partial
because absolute values and the reduction ratio change, even though its
selected `sensor_error` remains near `22.3`.

**Evidence:** `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/`
(`B3_cli_audit_summary.json` plus the 24 per-task logs/receipts).

**Scope guard:** This is a `--steps 1` vs `--steps 20` candidate only.
It is not a claim that these tasks ignore every possible step value or
ignore `--steps` under every adjacency, tags, dataset, or other
configuration.

**Kill criterion:** Any future same-scope evidence that
`resonance_r3`, `resonance_v2`, or `exp_i2` changes its primary output
between `--steps 1` and `--steps 20`, or a broader sweep that identifies
a real `--steps` response inside the claimed scope.

---

## Claim χ — DM3 invocation is path-independent at fixed config

**Status:** CONFIRMED (Session 8 Phase G cell G.6, 2026-04-26)

**Statement:** At fixed `(--task, --adj, --tags, --steps, --dataset)`,
the canonical SHA of `dm3_runner` outputs is bit-identical across
invocation-path A and invocation-path B. The Phase G cell `G.6
path_dependence` reports `4/4 same-config canonical SHAs match across
path A and B`. The binary therefore exposes no observable
cross-invocation state coupling on the tested surface.

**Evidence:**
- `cells/G6_path_dependence/outcome.json` (Phase G v2 chain;
  receipts pulled to host at chain close at
  `artifacts/phase_S8_PG_followup_<TS>/cells/G6_path_dependence/`).
- Phase G PRD anchor:
  `docs/restart/DM3_PHASE_G_AUGMENTED_PRD_v2_REORDERED_20260425.md`,
  cell ordering and dependency table.

**Kill criterion:** Any same-config future replicate where path-A and
path-B canonical SHAs differ.

---

## Claim ψ — `exp_k2_scars` baseline curve admits a cycle past the `49 → 50` cliff

**Status:** CANDIDATE (Session 8 Phase G cell G.1, 2026-04-26)

**Statement:** Phase G `G.1 cycle_probe` reports
`s56 best_uplift = 1.970840` on the σ″ baseline surface
`(--task exp_k2_scars / SriYantraAdj_v1.bin / RegionTags_v1.bin /
xnor_train)`. This value is HIGHER than the σ″ peak #1 at
`s33 = 1.873756`. The s33→s50 cliff is therefore not a permanent
collapse; the baseline curve admits at least one further cycle past
`s50`. The `s33 → s56` cycle length and the precise post-cliff
recovery shape are not yet mapped.

**Evidence:**
- `cells/G1_cycle_probe/outcome.json` (Phase G v2 chain, receipts
  pulled at chain close).
- Comparator: σ″ peak `s33 = 1.873756` from
  `cells/A5_peak_finder/`.

**Mechanism candidate (Session 8 Phase G cell G.1.5):**
The G.1.5 cycle disambiguator reports the multiplicity-7 sawtooth fits
tighter than multiplicity-6 or -8 on the same surface. This is
suggestive of a cycle-7 mechanism for σ″ but is recorded as PARTIAL,
not promoted.

**Scope guard:** ψ does not claim a periodic curve. It claims one
super-cliff value above σ″'s primary peak. Cycle structure
characterization is the work of Phase G cell `G.7
cliff_class_characterization`, conditional on `G.2 PASS`.

**Kill criterion:** A same-config replicate at `s56` returning
`best_uplift < σ″ peak #1` (`< 1.873756`), or a fine-resolution
sweep s50→s56 showing the `s56` value is a sampling artifact rather
than a real local maximum.

---

## Reconstruction (static, Tier-2)

The eight reconstruction hypotheses below are pre-registered in
`dm3-runner-reconstruction-2026-04-27/artifacts/phase_05_falsification_harness/H1_H8_STATIC_PREFLIGHT.md`.
Status semantics differ from the runtime claims: PASS_STATIC_TIER2
means the hypothesis is closed at the level of parsed fixtures, static
disassembly, and host-recomputable invariants. It is NOT a Tier-3
runtime trace. Tier-3 closure for the binary's actual L-branch
file-load, parse, and output-write behaviour requires Android
argv/file-open/write tracing under live execution and is parked behind
R8.

Anchor doc: `RECONSTRUCTION_TIER2_NOTE.md` (this folder).

| ID | Hypothesis | Status | Evidence handle |
|---|---|---|---|
| R1 | Loaded fixture is exactly `P_95 ☐ K_4` | PASS_STATIC_TIER2 | `dm3-runner-reconstruction-2026-04-27/artifacts/phase_01_binary_re/PHASE2_GEOMETRY_RECONCILIATION_REPORT.md` |
| R2 | `RegionTags_v2.json` is degree-4-root BFS shelling | PASS_STATIC_TIER2 | `phase_01_binary_re/scripts/reconstruct_generate_tags_v3.py` plus zero JSON mismatches |
| R3 | Spectrum is closed-form `λ_k(P_95) + μ(K_4)` | PASS_STATIC_TIER2 | `phase_01_binary_re/scripts/spectral_closed_form.py`; Fiedler `0.001093485318147902`, λ_max `7.9989065146818525` |
| R4 | Internal generated surface is exactly `P_95 ☐ K_3` | PASS_STATIC_TIER2 | `phase_01_binary_re/scripts/reconstruct_internal_dual_meru.py`; 285 vertices, 567 edges |
| R5 | Loaded and internal share `P_95` product family | PASS_STATIC_TIER2 | `phase_01_binary_re/PRODUCT_FAMILY_RELATION_REPORT.md`; Betti(R1) = 567 = E(R4) |
| R6 | L-branch flow is file-loaded under `generate_tags_v2` and `run_spectral_analysis` | PASS_STATIC_TIER2_DYNAMIC_OPEN | `phase_01_binary_re/RUNTIME_SURFACE_FLOW_REPORT.md`; main → 0x19e440 / 0x19667c |
| R7 | Catalogue invariants match `P_95 ☐ K_4` | PASS_STATIC_TIER2 | `phase_03_catalogue_identity/GRAPH_IDENTITY_CARD.md`; `Aut = C_2 × S_4`, diameter 95, radius 48 |
| R8 | Android execution trace identifies the loaded fixture path at runtime | OPEN_TIER3_BLOCKED | requires post-Phase-G live trace of argv, `openat`, and output writes |

**Static authority regression gate:**
`dm3-runner-reconstruction-2026-04-27/artifacts/phase_03_catalogue_identity/scripts/run_static_authority_checks.py`
fails on drift in any of fixture identity, RegionTags, spectrum, internal
skeleton, product-family relation, automorphism order, diameter/radius,
Betti number, or cycle primitives.

**Kill criterion (R-class):** Any Tier-3 trace at chain-close (R8 work)
showing the binary's runtime adjacency, BFS shelling, or spectral
computation is not consistent with the parsed `P_95 ☐ K_4` fixture and
the `P_95 ☐ K_3` default skeleton; or any host-side recomputation that
breaks the static-authority regression gate.

**Scope guard:** R1–R7 do not claim that "DM3 has been reconstructed."
They claim the static graph identity of the fixture surface, the
static-disassembly identity of the L-branch flow, and the
host-recomputable invariants. R8 holds the line on runtime identity.

---

## Retired claims (killed or superseded)

- **"freq = 1.0 → 100% HIGH"** (Session 3, N=2) — KILLED in Session 4 at N=5 (freq = 1.0 gave 1/5 = 20%).
- **"rot = 120° preserves bistability"** (Session 3, N=2) — KILLED in Session 4 (rot = 120° gave 0/5 HIGH).
- **"truth sensor suppresses HIGH in harmonic"** (Session 3, N=2) — KILLED in Session 4 (default 2/5, strong 2/5). Note: the truth sensor DOES have a real effect inside `exp_k3_truth_sensor` — see IS_AND_IS_NOT.md, scope matters.
- **"transformer 3× HIGH bias"** (Session 3) — KILLED in Session 4 (HAM = LN = 20%).
- **"sharp asymmetry critical point"** (Session 3 suggestion) — KILLED in Session 4 Phase K (smooth position shift, no sharp critical point).
- **Claim γ** (Session 4 Phase L, C3-asymmetric coupling) — RETRACTED in Session 5 P2b as detailed above.
- **Claim σ** (Session 8 Phase A draft, coarse 30/40 peak) — REJECTED-BEFORE-PROMOTED by A5/A6 one-step sweep.
- **Claim σ′** (Session 8 A5 interim draft, bimodal s32/s41 reading) — REJECTED-BEFORE-PROMOTED by A6a/A6b one-step sweep.
