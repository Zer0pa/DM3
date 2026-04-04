# Readiness Ceilings And Operating Rules

## Purpose

This document merges the current post-`01.2.3` engineering ceiling so later
hardware work does not outrun the authority metric.

## Serious-Run Law

Any serious run must preserve:

- exact command text
- runtime identity packet
- receipt root
- checkpoint policy
- Comet manifest plus experiment key or offline bundle path
- pre/post battery and thermal telemetry when device-side
- explicit `authority_status`, `evidence_surface`, `build_class`,
  `phase_outcome`, and `route_outcome`

## Compute Discipline

- maximize compute honestly, not theatrically
- on RM10 CPU, target the `>=70%` total CPU utilization posture when the
  workload meaningfully permits it
- do not create meaningless heat or change the scientific story to satisfy a
  utilization target

## Later-Lane Status

| Lane | Current status | What must be true before it changes |
| --- | --- | --- |
| RM10 GPU | `not ready now` | a different already-live CPU reference observable exists under the governed witness floor, the same observable can be receipted on RM10, and deterministic reduction / serialization rules are explicit |
| RM10 NPU | `feasibility-only` | a user-space callable path exists, the role is bounded, inputs and outputs are receiptable, and comparison against a CPU-governed baseline is possible |
| Heterogeneous embodiment | `premature` | a single-lane CPU reference observable is already live, GPU parity has already passed on that same observable, and NPU feasibility is already bounded |

## What Does Not Count As Progress

- another same-binary smoke receipt
- richer strings or task names with no callable routed surface
- witness-floor cleanup narrated as bundled `G2` recovery
- hardware presence narrated as readiness
- substitute code or wrapper invention narrated as archaeology

## Allowed Next Engineering Work

- launcher-adjacency provenance classification
- explicit redevelopment-boundary control
- Genesis default-validator reconciliation
- source-built parity clarification
- bounded GPU, NPU, or heterogeneous prep only within the current ceiling

## Canonical Source Docs

- `/Users/Zer0pa/DM3/restart/docs/restart/phase_01_2_3_execution_prep_20260404/DOCTRINE_LOCK_MEMO.md`
- `/Users/Zer0pa/DM3/restart/docs/restart/phase_01_2_3_execution_prep_20260404/BLOCKER_MATRIX_AND_KILL_CRITERIA.md`
- `/Users/Zer0pa/DM3/restart/docs/restart/phase_01_2_3_execution_prep_20260404/RUNBOOK_RM10_GPU_PARITY.md`
- `/Users/Zer0pa/DM3/restart/docs/restart/phase_01_2_3_execution_prep_20260404/RUNBOOK_RM10_NPU_FEASIBILITY.md`
- `/Users/Zer0pa/DM3/restart/docs/restart/phase_01_2_3_execution_prep_20260404/RUNBOOK_HETEROGENEOUS_EMBODIMENT.md`
