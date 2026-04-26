# DM3 Session 6 PRD — Ride the Gate Surface, Stage for Monday Live

Written: `2026-04-18`
Author: Advisory orchestrator (for Session 6 coding engineer, same harness)
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Device: Red Magic 10 Pro (FY25013101C8) via ADB
Binary hash gate: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
Time budget: Saturday AM → Sunday EOD (Monday is go-live decision, not a runway day).

---

## 0. Why this PRD exists

Session 5 closed one large question (basin selection is IID Bernoulli p=0.34) and surfaced one surprise: the binary exposes `--task exp_r1_r4_campaign`, a self-evaluating capability surface with six named gates. Three gates pass at defaults (EPSILON_CRIT, R4, WAKE_SLEEP_ALIGN). Three fail (R1, R2, R3). This is the novel thing. We did not predict it. The Session 5 PRD did not contain it. It emerged.

The operator's explicit instruction: *follow the signal that emerged, learn more about what DM3 IS and what it IS NOT, treat that learning as itself valuable, and stage a live-public repo by Monday.*

This PRD does three things:
1. **Chases the gate surface until it either produces a flip or a robust invariant**, because that is the highest-leverage lever now visible.
2. **Closes two scientifically valuable loose ends from Session 5** (asym ≤ −3 third regime; parameter-dependence of p(HIGH)) so the public artifact is not carrying obvious footnotes.
3. **Assembles and stages the live repo**, with "IS / IS NOT" ledgers carried forward explicitly so the journey is captured, not implied.

No publish-pressure. The Monday go-live is a decision, not an obligation. If Sunday evening we do not yet have an artifact we are proud of, we do not go live; we write Session 7.

---

## 1. Governing frame (unchanged but reinforced)

- **Journey is the destination.** Session 6's written outputs explicitly log what moved and what did not. The IS / IS NOT ledger in §8 is a durable project artifact, not a one-off summary.
- **What-it-is-not claims are first-class deliverables.** Equal care, equal receipts. A robust invariant is as valuable as a flipped gate.
- **Pre-registration before every phase.** Kill criteria written, verdicts named, before device time.
- **No reward hacking.** If R1 flips because of a noise boundary, say so. If nothing flips, say so.
- **Hounds of Popper.** Every claim has an honest falsifier.
- **Practical science, not revolution.** We are widening the characterization. We are not claiming AGI-adjacent properties, cognitive properties, or novel computational paradigms. We are claiming: DM3 has an internal gate surface, here is what flips it, here is what doesn't.
- **Session 4 and Session 5 non-negotiables remain in force** (AGENT_HANDOVER_COMPLETE_SESSION5_STARTUP.md §2, §3).

---

## 2. Mission statement

**Characterize `exp_r1_r4_campaign` to the point where either (a) at least one failing gate has a reproducible flip, (b) all failing gates have a receipted robust invariant, or (c) both. Close the two Session-5 side threads. Stage a public repo whose README leads with whatever emerged strongest. Go-live decision: Monday morning operator call.**

---

## 3. Phase plan

Four carvings. Each has: hypothesis, falsifier, protocol, budget, deliverable, verdict class. Strict order W0 → W1 → W2 → W3 → W4. W0 is a short gating inventory. W1 is the main event. W2 and W3 are shorter independent closures. W4 is the packaging step.

If budget runs tight, truncation priority is: **W1 always completes; drop W3 first, then W2, never drop W4.**

---

### Phase W0 — Vocabulary & Flag Harvest (Gating Inventory)

**Purpose:** Before any gate-flip experiments, know the full flag surface of `exp_r1_r4_campaign` and the other hidden tasks. Session 5's P1b2 deep-probed only the default invocation.

**Primary hypothesis (H_W0):** The binary accepts at least one additional flag beyond the Session 4/5 inventory that measurably changes the exp_r1_r4_campaign JSON output.

