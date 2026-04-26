# DM3 Session 7 PRD — The Learning Session

Written: `2026-04-18`
Author: Advisory orchestrator (for Session 7 engineering agent, same harness)
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Device: Red Magic 10 Pro (FY25013101C8) via ADB
Binary hash gate: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
Time budget: Saturday PM → Sunday EOD (Monday AM = operator go-live decision)

---

## 0. The mission in one sentence

**Prove or disprove, with pre-registered thresholds and receipted evidence, that at least one of DM3's hidden tasks exhibits real learning as a monotone function of an intervenable parameter.**

That is the binary commercial-gate question. A clean positive answer lifts the IP valuation from the "niche research artifact" tier (~$100K–$2M) into the "characterized alternative-computation primitive" tier (~$2M–$10M). A clean negative answer is still a first-class scientific deliverable and preserves the existing Session 6 artifact unchanged.

---

## 1. Why this session is different from W0-W4

Session 6 characterized the *structure* of DM3 (twelve tasks, six gates, two orthogonal tunability axes). Session 6 did **not** characterize *learning*. Specifically, Session 6 W0 surfaced three concrete learning signals that were observed but not probed:

- **`exp_k3_truth_sensor`** — at `sensor_strength=0.5`, final error drops from **89.26 → 22.32** (75% reduction) in a single invocation. Receipted in `phase_W0_task_probes/exp_k3_truth_sensor.log`. This is not subtle; it is a 4× error reduction that the binary self-logs.
- **`exp_k2_scars`** — at `lessons=3`, `best_uplift=0.01` and 1892 of 4560 edges changed. Receipted in `exp_k2_scars.log`. Small but nonzero signal; potentially scales.
- **`resonance_r3`** — after 10 training episodes on "Aum" between Om PRE and Om POST tests, `Delta dE = -0.0004` with the binary emitting `VERDICT: PLASTICITY CONFIRMED (State Changed)`. Self-certified plasticity; effect size ~0.03% at 10 training episodes. Potentially scales.

Session 6 did **not** scale any of these. This session does.

Session 6 also identified two hidden tasks with no-learning signatures at defaults (`exp_i1`, `exp_i2`, `exp_h1_h2` — constant energy ~2500.08 across phases). These may be defaults-only null or may be genuinely no-learn. Session 7 probes the dataset and parameter axes to distinguish.

Session 6 also identified one remaining failing gate (`exp_r1_r4_campaign.R3`) whose payload (`r3.k2_uplift`) moves 4× with `--steps 20` but does not cross the gate threshold. Session 7 pushes `--steps` further to test whether R3 can be flipped.

**This is not a broad survey. Every phase of Session 7 has one binary question and one pre-registered effect-size threshold.**

---

## 2. Governing rules

Inherits from Session 4/5/6 PRDs without exception. Reinforced for this session:

- **Per-task learning thresholds pre-registered below.** Do not change mid-run to chase a result. If a task misses its threshold, it misses.
- **No reward hacking.** A "VERDICT: PLASTICITY CONFIRMED" from the binary at Δ=0.0004 is NOT sufficient alone — the binary's own verdict is evidence but not proof. The threshold below applies.
- **Null results are deliverables.** If every task fails to clear its threshold, that is the Session 7 result and the repo ships with that verdict.
- **Commercial framing is prohibited in artifacts.** Phase writeups use scientific language only. Commercial implications live only in a single operator-facing document (§7) that is not part of the public repo.
- **All Session 4/5/6 retractions and scope boundaries stand.** No H2 reopen. No Claim γ reopen. No sacred-geometry as evidence.
- **All governance from Session 5/6 device sections applies verbatim** (hash gate, thermal ceiling, pidof check, ADB stdin, detached execution, no --soak, etc.).
- **Binary parallelization confirmed unproductive in Session 6.** Do not retest. Run serially.

---

## 3. Phase plan — six phases, one strict order

Phase order: **X0 → X1 → X2 → X3 → X4 → X5 → X6 → X7.** X6 is analysis. X7 is packaging. Each phase has one falsifiable hypothesis.

### Budget allocation

Total device-time budget for this session: **~18-22 hours wallclock.** Writing-only phases (X6, X7) add ~6 hours.

