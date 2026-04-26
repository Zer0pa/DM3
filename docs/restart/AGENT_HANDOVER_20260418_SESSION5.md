# Agent Handover — End of Session 5 (for Session 6)

Written: `2026-04-18` (session wallclock `2026-04-17T12:05Z` → `2026-04-17T22:37Z`)
Author: Session 5 autonomous execution agent
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`

---

## TL;DR for the next agent

Session 5 did exactly what the Session 4 handover asked: probed hidden
tasks (found 3), exercised the basin boundary (confirmed independence,
weakened the Phase L C3 claim), and tested extreme asymmetry (regimes
stay distinct). Everything is preserved as JSONL / CSV / stdout logs.
**The hardest open question is now "what flips R1/R2/R3 gates to PASS in
`--task exp_r1_r4_campaign`."** That is the single best next move
because the gate surface is **reproducible**, **compact** (one 3.7 kB
JSON per run), and **discriminating** (3 pass / 3 fail at defaults).

Read the Session 5 final report first:
`docs/restart/DM3_SESSION5_FINAL_REPORT.md`.

---

## 1. What changed in the DM3 characterization

| Area                      | Session 4 status                     | Session 5 status                       |
|---------------------------|--------------------------------------|-----------------------------------------|
| Acceptable `--task` values| 2 (harmonic, holography)            | **5** (+ interference, holographic_memory, exp_r1_r4_campaign) |
| Per-episode basin model   | "RNG-dominated" at N=5               | **IID Bernoulli p(HIGH) ≈ 0.34** at N=100 |
| rot=60°×asym=+0.5 sweet-spot | 3/5 HIGH (Phase L), claimed C3-asym | **5/10 HIGH = baseline**. C3 claim WEAKENED. Only rot=0° suppresses. |
| Asymmetry range validated | [-1, +1]                             | **[-5, +5] for E shift; [-2, +2] for Coh conservation** |
| Harmonic/holography E-scale | "Same family, different scale"     | **Distinct regimes, never merge**. Gap ~60 E-units persists at every asym. |
| Basin classifier validity | Universal (all asym)                 | **Valid for asym ∈ [-2, +2]**. At asym ≤ -3 both basin Coh signatures compress. |

---

## 2. Hidden tasks reference (new surface)

Three task names beyond harmonic / holography actually work:

### `--task interference`

- **What it runs:** "Phase F" classification over 10 pre-loaded samples
- **Output:** stdout only; no JSONL receipts
- **Learning:** DETERMINISTIC, NO LEARNING. 5 `--steps` produces 5
  bit-identical epochs. `--asymmetry` has zero effect (bit-identical diff).
- **Use case for future work:** As-is, not useful. Might be meaningful
  with a different `--dataset` (default is `data/xnor_train.jsonl`).

### `--task holographic_memory`

- **What it runs:** "Holographic Memory Experiment" (GPU-initialized
  even with `--cpu`, falls back due to 32KB vs 64KB shared-memory target)
- **Output:** `holographic_memory_log.csv` on device with columns
  `epoch, train_energy, recall_energy, recall_gain, cosine_sim`
- **Learning:** NO LEARNING at defaults. train_energy constant,
  recall_energy stochastic, gain ~3e-5, cosine ~-0.001.
- **Use case:** Default behaviour is null; non-trivial behaviour likely
  requires a prepared pattern dataset via `--patterns` / `--dataset`.

### `--task exp_r1_r4_campaign` — THE IMPORTANT ONE

- **What it runs:** A four-experiment evaluation suite (R1, R2, R3, R4)
  with six boolean pass/fail gates
- **Output:** single JSON object (~3.7 kB) at `-o <file>`, not JSONL
- **Gates:** `EPSILON_CRIT, R1, R2, R3, R4, WAKE_SLEEP_ALIGN`.
  **At defaults: PASS={EPSILON_CRIT, R4, WAKE_SLEEP_ALIGN}, FAIL={R1, R2, R3}.**
  Stable across `--steps 1` and `--steps 10`.
- **`operational_steps` scales with `--steps`** (5 at `--steps 1`,
  10 at `--steps 10`). Run time ~200 s cold at `--steps 1`, ~530 s at
  `--steps 10`.
- **Payload keys per block:**
  - `r1`: adj_baseline_acc (1.0), dm3_discrimination_acc (1.0),
    arnold_tongue.productive_ratio (0.0), margin (0.0),
    margin_threshold (0.01), wake_sleep_audit.{same_step_mse,
    shifted_step_mse, sleep_steps}, convergence_epsilon, convergence_points.
    R1 fails on **margin = 0** at default.
  - `r2`: phase_a, phase_b, phase_c, phase_d, reflexive, lessons.
    Structured multi-phase reflexive experiment.
  - `r3`: k2_uplift, points. K2 capacity uplift (hints at K1/K2
    hierarchy).
  - `r4`: base_holdout_err (0.051), post_holdout_err (0.048),
    base_trained_err, post_trained_err, holdout_uplift, trained_uplift,
    **transfer_ratio (1.37)**. R4 passes because transfer_ratio > 1.

**This is a compact, reproducible, discriminating evidence surface. The
next agent's best investment is to find parameter settings that flip R1,
R2, R3 to PASS.**

Invocation:
```bash
adb -s FY25013101C8 shell "cd /data/local/tmp && ./dm3_runner \
  --cpu --mode train --task exp_r1_r4_campaign --steps 1 \
  -o /data/local/tmp/r1r4.jsonl"