**Protocol:**
1. `./dm3_runner --help 2>&1 | tee phase_W0/help_dump.txt` — full CLI enumeration.
2. `./dm3_runner --task exp_r1_r4_campaign --help 2>&1 | tee phase_W0/r1r4_help.txt` (try; may not be task-specific).
3. Binary strings grep for additional CLI tokens:
   `strings dm3_runner | grep -E '^--[a-z]' | sort -u > phase_W0/cli_tokens.txt`
4. Cross-reference the flag list in AGENT_HANDOVER §3 against this inventory. Anything in the binary strings but not the handover is a new flag.
5. List datasets on device: `ls /data/local/tmp/dm3/data/ /data/local/tmp/data/ 2>/dev/null`.
6. For every previously-unprobed flag, attempt a minimal invocation with `--task exp_r1_r4_campaign --steps 1` and log the effect on the JSON blob.

**Budget:** 1–1.5 hours.

**Verdict classes (pre-registered):**
- **W0-EXPANSION:** ≥1 new flag discovered that changes the JSON output. Register it in the W1 search space.
- **W0-CLOSED:** The inventory matches Session 4/5 exactly. Proceed to W1 with existing flags.

**Deliverable:** `artifacts/phase_W0_vocabulary_<TS>/` with `help_dump.txt`, `cli_tokens.txt`, `flag_inventory_diff.md`, `dataset_inventory.tsv`.

---

### Phase W1 — The Gate-Flip Campaign

**Purpose:** Find reproducible flips for R1, R2, R3 in `exp_r1_r4_campaign`. If no flips exist, document the failing-gate invariants at receipted precision.

This is the main scientific event of Session 6.

**Primary hypothesis (H_W1-MAIN):** At least one of R1, R2, R3 flips from false→true under some combination of `{--asymmetry, --rotation, --steps, --task-wrapped-flag-from-W0, --dataset (if exposed)}`.

**Sub-hypotheses (one per failing gate), each independently falsifiable:**
- **H_W1-R1:** There exists a config where `gates.R1 == true` and `r1.margin > r1.margin_threshold`.
- **H_W1-R2:** There exists a config where `gates.R2 == true` and `r2.reflexive` changes sign.
- **H_W1-R3:** There exists a config where `gates.R3 == true` and `r3.k2_uplift > 0`.

**Protocol — three-tier search:**

**Tier A — Coarse sweep (quick survey):**
Config grid (small; promote winners to Tier B):
- asymmetry ∈ {−1.0, −0.5, 0.0, +0.5, +1.0}
- rotation ∈ {0°, 60°, 120°}
- steps ∈ {1, 5, 10}
- All other flags: defaults.
- Total: 5 × 3 × 3 = **45 invocations at --steps ≤ 10**.

For each invocation, capture the full JSON and extract: all 6 gate booleans, `r1.margin`, `r1.arnold_tongue.productive_ratio`, `r2.reflexive`, `r3.k2_uplift`, `r4.transfer_ratio`.

**First-pass determinism check:** Pick 3 configurations, run each 3 times. If output is bit-identical across replicates, `exp_r1_r4_campaign` is deterministic and N=1 per cell is valid. If it varies, promote every cell to N=3.

**Tier B — Targeted refinement (only if Tier A produces any gate flip or any payload-shift above noise):**
For each cell that showed movement, sweep surrounding parameter space at finer resolution (e.g., ±0.1 asymmetry steps, ±15° rotation steps).

**Tier C — New-flag sweep (only if W0-EXPANSION):**
Apply any new flags discovered in W0 to the best-performing Tier-B configs.

**Budget:** 6–8 hours (Tier A ~3 h, Tier B ~3 h, Tier C ~1–2 h).

