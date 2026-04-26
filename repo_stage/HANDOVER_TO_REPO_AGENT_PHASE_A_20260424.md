# Handover to repo-agent — Session 8 Phase A close

Written: `2026-04-24` by the Session 8 engineer-agent.
For: the repo-agent keeping `repo_stage/` fresh and the front door inviting.
Supersedes: the pending-sync items from `HANDOVER_TO_REPO_AGENT_20260422.md` are closed by the Session 7 integration pass you already ran; this doc is additive on top of that pass.

---

## TL;DR

Session 8 Phase A is **closed**. Two Session-7 candidates (**ξ** determinism, **ο** sharp overfit cliff) are upgraded to CONFIRMED with 55 new receipts. Three new candidates enter the ledger — **π** (dataset-invariance), **ρ** (first Phase-A IS_NOT: `RA+v2+steps=20 → zero learning`), and **σ** (peak at steps=30/40, not steps=20). Session 7's Claim μ survives but its headline framing narrows — the peak is not where μ was anchored.

One governance deviation is in the record and should surface in the public ledger honestly rather than be hidden: **airplane mode flipped OFF for 40 of the 55 Phase-A receipts** (10h 32min window). The deviation accidentally produced a 40-run substrate-null replicate that supports existing Claims η and ι. No receipts are quarantined.

Please inspect, integrate, and flag anything that reads as overstated or unsupported. The engineer-agent's final report is at [`docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md`](../docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md).

---

## What's new since your Session 7 integration pass

### Claims to upgrade CANDIDATE → CONFIRMED

| Claim | One-line | Evidence path |
|---|---|---|
| **ξ** | `exp_k2_scars` is bit-deterministic at fixed config | 55 receipts across `A1_mu_replicate`, `A2_overfit_boundary`, `A3_cross_graph`, `A4_cross_dataset`, all within-equivalence-class identical |
| **ο** | Overfit cliff between `--steps 45` (1.333) and `--steps 50` (0.000) is sharp-and-discrete | `A2_overfit_boundary/*_s45_r{1,2,3}.log` + `*_s50_r{1,2,3}.log` |

### New CANDIDATE claims

| Claim | One-line | Evidence path | Kill criterion |
|---|---|---|---|
| **π** | `exp_k2_scars` at steps=20/SY_v1/v1_tags is dataset-invariant across xnor_train, xnor_mini, xnor_test | `A4_cross_dataset/*.log` (9 runs × 1.324074) | A future dataset (non-xnor or adversarial) returning a different `best_uplift` at this config |
| **ρ** (IS_NOT) | `exp_k2_scars` at steps=20 with `RA + v2_tags` produces `best_uplift = 0.000` | `A3_cross_graph/A3_cross_graph_RA_v2_r{1,2,3}.log` | A future replicate at the same config returning `best_uplift ≥ 0.05` |
| **σ** | Peak `best_uplift` is at `--steps 30` (1.644) and `--steps 40` (1.642), not at `--steps 20` (1.324) | `A2_overfit_boundary/*.log` across 7 step values | A finer sweep (steps=28,30,32,38,40,42) showing the peak elsewhere, or no bimodal structure |

### Claim scope tightening (not a kill)

**Claim μ (Session 7)** — "exp_k2_scars LEARNS-STRONG at `--steps 20`". Survives. But A.2 showed steps=20 is a **shoulder**, not the peak. Peak is at steps=30/40.

**Recommended revision in `CLAIMS.md`**: retain Session 7's original μ wording verbatim (governance: retractions/weakenings remain visible), then append a Session 8 refinement block:

> *Session 8 Phase A refinement (2026-04-23): Claim μ's anchor point (`--steps 20`) is a shoulder on a bimodal curve. Peak `best_uplift` is at `--steps 30` (1.644524) and `--steps 40` (1.642128). The `--steps 20` measurement is bit-identical to Session 7's (1.324074) and robustly replicated (N=10 A.1 + N=3 A.2 + N=3 A.3 SY_v1 + N=9 A.4 = 25 receipts at this config, all 1.324074), so μ's claim of positive learning at `--steps 20` remains valid — only its framing as "the learning peak" is now known to be under-probed.*

---

## Artifact trees to mirror

All of these live under `artifacts/phase_S8_P0_learning_20260422T213500Z/`:

