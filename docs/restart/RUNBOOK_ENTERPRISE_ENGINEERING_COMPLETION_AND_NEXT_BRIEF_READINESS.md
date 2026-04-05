# Runbook: Enterprise Engineering Completion And Next-Brief Readiness

Last refreshed: `2026-04-05`

## Purpose

Use this runbook to identify what remains incomplete in the RM10-primary branch
from an engineering point of view and to return a next-brief-ready system.

This runbook is not for broad new science.
It is for controlled hardening, gap exposure, and readiness.

## Governing Branch Facts

Start from these ceilings:

- `F1` governed Genesis CPU control is the branch scientific anchor
- `F2` accelerator-bearing residue is `unstable_feasibility`
- NPU is `ABSTAIN`
- explicit heterogeneous role partition is `ABSTAIN`
- Mac Genesis is still the only `source_built` authority lane

Any action that weakens those distinctions is a failure.

## Work Order

### Stage 1: Startup reality check

Run:

- `$gpd-resume-work`
- `$gpd-health`
- `$gpd-progress`
- `adb devices -l`
- `adb shell getprop ro.product.model`
- `adb shell getprop ro.hardware.vulkan`
- `adb shell 'ls -ld /data/local/tmp /data/local/tmp/dm3 /data/local/tmp/SoC_runtime/workspace'`

Record:

- device serial
- model
- graphics property
- execution roots present or missing
- any unexpected path drift

### Stage 2: Validator and canonical gap localization

Use:

- `PREBUILT_VS_SOURCE_BUILT_MATRIX.md`
- `RM10_EXECUTION_SURFACE_MANIFEST.md`
- `WITNESS_LANE_REPAIR_NOTE.md`
- `RM10_F1_ANCHOR_DOSSIER.md`

Answer:

- what exact validator failure remains on fresh RM10 bundles
- which canonical target is still in dispute
- which paths can be compared honestly and which cannot

Output:

- `VALIDATOR_AND_CANONICAL_GAP_LEDGER.md`

### Stage 3: Source-vs-prebuilt boundary hardening

Confirm for every live lane:

- `authority_status`
- `build_class`
- execution provenance
- what claims the lane may and may not support

Do not let any report say "works on RM10" without the build class next to it.

Output:

- `SOURCE_VS_PREBUILT_BOUNDARY_NOTE.md`

### Stage 4: Governed `F1` CPU productionization

Treat `F1` as the only current governed instrument.

Define:

- which first science battery rows should run on `F1`
- what preconditions each row needs
- what receipt and manifest completeness looks like
- what counts as a pass, fail, or abstain for each row

Output:

- `F1_FIRST_BATTERY_ROW_SELECTION.md`
- `F1_SERIOUS_RUN_CHECKLIST.md`

### Stage 5: Residue `F2` outlier-localization readiness

Restrict this stage to one question:

- why does the exact residue CPU/GPU harmonic family still show outlier behavior
  under otherwise comparable identity capture?

Do not widen this into bridge progress.

Required captures:

- exact command
- cwd
- env
- run identity
- telemetry
- receipts
- outcome comparison table

Output:

- `F2_OUTLIER_LOCALIZATION_PLAN.md`
- `F2_REQUIRED_CAPTURE_MATRIX.md`

### Stage 6: NPU assist truth boundary

Treat NPU as inventory-only unless a callable, receiptable assist path exists.

Questions:

- what user-space path, if any, is callable now?
- what would make it more than inventory?
- what exact output would count as a bounded assist rather than opaque
  substitution?

Output:

- `NPU_ASSIST_TRUTH_BOUNDARY.md`

### Stage 7: Heterogeneous handoff prerequisites

Do not execute explicit heterogeneous claims until the handoff surface exists.

Define required artifacts for any future heterogeneous claim:

- pre-handoff artifact
- handoff declaration
- post-handoff artifact
- per-lane ownership of observable segments
- failure localization rule

Output:

- `HETEROGENEOUS_HANDOFF_REQUIREMENTS_NOTE.md`

### Stage 8: Logging and receipt hardening

Every serious run must retain:

- exact command
- exact cwd
- env manifest
- device identity
- run kind
- authority status
- build class
- artifact root
- receipt expectation
- thermal pre and post snapshots
- checkpoint identity
- Comet online key or offline bundle path

Output:

- `RUN_IDENTITY_AND_RECEIPT_AUDIT.md`
- `COMET_AND_LEDGER_HARDENING_NOTE.md`

### Stage 9: Next-brief readiness freeze

Before handoff, write:

- what is clean now
- what is still incomplete
- what should happen next
- what should explicitly not happen next

Required outputs:

- `NEXT_BRIEF_READINESS_MEMO.md`
- `NEXT_BOUNDED_ENGINEERING_MOVE.md`
- `STARTUP_READING_ORDER_FREEZE.md`

## Enterprise-Grade Completion Checklist

The branch is ready for the next brief only if:

- startup docs are current
- operating docs are current
- authority and build-class language is consistent across active surfaces
- engineering gaps are explicit and prioritized
- `F1` is ready for governed science rows
- `F2` is fenced as residue classification work only
- NPU abstain is justified, not implied
- heterogeneous abstain is justified, not implied
- logging and receipt rules are explicit enough that a new operator cannot
  silently drift

## Hard Stops

Stop and write a blocker note if:

- you cannot separate validator drift from build-class drift
- a lane cannot be described without contradictory authority language
- the only remaining path requires unrecovered code while still being described
  as execution rather than redevelopment
- later docs require more trust than current evidence can bear

## Final Return

This runbook is complete only when the next operator can begin work without:

- oral history
- implicit branch lore
- guesswork about authority
- guesswork about what still needs engineering