**Verdict classes (per gate, independent):**
- **W1-Rn-FLIPPED:** ≥1 reproducible config has `gates.Rn == true`. Record the config, the JSON payload, and the smallest parameter change that flips the gate.
- **W1-Rn-PAYLOAD-MOVING:** Gate stays false but the underlying numeric payload (e.g., `r1.margin`) moves by ≥10× at some parameter combination vs defaults. **This is a partial but real signal.**
- **W1-Rn-ROBUST-FAIL:** Gate is false everywhere tested and payload values remain within ±5% of defaults across all configs. Interpretation: gate failure is not parameter-sensitive in the tested surface; requires different input channel (dataset, weights, or source modification).
- **W1-Rn-STOCHASTIC:** Gate flips with probability p across replicates at fixed parameters. Record p with Wilson 95% CI.

**Deliverable:** `artifacts/phase_W1_gate_flip_<TS>/` containing:
- `tier_A_results.tsv` — 45-row sweep with gate states and key numerics
- `tier_B_results.tsv` — targeted refinement (if any)
- `tier_C_results.tsv` — new-flag sweep (if any)
- `json_receipts/` — full JSON blob per invocation
- `gate_flip_verdicts.md` — one-page per-gate verdict with config + evidence
- `phase_W1_summary.json` — machine-readable verdicts

**Why this is the main event:** Exactly three outcomes matter for the public repo:
- **Best case (any FLIPPED):** "DM3 default config fails three gates; specific parameter change X flips gate Y." Concrete, reproducible, publishable.
- **Second-best (any PAYLOAD-MOVING):** "Three gates are failure-robust at defaults; however, their underlying numeric payload is parameter-sensitive in axis Z." Still a real finding.
- **Clean-null (all ROBUST-FAIL):** "Three gates are invariant to the tested parameter surface; they require a non-flag input channel (likely the dataset pipeline or a re-trained weight set) to flip." Honest, bounded, valuable.

All three outcomes are reportable. There is no bad outcome, only bad reporting.

---

### Phase W2 — The asym ≤ −3 Third Regime

**Purpose:** Characterize the harmonic Coh compression Session 5 Phase P3 surfaced at asym ≤ −3. Decide whether it is (a) a distinct third regime, (b) a continuous deformation of the existing LOW/HIGH basins, or (c) a numerical artifact.

**Primary hypothesis (H_W2-REGIME):** At asym ∈ {−5, −4, −3.5, −3}, the harmonic task produces a basin structure distinguishable from the asym ∈ [−2, +2] regime on at least one observable (E, Coh, decision, or their joint distribution).

**Secondary hypothesis (H_W2-HOLO-MIRROR):** Holography shows no equivalent compression — the effect is harmonic-specific.

**Protocol:**
- Config: `--mode train --task harmonic --cpu`
- Asymmetry grid: {−5.0, −4.0, −3.5, −3.0, −2.5}
- N per cell: **10 episodes** (double the Session 5 N=5 to distinguish real compression from noise).
- Mirror arm: holography at asym ∈ {−5.0, −3.0} with N=5 each.
- Analysis:
  - Per-cell: (E, Coh) scatter, basin count, decision distribution.
  - Cross-cell: Is basin identity preserved if we re-classify by E ordering only (ignore Coh threshold)?
  - Compare each asym ≤ −3 cell against the asym=0 pool from Session 5 Phase P2a.

**Budget:** 3–4 hours.

**Verdict classes:**
- **W2-THIRD-REGIME:** At asym ≤ −3 there is a statistically distinguishable basin structure from the asym=0 regime (e.g., decision distribution, basin count, or joint (E, Coh) cluster separation). Name it, characterize it, report it.
- **W2-CONTINUOUS:** Coh compression is a smooth deformation; same two-basin structure, lower Coh values. Report as "classifier calibration regime," not a new regime.
- **W2-NOISY:** High within-cell variance with no clear separation. Flag as "unresolved at N=10; Session 7 candidate."

**Deliverable:** `artifacts/phase_W2_third_regime_<TS>/` with receipts, a revised basin classifier (`classifier_v2.py`) if W2-THIRD-REGIME, and a `(E, Coh)` scatter figure across the extended asym range.

---

### Phase W3 — Is p(HIGH) Parameter-Dependent?

