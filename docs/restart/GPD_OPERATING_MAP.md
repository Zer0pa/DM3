# DM3 RM10 Branch GPD Operating Map

## Purpose

This document maps the available GPD workflow to the RM10-primary hypothesis
branch.
It answers two questions:

1. Is the branch already a real GPD project?
2. Which commands and skills should govern cleanup, readiness hardening,
   bounded diagnostics, and later science execution?

## Current Status

The branch is already a valid GPD project in:

- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd`

Verified state:

- `state.json` present
- `STATE.md`, `PROJECT.md`, `ROADMAP.md`, `REQUIREMENTS.md`, `CONVENTIONS.md` present
- `gpd state validate` passes
- `gpd health` is expected to pass structural checks aside from future-phase
  directory warnings when those phases are intentionally not yet instantiated

Current runtime posture:

- `model_profile = review`
- `research_mode = explore`
- `autonomy = balanced`
- `execution.review_cadence = adaptive`
- `parallelization = true`

This is the right default for the current branch stage:

- `review` keeps falsification and anti-proxy discipline active
- `explore` allows branching and alternative-hypothesis investigation

## The Short Answer

Use GPD in three layers:

1. **Mainline roadmap**
   The parent-branch path that remains the control line
2. **This hypothesis branch**
   The RM10-primary, heterogeneity-early alternative line with its own `.gpd`
   state and evidence pack
3. **Branch execution surfaces**
   Governed `F1`, residue `F2`, inventory-only NPU, and abstained
   heterogeneous work kept separate by build class and authority ceiling

## Current Branch Ground Truth

- current completed phase: `01.2.3.2`
- governed branch scientific anchor: RM10 `F1` Genesis CPU control
- current next move: one narrow `F2` outlier-localization diagnostic under
  locked identity capture
- no current same-family governed accelerator bridge exists on the live
  `genesis_cli`
- no receiptable NPU assist path exists yet
- no explicit heterogeneous handoff artifact exists yet

Do not plan or execute around older branch assumptions that contradict those
facts.

## Startup Command Order

For any fresh takeover on this branch:

1. `$gpd-resume-work`
2. `$gpd-health`
3. `$gpd-progress`
4. inspect `.gpd/STATE.md`
5. inspect the current `01.2.3.2` branch pack

Only after that:

6. use [$gpd-plan-phase](~/.agents/skills/gpd-plan-phase/SKILL.md) if a new cleanup or engineering-completion phase needs to be formalized
7. use [$gpd-execute-phase](~/.agents/skills/gpd-execute-phase/SKILL.md) only after the execution boundary is current and the cleanup surface is truthful

## Current Branch Reading Priority

Trust these first:

1. `.gpd/STATE.md`
2. `briefing-pack-dm3-rm10-bridge-phase-01-2-3-2-10doc-20260405/`
3. `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/`
4. `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md`
5. `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`
6. current startup / PRD / runbooks in `docs/restart/`

Treat older `01.2.3.1` branch packs and mainline long-horizon docs as history
unless current branch state promotes them.

## Which GPD Skills Matter Now

### Bootstrap and branch restore

- `$gpd-map-research`
  Use only if the evidence map changes materially enough that the branch needs a
  fresh structured map.
- `$gpd-help`
  Full command reference.
- `$gpd-health`
  Structural sanity check before or after major updates.
- `$gpd-resume-work`
  First recovery surface for a new operator.

### Steering and state awareness

- `$gpd-progress`
  Fast project status.
- `$gpd-suggest-next`
  Best next action from live state.
- `$gpd-show-phase <N>`
  Inspect one phase in detail.
- `$gpd-decisions`
  Review accumulated decisions.

### Planning the next bounded move

- `$gpd-discuss-phase <N>`
  Clarify gray areas before planning.
- `$gpd-plan-phase <N>`
  Create executable plans for a cleanup, readiness, or bounded diagnostic phase.
- `$gpd-list-phase-assumptions <N>`
  Surface what the planner is assuming before it writes the plan.
- `$gpd-add-phase <description>`
  Add a new phase at the end of the roadmap.
- `$gpd-insert-phase <after> <description>`
  Insert urgent decimal phases when a missing branch-hardening step is
  discovered midstream.

### Execution and checking

- `$gpd-execute-phase <N>`
  Execute only after the cleanup surface and execution boundary are truthful.
- `$gpd-verify-work <N>`
  Verify that the phase actually established what it claimed.
- `$gpd-debug`
  Diagnose blocker causes after verification or failed runs.
- `$gpd-regression-check`
  Re-check previously established claims after changes.
- `$gpd-validate-conventions`
  Catch convention drift.
- `$gpd-quick`
  Small one-off checks without opening a whole roadmap phase.

### Hypotheses and alternatives

- `$gpd-branch-hypothesis <description>`
  Create a real hypothesis branch with isolated research state.
- `$gpd-compare-branches`
  Compare hypothesis branches against each other and against the parent branch.
- `$gpd-parameter-sweep`
  Use for parameter changes that do not justify a separate hypothesis branch.

### Handoffs and continuity

- `$gpd-pause-work`
  Create a handoff file and preserve session state.
- `$gpd-resume-work`
  Reconstruct where the project was.
- `$gpd-sync-state`
  Reconcile markdown state and JSON state if they drift.
- `$gpd-compact-state`
  Keep `STATE.md` readable.

### Backlog capture

- `$gpd-add-todo`
  Capture ideas without derailing the current phase.
- `$gpd-check-todos`
  Review and route stored tasks.

### Later-stage publication commands

These are real, but not active now:

- `$gpd-write-paper`
- `$gpd-peer-review`
- `$gpd-respond-to-referees`
- `$gpd-arxiv-submission`
- `$gpd-export`

## Full Skill Inventory Reviewed

The broad installed skill surface still exists, but the branch does not need all
of it for startup. Prefer the smallest set that restores truthful state first.

### Initialization, mapping, and navigation

- `$gpd-help`
- `$gpd-health`
- `$gpd-progress`
- `$gpd-suggest-next`
- `$gpd-show-phase`
- `$gpd-graph`
- `$gpd-map-research`
- `$gpd-new-project`
- `$gpd-new-milestone`

### Planning, discovery, and roadmap surgery

- `$gpd-discuss-phase`
- `$gpd-research-phase`
- `$gpd-discover`
- `$gpd-list-phase-assumptions`
- `$gpd-plan-phase`
- `$gpd-add-phase`
- `$gpd-insert-phase`
- `$gpd-remove-phase`
- `$gpd-revise-phase`
- `$gpd-merge-phases`
- `$gpd-plan-milestone-gaps`

### Execution and technical investigation

- `$gpd-execute-phase`
- `$gpd-quick`
- `$gpd-derive-equation`
- `$gpd-dimensional-analysis`
- `$gpd-limiting-cases`
- `$gpd-numerical-convergence`
- `$gpd-parameter-sweep`
- `$gpd-sensitivity-analysis`
- `$gpd-compare-experiment`
- `$gpd-compare-results`
- `$gpd-error-propagation`

### Verification, regression, and debugging

- `$gpd-verify-work`
- `$gpd-debug`
- `$gpd-regression-check`
- `$gpd-validate-conventions`
- `$gpd-error-patterns`

### Branching, backlog, and continuity

- `$gpd-branch-hypothesis`
- `$gpd-compare-branches`
- `$gpd-decisions`
- `$gpd-record-insight`
- `$gpd-add-todo`
- `$gpd-check-todos`
- `$gpd-pause-work`
- `$gpd-resume-work`
- `$gpd-compact-state`
- `$gpd-sync-state`
- `$gpd-undo`
- `$gpd-update`
- `$gpd-settings`
- `$gpd-set-profile`
- `$gpd-reapply-patches`

### Audit, milestone, and completion

- `$gpd-audit-milestone`
- `$gpd-complete-milestone`

### Communication, export, and publication

- `$gpd-explain`
- `$gpd-export`
- `$gpd-slides`
- `$gpd-write-paper`
- `$gpd-peer-review`
- `$gpd-respond-to-referees`
- `$gpd-arxiv-submission`

For DM3 right now, only a subset should be active.
The rest are deferred intentionally until the project has real executed plans and verified results.

## Command Path For DM3 Right Now

This is the recommended mainline command order for the restart:

1. `$gpd-health`
2. `$gpd-progress`
3. `$gpd-discuss-phase 01`
4. `$gpd-plan-phase 01`
5. `$gpd-execute-phase 01`
6. `$gpd-verify-work 01`

After Phase 1 produces a real claim map and pivot boundary:

7. `$gpd-branch-hypothesis <description>` for genuine alternative scientific stories
8. `$gpd-plan-phase <current>` on those branches
9. `$gpd-execute-phase <current>` on those branches
10. `$gpd-compare-branches`

## What Deserves A Hypothesis Branch

Create a hypothesis branch when the alternative changes the scientific story or architectural identity.

Examples that deserve branching:

- DM3 is primarily an exact geometric artifact and indexing substrate
- DM3 is a true field-computation manifold with unique dynamical value
- transformer logic belongs only at the boundary
- a stronger model at the center is necessary
- a dense transformer on every node is necessary
- training must remain relaxation-first versus allowing hybrid gradient-assisted regimes

Do **not** branch for:

- different seeds
- different batch sizes
- different wave lengths
- different battery durations
- simple hyperparameter or threshold changes

Those belong in run matrices, parameter sweeps, or battery ledgers.

## What Deserves A Decimal Phase Instead

Use `$gpd-insert-phase` when the roadmap is missing a necessary step in the mainline.

Examples:

- a missing formal definition of the authority metric
- an urgent convergence study needed before device replay
- a newly discovered source-mapping gap that blocks the next phase

## What Belongs In Batteries Rather Than In Branches

The following are execution classes, not worldviews:

- micro-batteries
- long batteries
- Mac vs RM10 replay lanes
- CPU vs GPU vs NPU availability tests
- resume and checkpoint identity tests
- streaming-window size tests

These should be tracked as structured runs under the same hypothesis unless they change the scientific explanation being tested.

## DM3-Specific Hypothesis Policy

The project should keep one mainline and a small number of serious side
branches.

Mainline:

- source-backed falsification path
- authority metric
- minimal battery
- RM10 Pro device lane

Side branches:

- only for incompatible architectural or scientific interpretations

This keeps the project from collapsing into either:

- one rigid story that cannot pivot
- or many branches with no common authority metric

## Candidate Branch Set

The current candidate branch set is tracked in:

- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md`

That register includes:

- candidate hypotheses
- battery classes
- device lanes
- expected outputs
- honest failure signals
- likely pivots

## Long-Running PRD Precursor

The branch now has an explicit cleanup and engineering-completion PRD in:

- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/ENTERPRISE_DRIFT_ELIMINATION_AND_ENGINEERING_COMPLETION_PRD.md`

Do not replace that PRD with a softer prose surface.
If a later long-running PRD is needed, freeze these ingredients first:

- branchable hypothesis set
- authority metric
- battery hierarchy
- input and output contracts
- allowed pivots
- kill criteria
- device-lane governance

Once those are stable, the PRD can be written without becoming fiction.

## Working Rule

For DM3, GPD should be used to keep one falsifiable mainline alive while allowing a small number of explicit architectural side branches.
The branch is the scientific story.
The battery is the run class.
Do not confuse them.