| Cell | Device path | Run count | Summary SHA |
|---|---|---|---|
| `A1_mu_replicate` | `/data/local/tmp/dm3_harness/cells/A1_mu_replicate/` | 10 | `be8e87e494f71250093a7e7f5f71be280d1b3d865dc657d44540137eed46dac0` |
| `A2_overfit_boundary` | `/data/local/tmp/dm3_harness/cells/A2_overfit_boundary/` | 22 | `3b513c8f2d3eba6bebf61d67a41c1c174f17186a3d0dc6794ddbe527a8451458` |
| `A3_cross_graph` | `/data/local/tmp/dm3_harness/cells/A3_cross_graph/` | 13 | `1100f4707ccd86fd9080ee92f965434e359e4251c43cf9ed64cafe2ed7707cf5` |
| `A4_cross_dataset` | `/data/local/tmp/dm3_harness/cells/A4_cross_dataset/` | 10 | `164d300347b8bc8b58a2066879200093a5968c199e077d01617db5123fd3ab54` |

Per-run schema same as Session 7 (receipt JSON + empty-hash `.bin` + raw/canonical SHA + receipt SHA + stdout `.log`).

**Host-side pull pending.** Engineer-agent will run the pull script before Phase B opens; once landed, `MANIFEST.tsv` will need ~220 new entries (55 runs × 4 per-run files + summaries + progress).

---

## What the engineer-agent recommends you do

1. **Upgrade Claims ξ and ο from CANDIDATE to CONFIRMED** in `repo_stage/CLAIMS.md`. Both have ≥ 55 replicates of evidence (ξ) and triplicate receipts on each side of the cliff (ο).

2. **Add new CANDIDATE entries for π, ρ, σ** with the kill criteria verbatim from the table above.

3. **Append the Session 8 μ refinement block** to the existing μ entry. Do not overwrite the Session 7 wording.

4. **Update `IS_AND_IS_NOT.md`**:
   - DM3 IS: *"a system where `exp_k2_scars` is dataset-invariant at the μ baseline config"*
   - DM3 IS: *"a system where `exp_k2_scars` has a non-trivial steps response curve with bimodal peak at 30/40 and sharp cliff at 50"*
   - DM3 IS: *"a system where both adjacency topology and region-tag partition affect learning"*
   - DM3 IS NOT: *"a system where `exp_k2_scars` learns under `RA + v2_tags + --steps 20`"* (first Phase-A IS_NOT)
   - DM3 IS NOT: *"a system where peak `best_uplift` is at `--steps 20`"* (Session 7 μ under-probed)

5. **Refresh `README.md` and `website_summary.md`** with the Phase A story. Suggested headline:
   > *Session 8 Phase A closed: 55 new receipts across four cells characterize `exp_k2_scars`'s response curve end-to-end. Determinism is bit-identical at fixed config (Claim ξ CONFIRMED). The overfit cliff at `--steps 50` is sharp, not gradual (Claim ο CONFIRMED). Cross-graph + cross-dataset sweeps reveal the first Phase-A IS_NOT: `RA + v2_tags + --steps 20` gives zero learning (Claim ρ CANDIDATE). Full 2×2 cross-graph and cross-dataset tables receipted.*

6. **Update `JOURNEY_LOG.md`** with a Session 8 Phase A paragraph. Note the 23h 40min wall-clock and the thermal-gate patch mid-chain.

7. **Update `LIVE_PROJECT.md`** status block: Session 8 Phase A ✓; Phases B-F pending operator sign-off on the three rejig questions in the engineer-agent final report §9.

---

## What NOT to do

- **Do not hide the airplane-off deviation.** It's in every affected receipt's `env_pre`. The repo-facing account should be honest: 40 of the 55 Phase-A receipts were captured with airplane=OFF, wifi+BT+5G ON, battery Fast-charging. The accidental substrate-null replicate is valuable. If it ever becomes a problem, the honest public record protects the project; sanitizing it wouldn't.
- **Do not roll Claim π into a broader "dataset-invariant" narrative.** π is strictly scoped to `exp_k2_scars` at `--steps 20 / SY_v1 / v1_tags` across three xnor datasets. Other tasks and other configs are untested.
- **Do not present the RA+v2 kill (ρ) as a ceiling or capability limit.** ρ is strictly scoped to `steps=20`. At steps=30–45 the RA+v2 cell is untested. This is a direct question Phase C will address.
- **Do not promote σ (peak at 30/40) to CONFIRMED** until the finer sweep lands. The N=3 per step value is robust for bit-determinism but thin for curve shape.
- **Do not let the commercial framing cross the `repo_stage/` boundary.** Session 8 is operator-mandated scientific-learning frame only; commercial prospectus stays in the operator-only dir.
- **Do not claim Phase A is "Session 8 complete."** Phases B–F are still to run. Phase A is A of 6.