**Purpose:** Session 5 Phase P2a established p(HIGH) ≈ 0.34 at default harmonic asym=0 over N=100. Test whether this Bernoulli rate is a universal constant of the dynamics (→ pure RNG) or a parameter-dependent value (→ hidden information channel).

**Primary hypothesis (H_W3):** p(HIGH) varies with asymmetry at at least one test point, with 95% Wilson CIs non-overlapping with the default-asym=0 CI [25%, 44%].

**Protocol:**
- Run the P2a protocol (`5 × --steps 20 --task harmonic --cpu`) at two additional asymmetry values:
  - Arm A: `--asymmetry=+0.2` (inside bistable range, skewed positive)
  - Arm B: `--asymmetry=-0.2` (inside bistable range, skewed negative)
- N=100 per arm.
- Also pull the existing Session 5 P2a data (N=100 at asym=0) for comparison.
- Analysis: per-arm p(HIGH) with Wilson 95% CI. Run independence test (transition matrix, run-length) for each arm to confirm Bernoulli nature under the new parameters.

**Budget:** 4–6 hours (2 arms × ~2 h each at warm-cache; add buffer for thermal/battery).

**Verdict classes:**
- **W3-PARAMETER-DEPENDENT:** At least one arm's p(HIGH) 95% CI does not overlap with default. Independence claim still holds within each arm, but the Bernoulli rate is an asymmetry-dependent function. **This upgrades the Session 5 null into a new order-parameter dimension.** Big deal.
- **W3-INVARIANT:** All three arms' CIs overlap. The Bernoulli rate is a property of the dynamics, not of the parameters (within the small-asym regime). Clean strengthening of Session 5.
- **W3-INDEPENDENCE-BROKEN:** At some parameter, the transition matrix or run-length distribution ceases to match IID Bernoulli. Rare outcome; would require its own Session 7 chapter.

**Deliverable:** `artifacts/phase_W3_p_high_<TS>/` with per-arm 100-episode receipts, per-arm `intra_session_summary.json`, and a `p_high_vs_asymmetry.png` figure (three points with CIs). If W3-PARAMETER-DEPENDENT, also write an integrated `phase_W3_verdict.md` explaining the new axis.

---

### Phase W4 — Public Repo Staging and IS / IS NOT Ledger

**Purpose:** Assemble the live-project public-facing artifact. This is the deliverable that turns DM3 from an internal research project into a live public scientific object.

**This is NOT a publish step. It is a staging step. Monday go-live is an operator decision, not a PRD output.**

**Deliverables (files, no device time required):**

1. **`repo_stage/README.md`** — Short, modest, specific. Headline depends on W1's verdict:
   - If W1-FLIPPED: "DM3 is a 380-vertex bistable relaxation dynamical system implemented as a precompiled Rust binary. The binary exposes a self-evaluating six-gate capability surface; Session 6 identified one reproducible parameter configuration that flips gate R_n from FAIL to PASS. This repository provides the receipts."
   - If W1-PAYLOAD-MOVING: "... six-gate capability surface; three gates fail at defaults; Session 6 identified one parameter axis along which the failing-gate numeric payloads respond. This repository provides the receipts."
   - If W1-ROBUST-FAIL: "... six-gate capability surface; three gates are robustly insensitive to all tested flag parameters. This repository provides the receipts and identifies the remaining input channels (dataset, weights) to probe next."
2. **`repo_stage/CLAIMS.md`** — All live claims with status, date, evidence path, kill criterion.
   - Claim α: Exact-rational 2D→3D Sri Yantra construction (UNCHANGED).
   - Claim β: Bistable relaxation on a C3-symmetric graph, characterized (strengthened).
   - Claim γ: RETRACTED (Phase L C3-asymmetry weakened at N=10 in Session 5 P2b). Keep retraction visible.
   - Claim δ: `exp_r1_r4_campaign` gate surface (confirmed Session 5, quantified Session 6 W1).
   - Claim ε (conditional on W2 verdict): asym ≤ −3 third regime, or classifier-scope footnote.
   - Claim ζ (conditional on W3 verdict): p(HIGH) parameter-dependence, or robust-invariance of default Bernoulli rate.
