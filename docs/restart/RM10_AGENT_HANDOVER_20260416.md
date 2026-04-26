# RM10 Agent Handover

Last refreshed: `2026-04-16`

## Purpose

This is the live takeover surface for a new agent.

Use it together with:

- `/Users/Zer0pa/DM3/AGENTS.md`
- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd/STATE.md`
- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd/ROADMAP.md`

If any older startup note, brief, or handoff conflicts with this document, this
document wins.

## Governing Objective

The project is not trying to narrate a clever win.
It is trying to clear the real authority gate.

The current branch rules are:

- treat the top acceptance gate as sovereign
- treat any regression on the authority metric as failure
- do not convert mixed evidence into a pass narrative
- keep `F1`, top-level `F2`, and legacy bundled archaeology as separate lanes
- keep geometry sovereign
- treat environment as part of the computation
- treat thermal/runtime data as confound screens, not signal
- treat the organism framing as experiment design discipline, not proof

## Current Branch Position

- repo:
  `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform`
- branch:
  `hypothesis/rm10-primary-platform-heterogeneous-learning`
- last completed phase:
  `01.2.3.4.1.1.3.1.2.1`
- next planned phase:
  `01.2.3.4.1.1.3.1.2.2`
- current live problem:
  entrance-condition localization before row `cpu_a` on the top-level
  same-family `F2` surface

This means the branch is no longer asking:

`can the four-row packet complete?`

It is now asking:

`what pre-run or start-state condition selects the high regime versus the low regime on the same binary and same stronger envelope?`

## What The Red Magic Is For

The Red Magic 10 Pro is the real device instrument for this branch.

It is being used in two sharply separated ways:

### `F1` governed control

- binary: `/data/local/tmp/genesis_cli`
- `cwd`: `/data/local/tmp/SoC_runtime/workspace`
- meaning: governed device control lane
- current ceiling: trustworthy branch-local control instrument, but not
  source-built parity
- validator status: still under `explicit_hash` handling because the default
  device validator remains stale

### Top-level `F2` same-family residue

- binary: `/data/local/tmp/dm3_runner`
- `cwd`: `/data/local/tmp`
- meaning: lower-trust same-family behavior surface used for bounded
  engineering and observability work
- current ceiling: callable under the stronger envelope, but regime selection
  is unstable across sessions

### Legacy bundled archaeology surface

- binary: `/data/local/tmp/dm3/dm3_runner`
- `cwd`: `/data/local/tmp/dm3`
- meaning: separate historical residue surface
- rule: comparison-only and archaeology-only; never substitute it for the
  top-level `F2` family

## What We Now Know

### Governing truths that remain active

- `F1` governed Genesis CPU control is still the only trustworthy
  branch-local scientific instrument
- Mac Genesis remains the only live `source_built` authority lane
- NPU remains `ABSTAIN / inventory_only`
- explicit heterogeneous role partition remains `ABSTAIN`
- the live RM10 default-validator problem is localized to a stale compiled
  default pair, not vague bundle corruption

### Same-family `F2` empirical chain

1. Phase `01.2.3.4.1.1.3.1` repaired the old hard closing-row failure enough to
   produce one full four-row packet with real receipts under a stronger
   envelope.
2. Phase `01.2.3.4.1.1.3.1.2` reran that exact four-row packet and proved the
   repair was not reproducible.
3. The confirmation replay still completed, but it classified as
   `whole_session_instability`, not `reproducible_repair`.
4. Phase `01.2.3.4.1.1.3.1.2.1` then narrowed the packet to
   `cpu_a,gpu_a,cpu_b` and showed the low regime can already be present at row
   `cpu_a`.
5. That killed the `third_row_only` and `gpu_b_is_required_for_low_regime`
   stories.
6. The live blocker is therefore not packet width and not a late `cpu_b`
   problem by itself. The live blocker is the entrance condition before row 1.

### Artifact trail for that chain

- repaired width-boundary replay:
  `artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay`
- confirmation replay:
  `artifacts/phase_01_2_3_4_1_1_3_1_2_confirmation_replay_20260415T225828Z_full_replay`
- bounded localization replay:
  `artifacts/phase_01_2_3_4_1_1_3_1_2_1_third_row_localization_20260415T231357Z_cpu_a_gpu_a_cpu_b`

## What We Are Doing Conceptually

The current best reading is:

`DM3 behaves like a geometry-constrained dynamical medium with optional learned boundary adapters.`

Operational consequences:

- geometry is body plan
- dynamics are the medium
- environment is part of the computation
- repeated-window assays matter more than one-off output folklore
- transformers, if used at all, stay boundary-local until evidence forces more

This framing is useful only because it changes the measurement discipline.
It is not admissible as proof language by itself.

## Temperature, Thermal, And "Temp Pro"

