# DM3 Session 4 PRD — Sculptor's-Scalpel Characterization

Written: `2026-04-16`
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Drives: `SESSION_4_FEEDBACK_DOCUMENT.md` (authority)
Builds on: `DM3_MULTI_HYPOTHESIS_FINAL_REPORT.md` (Session 3 findings)
Execution host: Mac (not phone — see `SESSION4_EXECUTION_HOST_DECISION.md`)

---

## Governing Principle

Every experiment in Session 4 is a **falsifier**, not a confirmer. An
experiment's value is measured by which possibilities it removes, not by what
it shows. If an experiment cannot be described in the form *"this carving
removes the possibility that the object is X"*, it does not belong in this
PRD.

## Objective Hierarchy (Strict)

1. **PRIMARY — Discovery.** Characterize what the 3D Double Meru actually is.
2. **SECONDARY — Commercial wedge.** Emergent only. Not pursued.

If the PRD reads like it optimizes for commercial pitch, pull back. This is
a discipline.

## What Session 4 Will Not Touch

- H2 (transformer creates bistability) — killed, settled.
- RNG seed control — source-blocked.
- FAST session (~155s) anomaly — filed.
- NPU lane — ABSTAIN holds.
- Heterogeneous role partition — ABSTAIN holds.
- Inference mode as a live surface — stub, confirmed.
- Manifesto T-registry as operational predictions — with inference mode
  stubbed, T01-T236 are not tests.

## Naming Discipline

Sacred-geometry names (Meru, Bindu, Sri Yantra) are inherited source vocabulary.
They are not evidence. In Session 4 writeups, a vertex tag named "BINDU" is
"a vertex in the 39% equatorial graph region", not "the central point of
reality". Similarly:

- "holography-mode" not "holography" until mathematical identity established
- "task=harmonic" not "the harmonic task" as if that's a known object
- "BINDU region" used only when quoting data; otherwise "equatorial belt"
- "3D Double Meru graph" = "the 380-vertex graph"

The 380-vertex graph's properties are defended on graph-theoretic grounds.

## Minimum Statistical Discipline

- **N ≥ 5 episodes** for any claim promoted to "confirmed".
- **Pre-registration**: every phase writes its expected outcome and kill
  criterion BEFORE running. No post-hoc hypothesis fitting.
- **Null-result parity**: writeups for killed hypotheses receive the same
  care as confirmed ones.