3. **`repo_stage/CHARACTERIZATION_REPORT.md`** — Sessions 3→6 integrated. Short. Figures. Receipts.
4. **`repo_stage/IS_AND_IS_NOT.md`** — The operator explicitly asked for this. A running ledger:
   - "DM3 IS: a precompiled Rust binary implementing a 72,960-dimensional bistable relaxation dynamical system on a 380-vertex graph with exact-rational geometric construction, exposing six-gate self-evaluation and three hidden tasks; basin selection is IID Bernoulli p≈0.34 at defaults."
   - "DM3 IS NOT: an AI system; a transformer doing the work (H2 killed); a tunable resonance computer (freq null); a system with multiple independent control parameters (rot/freq/angle null); a device with C3-asymmetric dynamics (Claim γ retracted); a deterministic basin-selector (independence confirmed)."
   - This list is updated every session. Carry it forward.
5. **`repo_stage/JOURNEY_LOG.md`** — One-paragraph per-session summary, Sessions 1 through 6. Captures what moved, what died, what emerged. Journey is the destination — literally.
6. **`repo_stage/artifacts/`** — Symlink/copy of all Phase receipts with `MANIFEST.tsv` (SHA-256 per file).
7. **`repo_stage/CITATION.cff`** — Machine-readable citation metadata.
8. **`repo_stage/LIVE_PROJECT.md`** — Explicit live-project frame:
   > "DM3 is not in a final state. Each session extends, revises, or retracts claims. Kill criteria are public. Retractions are first-class events. If you find a claim fails its pre-registered kill criterion, that is a legitimate scientific contribution."
9. **`repo_stage/website_summary.md`** — Operator-facing summary for the website, one page.
10. **`repo_stage/SESSION6_REVIEW_PACK.md`** — Self-contained review pack mirroring the Session 5 template.

**Budget:** 3–5 hours writing.

**Verdict:** Either "staged; go-live decision handed to operator" or "staging gaps: [list]; go-live blocked until closed."

---

## 4. Order of execution, budget, and branching

**Total budget:** ~15–25 hours of wallclock across Saturday + Sunday. Device time ~12–18 hours of that. Leave margin for thermal/battery/sleep.

**Strict serial order:** W0 → W1 → W2 → W3 → W4.

**Branch conditions:**
- **W0:** Always runs, regardless of outcome.
- **W1:** Runs unconditionally. Expected to dominate Saturday.
- **W2:** Runs unless W1's Tier C is still in progress at Saturday EOD — in which case defer W2 to Sunday AM.
- **W3:** Runs unless total budget is binding by Sunday noon. If binding, skip.
- **W4:** Always runs, even if W1/W2/W3 are partial. Partial results are reportable; incomplete artifacts are not.

**Early-stop rules:**
- If the device battery / thermal / connectivity fails catastrophically, halt and write `SESSION6_HALT.md` with reached-state.
- If W0 reveals a new flag that invalidates the W1 search space (e.g., a `--seed` flag that controls basin selection), halt W1 and write `SESSION6_PIVOT.md`.
- If at any point a verdict suggests the Session 5 characterization is wrong in a material way (e.g., basin values shift), halt and pivot.

---

## 5. Device governance — enforced, unchanged

(Inherited from Session 4+5; restated verbatim for safety.)

