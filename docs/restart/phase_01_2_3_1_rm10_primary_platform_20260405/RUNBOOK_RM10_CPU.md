# Runbook RM10 CPU

## Goal

Use RM10 CPU as the first serious branch control lane.

## Preconditions

- ADB device visible
- power connected
- thermal status nominal
- branch governance pack written
- preflight bundle captured

## Execution Surface

- execute from `/data/local/tmp`
- treat shared storage as ingress only
- preserve exact `cwd` and `PATH` in the run ledger

## First Branch CPU Pattern

1. confirm device identity and preflight snapshots
2. choose the narrowest receiptable CPU control observable
3. run one bounded CPU pass
4. capture receipts, stdout or stderr, thermal snapshots, and working directory
5. classify `PASS`, `FAIL`, or `ABSTAIN`

## Candidate Control Family

Prefer the governed Genesis or SoC runtime surface that is already live on the
device over the retired bundled `G2` family.

## Required Captures

- exact command
- `cwd`
- `PATH` or wrapper surface
- artifact root
- battery and thermal snapshots before and after

## CPU Pass Standard

- `PASS`: the chosen control observable runs and is receiptable under the
  branch contract
- `FAIL`: the control lane drifts, cannot receipt, or loses reproducibility
- `ABSTAIN`: a path exists, but the current observable is not clean enough to
  compare honestly

## Hard Stops

- current device identity no longer matches the expected RM10
- execution drifts away from `/data/local/tmp`
- thermal state leaves nominal and outputs drift
- control observable depends on the retired bundled `G2` route story