| Phase | Subject | Device hours (est.) | Priority |
|-------|---------|---------------------|----------|
| X0 | Learning baseline cartography | 2–3 | Required |
| X1 | `exp_k3_truth_sensor` deep characterization | 3–4 | **Highest commercial leverage** |
| X2 | `exp_r1_r4_campaign` R3 flip campaign | 3–4 | **Highest scientific leverage** |
| X3 | `exp_k2_scars` multi-lesson scaling | 3–4 | High |
| X4 | `resonance_r3` plasticity scaling | 2–3 | High |
| X5 | `exp_i1` / `exp_i2` / `exp_h1_h2` dataset probe | 2–3 | Medium |
| X6 | Cross-task synthesis + learning verdict table | 2 (writing) | Required |
| X7 | Repo update + commercial prospectus | 3–4 (writing) | Required |

**Truncation priority** (if budget binds): X1 and X2 always complete. Drop X5 first, then X4, then X3. Never drop X6 or X7. Partial coverage is reportable.

---

### Phase X0 — Learning Baseline Cartography

**Purpose:** Establish the exact-default measurements for every candidate learning task so the subsequent sweeps have a clean zero-point. Also confirm per-task determinism.

**Hypotheses (one per task):**
- **H_X0-K3:** `exp_k3_truth_sensor` default output is deterministic across ≥3 replicates.
- **H_X0-K2:** `exp_k2_scars` default output at `lessons=0,3` reproduces Session 6 baseline values within ±1%.
- **H_X0-R3:** `resonance_r3` default 10-episode output reproduces Session 6 Om PRE/POST values within ±1%.
- **H_X0-I1/I2/H:** `exp_i1`, `exp_i2`, `exp_h1_h2` emit constant energy across all default CSV rows (no-learn baseline confirmed).
- **H_X0-R1R4:** `exp_r1_r4_campaign` at default + `--steps 1` reproduces the SY canonical hash from Session 6.

**Protocol:**
- For each of the six tasks above, run **3 replicates at defaults** with stdout + log capture.
- For each stdout, extract the task's primary numeric KPI(s) and record in a per-task `baseline.tsv`.
- Compute determinism: byte-diff replicate 1 vs replicate 2 vs replicate 3 (ignoring `run_sec` / timestamps).

**Budget:** 2–3 hours.

**Verdict classes (per task):**
- **X0-BASELINE-CLEAN:** ≥3 deterministic replicates; baseline numbers logged. Task enters its specific phase (X1-X5) with a locked zero-point.
- **X0-BASELINE-NOISY:** Replicates disagree >1% on any KPI. Task's downstream phase uses pooled baseline at N=5 minimum.
- **X0-TASK-UNCALLABLE:** Task errors out unexpectedly. Record reason, remove task from downstream plan.

**Deliverable:** `artifacts/phase_X0_baselines_<TS>/` with per-task `baseline.tsv`, `determinism_check.txt`, and a `phase_X0_summary.json` indexing which tasks are cleared for downstream phases.

**Why X0 matters:** Session 6 assumed determinism from a single observation. At this stage we are pre-registering effect-size thresholds that depend on baseline precision. Three replicates is the minimum for a confidence interval.

---

### Phase X1 — `exp_k3_truth_sensor` Deep Characterization

**Purpose:** Characterize the 75% error reduction observed at defaults. Answer: is this a real monotone learning curve, a single-point lucky parameter, or a numerical artifact?

**Primary hypothesis (H_X1-LEARNS):** Error reduction in `exp_k3_truth_sensor` scales monotonically with `--truth-sensor-strength` and/or with `--dataset-size`. At the best-tested sweep point, error reduction ≥ 80% vs baseline (89.26).

**Falsification thresholds:**
- **X1-LEARNS-STRONG:** Monotone error reduction across ≥4 sensor-strength values with best-point error reduction ≥ 80%.
- **X1-LEARNS-PARTIAL:** Some sensor-strength values produce ≥50% reduction but the curve is non-monotone or plateaus below 80%.
- **X1-SATURATED:** Error reduction is essentially constant (≥50%) across all sensor-strength values — suggests the 75% reduction is an all-or-nothing effect, not a scaling law.
- **X1-NO-LEARN:** Replication fails to reproduce the Session 6 75% reduction at sensor_strength=0.5. This would invalidate Session 6's W0 finding.

**Protocol:**