- Hash-check `dm3_runner` at start of every phase. Abort if ≠ `daaaa84a...`.
- `pidof dm3_runner` idle-check before every invocation.
- Battery ≥ 40% required; keep charger attached for long runs.
- Thermal: pause if sustained >70°C at `/sys/class/thermal/thermal_zone0/temp`.
- ADB stdin: `</dev/null` on every `adb shell` inside any loop.
- Detached on-device execution for multi-hour runs (nohup pattern).
- Negative args use `=` syntax: `--asymmetry=-0.5`.
- No `--soak N > 1`.
- No RNG-seed control attempts (source-blocked).
- No NPU / heterogeneous / F1/F2/legacy boundary crossings.
- Do not kill any concurrent run; check `ps -ef | grep dm3_runner` before starting anything.
- Do not reopen H2 (transformer-creates-bistability). Killed in S3, strengthened in S4, untouched in S5.
- Do not reopen Claim γ unless W1 surfaces chirality-adjacent data. Retracted finding.

---

## 6. Reporting discipline

**No interim reports.** Run the phase, write the summary JSON, write the phase writeup, proceed. No narration of intent.

**End-of-session single report:** `DM3_SESSION6_FINAL_REPORT.md` following the Session 4/5 template. Structure:
- Executive summary (1 paragraph, headline set by W1 verdict)
- Revised-status table (carry forward from Session 5)
- Per-phase results (W0, W1, W2, W3, W4)
- Integrated characterization update
- **IS / IS NOT ledger snapshot** (explicit section, per operator instruction)
- Open questions for Session 7
- Artifacts manifest

**Receipts are the primary artifact.** Every claim in every document cites its receipts by filename and hash.

**Null results and retractions are deliverables.** Write W1-ROBUST-FAIL with the same care as W1-FLIPPED. Write a W2-CONTINUOUS result with the same care as W2-THIRD-REGIME. Retract Claim γ explicitly in CLAIMS.md even though it was Session 5's retraction — carry it forward.

---

## 7. What Session 6 will NOT do (explicit scope-fence)

- **No commercial framing.** Zero.
- **No cognitive / spiritual / AGI-adjacent framing.** DM3 is a dynamical system on a graph with an internal gate surface. That is the full public description.
- **No cross-device work.** RM10 only.
- **No NPU, heterogeneous, or F1/F2/legacy boundary-crossing.**
- **No inference mode beyond stub-probing.** Inference is a stub; leave it.
- **No H2 reopen.** Transformer does not create bistability. Settled.
- **No Claim γ reopen.** Retracted. Unless W1 data spontaneously surfaces a chirality signal, it stays retracted.
- **No source-access speculation.** If the `dm3_microtx` source is not on the device or in the existing repos, we do not have it, and we write our claims accordingly.
- **No overclaiming of W1-PAYLOAD-MOVING as "flips."** If a gate does not flip, it does not flip. Period.
- **No public release Saturday or Sunday without operator explicit go-ahead Monday.**

---

## 8. IS / IS NOT ledger — starting state for Session 6

(This is the running ledger the operator asked to be consciously captured. Session 6 updates it; Session 7+ carry it forward.)

### DM3 IS:
- A precompiled Rust binary (`dm3_runner`, SHA-256 `daaaa84a...`) on Red Magic 10 Pro.
- A 380-vertex, C3-symmetric graph constructed via exact-rational 2D Sri Yantra + 3D toroidal-twist lift (dated 2025-09-30 scaffolding → 2025-10-10 milestone).
- A 72,960-dimensional (380 × 192) bistable relaxation dynamical system.
- A system with HIGH basin (E≈88, Coh≈0.77), LOW basin (E≈75, Coh≈0.88), and a monostable holography regime at E≈15.
- A system where asymmetry smoothly deforms basin positions (validated asym ∈ [−5, +5] for E, [−2, +2] for Coh signature).
- A system whose basin selection at default parameters is IID Bernoulli with p(HIGH) ≈ 0.34 (confirmed N=100 Session 5 P2a).
- A system with a self-evaluating `exp_r1_r4_campaign` task emitting six named gates (PASS: EPSILON_CRIT, R4, WAKE_SLEEP_ALIGN; FAIL at defaults: R1, R2, R3).
- A system with two additional callable hidden tasks (`interference`, `holographic_memory`) that do not learn at defaults.