---

## Scope fences remain intact

- Binary hash gate `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672` held on every one of 55 Phase-A receipts
- No NPU / Hexagon / Adreno DM3 offload (still ABSTAIN)
- No parallel `dm3_runner` during any A-cell
- No reopening killed Session-3/5 claims (H2, γ)
- No source modification
- Sri Yantra geometry unchanged (adjacency sovereign)
- No binary substitution (hash verified at chain open and at every cell boundary)
- S9 freq-locked remains gated on root; still not runnable

---

## Sync seams to watch during your pass

1. **exp_k2_scars .bin files are empty-hash by design.** Same as S10 truth-sensor in Session 7. The task writes KPIs to stdout, not to `-o <path>`. All 55 `.bin.sha` files are `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` (SHA of empty content). That's correct behavior, not data loss. Science is in the `.log` files.

2. **Cell summary `verdict=PASS` is decorative for Phase A cells.** `unique_output_sha256_canonical = 1` across all 55 runs because all canonical SHAs are the empty-hash. This is trivially true, not a real determinism verdict. Real determinism is in the per-run `best_uplift` lines tracked in the final report §3. The Session 7 note on this limitation (in `HANDOVER_TO_REPO_AGENT_20260422.md` §"Sync seams" item 5) applies unchanged.

3. **A.2 has 22 runs, not 21.** Original plan was 21 (7 steps × 3 replicates). The resume chain's boundary logic re-emitted one `s30_r2` entry during the thermal-patch recovery. The extra receipt is bit-identical to its twin (both 1.644524). Not a data quality issue — a resume-chain bookkeeping artifact. The `unique_receipt_sha256 = 21` in the summary is correct (21 distinct receipt JSONs from 22 run invocations).

4. **A.2 had a thermal-halt incident.** Original chain ran 00:02–02:39 UTC, halted at s30_r2 when the PMIC sensor stuck at 71 °C for 2 hours while CPUs were cool. Thermal-gate patch narrowed the sensor filter. Chain resumed at 09:33 UTC. Time gap is documented in the final report §2 and §7. No data loss.

5. **Airplane mode flipped OFF between s40_r1 and s40_r2**. Documented in §6 of the final report. Every affected receipt (40 runs) honestly captures `"airplane_mode": false` in `env_pre`. Please do not sanitize.

---

## Three questions for the repo-agent to pose back

If anything reads as overstated or unsupported, flag it. Three specific things to scrutinize:

1. **Is Claim σ (peak at steps=30/40) tight enough to enter the public ledger as a CANDIDATE?** Seven step values at N=3 is strong for determinism but thin for curve shape. Would you prefer I mark σ as "preliminary observation pending Phase A.5 finer sweep" rather than CANDIDATE?

2. **Should the RA+v2 kill (ρ) be reported as an IS_NOT in the IS_AND_IS_NOT.md ledger immediately, or wait for cross-step confirmation?** The N=3 at steps=20 is solid, but if RA+v2 learns at steps=30 the IS_NOT would need a scope qualifier.

3. **Is the airplane-off deviation worth surfacing in `README.md` / `website_summary.md`** or should it live only in the final report + `IS_AND_IS_NOT.md`'s governance subsection? The engineer-agent leans toward full surfacing (project governance is part of the story, not a footnote), but deferring to repo-agent judgment on the public framing.

Treat these as invitations to push back rather than ratify.

---

## Final note

Phase A took ~23h 40min wall-clock to close. It produced the cleanest single-task characterization curve in the project's history (7 steps × 3 replicates, bit-identical within each step, bimodal peak resolved, sharp cliff documented, cross-graph 2×2 table complete, cross-dataset invariance receipted). The single IS_NOT finding (ρ) is the first in Phase A and complements the Session-7 substrate-null story by showing that *some* configs genuinely do not learn — the determinism is not a null effect.

Five Phase-A questions remain open for Phases B–F. Phase B opens on operator sign-off.

Thank you for keeping the door fresh.

—— Session 8 engineer-agent, 2026-04-24

---

## ADDENDUM — Orchestrator decisions 2026-04-24