**Tier X1.A — Sensor strength sweep (default dataset, default adj):**
- `--task exp_k3_truth_sensor --cpu` held constant.
- `--truth-sensor-strength ∈ {0.0, 0.1, 0.25, 0.5, 0.75, 1.0}` (6 points). Verify exact flag name from `help_dump.txt`; if different (likely `--sensor-strength` or internal T/S/C config), adapt.
- If no direct sensor-strength flag exists but the default sweep (T=0.1 / S=0.0,0.25,0.5) does all the work internally, instead capture the binary's internal sweep from the stdout and record the full 3-point curve per invocation.
- N per cell: 1 (determinism confirmed in X0).

**Tier X1.B — Dataset size effect:**
- At the X1.A best point (probably sensor_strength=0.5 or 1.0):
- `--dataset /data/local/tmp/dm3/data/xnor_train.jsonl` (default, 84 KB, already tested)
- `--dataset /data/local/tmp/dm3/data/xnor_mini.jsonl` (840 KB, 10×)
- `--dataset /data/local/tmp/dm3/data/xnor_test.jsonl` (1680 KB, 20×)
- Measure: final error, corrections triggered, boundary_gap, truth_gap at each.

**Tier X1.C — Graph sensitivity (optional if time):**
- At the X1.A best point:
- `--adj SriYantraAdj_v1.bin` (default) vs `--adj RandomAdj_v1.bin`.
- Test whether Truth Sensor effectiveness is graph-specific.

**Budget:** 3–4 hours.

**Deliverable:** `artifacts/phase_X1_truth_sensor_<TS>/` with:
- `tier_A_sensor_sweep.tsv` — sensor-strength × error curve
- `tier_B_dataset_sweep.tsv` — dataset-size × error curve
- `tier_C_graph_sweep.tsv` — adj × error (if run)
- `error_reduction_curve.png` — the signature figure
- `phase_X1_summary.json` with verdict class

**Commercial leverage (operator-facing, not public):**
A clean X1-LEARNS-STRONG verdict is the strongest single commercial finding Session 7 can produce. A 75%+ error reduction tied monotonically to a sensor-strength parameter is the kind of result that moves the IP from "interesting curiosity" to "characterized computation primitive with a learning law." This phase alone justifies the session.

---

### Phase X2 — `exp_r1_r4_campaign` R3 Gate Flip Campaign

**Purpose:** Session 6 observed `r3.k2_uplift` increases 4× from `--steps 1` to `--steps 20` (0.00704 → 0.0286), but R3 gate stays FAIL. Session 7 asks: does further `--steps` scaling, or combination with other gate-flipping axes (adj, tags, dataset), flip R3 to PASS?

A clean R3 flip gives DM3 a config where **all six gates pass simultaneously** — a reportable "DM3 can be tuned to a fully-passing regime" result with clear commercial optics.

**Primary hypothesis (H_X2-R3-FLIP):** There exists a `(--steps, --adj, --tags, --dataset, --truth-sensor-strength)` configuration where `exp_r1_r4_campaign.gates.R3 == true`.

**Falsification thresholds:**
- **X2-R3-FLIPPED:** Any config produces `gates.R3 == true`. Record the minimal parameter change.
- **X2-R3-PAYLOAD-SCALING:** `r3.k2_uplift` continues to grow monotonically with `--steps` through all tested values but never crosses threshold. Record the scaling law.
- **X2-R3-PAYLOAD-SATURATED:** `r3.k2_uplift` plateaus at some `--steps` value. Record the plateau.
- **X2-R3-ROBUST-FAIL:** Gate stays false, payload does not move measurably beyond Session 6's 4×. Hypothesis killed.

**Protocol:**

**Tier X2.A — Steps scaling (SY adjacency, default tags):**
- `--task exp_r1_r4_campaign --cpu` held constant.
- `--steps ∈ {20, 50, 100, 200, 500}` (5 points). 500 is a budget probe — expect ~1 hour per invocation at that depth; halt if thermal or timing makes it unviable.
- Measure: all 6 gates, `r3.k2_uplift`, and the full `r3.*` substructure per run.
- **Early-stop rule:** if `--steps 50` shows `gates.R3 == true`, lock the flip; do not run 100/200/500 in Tier A. Investigate replication in Tier B.

**Tier X2.B — Combined-axis flip probe (if A does not flip R3):**
- At the best Tier-A steps value, add axes:
- `--adj RandomAdj_v1.bin`
- `--tags RegionTags_v2.bin`
- `--dataset xnor_mini.jsonl`
- 2³ = 8 cells at one steps value. If the winner flips R3, good.