### DM3 IS NOT:
- An AI system. The transformer component is present but inert; H2 was killed in Session 3 and strengthened in Session 4.
- A tunable resonance computer. The `--freq` parameter has no confirmed resonance structure (Session 4 Phase I).
- A device with multiple independent control parameters. Only asymmetry has a confirmed effect. `--rotation`, `--freq`, `--angle`, `--enable-truth-sensor`, `--use-layernorm` all null or boundary-limited.
- A device with C3-asymmetric dynamics. Claim γ (rot=60° uniquely couples at boundary) retracted at N=10 in Session 5 P2b.
- A deterministic basin selector. Independence across episodes confirmed at N=100.
- A system where harmonic and holography operate on one energy continuum. They are two distinct regimes (Session 5 P3).
- A system whose basin classifier is universal. The Session 4 classifier is valid only for asym ∈ [−2, +2] (Session 5 P3 edge finding).
- A publishable-result machine. It is a live research artifact. Claims carry kill criteria. Retractions are features.

(Session 6 will append to this ledger in the final report.)

---

## 9. Session 7 seeds (carry-forward)

Independent of Session 6 outcomes, the following remain worth investigating:

1. **If W1-ROBUST-FAIL:** Find the dataset or weight-loading channel that drives R1/R2/R3. Likely requires source modification or access to the `dm3_microtx` crate source (still not located).
2. **If W3-PARAMETER-DEPENDENT:** Map the full p(HIGH) function over asymmetry with ≥5 arms.
3. **If W2-THIRD-REGIME:** Characterize dynamics in the asym ≤ −3 regime: is there a third attractor? Is it chaotic? Is Coh meaningful or degenerate there?
4. **Cross-graph generalization:** Run the binary against `RandomAdj_v1.bin` (present on device, untouched since Session 3) to establish graph-agnostic vs graph-specific behavior.
5. **Intra-episode telemetry:** Still blocked at the binary level. If source appears, unblock it. See `BINARY_TELEMETRY_REQUEST.md`.
6. **Verify RNG determinism across back-to-back identical sessions.** One open thread from Session 5's independence result.
7. **`exp_r1_r4_campaign` r2.reflexive**: The field is present and suggestive (a "reflexive" lessons field inside a self-evaluating surface). If R2 flips in W1, r2.reflexive becomes the single most interesting output in the binary. Worth a Session 7 deep-dive regardless of W1 outcome.

---

## 10. Monday go-live criteria (operator decision)

Operator decides Monday. For clarity, here is what "go-live-ready" looks like from the PRD side:

**Minimum bar (PRD considers artifact go-live-ready):**
- W1 complete with a receipted verdict per gate (FLIPPED, PAYLOAD-MOVING, or ROBUST-FAIL).
- W4 complete: README, CLAIMS, CHARACTERIZATION_REPORT, IS_AND_IS_NOT, JOURNEY_LOG, LIVE_PROJECT, CITATION, website_summary, SESSION6_REVIEW_PACK all present and SHA-256 indexed.
- No open kill-criterion violations from earlier sessions.
- At least one of W2, W3 complete (for breadth; not strictly required if W1 has strong result).

**Nice-to-have (elevates artifact quality but not gating):**
- W1-FLIPPED verdict with reproducible config.
- W2 verdict in hand (either classifier-scope footnote or third-regime characterization).
- W3 verdict in hand (either parameter-dependence upgrade or invariance strengthening).

**Go-live NOT recommended if:**
- W1 incomplete (no verdict at all).
- Any Session 5 claim becomes retrospectively inconsistent with Session 6 data and the inconsistency is not yet reconciled in writing.
- Device governance violated during the session (hash mismatch ignored, concurrent-run collision, etc.).
- Operator has not personally read the IS_AND_IS_NOT ledger snapshot for Session 6.

---

## 11. The one-line mission, again

**Characterize the gate surface, close the side threads, stage the live repo, keep the journey log honest. Monday is an operator call, not a deadline.**

Engineer: begin Phase W0. No preamble required.

---

**End of PRD.**