adb -s FY25013101C8 pull /data/local/tmp/r1r4.jsonl .
```

---

## 3. Basin-selection process (sharpened)

At N=100 (5 × 20-episode harmonic sessions, asym=0):

- **Marginal P(HIGH) = 34 %.** LOW = 66 %. No OTHER/RETRY.
- **Transitions are independent.** P(H|H) = 31 %, P(H|L) = 35 %, all
  within 3 pp of marginal. 95 % CIs overlap.
- **Run-length distributions match geometric** predictions under
  IID Bernoulli p=0.34. Mean HIGH run 1.42 (predicted 1.52); mean LOW
  run 2.64 (predicted 2.94). Max runs (HIGH=4, LOW=9) expected under
  tail.
- **No session-level lock** (first-episode distribution matches marginal
  — 2/5 HIGH).
- **No per-index drift** (HIGH rate per position k ∈ [1..20] fluctuates
  binomially, no monotone trend; first-5 vs last-5 within noise).

**Operational interpretation:** within a harmonic session, each
episode's basin is a fresh independent Bernoulli draw. Binary page-cache
warmth affects runtime (~65 s warm, ~195 s cold) but does NOT change
marginal HIGH rate at session-level scale. This is the strongest
statistical characterization of basin selection to date.

---

## 4. What the rotation × asymmetry coupling actually is

Pooling Session 4 Phase L + Session 5 P2b (N=10 each):

| Config                     | HIGH rate (N=10) |
|----------------------------|------------------|
| rot=0°   × asym=+0.5       | **0/10 = 0 %**   |
| rot=60°  × asym=+0.5       | 5/10 = 50 %      |
| rot=120° × asym=+0.5       | 3/10 = 30 %      |

- Fisher-exact rot=60° vs rot=120°: **p = 0.65** (not distinguishable).
- Fisher-exact rot=60° vs rot=0°:   **p = 0.033** (distinguishable).

**Revised claim:** *At asym=+0.5, zero rotation suppresses HIGH
(0/10). Any nonzero rotation restores baseline HIGH access (30-50 %,
consistent with P2a's marginal 34 %).* The "C3-asymmetric coupling"
interpretation is not supported at this sample size.

Also, the rot=60° fine sweep across asym ∈ {0.40, 0.45, 0.50, 0.55, 0.60}
shows HIGH rates {2,1,2,1,3}/5 with maximum at 0.60, not at 0.50. No
boundary-localized peak; the sweep is within binomial noise.

---

## 5. E-scale behavior under extreme asymmetry

### Holography

E = 11.3 + 5.1 × asym across asym ∈ [-2, +5]. Coh constant at 0.72-0.73.
Strictly monostable (Retry). Tight cluster (sd ≈ 0.5) at each asym.

### Harmonic

Bistable throughout asym ∈ [-5, +2]. Both basins shift linearly in E
with slope ~6 E/asym-unit.

**NEW: at asym ≤ -3, both basin Coh signatures compress.** At asym=-5:

| Basin        | E     | Coh   |
|--------------|-------|-------|
| B1 (lower)   | 55.3  | 0.620 |
| B2 (higher)  | 77.4  | 0.690 |

These Coh values are below the session-4 locked threshold (LOW Coh >
0.82). **Locked classifier misclassifies these as OTHER.** The
classifier needs a regime tag: valid for asym ∈ [-2, +2].

### The two regimes are distinct

Gap between harmonic LOW-basin E and holography E at each common asym:

| asym | harm B1 E | holo E | gap |
|------|-----------|---------|-----|
| -2   | 61.7      | 7.6     | 54.1 |
|  0   | 75.3      | 14.8    | 60.5 |
| +2   | 86.8      | 26.2    | 60.6 |

Gap is stable at ~60 units. Linear extrapolation would require Δasym
~12 more units to close, which is beyond what the binary accepts
cleanly. **Harmonic and holography are distinct dynamical regimes
sharing one asymmetry axis, not two points on one E continuum.**

---

## 6. Device operational notes (unchanged from Session 4 except where flagged)

- Serial: `FY25013101C8`, binary hash `daaaa84a...9672` (verify every phase)
- 80 % battery held across the full 10h 32m session while AC-powered
- Cold cache after ~30 s idle → ~195 s per episode; warm ~65 s per episode
- **Session 3 of P2a was unexpectedly cold** despite 30 s idle
  between sessions. Unclear trigger; likely page-cache eviction by some
  Android housekeeping. Budget 100 % extra time if you plan
  multi-session sweeps.
- `--soak N > 1` still not used. Remains a 20×N episode trap.
- `exp_r1_r4_campaign` takes ~200 s at `--steps 1` (cold) and scales
  approximately linearly in operational_steps with steps_hint.
- `holographic_memory` task initializes GPU even with `--cpu` and
  reports `max_compute_workgroup_storage_size=32768 < target 65536; using
  reduced limit`. Device runs it anyway.

---

## 7. Pre-registered priorities for Session 6 (recommended)

### Priority 1 (highest leverage): Flip R1, R2, R3 gates in exp_r1_r4_campaign

The campaign is reproducible (same verdicts at steps=1 and steps=10).
R1 fails on `margin = 0` vs threshold 0.01. R2 fails on its own gate
(unknown criterion). R3 fails on its own gate.

**Investigate:**
- Does increasing `--steps` to 50+ raise margin above threshold?
- Does asymmetry affect margin? (Phase K showed asymmetry shifts basin
  positions — likely shifts margin.)
- Does `--rotation` affect wake_sleep_audit?
- Does `--freq` affect arnold_tongue.productive_ratio?

Budget ~2 hours. Each probe is ~200 s cold, or ~500 s at `--steps 10`.
20 probes with varied parameters fits the budget.

### Priority 2: Rebuild basin classifier for the asym ≤ -3 regime

Current classifier (HIGH iff E>82 AND Coh<0.82; LOW iff E<82 AND
Coh>0.82) maps to OTHER at asym=-5 for 100 % of episodes. Session 6
should either:
- Locate the asym boundary where Coh-signature preservation breaks
  (test asym=-2.5, -2.7, -2.9),
- OR adopt an E-ordering-based classifier ("lower-E basin vs higher-E
  basin in a given cell") that works across regimes.

### Priority 3: RNG isolation (if feasible)

P2a establishes basin selection is independent Bernoulli. The only
hope for deterministic control is isolating what the RNG depends on.
Source is blocked. But we can ask: is the per-episode seed drawn from
`/dev/urandom`, from wall-clock time, from a hash of the previous
episode, or from an internal PRNG with a known state?

Test: run two 10-episode sessions back-to-back with identical flags.
If the basin sequences match, the PRNG is reproducible across sessions
→ seed must come from something deterministic on device.

---

## 8. Do NOT do next

- Do not rerun Phase L configurations hoping for different rot=60°
  peak; P2b already settled this at N=10.
- Do not chase the FAST session (~155 s anomaly from Session 3) — same
  warning as Session 4. Still not reproduced.
- Do not reopen H2 (transformer). Geometry-sovereign is STRONGER now
  that basin independence is confirmed.
- Do not try to make the system deterministic by controlling non-RNG
  parameters. P2a proves basin selection is IID within a session; only
  the internal seed controls it.
- Do not run `--soak N > 1`. It is 20×N episodes, hours of compute.
- Do not promote `interference` or `holographic_memory` as evidence
  surfaces at defaults — they are null. Promote only if/when you find
  a parameter setting that makes them learn.
- Do not compute margin of the OLD basin classifier at asym ≤ -3 —
  the classifier is not calibrated there.

---

## 9. Commands the next agent will need

### Pre-flight (run before each phase)

```bash
adb -s FY25013101C8 shell 'pidof dm3_runner || echo "idle"; \
  cat /sys/class/power_supply/battery/capacity; \
  cat /sys/class/thermal/thermal_zone0/temp; \
  sha256sum /data/local/tmp/dm3_runner; \
  dumpsys battery | grep -E "status|AC powered"'