**Tier X2.C — All-gates-passing search (only if X2.B flips R3):**
- Verify the final config: does it retain R1 PASS (from RA adj) and R2 PASS (from tags v2) and R3 PASS (from this phase)?
- If yes: receipt as "all 6 gates PASS simultaneously" — a Session 7 headline.
- If no: the gate flips are mutually exclusive — also a reportable finding.

**Budget:** 3–4 hours.

**Deliverable:** `artifacts/phase_X2_r3_flip_<TS>/` with:
- `tier_A_steps_sweep.tsv` — steps × gate/payload
- `tier_B_axis_sweep.tsv` — combined axes (if run)
- `tier_C_all_gates_passing.json` — the all-6-passing receipt (if found)
- `phase_X2_summary.json` with verdict

**Commercial leverage:** A `tier_C_all_gates_passing` artifact is the second-strongest possible Session 7 outcome. "DM3 has a configuration where all six of its internal gates pass" is a cleaner sentence than any other possible Session 7 finding.

---

### Phase X3 — `exp_k2_scars` Multi-Lesson Scaling

**Purpose:** Session 6 observed `best_uplift=0.01` at `lessons=3`. Session 7 asks: does uplift scale with lessons?

**Primary hypothesis (H_X3-SCALES):** `best_uplift` grows monotonically with lesson count over at least one order of magnitude.

**Falsification thresholds:**
- **X3-LEARNS-STRONG:** At best lesson count, `best_uplift ≥ 0.05` (5× the Session 6 observation) AND curve is monotone over ≥4 points.
- **X3-LEARNS-PARTIAL:** Monotone but max uplift < 0.05.
- **X3-NO-SCALING:** Uplift is flat or non-monotone across lessons. Session 6 observation is not a learning curve.

**Protocol:**

**Tier X3.A — Lesson count sweep:**
- `--task exp_k2_scars --cpu` held constant.
- `--lessons ∈ {0, 3, 5, 10, 20, 50}` (6 points; 100 is a budget probe optional).
- Verify the exact flag. Session 6 results imply lessons is internally swept via a grid; may require `--dataset-size` or `--lesson-count` flag (check `help_dump.txt`). If internal-sweep-only, capture the full internal grid from the stdout.
- Measure per lesson-count: `max_scar_weight`, `best_uplift`, `avg_recall_err`, `changed_edges`.

**Tier X3.B — Noise sweep at best-uplift lesson count:**
- `--noise ∈ {0.0, 0.1, 0.2, 0.3, 0.5}` (5 points).
- Tests whether learning robustness degrades gracefully with noise.

**Budget:** 3–4 hours.

**Deliverable:** `artifacts/phase_X3_scars_<TS>/` with:
- `lesson_sweep.tsv`
- `noise_sweep.tsv`
- `uplift_learning_curve.png`
- `phase_X3_summary.json`

---

### Phase X4 — `resonance_r3` Plasticity Scaling

**Purpose:** Session 6 observed `Delta dE = -0.0004` after 10 Aum training episodes. Session 7 asks: does plasticity effect size scale with training episodes?

**Primary hypothesis (H_X4-SCALES):** `|Delta dE|` grows monotonically with training episode count.

**Falsification thresholds:**
- **X4-LEARNS-STRONG:** At best training-count, `|Delta dE| ≥ 0.01` (25× the Session 6 observation) AND curve is monotone over ≥3 points.
- **X4-LEARNS-PARTIAL:** Monotone but max |Delta dE| < 0.01.
- **X4-NO-SCALING:** Delta dE is flat or bounces — plasticity verdict is numerical drift, not learning.

**Protocol:**

**Tier X4.A — Training episode sweep:**
- `--task resonance_r3 --cpu` held constant.
- `--episodes` or `--steps ∈ {10, 50, 100, 500}` (4 points). Verify flag and internal dispatch.
- Measure per episode-count: Om PRE dE, Om POST dE, Delta dE, Coh stability.

**Tier X4.B — Training pattern variation (if time):**
- Default pattern is Aum. If other patterns are exposed (check `--patterns`, the single `PhonemePatterns_v1.bin`), try a second training pattern.
- Goal: determine whether plasticity magnitude depends on training-signal structure.

