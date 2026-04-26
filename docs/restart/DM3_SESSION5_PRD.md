# DM3 Session 5 PRD — Push to Novel, Stage for Live

Written: `2026-04-17`
Author: Advisory orchestrator (for Session 5 coding engineer)
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Device: Red Magic 10 Pro (FY25013101C8) via ADB
Binary hash gate: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`

---

## 0. Governing frame

This PRD is written for a live R&D lab, not for a publication sprint. The operating stance is:

- **Journey is the destination.** Every artifact produced this session feeds a live repo and website that will continue to evolve. Nothing here is "final."
- **Practical science, not a revolution.** Aim: advance the characterization to a point where it is *novel and of real scientific interest*, then stage for public disclosure. Do not stop when we first have "something to talk about."
- **Intersectional / interscience.** DM3 sits at the intersection of exact geometric construction, bistable dynamical systems, graph theory, and on-device computation. Session 5 extends the characterization without committing to any single disciplinary framing.
- **Hounds of Popper.** Every claim in this PRD has a pre-registered kill criterion. Apply them honestly. Null results and kills are deliverables with equal status to confirmations.
- **No reward hacking.** If a phase verdict is "this is boring and finished," write it that way and move on.
- **No publish pressure.** We release when the artifact is real, not when it's polishable.

All Session 4 non-negotiables (AGENT_HANDOVER_COMPLETE_SESSION5_STARTUP.md §2) remain in force.

---

## 1. Objectives

By the end of Session 5, we want the following state:

1. **Basin-selection question advanced.** Either the RNG-dominated story is sharpened (with a negative-correlation ledger across ≥50 consecutive episodes under controlled conditions), or a latent signature is found. Either outcome is a real deliverable.
2. **Claim γ (broken-C3 rotation anomaly) decided.** Either killed at a fine grid with n≥10 per cell, or promoted to a first-class finding with an explicit chirality characterization.
3. **Hidden task surface mapped.** The five hidden task strings found in Phase N binary scan are probed for callability and receipt schema. Non-callable ones retired. Callable ones characterized at minimal N.
4. **Micro-battery methodology validated or rejected** as an experimental tool. If validated, Session 5 and onward use it to extend reach at fixed device budget.
5. **Bifurcation diagram for asymmetry produced.** The one confirmed order parameter deserves a clean diagram. This becomes the signature figure of the characterization.
6. **Holography-harmonic E-scale relationship probed.** Continuous or discrete? A single answer.
7. **Live repo staged.** A public-facing repo layout, README, disclosure scaffold, CITATION.cff, and a website-ready summary are assembled. Staging, not pushing — go-live decision remains the operator's call.

None of these are "the final answer." Each one moves the characterization forward by one honest step.

---

## 2. The micro-battery premise (explicit, because it changes the method)

**Operator's hypothesis:**
> With geometric determinism, the shape of a run is consistent. Starting conditions are the prevailing conditions. The run that is best at the end is best at the beginning. Once a baseline exists, micro-batteries (fewer or shorter episodes) can substitute for full runs.

**Status in Session 5:** This is currently an **unverified methodological conjecture** in DM3. The binary emits no per-step telemetry (Phase N confirmed), so we cannot directly observe "best at the beginning." We must test the conjecture indirectly before depending on it.

**Operational translation:** A run is parameterized by `--steps N`. If the episode outcome distribution at steps=1 matches the distribution at steps=5 within noise, then "the shape is set early" has empirical support *at the level of episode-outcome statistics*, even without per-step data. If the distributions diverge, micro-batteries are unsafe and we keep N=5.

**Phase O is the gate.** Every other Session-5 phase conditionally uses micro-batteries *only if Phase O validates them*.

---

## 3. Phase plan

Seven carvings. Each carving has: hypothesis, falsifier, protocol, budget, deliverable, and pre-registered verdict classes. Phase O runs first and gates the rest.

### Phase O — Micro-Battery Validation (Gate Phase)

**Purpose:** Decide whether micro-batteries are a valid research tool for DM3 before spending device budget on them.

**Primary hypothesis (H_O1):**
The basin-outcome distribution at `--steps 1` matches the distribution at `--steps 5` within ±15 percentage-point HIGH-rate at n=20.

**Secondary hypothesis (H_O2):**
Basin *values* (ΔE, Coh) within each basin are identical (to 3 sig figs) across step lengths.

**Protocol:**
- Config: `--mode train --task harmonic --cpu --asymmetry=0.0`
- Three arms:
  - A. `--steps 1` × 20 episodes (5 runs of 4 steps? No — run as 20 separate invocations of --steps 1, to keep episode independence and capture cold/warm variance.)
  - B. `--steps 2` × 20 episodes (same pattern)
  - C. `--steps 5` × 20 episodes (baseline, matches Session 4 N=5 × 4 reps)
- Randomize arm order across the session to avoid thermal/cache bias.

**Budget:** ~3 hours device time at the 60–195 s/episode envelope.

**Verdict classes (pre-registered):**
- **O-VALID:** `|HIGH_rate(A) − HIGH_rate(C)| ≤ 15 pp` AND basin values agree to 3 sig figs. Micro-batteries promoted. Subsequent phases may use steps=1 or steps=2.
- **O-PARTIAL:** steps=2 agrees but steps=1 does not. Promote steps=2 only.
- **O-INVALID:** Neither steps=1 nor steps=2 tracks steps=5 within envelope. Retire micro-batteries. All Session 5 phases run N=5.

**Deliverable:** `artifacts/phase_O_micro_battery_<TS>/` with raw JSONL + `phase_O_summary.json` carrying the verdict label.

**Secondary use:** If O-VALID or O-PARTIAL, Phase O doubles as the largest-N baseline ever taken on DM3 at asym=0 (n=60 if all arms pooled into "harmonic/asym=0/HAM-default"). That pooled number replaces the n=10 Session 3 and n=14 Session 4 baselines as the canonical reference for all future null-hypothesis tests.

---

### Phase P — Hidden Task Reconnaissance

**Purpose:** Probe whether the five hidden task names found in Session 4 Phase N (`InterferenceTask`, `holographic_memory`, `K1` pattern-ontology, `G2` boundary-readout, `exp_r1_r4_campaign`) are invokable via `--task` or another flag route. Settle which of them give receipts and which error out.

**Primary hypothesis (H_P1):** At least one hidden task name is directly callable via `--task <name>` and produces a receipt that differs measurably from harmonic or holography.

**Secondary hypothesis (H_P2):** Callable hidden tasks reveal at least one additional operating point (a fourth basin value cluster) distinct from HIGH, LOW, RETRY.

**Protocol:**
- Dry-probe each candidate name at `--steps 1` (or, if O-INVALID, `--steps 2`) × 1 episode to check return code and receipt validity.
  - Candidate list: `interference`, `holographic_memory`, `holo_memory`, `k1`, `k1_ontology`, `pattern_ontology`, `g2`, `g2_boundary`, `boundary_readout`, `r1_r4`, `eval_stats`.
  - Also probe `--help` / `--task help` / `--task ?` for an undocumented listing.
- For each that returns RC=0 with a valid 6-field (or richer) receipt, run n=5 at asym=0.0.
- For those that error, log the error string into a `task_not_callable.tsv` matrix.

**Budget:** 1.5 hours (probes are cheap; most cost is in the per-candidate cold-start).

**Verdict classes:**
- **P-OPEN:** ≥1 hidden task callable with valid receipt. Register each as a new lane; no further Session 5 characterization required beyond N=5.
- **P-CLOSED:** All hidden task names error out. Retire the set. Record exact error strings per candidate as evidence for binary-vocabulary audit.
- **P-MIXED:** Partial — some callable, some not. Tabulate.

**Deliverable:** `artifacts/phase_P_hidden_tasks_<TS>/` containing per-candidate receipts, `task_callable.tsv`, `task_not_callable.tsv`, and `phase_P_summary.json`.

---

### Phase Q — Broken-C3 Rotation Anomaly (Claim γ)

**Purpose:** Decide whether the Session 4 Phase L finding that `rot=60°` at `asym=+0.5` gives 3/5 HIGH while `rot=120°` gives 1/5 HIGH (an apparent C3-breaking coupling) survives at finer grid and larger N.

**Primary hypothesis (H_Q1):** At `asym=+0.5`, HIGH rate depends systematically on rotation with `rot=60°` peaking and `rot=120°` at baseline-or-below. If true, **C3 symmetry of the graph is broken by the dynamics** — a genuinely interesting finding.

**Secondary hypothesis (H_Q2, chirality):** If H_Q1 holds, the effect is chiral: `rot=+60°` (=60°) ≠ `rot=−60°` (=300°). If so, the symmetry is broken in a handed way pointing at the quaternion-rotor lift (t_half=1/3, from `lift_3d` construction docs).

**Protocol:**
- Config: `--mode train --task harmonic --cpu --asymmetry=+0.5`
- Grid (8 cells): `rotation ∈ {0, 30, 60, 90, 120, 150, 180, 300}` (300° = −60° for chirality test)
- N per cell: 10 full episodes (or 15 micro-battery steps=1 episodes if Phase O grants O-VALID)
- Randomize cell order.
- Mirror spot-check: single cell at `asym=−0.5, rot=60°` and `asym=−0.5, rot=120°` with n=5 each, to test whether the effect reverses under asymmetry sign.

**Budget:** 4–6 hours depending on micro-battery eligibility.

**Verdict classes:**
- **Q-γ-CONFIRMED-C3-SYMMETRIC:** `rot=60°`, `rot=120°`, `rot=180°`, `rot=240°`, `rot=300°` partition cleanly into the three C3-equivalence classes and within-class HIGH rates agree. That would **kill the C3-breaking claim** and reinstate symmetry.
- **Q-γ-CONFIRMED-NON-C3:** HIGH rate at `rot=60°` and `rot=300°` differs from HIGH rate at `rot=120°` by ≥20 pp with non-overlapping bootstrap 90% CIs. C3 is broken by the dynamics. Claim γ promoted.
- **Q-γ-CHIRAL:** `rot=60°` ≠ `rot=300°` at ≥20 pp separation. Chirality-breaking; highest-impact outcome, points toward the quaternion lift as the source.
- **Q-γ-NULL:** All rotations agree within ±15 pp at asym=+0.5. Session 4 L finding was boundary-noise. Claim γ killed.

**Deliverable:** `artifacts/phase_Q_c3_rotation_<TS>/` with rotation × replicate matrix, bootstrap CIs per cell, `phase_Q_summary.json`, and a plotted `rotation_vs_high_rate.png` figure. This figure is a candidate "money shot" if Q-γ-CHIRAL or Q-γ-CONFIRMED-NON-C3.

---

### Phase R — Basin-Selection Signature Probe

**Purpose:** Test whether the "RNG-dominated" basin selection is genuinely random or carries a latent signature we have not yet read.

**Primary hypothesis (H_R1):** Basin outcome in a given episode correlates with a measurable observable — device temperature, battery voltage, episode index within a run, duration_ms, or the outcome of the immediately preceding episode (Markov structure).

**Secondary hypothesis (H_R2):** Basin outcomes in consecutive episodes are temporally independent (null model).

**Protocol:**
- Config: `--mode train --task harmonic --cpu --asymmetry=0.0 --steps 5` (canonical). Also a twin under `--steps 1` if Phase O validates.
- Long run: **60 consecutive episodes** in a single invocation (`--steps 60` if the binary accepts it; otherwise 12 invocations of `--steps 5`) with interleaved observable capture:
  - Before each episode: `dumpsys battery | grep -E 'level|status|voltage|temperature'`
  - After each episode: thermal zone temperature
  - All timestamps captured
- Analyze:
  - HIGH/LOW autocorrelation at lags 1, 2, 3
  - HIGH rate vs battery temperature (split median)
  - HIGH rate vs duration_ms (cold vs warm)
  - HIGH rate vs episode index (beginning vs end of run)

**Budget:** ~4 hours of device time + 1 hour analysis.

**Verdict classes:**
- **R-RANDOM:** No correlation of basin outcome with any observable above p=0.05 / chance baseline. The "RNG-dominated" claim is strengthened. Write up as a clean null result.
- **R-SIGNATURE:** At least one observable carries a signature at effect size ≥0.3 (standardized) with consistent sign. Highest-impact outcome; reopens basin-selection question with a new handle.
- **R-AUTOCORRELATED:** Lag-1 autocorrelation ≥0.3 in HIGH/LOW sequence. Basins carry a short-range memory — also interesting, different implication.

**Deliverable:** `artifacts/phase_R_signature_<TS>/` with a 60-episode receipt + `observables.csv` + `phase_R_summary.json` + `autocorrelation.png` + `signature_scan.png`.

---

### Phase S — Asymmetry Bifurcation Diagram

**Purpose:** Produce the canonical bifurcation figure for the one confirmed order parameter. This becomes the signature figure of the DM3 characterization.

**Primary hypothesis (H_S1):** There is a well-defined critical asymmetry `|asym*|` at which bistability collapses. Below `|asym*|`: two basins coexist. Above: one basin dominates.

**Secondary hypothesis (H_S2):** The transition is continuous (second-order-like) in the basin HIGH-rate as a function of asymmetry.

**Protocol:**
- Config: `--mode train --task harmonic --cpu --steps 5` (or micro-battery if O-VALID)
- Fine grid on positive side: asym ∈ {0.0, 0.1, 0.2, 0.3, 0.4, 0.45, 0.5, 0.55, 0.6, 0.7, 0.85, 1.0}
- Mirror grid on negative side: asym ∈ {−0.1, −0.2, −0.3, −0.4, −0.45, −0.5, −0.55, −0.6, −0.7, −0.85, −1.0}
- N per point: 10 (full) or 20 (micro-battery)
- Total: 23 points × 10 = 230 episodes, or 23 × 20 = 460 with micro-batteries

**Budget:** 6–10 hours depending on micro-battery eligibility. If budget tight, drop mirror side to 6 points.

**Verdict classes:**
- **S-SHARP:** A clean step (HIGH rate transitions from ~40% to <5% within one grid step). Bifurcation is sharp — a critical point exists.
- **S-SMOOTH:** HIGH rate decays smoothly over a range (no step). Supports Session 4 Phase K "smooth deformation" finding at higher resolution.
- **S-ASYMMETRIC:** Positive and negative asymmetry transitions occur at different |asym*| values. Points at a hidden asymmetry in the construction.

**Deliverable:** `artifacts/phase_S_bifurcation_<TS>/` + `bifurcation_diagram.png` (publication-quality figure, both axes labeled, CIs shown, verdict annotated). This figure is a repo/website anchor.

---

### Phase T — Holography ↔ Harmonic E-Scale Path

**Purpose:** Decide whether there is a continuous path between the harmonic operating point (E≈75–89) and the holography operating point (E≈15), or whether they are disjoint sectors of the landscape.

**Primary hypothesis (H_T1):** Some CLI flag combination produces basin values in the gap region (E ∈ [20, 70]) currently unobserved. If so, the E-scale is continuous.

**Secondary hypothesis (H_T2):** No flag combination produces intermediate E. Harmonic and holography occupy two disjoint operating shells.

**Protocol:**
- Exhaustive CLI flag combination probe at n=2 (exploratory, then promote to n=5 anything that lands in the gap):
  - `--task {harmonic, holography} × --asymmetry ∈ {−1, −0.5, 0, +0.5, +1} × {with, without} --enable-truth-sensor × {with, without} --use-layernorm=false`
  - Plus any callable hidden tasks from Phase P.
- Additional probe: try the documented but un-swept `--gated` flag at asym=0 on both tasks.
- Plot: E distribution across all probe episodes. Look for gap-filling.

**Budget:** 3–4 hours (n=2 per cell, promote only the interesting ones).

**Verdict classes:**
- **T-CONTINUOUS:** At least one config places episodes in E ∈ [20, 70] gap region. Scale is continuous. The "one dynamical family" thesis is strengthened.
- **T-DISJOINT:** No config fills the gap across ≥60 episodes total. Scale is disjoint.
- **T-SCALING:** Ratio E_harmonic / E_holography is consistent and simple (e.g., exactly 5×) across asymmetry sweeps. Hints at an internal rescaling constant.

**Deliverable:** `artifacts/phase_T_escale_<TS>/` + `escale_spectrum.png` showing E distribution across all probed configs.

---

### Phase U — Repo / Website Live-Staging

**Purpose:** Consolidate Sessions 3+4+5 into a coherent public-facing package. This is the deliverable that turns DM3 from an internal artifact into a live scientific project.

**Not a "publish step."** This is a *staging* step. The operator decides when/whether to push public.

**Deliverables (files, not runs):**

1. `repo_stage/README.md` — One-paragraph description, no sacred-geometry oversell. Plain language:
   > "DM3 is a 72,960-dimensional bistable relaxation dynamical system on a 380-vertex C3-symmetric graph constructed from an exact rational-arithmetic 2D Sri Yantra plus 3D toroidal-twist lift. This repository contains the characterization artifacts (N≥5 experimental receipts, analysis code, figures) and the geometry construction artifacts. The project is live: findings are iterated as new experiments run."

2. `repo_stage/CLAIMS.md` — Three separable claims (α geometry, β dynamics, γ broken-C3 conditional on Phase Q verdict). Each with date, hash, evidence pointer, and kill criterion.

3. `repo_stage/CHARACTERIZATION_REPORT.md` — Sessions 3+4+5 integrated characterization. Structure:
   - What the object is (post-Session 5)
   - What is confirmed (N≥5 with receipts)
   - What is killed (with which receipts)
   - What is open (the honest frontier)
   - Methodology (incl. micro-battery verdict from Phase O)

4. `repo_stage/artifacts/` — Symlinks or copies of all phase JSONL receipts, summaries, and figures from Sessions 3–5. Include a `MANIFEST.tsv` with SHA-256 per file.

5. `repo_stage/CITATION.cff` — Machine-readable citation metadata.

6. `repo_stage/LIVE_PROJECT.md` — Explicit live-project framing:
   > "DM3 is not in a final state. No version here is the last word. New sessions extend, revise, or retract claims. Kill criteria are public. If you find that a claim fails a pre-registered kill criterion, that is a legitimate contribution."

7. `website_stage/index_summary.md` — One-page readable summary for the website.

8. `repo_stage/SESSION5_REVIEW_PACK.md` — Self-contained review pack for Session 5 (following the Session-3 pack template).

**Budget:** 3–4 hours (writing only, no device time).

**Verdict:** Either "staged and ready for operator go-live decision" or a list of unresolved gaps that block staging.

---

## 4. Order of execution and branching

Strict serial order: **O → P → Q → R → S → T → U**.

**Branch conditions:**
- After Phase O: all subsequent phases use or do not use micro-batteries based on verdict.
- After Phase P: if P-OPEN with ≥1 callable hidden task, insert a short Phase P.5 characterization (n=5 per new task) before Phase Q.
- After Phase Q: if Q-γ-NULL (anomaly killed), collapse Phase Q write-up into a short kill note and proceed. If Q-γ-CHIRAL, add a short follow-up on the quaternion-rotor chirality hypothesis.
- After Phase R: if R-SIGNATURE, add a short Phase R.5 with the identified observable under controlled sweep.
- Phases S, T, U always run as-is.

**Early-stopping:** If device battery/thermal or calendar time becomes binding, the priority order for completion is: O (required for method), Q (highest scientific interest per my advisory), R (highest strategic interest per operator), S (canonical figure), P (survey), T (probe), U (staging).

---

## 5. Device governance (from AGENT_HANDOVER_COMPLETE_SESSION5_STARTUP.md §3)

Enforced strictly. No deviations:

- Hash-check `dm3_runner` at start of every phase. Abort if ≠ `daaaa84a...`.
- `pidof dm3_runner` idle-check before every invocation.
- Battery: keep charging; if drops below 40%, pause.
- Thermal: monitor `/sys/class/thermal/thermal_zone0/temp`; pause if sustained >70°C.
- ADB stdin: `</dev/null` on every `adb shell` inside any loop.
- Detached execution for long runs: `nohup .../run_script.sh > /dev/null 2>&1 &` on device.
- Do NOT run `--soak N > 1` (Session 4 lesson).
- Do NOT try to control RNG seed (source-blocked).
- Do NOT touch NPU or heterogeneous lanes (ABSTAIN).
- Do NOT invoke inference mode as a live surface (stub).
- Do NOT kill an engineer's concurrent run. Check `ps -ef | grep dm3_runner` before starting anything.

---

## 6. Reporting discipline

**No interim reports.** No narration of what is "about to happen." Start Phase O, execute, write `phase_O_summary.json`, proceed.

**End-of-session report only:** `DM3_SESSION5_FINAL_REPORT.md` following the Session 4 final-report template. Structure:
- Executive summary (1 paragraph)
- Revised-status table (carrying forward Session 3+4 table)
- Per-phase results (O through U)
- Integrated characterization (what is the object after Session 5?)
- Open questions for Session 6
- Artifacts manifest

**Receipts are the primary artifact.** Every claim cites its JSONL file by name. Every figure cites the JSONL it was made from. Every kill cites the receipts that killed it.

**Null results are deliverables.** A phase that kills its own hypothesis produces the same documentation quality as a phase that confirms one. "Phase Q killed claim γ" is a first-class result if that is what the data says.

---

## 7. What this PRD deliberately does NOT include

- **No publication plan.** Publication decisions are downstream of Phase U staging and are the operator's call.
- **No commercial framing.** Utility claims (tunable bistable switch, physical RNG with structured output, etc.) are held back from all Session-5-produced documents until supporting data lands.
- **No new hypothesis about the transformer.** H2 is killed and strengthened. Do not reopen.
- **No sacred-geometry language as evidence.** The geometry construction earns Claim α as a mathematical artifact (exact rational arithmetic), not as a vocabulary claim.
- **No claims about DM3's cognitive, spiritual, metaphysical, or AI-adjacent properties.** It is a dynamical system on a graph. Describe it as such.
- **No cross-device comparison.** Red Magic 10 Pro only this session. Heterogeneous lanes ABSTAIN.

---

## 8. Session 6 seeds (explicit, because journey-is-destination)

Regardless of Session 5 outcomes, the following questions are seeds for Session 6 and beyond:

1. **Source access for `dm3_microtx`.** Still not found in any available repo. If located, A1 (transformer layer count), G1–G3 (weight loading), and per-step telemetry all become tractable.
2. **Mathematical explanation for the rot=60° / rot=120° asymmetry** (if Phase Q promotes it). Is it the quaternion rotor `t_half=1/3`? The sector asymmetry 48/47 in v2 tags? The 3-strand helix in the 8-sector frame? These are testable with targeted construction-code modifications — but that requires access to `yantra_2d`, `lift_3d`, `yantra_3d_dual` crates (which we have) to produce variants and test.
3. **Generalization across graph substrates.** Can the same binary be run against `RandomAdj_v1.bin` (already present on device, untouched) to establish a graph-agnostic vs graph-specific baseline? If DM3's behaviour is unique to this graph, that is itself the result.
4. **The 20% HIGH rate puzzle.** Why exactly 20% at asym=0 across Session 4? Is there a fundamental reason for this specific fraction, or is it an artifact of the initial-condition distribution in the RNG? Cross-check against a longer Phase R.
5. **Full spectral re-analysis under the v2 (RING/SECTOR) tagging.** Session 3's spectral work was all v1-tagged. The same graph under v2 coordinates may expose basin-boundary structure that v1 hid.
6. **Ontology of the "BINDU belt" under dynamics.** 147 vertices tagged BINDU in v1; 60 in v2 RING_9. Whether these play a preferred role during basin selection is unknown — and untestable without per-step telemetry. Session 6 item.

These are not promises. They are the honest frontier.

---

## 9. Kill the PRD if necessary

If, mid-session, the device develops a hardware issue, a battery problem, or the binary hash changes, halt Session 5 and write a short `SESSION5_HALT.md` describing what state was reached. Do not attempt heroics.

If, mid-session, a phase verdict suggests the entire characterization framework needs revision (e.g., a hidden task produces wildly different output than the 6-field receipt), halt the remaining phases and write a `SESSION5_PIVOT.md` proposing how to reframe. The operator reviews before Session 5 resumes.

This PRD is itself falsifiable. Its kill criterion is: "a finding in an earlier phase invalidates the assumptions of a later phase."

---

## 10. One-line mission

**Advance DM3 from a characterized curiosity to a characterized, novel, publicly stageable live research object — without overclaiming, without stopping early, and without losing the thread back to the next session.**

Engineer: begin Phase O. No preamble required.

---

**End of PRD.**
