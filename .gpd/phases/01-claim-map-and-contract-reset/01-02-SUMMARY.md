# Phase 01-02 Summary

## Objective

Freeze the skeptical carry-forward contract so the restart cannot quietly drift
back into folklore while execution begins.

## Completed Outputs

- added `docs/restart/PHASE_01_CONTRACT_FREEZE.md`
- added `docs/restart/RESTART_PRD.md`
- added `docs/restart/BATTERY_SCHEDULE.md`
- added `docs/restart/RUNBOOK_MAC_BASELINE.md`
- added `docs/restart/RUNBOOK_RM10_CPU.md`
- added `docs/restart/RUNBOOK_RM10_GPU.md`
- added `docs/restart/RUNBOOK_RM10_NPU_FEASIBILITY.md`
- added `docs/restart/RUNBOOK_HETEROGENEOUS_COMPUTE.md`
- tightened `docs/restart/GPD_OPERATING_MAP.md`
- tightened `docs/restart/HYPOTHESIS_BRANCH_REGISTER.md`
- added `artifacts/mac_replay/ledger.md`
- added `artifacts/rm10_replay/ledger.md`
- added `artifacts/rm10_replay/legacy_findings.md`

## What Changed

### The restart now has a frozen doctrine

Phase 01 now says plainly:

- mapped claims outrank prose
- hypothesis branches require a changed scientific story
- batteries and hardware lanes are not branches by default
- RM10 CPU is the first safe phone lane
- RM10 GPU is governed engineering, not inherited authority
- RM10 NPU remains feasibility-only until a usable path is proven

### The authority metric is now explicit

The PRD and battery schedule move the restart out of vague "replay the thing"
language and into a tighter standard:

- traceable command path
- preserved receipts
- replayability
- comparability
- discipline against unmapped claim smuggling

### Execution started during the same pass

Phase 01 did not stop at doctrine writing.
The repo now carries fresh receipts showing:

- Mac Genesis `G-01` and `G-02` are stable
- Mac October smoke passes
- fresh ADB-shell RM10 replay works from `/data/local/tmp`
- the phone storage split is a real engineering fact: shared storage is
  `noexec`, executable staging belongs under `/data/local/tmp`

## Strongest Surviving Evidence

- fresh Mac Genesis `G-01` and `G-02` agree exactly with each other at
  `verify = e894...` and `solve = 62897...`
- fresh Mac October smoke passes with clean gate outputs
- fresh RM10 ADB-shell replay now works in two lanes:
  `SoC_runtime/workspace` and the raw `snic_workspace_a83f` workspace after a
  reversible shebang adaptation
- historical RM10 `T1-T7` phone receipts still show exact parity with the fresh
  Mac Genesis surface

## Still Open

- the documented Genesis `verify.json` canonical is stale against the live Mac
  and historical RM10 parity surface
- the current phone `genesis_cli` validator rejects both of its own fresh
  bundles under default validation and also rejects the historical Mac-parity
  run on `verify.json`
- the fresh phone lanes currently depend on prebuilt device binaries and a
  cargo stub, so they are executable but not yet full source-build parity
- the later hybrid DM3 source tree remains missing

## Carry-Forward Rule

Phase 01 is complete, but the acceptance gate is not.
The restart must now move into a fix loop around:

- canonical-hash governance
- phone lane acceptance
- source-build versus prebuilt-lane separation

No later pass is allowed to convert these mixed signals into a narrative win.

```yaml
gpd_return:
  status: completed
  files_written:
    - "docs/restart/PHASE_01_CONTRACT_FREEZE.md"
    - "docs/restart/RESTART_PRD.md"
    - "docs/restart/BATTERY_SCHEDULE.md"
    - "docs/restart/RUNBOOK_MAC_BASELINE.md"
    - "docs/restart/RUNBOOK_RM10_CPU.md"
    - "docs/restart/RUNBOOK_RM10_GPU.md"
    - "docs/restart/RUNBOOK_RM10_NPU_FEASIBILITY.md"
    - "docs/restart/RUNBOOK_HETEROGENEOUS_COMPUTE.md"
    - "docs/restart/GPD_OPERATING_MAP.md"
    - "docs/restart/HYPOTHESIS_BRANCH_REGISTER.md"
    - "artifacts/mac_replay/ledger.md"
    - "artifacts/rm10_replay/ledger.md"
    - "artifacts/rm10_replay/legacy_findings.md"
    - ".gpd/phases/01-claim-map-and-contract-reset/01-02-SUMMARY.md"
  issues:
    - "Genesis verify.json canonical governance is stale against the live Mac and historical RM10 parity surface."
    - "Fresh RM10 replay is executable but not yet accepted by the default device validator."
    - "Fresh RM10 replay currently depends on prebuilt device binaries and a cargo stub."
  next_actions:
    - "$gpd-plan-phase 02"
    - "$gpd-plan-phase 04"
    - "$gpd-verify-work 01"
```