**Budget:** 2–3 hours.

**Deliverable:** `artifacts/phase_X4_plasticity_<TS>/` with:
- `episode_sweep.tsv`
- `plasticity_curve.png`
- `phase_X4_summary.json`

---

### Phase X5 — `exp_i1` / `exp_i2` / `exp_h1_h2` Dataset & Parameter Probe

**Purpose:** These three tasks emit constant-energy CSVs at defaults (Session 6 W0). Session 7 asks: is this a genuine no-learn property or a parameters-wrong problem?

**Primary hypothesis (H_X5-UNLOCK):** At least one of `exp_i1`, `exp_i2`, `exp_h1_h2` produces a non-constant energy trajectory under some combination of `--dataset`, `--dataset-size`, or `--patterns` variation.

**Falsification thresholds:**
- **X5-UNLOCKED:** At least one task produces energy variance >1% across phases/lessons under a non-default parameter.
- **X5-STILL-CONSTANT:** All three tasks emit constant energy under every tested variation. Ship the no-learn verdict with the dataset matrix as evidence.

**Protocol:**

**Tier X5.A — Dataset swap:**
- For each of the three tasks: run with each of the three available datasets (`xnor_train`, `xnor_mini`, `xnor_test`).
- 3 tasks × 3 datasets = 9 cells.
- Measure: energy trajectory across CSV rows. Any non-constant trajectory is an unlock signal.

**Tier X5.B — Dataset size sweep (if A produces any unlock):**
- For the unlocked task: vary `--dataset-size ∈ {10, 100, 1000}` on its most-learning dataset.

**Tier X5.C — Minimum-effort fallback:**
- If X5.A and X5.B produce no unlock, before closing the phase: try `--steps 50` on each task (more internal iterations may unlock energy movement).

**Budget:** 2–3 hours.

**Deliverable:** `artifacts/phase_X5_hidden_unlock_<TS>/` with:
- `dataset_sweep.tsv` (task × dataset × energy-variance)
- Per-task CSV samples showing any non-constant trajectories
- `phase_X5_summary.json`

---

### Phase X6 — Cross-Task Learning Verdict Synthesis

**Purpose:** Aggregate X1–X5 into a single-page per-task verdict table that is the artifact's center of gravity.

**No device time.** Writing phase only.

**Deliverables:**

1. `artifacts/phase_X6_synthesis_<TS>/LEARNING_VERDICT.md` — the master table:

```
| Task                 | Learning metric          | Baseline | Best     | Effect size | Verdict class    | Receipt          |
|----------------------|--------------------------|----------|----------|-------------|------------------|------------------|
| exp_k3_truth_sensor  | final_error reduction    | 89.26    | ?        | ?           | X1-?             | tier_A + B       |
| exp_r1_r4_campaign/R3| gates.R3 (bool)          | false    | ?        | flip/stay   | X2-?             | tier_A + B + C   |
| exp_k2_scars         | best_uplift              | 0.010    | ?        | ?           | X3-?             | lesson_sweep     |
| resonance_r3         | |Delta dE|               | 0.0004   | ?        | ?           | X4-?             | episode_sweep    |
| exp_i1               | energy variance          | 0.0      | ?        | ?           | X5-?             | dataset_sweep    |
| exp_i2               | energy variance          | 0.0      | ?        | ?           | X5-?             | dataset_sweep    |
| exp_h1_h2            | energy variance          | 0.0      | ?        | ?           | X5-?             | dataset_sweep    |
```

2. `artifacts/phase_X6_synthesis_<TS>/SESSION7_HEADLINE.md` — a 300-word paragraph stating the session's headline finding in scientific language, receipts-cited. This becomes the lead paragraph of the public README update.

3. `artifacts/phase_X6_synthesis_<TS>/phase_X6_summary.json` — machine-readable per-task verdicts.

**Budget:** 2 hours.

---

### Phase X7 — Repo Update + Commercial Prospectus

**Purpose:** Update the `repo_stage/` artifacts from Session 6 with Session 7 findings. Write the operator-only commercial prospectus.

**No device time.** Writing phase only.

**Public repo updates (go into `repo_stage/` and into the live-repo if operator greenlights Monday):**