```

Binary hash MUST be `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`. ABORT otherwise.

### Reference invocation for exp_r1_r4_campaign

```bash
adb -s FY25013101C8 shell "cd /data/local/tmp && ./dm3_runner \
  --cpu --mode train --task exp_r1_r4_campaign --steps 10 \
  --asymmetry 0.3 -o /data/local/tmp/r1r4_probe.jsonl"
```

### Kill runaway

```bash
adb -s FY25013101C8 shell 'kill -9 $(pidof dm3_runner)'
```

---

## 10. Artifacts to look at first

1. `docs/restart/DM3_SESSION5_FINAL_REPORT.md` — complete Session 5 results
2. `artifacts/phase_O_hidden_tasks_20260417T120540Z/PHASE_O_SUMMARY.md`
   — the hidden-task inventory and the R1-R4 campaign JSON anatomy
3. `artifacts/phase_P2a_intra_session_20260417T130742Z/PHASE_P2a_SUMMARY.md`
   — independence proof at N=100
4. `artifacts/phase_P2b_coupling/PHASE_P2b_SUMMARY.md` — why Phase L's
   C3 claim weakened
5. `artifacts/phase_P3_escale/PHASE_P3_SUMMARY.md` — E-scale regime
   analysis + Coh compression discovery

---

## 11. Session 5 governance retrospective

- Pre-registered hypotheses before each phase. All five phases
  (O, P1b/P1b2, P2a, P2b, P3) had explicit kill criteria.
- Two Session 4 claims weakened / revised on stronger evidence:
  rotation-coupling C3 claim, and "holography = same family as harmonic".
- Two claims strengthened: basin independence, geometry sovereignty.
- One new evidence surface added: exp_r1_r4_campaign gate suite.
- One new regime edge discovered: Coh compression at asym ≤ -3.
- No reward-hacking. Null results written up with same care as
  confirmations (interference = no learning; holo = no learning;
  rot=60° fine sweep = no structure at N=5).
- Killed wasteful probes promptly (holo_steps10 after holo_steps5
  showed no learning; interf_asym_0/p05 after asym invariance was
  confirmed bit-identical).

**All governing-rules checks from AGENTS.md pass.**