After the engineer-agent's first draft of this handover, the orchestrator (via operator) returned three decisions and two additions. Recording here so your integration pass uses the authoritative ledger state.

### Decisions (overrides the "CANDIDATE" wording earlier in this doc)

| Claim | Final status (after orchestrator sign-off) | Notes |
|---|---|---|
| **ξ** | **CONFIRMED** (approved) | Upgrade from CANDIDATE. N ≥ 55 receipts evidence unchanged. |
| **ο** | **CONFIRMED** (approved) | Upgrade from CANDIDATE. Sharp cliff A.2 s45→s50 unchanged. |
| **π** | **CANDIDATE** (approved, strict scope) | "Strictly `exp_k2_scars` for now. Do not extend to harmonic by inference. B.3 will empirically resolve whether harmonic inherits dataset-invariance." |
| **ρ** | **CANDIDATE** (approved, IS_NOT) | First Phase-A IS_NOT finding stands as written. Kill criterion unchanged. |
| **σ** | **CANDIDATE — HELD pending A.5** | Operator authorized A.5 peak-finder (see below). Do not promote σ to CONFIRMED until A.5 cell closes. |

### A.5 peak-finder sub-phase (inserted before Phase B)

Operator-approved at orchestrator's recommendation: A.5 sweeps `--steps ∈ {28, 29, 30, 31, 32, 38, 39, 40, 41, 42}` at A.1 baseline config, N=3 each, 30 runs total. Device-budget nominally 2 h but may run longer. Resolves whether σ's bimodal peak shape is real or a 5-step-grid artifact. When A.5 closes, σ upgrades (if bimodal confirmed) or σ-supersedes (if new finding).

### AGD-H1 cross-platform determinism — promoted to Tier S parallel workstream

Operator-addition 2026-04-24: **The five bit-identical output values from Phase A**
- `1.324074` at steps=20
- `1.644524` at steps=30
- `1.642128` at steps=40
- `1.332733` at steps=45
- `0.000000` at steps=50

**form a determinism vector that can be tested on any ARM substrate.** Zero RM10 device-time required. This is a parallel workstream; operator will identify target device (Apple Silicon Mac, RPi5, Android other-than-RM10). Highest-leverage cheap result in the backlog.

Repo-agent: when content for this ledger update lands, please add a note that AGD-H1 has been promoted from Tier 4 ("needs second device") to active Tier S parallel workstream.

### Engineering IS-NOT #001: PMIC-thermal-mass-lag

Operator directive: *"promote to first-class engineering IS-NOT finding. Write it up as a self-contained engineering note alongside the scientific claims."*

**New doc to mirror into repo_stage/CHARACTERIZATION_REPORT.md or `repo_stage/` equivalent**:
[`docs/restart/DM3_ENGINEERING_NOTE_PMIC_THERMAL_WATCHDOG_20260424.md`](../docs/restart/DM3_ENGINEERING_NOTE_PMIC_THERMAL_WATCHDOG_20260424.md)

Summary for the public-facing ledger:
> **DM3 Engineering IS-NOT #001**: Smartphone thermal watchdogs that max-over-all-zones false-trigger due to PMIC thermal-mass lag (hours of inertia). Correct pattern: filter thermal sensors by compute-domain type (`cpu-*`, `cpuss-*`, `gpuss-*` on Snapdragon). Evidence: Phase A.2 chain halted 64 min before the patch landed; resume ran clean under the filtered gate.

### Scope fence renewal

Operator held ordering: **no PRD reorder authorized**. Phase B proceeds in the mandated order. C.2 tag sweep stays AFTER B.3 CLI audit (B.3 screens which tasks are actually responsive; C.2 only makes sense on responsive tasks).

The "scientifically novel Phase A observation" per orchestrator: **the 2×2 RA+v2 finding — gate surface synergistic enhancement (Session 7 θ) + learning surface synergistic destruction (Phase A ρ) on the same axes.** Flag for Phase C attention.

### Governance closure

- Airplane mode: **restored to ON before A.5/B.3 chain launch** (engineer-agent verified at 02:48 SAST via `settings put global airplane_mode_on 1`)
- Summary-script caveat (empty-hash for exp_k2_scars cells) has been matched into Phase B scripts for all KPI-stdout tasks by reusing the same `summarize_cell.sh` + same per-run `.log` discipline

—— Session 8 engineer-agent, 2026-04-24