1. **`repo_stage/CLAIMS.md` — add/revise:**
   - For any X1-LEARNS-STRONG: add Claim η (truth-sensor error reduction scales with sensor strength; effect size X%; receipt Y).
   - For any X2-R3-FLIPPED: add Claim θ (exp_r1_r4_campaign has a configuration where all 6 gates PASS; receipt Z).
   - For any X3-LEARNS-STRONG: add Claim ι (exp_k2_scars uplift scales monotonically with lessons; slope W).
   - For any X4-LEARNS-STRONG: add Claim κ (resonance_r3 plasticity effect size scales with training episodes).
   - For X5-UNLOCKED: add Claim λ (previously no-learn tasks produce learning signals under non-default dataset).
   - For all null verdicts: add "Session 7 falsification" entries with kill-criterion pointer.

2. **`repo_stage/IS_AND_IS_NOT.md` — append Session 7 section:**
   - New IS lines for any confirmed learning
   - Expanded IS-NOT lines for any confirmed no-learn

3. **`repo_stage/CHARACTERIZATION_REPORT.md` — add Session 7 chapter:**
   - "DM3 Learning Characterization" — one page per task with figure.

4. **`repo_stage/JOURNEY_LOG.md` — append one paragraph:** Session 7's binary question and its answer.

5. **`repo_stage/README.md` — rewrite the headline paragraph:**
   - If any strong learning verdict: headline is now *"DM3 is a self-certifying dynamical substrate exhibiting measurable learning curves on at least one task family..."*
   - If all-null: headline retains Session 6 language plus *"Session 7 tested whether hidden tasks exhibit scaled learning; all tested tasks produced null or below-threshold effect sizes. The substrate's learning surface, if it exists, lies outside the parameter space probed by CLI flags."*

6. **`repo_stage/MANIFEST.tsv` — regenerate SHA-256 manifest with Session 7 artifacts appended.**

7. **`repo_stage/website_summary.md` — one-page public summary refresh.**

**Operator-only commercial prospectus (NOT in public repo):**

**`/Users/Zer0pa/DM3/DM3_SESSION7_OPERATOR_PROSPECTUS.md`** — written outside `repo_stage/` so it does not accidentally ship. Contents:
- One paragraph: what Session 7 produced, in commercial language
- Revised valuation range estimate given Session 7 findings (per the ranges below)
- Buyer-pool implications: which outcomes address which buyer types
- Recommended next moves for the operator (go-live Monday vs wait vs add one more session)
- Specific next-48-hours action list if go-live is greenlighted

**Budget:** 3–4 hours writing.

**Deliverable gate:** `repo_stage/` and `DM3_SESSION6_REVIEW_PACK/` (renamed to SESSION7 if updates are substantial) consistent with all Session 7 findings. `MANIFEST.tsv` regenerated. `SESSION7_OPERATOR_PROSPECTUS.md` delivered separately.

---

## 4. Pre-registered effect-size thresholds (the honesty contract)

Quoted once, binding for the whole session:

| Task | "LEARNS" requires | "PARTIAL" range | "NO-LEARN" condition |
|------|-------------------|------------------|----------------------|
| `exp_k3_truth_sensor` | ≥80% error reduction AND monotone curve over ≥4 points | 50–80% or non-monotone | <50% or replication fails |
| `exp_r1_r4_campaign` R3 | `gates.R3 == true` in any tested config | payload scales monotonically but stays false | both gate and payload flat |
| `exp_k2_scars` | `best_uplift ≥ 0.05` AND monotone over ≥4 lesson counts | monotone but max < 0.05 | flat or non-monotone |
| `resonance_r3` | `|Delta dE| ≥ 0.01` AND monotone over ≥3 episode counts | monotone but max < 0.01 | flat or non-monotone |
| `exp_i1/i2/h1_h2` | energy variance >1% under any tested param | variance 0.1–1% | <0.1% in all cells |

These thresholds are quantitative, pre-registered, and not to be revised mid-session. If the data misses them, the verdict is "miss."

---

## 5. Device governance — unchanged

All Session 4/5/6 non-negotiables apply verbatim. Highlights worth repeating for Session 7 specifically:

- Hash gate at every phase start.
- `pidof dm3_runner` idle-check before each invocation. Never collide with a human engineer's parallel work.
- Thermal ceiling 70°C sustained; pause and wait if breached.
- Battery ≥40%; keep charger attached.
- ADB stdin: `</dev/null` on every loop invocation.
- Detached on-device execution for >30-minute phases.
- Negative args use `=` syntax.
- No `--soak N>1`.
- No parallel `dm3_runner` invocations (Session 6 confirmed unproductive; do not retest).
- No NPU / heterogeneous / F1-F2-legacy boundary crossings.
- Do not reopen H2 or Claim γ.

