# Agent Handover — Session 4 Startup

Written: `2026-04-16` (end of Session 3 + operator feedback cycle)
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Execution host: **Mac** (not phone — see `SESSION4_EXECUTION_HOST_DECISION.md`)

## For The Session 4 Agent

You are taking over a multi-session physics/computational research project.
Session 3 characterized a 380-vertex graph-based dynamical system across six
experimental phases. Session 4's job is to **replicate and deepen** those
findings at N=5 episodes, then run five new carving experiments. The operator
wants **no interim reporting — execute to completion, then report**.

Do not design new research questions. The Session 4 PRD is fixed. Execute it.

## Your Operating Context

- **Mac** runs the Claude Code agent. **RM10 Pro** (serial `FY25013101C8`)
  runs the binary via adb.
- Binary: `/data/local/tmp/dm3_runner`
- Binary hash (verify before every phase):
  `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- Typical run: 200s per episode; N=5 episodes per value ≈ 17 minutes per config.
- Total Session 4 budget: ~21 hours clean device time across 8 phases.

## Read First (In Order)

1. `/Users/Zer0pa/DM3/AGENTS.md` — governing objective (no reward hacking,
   action bias)
2. `docs/restart/DM3_SESSION4_PRD.md` — **your executable PRD** (primary
   document)
3. `docs/restart/SESSION_4_FEEDBACK_DOCUMENT.md` — operator's verbatim
   feedback; authority for PRD
4. `docs/restart/DM3_MULTI_HYPOTHESIS_FINAL_REPORT.md` — Session 3 findings
5. `docs/restart/SESSION4_EXECUTION_HOST_DECISION.md` — why Mac, not phone
6. `.gpd/STATE.md` — current state
7. `artifacts/phase_A_spectral_analysis/SPECTRAL_ANALYSIS_REPORT.md` —
   graph theory backbone

## Solid Session 3 Findings (Your Foundation)

- **Geometry is sovereign.** Bistability persists without the transformer.
  H2 is killed. Do not reopen.
- **Graph is C3-dominant**, not Z2. 95 of 127 eigenvalue levels are 3-fold
  degenerate. Fiedler does not separate cones.
- **Two basins**: HIGH ≈ (E=89, Coh=0.77), LOW ≈ (E=75, Coh=0.89). Thresholds
  locked: HIGH if E>82 & Coh<0.82; LOW if E<82 & Coh>0.82.
- **Basin selection is per-episode**, not per-session.
- **Inference mode is a stub.** Always T1 Contraction, canonical receipt.
  Not a live surface. Don't use.

## Suggestive Session 3 Findings (Your Phase H Targets)

At N=2 per config, needing N=5 replication:
- Asymmetry as continuous order parameter.
- Rotation=120° preserving bistability.
- freq=1.0 giving 100% HIGH.
- Holography third attractor.
- Truth sensor unidirectional LOW bias.

## Session 4 Phase Summary

Execute in this order (Phase H must come first):

| Phase | Purpose | Est. device time |
|-------|---------|------------------|
| H | Replicate Session 3 headlines at N=5 | 4.0 hrs |
| I | Frequency deep-characterization | 5.4 hrs |
| J | Holography parameter sweep | 3.1 hrs |
| K | Asymmetry fine sweep | 3.7 hrs |
| L | Rotation × asymmetry coupling | 2.6 hrs |
| M | `--angle` characterization | 1.2 hrs |
| N | Intra-episode telemetry investigation | ~1 hr |
| O | Integrated final report | writing |

Full details: `docs/restart/DM3_SESSION4_PRD.md`

## Hard Rules (Non-Negotiable)

1. **Minimum N=5** for any "confirmed" claim. No exceptions without explicit
   justification.
2. **Pre-register** each phase (predictions + kill criteria written BEFORE
   execution).
3. **Null results are equal in value** to confirmations. Write them up with
   the same care.
4. **No commercial framing** in phase writeups. Session 4's primary objective
   is discovery. Commercial wedge is emergent only.
5. **Distinguish binary flags from mathematical concepts.** Say "holography-mode"
   not "holography" (until proven equivalent). Say "task=harmonic" not "the
   harmonic task".
6. **Sacred-geometry names are inherited vocabulary, not evidence.** Sri Yantra,
   Meru, Bindu don't justify claims. 380-vertex graph properties must be
   defended on graph-theoretic grounds.
7. **Session 3 rules still apply**: geometry sovereign, F1/F2/legacy separate,
   NPU ABSTAIN, heterogeneous ABSTAIN, every claim has a retained packet.

## Hard Don'ts

- Do NOT reopen H2 (transformer creates bistability).
- Do NOT try to control RNG seed (source-blocked).
- Do NOT chase the FAST session (~155s anomaly).
- Do NOT touch NPU or heterogeneous lane.
- Do NOT promote inference mode as live.
- Do NOT cite T01-T236 as operational predictions.
- Do NOT write interim status reports to the user.
- Do NOT drift into commercial pitch.

## Device CLI Syntax Notes

- Negative numeric args: `--asymmetry=-0.5` (with `=`), NOT `--asymmetry -0.5`
  (clap parses it as a missing-value flag).
- Kill runaway: `adb -s FY25013101C8 shell 'kill -9 $(pidof dm3_runner)'`
- Do NOT run `--soak N` for N > 1 (N=5 means 100 episodes, ~5.4 hours).

## Artifact Layout

Same convention as Session 3:
```
artifacts/
├── phase_H_statistical_replication_<TS>/
├── phase_I_frequency_<TS>/
├── phase_J_holography_<TS>/
├── phase_K_asymmetry_fine_<TS>/
├── phase_L_coupling_<TS>/
├── phase_M_angle_<TS>/
├── phase_N_telemetry_<TS>/
├── phase_H_summary.json
├── phase_I_summary.json
...
```

At session end, produce:
- `docs/restart/DM3_SESSION4_FINAL_REPORT.md`
- `docs/restart/AGENT_HANDOVER_<DATE>_SESSION4.md`
- `docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md` (update)
- `.gpd/STATE.md` (append Session 4 entry)
- `/Users/Zer0pa/DM3/DM3_SESSION4_REVIEW_PACK/` — same structure as Session 3
  pack

## Governing Question

Session 4 is not about finding out what this object can *do for us*. It is
about finding out what this object *is*. Every carving removes one wrong
answer. When enough wrong answers are gone, the right one becomes visible.

## Go

Read the PRD. Execute Phase H first. Report only at the end.