- **Basin classification thresholds** (locked from Session 3):
  - HIGH: E > 82 AND Coh < 0.82
  - LOW: E < 82 AND Coh > 0.82
  - OTHER: anything outside either box (report as OTHER, don't force)

## Device Invocation Standard

All runs in Session 4 use this base invocation:

```
adb -s FY25013101C8 shell "cd /data/local/tmp && rm -f <OUTFILE> && \
  ./dm3_runner -o <OUTFILE> --mode train --task <TASK> --steps <N> --cpu <EXTRA_FLAGS>"
```

With:
- `<OUTFILE>` = phase-and-run-scoped filename
- `<TASK>` in `{harmonic, holography}`
- `<N>` = episodes per invocation (N=5 or N=10 typical in Session 4)
- `<EXTRA_FLAGS>` vary per experiment
- **Negative numeric args**: `--asymmetry=-0.5` (with `=`), NOT `--asymmetry -0.5`

Binary hash MUST match `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
before every phase starts. Verify with `adb -s FY25013101C8 shell 'sha256sum /data/local/tmp/dm3_runner'`.

Typical episode duration: ~195-215s. One episode ≈ 200s for planning.

## Pre-Run Capture

Before every phase (not every run — per phase is sufficient), capture:
```
adb -s FY25013101C8 shell 'cat /sys/class/power_supply/battery/capacity && \
  echo "---" && cat /sys/class/thermal/thermal_zone0/temp && \
  echo "---" && cat /proc/loadavg && \
  echo "---" && sha256sum /data/local/tmp/dm3_runner'
```

Save into the phase artifact directory as `pre_state.txt`.

---

# PHASES

## Phase H — Statistical Replication (Carving 1)

**Status:** MUST BE FIRST. All downstream phases are built on sand until
Session 3 headlines hold at N=5.

**Carving goal:** Remove the possibility that Session 3's main findings are
2-episode noise.

### Pre-Registered Predictions

- H2 confirmation replay: HAM HIGH rate stays ≤ 30%, LN HIGH rate stays ≥ 50%
  across N=5 each. If these don't hold, the H2 kill is weaker than stated.
- Asymmetry order parameter: at N=5, asym=-1 still gives E < 74 with
  Coh > 0.85 (deep-low cluster); asym=+1 still produces at least one episode
  with E > 90.
- Rotation differentiation: at N=5 per angle, rot=120 produces HIGH rate
  significantly different from at least one of rot={60, 90, 180}.
- freq=1.0 robustness: 5/5 HIGH, or HIGH rate ≥ 80%.
- Holography cluster: at N=5, all 5 runs stay in the E=12-18, Coh=0.70-0.76
  Retry cluster.
- Truth sensor bias: at N=5 across 4 configs, HIGH rate ≤ 20% overall.

### Kill Criteria

- If H2 HAM HIGH rate ≥ 50% at N=5, REOPEN H2 and note confusion.
- If asym=-1 gives any episode with E > 82, the order-parameter claim softens.
- If rot=120 high rate is indistinguishable from rot=0 at N=5, H6/H8 soften.
- If freq=1.0 HIGH rate < 60% at N=5, H3's strongest claim dies.
- If holography shows ANY basin-switching at N=5, the "monostable third
  attractor" claim dies.

### Executable Plan

All with `--cpu --task harmonic --steps 5` unless noted. Collect 5 episodes
per invocation.

| H-Run | Command | Purpose | Est. time |
|-------|---------|---------|-----------|
| H.1 | `--use-layernorm false` | HAM replication, pre-registration for H2 | 17 min |
| H.2 | `--use-layernorm true` | LN replication control | 17 min |
| H.3 | `--asymmetry=-1.0` | asym order-param replay | 17 min |
| H.4 | `--asymmetry=-0.1` | asym HIGH boundary | 17 min |
| H.5 | `--asymmetry=0.1` | asym mixed boundary | 17 min |
| H.6 | `--asymmetry=1.0` | asym splat/elevated-high replay | 17 min |
| H.7 | `--rotation 120` | C3 rotation replay | 17 min |
| H.8 | `--rotation 60` | C3 non-gen replay | 17 min |
| H.9 | `--rotation 0` | rotation zero-point | 17 min |
| H.10 | `--freq 1.0` | freq=1.0 lock replay | 17 min |
| H.11 | `--freq 0.033` | freq low replay | 17 min |
| H.12 | `--task holography` | holography cluster replay | 17 min |
| H.13 | `--enable-truth-sensor` | truth sensor default replay | 17 min |
| H.14 | `--enable-truth-sensor --sensor-threshold 0.1 --sensor-strength 0.9` | truth sensor strong replay | 17 min |

Total: 14 runs × ~17 min = **~4 hrs device time**.

### Artifacts
- `artifacts/phase_H_statistical_replication_<TS>/pre_state.txt`
- `artifacts/phase_H_statistical_replication_<TS>/H.N.jsonl` per run
- `artifacts/phase_H_statistical_replication_<TS>/log.txt`
- `artifacts/phase_H_summary.json` with per-run basin counts and kill-criterion
  evaluations

### Success Gate
- Every Session 3 solid/suggestive finding either (a) replicates at N=5, (b)
  is downgraded with evidence, or (c) is killed with evidence.
- Phase H produces a "Session 3 findings revised status" table.

---

## Phase I — Frequency Deep-Characterization (Carving 2)

**Depends on:** Phase H (must know if freq=1.0 held up).

**Carving goal:** Remove the ambiguity around `--freq`. Is it a resonance
peak, a monotone amplitude, or something coupled and nonlinear?

### Pre-Registered Predictions

- Sub-carving I.a (freq sweep): if there is a single clean peak around 1.0,
  `--freq` is a resonance driver. If monotone in `|freq|`, it's an
  amplitude/gain. If multi-peaked, it's coupling to multiple modes.
- Sub-carving I.b (freq × task): if peak is at the same freq for both
  harmonic and holography, it's driver-level. If it shifts, it's task-coupled.
- Sub-carving I.c (freq × rotation): if freq=1.0 locks HIGH regardless of
  rotation, frequency dominates rotation. If rotation can break the lock,
  they're coupled.

### Kill Criteria

- If freq-sweep shows no peak and HIGH rate is flat across all freq values,
  `--freq` is NOT a resonance parameter and H3 fully dies.
- If freq=1.0's HIGH rate from Phase H already came out < 60%, skip the
  I.c coupling sweep (not worth testing coupling to a non-effect) and
  demote to a shorter I.a only.

### Executable Plan

**I.a — Freq sweep, harmonic task**, N=5 episodes each:

```
--freq 0.1
--freq 0.3
--freq 0.5
--freq 0.8
--freq 1.0
--freq 1.2
--freq 1.5
--freq 2.0
--freq 5.0
--freq 10.0
```

All with `--cpu --mode train --task harmonic --steps 5`. 10 runs × ~17 min =
**~170 min**.

**I.b — Freq sweep, holography task**, subset:

```
--freq 0.3 --task holography
--freq 0.8 --task holography
--freq 1.0 --task holography
--freq 1.5 --task holography
--freq 2.0 --task holography
```

5 runs × ~17 min = **~85 min**.

**I.c — Freq×Rotation coupling** (only if I.a confirms peak near 1.0):

```
--freq 1.0 --rotation 0
--freq 1.0 --rotation 60
--freq 1.0 --rotation 120
--freq 1.0 --rotation 180
```

4 runs × ~17 min = **~68 min**.

Total Phase I: up to **~5.4 hrs device time**.

### Artifacts
- `artifacts/phase_I_frequency_<TS>/` with per-sub-carving subdirs
- `artifacts/phase_I_summary.json` with peak-fit, HIGH rate vs freq curve,
  task-comparison table, coupling matrix (if I.c ran)

### Success Gate
- `--freq` is categorized into one of: {resonance, amplitude, coupling,
  null-effect} with retained data supporting the choice.

---

## Phase J — Holography Parameter Sweep (Carving 3)

**Depends on:** Phase H (must know holography cluster replicated).

**Carving goal:** Distinguish three hypotheses: holography is monostable vs
narrowly bistable vs task-parameterized (same dynamical family at a different
operating point).

### Pre-Registered Predictions

- If holography's single attractor is insensitive to {asym, rot, freq}, it's
  a degenerate mode — and the harmonic bistability is the ONLY live dynamical
  structure.
- If holography's attractor shifts the way harmonic's does under asymmetry,
  the two tasks are the same dynamical family at different operating points —
  a much stronger claim about the geometry.
- If holography shows emergent bistability (second attractor appearing at some
  parameter setting), the parameter triggers a mode-transition.

### Kill Criteria

- If all 15 holography runs across all parameter values return the same (E≈14,
  Coh≈0.73, Retry) cluster, holography is degenerate and the "task-parameterized"
  hypothesis dies.

### Executable Plan

All with `--cpu --mode train --task holography --steps 5`:

**Asymmetry arm** (5 values × 5 eps):
```
--asymmetry=-1.0
--asymmetry=-0.5
--asymmetry=0.0
--asymmetry=0.5
--asymmetry=1.0
```

**Rotation arm** (3 values × 5 eps):
```
--rotation 0
--rotation 60
--rotation 120
```

**Frequency arm** (3 values × 5 eps):
```
--freq 0.5
--freq 1.0
--freq 2.0
```

Total: 11 runs × ~17 min = **~3.1 hrs device time**.

### Artifacts
- `artifacts/phase_J_holography_<TS>/`
- `artifacts/phase_J_summary.json` with holography basin-map under parameter
  variation, comparison against harmonic's basin-map

### Success Gate
- Holography is categorized into one of: {degenerate, narrowly-bistable,
  task-parameterized-same-family, multi-stable}.

---

## Phase K — Asymmetry Fine Sweep (Carving 4)

**Depends on:** Phase H (asymmetry order-parameter claim replicated).

**Carving goal:** Distinguish sharp critical point (first-order phase
transition) from smooth crossover.

### Pre-Registered Predictions

- Sharp critical point: at some |asym_c|, HIGH rate goes from ≥50% to ≤10%
  within an asym window of 0.05 width. Indicates a phase transition.
- Smooth crossover: HIGH rate decreases monotonically over a window of
  0.2-0.4 asym width. Indicates a continuous controller.
- Non-monotone: HIGH rate oscillates with asym. Indicates coupling to a
  hidden parameter or mode structure.

### Kill Criteria

- If the 13-point sweep shows no systematic trend (HIGH rate looks like noise),
  the "asymmetry as order parameter" claim weakens severely.

### Executable Plan

All with `--cpu --mode train --task harmonic --steps 5`:

```
--asymmetry=-0.3
--asymmetry=-0.2
--asymmetry=-0.15
--asymmetry=-0.10
--asymmetry=-0.05
--asymmetry=-0.02
--asymmetry=0.00
--asymmetry=0.02
--asymmetry=0.05
--asymmetry=0.10
--asymmetry=0.15
--asymmetry=0.20
--asymmetry=0.30
```

13 runs × ~17 min = **~3.7 hrs device time**.

### Artifacts
- `artifacts/phase_K_asymmetry_fine_<TS>/`
- `artifacts/phase_K_summary.json` with HIGH rate vs asymmetry curve,
  phase-transition classification

### Success Gate
- Asymmetry transition is classified as {sharp, smooth, non-monotone, null}.
  If sharp: critical point reported with uncertainty interval.

---

## Phase L — Rotation × Asymmetry Coupling (Carving 5)

**Depends on:** Phase H and Phase K (must know both individual effects).

**Carving goal:** Determine whether rotation and asymmetry are independent
control axes or coupled through the symmetry structure.

### Pre-Registered Predictions

- Independent: rot=120° + asym=+0.5 behaves like asym=+0.5 alone. C3 rotation
  does not alter asymmetry's effect.
- Coupled: rot=120° + asym=+0.5 recovers bistability that asym=+0.5 alone
  damages. The two controls interact through the symmetry structure.
- Rotation dominates: any non-zero rotation erases asymmetry's effect.
- Asymmetry dominates: any non-zero asymmetry erases rotation's effect.

### Kill Criteria

- If all 9 test points look identical to their corresponding asym-only
  controls, rotation has no effect when asymmetry is active and the rotation
  finding (H6/H8) softens.

### Executable Plan

All with `--cpu --mode train --task harmonic --steps 5`:

Grid (3 rotations × 3 asymmetries):
```
--rotation 0   --asymmetry=-0.5
--rotation 0   --asymmetry=0.0
--rotation 0   --asymmetry=0.5
--rotation 120 --asymmetry=-0.5
--rotation 120 --asymmetry=0.0
--rotation 120 --asymmetry=0.5
--rotation 60  --asymmetry=-0.5
--rotation 60  --asymmetry=0.0
--rotation 60  --asymmetry=0.5
```

9 runs × ~17 min = **~2.6 hrs device time**.

### Artifacts
- `artifacts/phase_L_coupling_<TS>/`
- `artifacts/phase_L_summary.json` with 3×3 HIGH rate matrix, interaction
  classification

### Success Gate
- Coupling structure classified as {independent, coupled-symmetric,
  rotation-dominates, asymmetry-dominates, complex}.

---

## Phase M — `--angle` Characterization (Carving 6)

**Depends on:** nothing — cheap, can run anytime.

**Carving goal:** Settle whether `--angle` is a functional parameter or dead
code.

### Pre-Registered Predictions

- Functional: at least one --angle value produces HIGH rate or E/Coh
  distribution distinguishable from angle=0.
- Non-functional: all --angle values produce statistically identical
  distributions.

### Kill Criteria

- If all 7 angle values produce statistically identical HIGH rates (at N=3
  each that's limited power, but a 7-point flat line is informative), `--angle`
  is retired from the PRD.

### Executable Plan

All with `--cpu --mode train --task harmonic --steps 3`:

```
--angle 0
--angle 30
--angle 45
--angle 60
--angle 90
--angle 120
--angle 180
```

7 runs × ~10 min = **~1.2 hrs device time**.

### Artifacts
- `artifacts/phase_M_angle_<TS>/`
- `artifacts/phase_M_summary.json` with HIGH rate vs angle

### Success Gate
- `--angle` categorized as {functional, non-functional, ambiguous-need-more-N}.

---

## Phase N — Intra-Episode Telemetry (Carving 7)

**Depends on:** nothing — but this is the variable-scope phase.

**Carving goal:** See inside a single episode. Is convergence monotone,
oscillatory, or hopping?

### Pre-Registered Predictions

- The receipt schema (per Session 3 Phase E data):
  `{asymmetry, coherence, decision, delta_E, duration_ms, episode}`.
- No per-step trace fields have been observed. But the inference-mode
  receipt included a `delta_e_trace` field (empty in stub). There may be
  hidden training-mode telemetry that never populates.
- Test: run with `--mode train --steps 1 --soak 1` to see if soak mode
  produces a trace (soak=1 = 20 episodes, ~66 min — test-and-kill).

### Kill Criteria

- If no extended telemetry surfaces in any mode/flag combination, intra-
  episode telemetry is blocked at the binary level. File a source request,
  retire this phase.

### Executable Plan

**N.1 — Schema scan**: Test unusual flags to see if any surface per-step fields:
```
--mode train --task harmonic --steps 1 --cpu --soak 1
--mode train --task harmonic --steps 1 --cpu --autobrake 1
--mode train --task harmonic --steps 1 --cpu --dataset-size 100
--mode train --task harmonic --steps 1 --cpu --calibration /does/not/exist
```

Each run checks: does the output JSONL contain any field beyond the 6 known ones?

**N.2 — Binary strings scan** (on Mac, not device):
```
adb pull /data/local/tmp/dm3_runner /tmp/dm3_runner_binary
strings /tmp/dm3_runner_binary | grep -iE '(trace|checkpoint|log|debug|step)'
```

Look for hidden telemetry flags not in --help.

**N.3 — Source-level request** (writeup): if N.1 and N.2 find nothing, file
a request document: "dm3_runner needs per-step telemetry emission for
Session 5". Don't try to patch the binary.

### Artifacts
- `artifacts/phase_N_telemetry_<TS>/`
- `artifacts/phase_N_summary.json` with schema findings
- `docs/restart/BINARY_TELEMETRY_REQUEST.md` (if N.3 triggered)

### Success Gate
- Either per-episode telemetry is accessible, OR a clean source-side request
  exists.

---

## Phase O — Session 4 Integrated Report

**Depends on:** all prior phases.

**Goal:** Write the Session 4 equivalent of Session 3's final report.

### Required Sections

1. Revised status of Session 3 findings (solid / suggestive / killed).
2. Per-phase results with pre-registered-vs-observed comparisons.
3. New parameter-space map: what each flag actually does (empirical).
4. Open questions remaining for Session 5.
5. *(Optional, only if something has emerged)* Commercial wedge observation
   section. One paragraph max. If nothing has emerged, section is omitted,
   not padded.

### Deliverables
- `docs/restart/DM3_SESSION4_FINAL_REPORT.md`
- `docs/restart/AGENT_HANDOVER_20260416_SESSION4.md` (or dated next day if
  session runs overnight)
- `docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md` updated
- `.gpd/STATE.md` updated with Session 4 entry
- `DM3_SESSION4_REVIEW_PACK/` prepared under `/Users/Zer0pa/DM3/` (same
  structure as Session 3 pack)

---

# Aggregate Planning

## Device Time Budget

| Phase | Device hrs | Cumulative |
|-------|-----------|------------|
| H | 4.0 | 4.0 |
| I | 5.4 | 9.4 |
| J | 3.1 | 12.5 |
| K | 3.7 | 16.2 |
| L | 2.6 | 18.8 |
| M | 1.2 | 20.0 |
| N | ~1 (+src request) | 21.0 |
| O | writing | 21.0 |

Total: **~21 hours of clean device execution.** Call it 25-28 hours with
battery/thermal breaks and log/pull overhead. This is 2-3 calendar sessions.

## Phase Ordering Rules

- **Phase H MUST be first.** Nothing else is trustworthy until replication
  passes.
- **Phase M and N are cheap and side-trackable.** Can be interleaved if
  device needs a cooling break between heavier phases.
- **Phase I depends on H.10 result** (freq=1.0 replication).
- **Phase L depends on H and K** (both axes confirmed first).
- **Phase O is last.** Don't write it until carvings complete.

## Operational Protocol

- Before each phase: run pre-state capture. Verify binary hash.
- During each phase: stream to background task, monitor via output file.
- After each phase: pull receipts to Mac, write phase summary JSON.
- Between phases: 5-10 min device idle for thermal recovery if thermal_zone0
  ≠ 0.
- Kill-switch: if binary hash changes mid-session, abort session immediately.

## File Hygiene

Mac has ~17GB free. Keep artifacts small.

- Do NOT pull the entire binary to Mac repeatedly. Once, for Phase N strings.
- Do NOT keep large intermediate files (>1MB) in the repo.
- JSONL receipts are ~100-200 bytes each — fine.
- Archive phase directories into `DM3_SESSION4_REVIEW_PACK/` at session end.

## Phase Writeup Template (required for every phase)

```markdown
# Phase <LETTER> — <NAME>

## Pre-Registration
- Predictions (written before running):
- Kill criteria (written before running):

## Execution Record
- Date/time range:
- Device state pre/post:
- Binary hash confirmed:
- Runs executed: N
- Aborts / retries: N

## Results
- Per-run data table
- Summary statistics
- Pre-registered prediction vs observed (explicit comparison)

## Verdict
- [CONFIRMED / KILLED / PARTIAL / NULL / REOPENED]
- One-paragraph explanation

## Artifacts
- `artifacts/phase_<LETTER>_<NAME>_<TS>/`
```

---

## Governance (Inherited + New)

**Inherited from Session 3:**
- Do not reward hack. Do not narrate local improvements as branch wins.
- F1 / F2 / legacy lane separation.
- NPU: ABSTAIN. Heterogeneous: ABSTAIN.
- Every claim has a retained packet.
- Each hypothesis has a kill criterion — applied honestly.

**New in Session 4:**
- Minimum N=5 discipline.
- Pre-registration before every phase.
- Null-result parity.
- No commercial framing in phase writeups.
- Distinguish binary flags from mathematical concepts.
- Sacred-geometry names are vocabulary, not evidence.

## What Success Looks Like

Session 4 succeeds if:

1. Every Session 3 headline is either replicated at N=5 or killed with evidence.
2. `--freq` is categorized.
3. Holography-mode is categorized.
4. Asymmetry transition type is classified.
5. Rotation × asymmetry coupling structure is determined.
6. `--angle` is settled.
7. Intra-episode telemetry status is resolved.
8. The resulting characterization is sharper than Session 3's.

Session 4 does NOT succeed if:
- Findings are promoted without N=5 replication.
- The PRD drifts into commercial framing.
- Sacred-geometry names creep back in as load-bearing claims.
- Killed hypotheses are quietly resurrected.

## One-Line Brief

Session 4 removes wrong answers about what this object is, at statistical
strength sufficient to stand as the foundation for Session 5.