---

## 6. Reporting discipline

**No interim reports.** Phase-summary JSONs are written; phase-writeup MDs are written; proceed.

**End-of-session single report:** `DM3_SESSION7_FINAL_REPORT.md` following Session 4/5/6 template. Mandatory sections:
- Executive summary (1 paragraph, headline set by strongest X1-X5 verdict)
- Per-phase results (X0 through X7)
- Updated Session-3→Session-7 claims status table
- Updated IS / IS NOT ledger snapshot
- Commercial-implications section is **not** part of the session final report — it lives only in `SESSION7_OPERATOR_PROSPECTUS.md`
- Open questions for Session 8
- Artifacts manifest

**Receipts-first discipline:** Every numeric claim in every artifact cites the receipt file by filename and SHA-256.

---

## 7. Commercial implications ledger (operator-facing, NOT in public repo)

This section lives in this PRD so the engineering agent is aware of the commercial frame but is explicitly instructed not to reproduce this framing in any public artifact.

**Outcome-to-valuation-band mapping (for operator planning only):**

| Session 7 outcome shape | Approximate IP valuation band |
|-------------------------|-------------------------------|
| All verdicts NO-LEARN | $100K–$1M (unchanged from Session 6 artifact) |
| One task PARTIAL, others NO-LEARN | $500K–$2M (moderate uplift) |
| One task LEARNS-STRONG | $2M–$5M (the PRD's target band) |
| Two tasks LEARNS-STRONG | $3M–$8M |
| X2-R3-FLIPPED produces all-6-gates-passing config | Adds $1–3M premium to whatever else lands |
| Three+ tasks LEARNS-STRONG | $5M–$10M (ambitious target) |

The Monday go-live decision should be informed by which band the session lands in. Operator signals this to engineering agent by either greenlighting Monday publish or requesting a Session 8 holding-pattern.

**Buyer-pool implications by outcome:**
- **X1-LEARNS-STRONG on truth sensor** → defense integrators, edge-ML vendors
- **X2-R3-FLIPPED all-gates-passing** → alternative-computation research labs (DARPA, IARPA, foundation-model lab exploratory teams)
- **X3-LEARNS-STRONG on scars** → neuromorphic computing vendors (BrainChip, Intel Loihi team, IBM neuromorphic)
- **X4-LEARNS-STRONG on plasticity** → computational neuroscience collaborators (academic prestige buy + grant leverage)
- **All-null** → defensive disclosure only; no change to buyer pool from Session 6

---

## 8. Session 8 seeds (carry-forward regardless of outcome)

1. **Graph cross-product at wider scale.** Session 6 flagged this; still pending. With Session 7 learning data in hand, the cross-product gains meaning: which graphs support learning on which tasks.
2. **External replication request.** Once a strong learning verdict is in hand, publish a minimal invitation for independent replication. One replicator validates the IP dramatically.
3. **Source location for `dm3_microtx` crate.** Still unlocated across all known repos. If source appears, per-step telemetry and gate-internal structure become tractable.
4. **`--calibration` flag probe.** Session 6 noted this flag exists but no calibration file is on device. Authoring a calibration file by hand and probing its effect is a Session 8 candidate.
5. **Cross-device validation.** RM10 only throughout Sessions 1-7. A second Android device running the same binary would establish hardware-independence of the learning verdicts.

---

## 9. Halt and pivot conditions

If, mid-session:
- Device battery/thermal/connectivity fails → `SESSION7_HALT.md` with reached-state
- Binary hash changes → abort immediately; operator review required
- Any early phase (X0) reveals determinism assumption fails broadly (i.e., tasks are stochastic) → `SESSION7_PIVOT.md` proposing revised thresholds at higher N
- An X-phase produces a finding so anomalous it invalidates Session 6 characterization → halt remaining phases, write `SESSION7_SESSION6_INVALIDATED.md`, operator review

---

## 10. The one-line mission

**Characterize the learning surface; publish receipts; update the ledgers; hand the operator a single document that tells them whether the IP just became more valuable.** Engineer: begin X0. No preamble required.

---

**End of PRD.**