The repo does not currently contain a distinct in-branch artifact or control
surface named `Temp Pro`.

The live in-repo temperature and thermal discipline is:

- `adb shell dumpsys battery`
- `adb shell dumpsys thermalservice`
- periodic telemetry capture in the replay helpers
- before/after snapshots on each serious row or packet

If there is external temperature tooling outside the repo, treat it as
secondary until its outputs are captured into receipted branch evidence.

## Required Reading Order

Read these in order before planning or executing:

1. `/Users/Zer0pa/DM3/AGENTS.md`
2. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd/STATE.md`
3. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd/PROJECT.md`
4. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd/ROADMAP.md`
5. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/ENGINEERING_GAP_LEDGER.md`
6. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/VALIDATOR_AND_CANONICAL_GAP_LEDGER.md`
7. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md`
8. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_CONFIRMATION_REPLAY_CONTRACT.md`
9. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_CONFIRMATION_REPLAY_COMPARISON_LEDGER.md`
10. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_HOMEOSTASIS_GATE_VERDICT.md`
11. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_REGIME_LOCALIZATION_LEDGER.md`
12. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_REGIME_ENTRANCE_CONDITION_NEXT_MOVE.md`
13. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_STARTUP_REALITY_NOTE.md`
14. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_STAGING_AND_PATH_AUDIT.md`
15. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/HARDWARE_LANE_BASELINE.md`
16. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_GEOMETRIC_ORGANISM_SYSTEM_SYNTHESIS.md`
17. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_PHYSICAL_ORGANISM_OPERATING_DOCTRINE.md`
18. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_ORGANISM_ENVIRONMENT_SPEC.md`
19. `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/AGENT_STARTUP_PROMPT.md`

## Mandatory Startup Checks

Run these before any new empirical action:

- `adb devices -l`
- `adb -s FY25013101C8 shell getprop ro.product.model`
- `adb -s FY25013101C8 shell getprop ro.hardware.vulkan`
- `adb -s FY25013101C8 shell getprop ro.hardware.egl`
- `adb -s FY25013101C8 shell 'ls -ld /data/local/tmp /data/local/tmp/SoC_runtime/workspace /data/local/tmp/dm3 /data/local/tmp/genesis_cli /data/local/tmp/dm3_runner /data/local/tmp/dm3/dm3_runner'`
- `adb -s FY25013101C8 shell dumpsys battery`
- `adb -s FY25013101C8 shell dumpsys thermalservice`

If these drift, localize that drift first.

## Exact Immediate Mission

The next live phase is:

`01.2.3.4.1.1.3.1.2.2`

Its job is not to rerun the full packet immediately.

Its job is to localize the start-state selector.

Minimum required battery:

1. `cpu_a` after explicit cleanup plus a long idle / cooldown window
2. `cpu_a` immediately after a retained low-regime packet
3. `cpu_a` immediately after a retained high-regime packet, if a high packet
   can be re-entered honestly

Retain before each anchor:

- battery snapshot
- thermal snapshot
- `/proc/loadavg`
- `dm3_runner` process snapshot
- binary hashes
- sidecar listing

The phase must end with one of two honest outcomes:

- strongest entrance-condition candidate retained
- exact failure to isolate the selector retained without widening claims

## What Must Stay Blocked

Do not reopen any of the following until the gate above is cleared:

- homeostasis batteries
- broader chamber-science language
- NPU execution claims
- explicit heterogeneous role partition
- source-built language for fresh RM10 lanes

## What To Avoid

- do not rerun the four-row packet first out of impatience
- do not substitute `/data/local/tmp/dm3/dm3_runner` for
  `/data/local/tmp/dm3_runner`
- do not treat `explicit_hash` validation as validator repair
- do not use runtime, heat, or GPU presence as signal by themselves
- do not let the organism metaphor become a pass narrative
- do not convert one promising packet into a branch verdict

## Recommended Skill Order

Use these first:

1. [$gpd-resume-work](/Users/prinivenpillay/.agents/skills/gpd-resume-work/SKILL.md)
2. [$gpd-health](/Users/prinivenpillay/.agents/skills/gpd-health/SKILL.md)
3. [$gpd-progress](/Users/prinivenpillay/.agents/skills/gpd-progress/SKILL.md)
4. [$gpd-plan-phase](/Users/prinivenpillay/.agents/skills/gpd-plan-phase/SKILL.md)
5. [$gpd-execute-phase](/Users/prinivenpillay/.agents/skills/gpd-execute-phase/SKILL.md)

Use `plan` and `execute` for `01.2.3.4.1.1.3.1.2.2`, not for a wider phase.

## Resume Rule

When in doubt, resume from the smallest honest question:

`what selects the high versus low regime before row cpu_a starts?`

Everything else is downstream.
