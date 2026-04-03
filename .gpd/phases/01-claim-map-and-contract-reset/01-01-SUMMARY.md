# Phase 01-01 Summary

## Objective

Build the first source-backed registry for manifesto `Txx` claims and record the real legacy entrypoints that can seed restart batteries.

## Completed Outputs

- added `docs/restart/LEGACY_BATTERY_ENTRYPOINTS.md`
- tightened `docs/recovery/TEST_REFERENCE_STATUS.md`
- tightened `docs/restart/TRAINING_DOC_HYPOTHESES.md`

## What Changed

### Legacy entrypoints are now explicit

The restart now has one concrete inventory of recoverable battery surfaces across the two main surviving strata:

- October exact-rational substrate
- Genesis deterministic governance wrapper

The inventory distinguishes:

- micro, medium, and long batteries
- support and governance commands
- receipt surfaces that matter
- what is safe to bring up first on RM10 Pro

### The `Txx` registry is more skeptical

The registry now distinguishes:

- mapped families
- collapsed families
- partially mapped claims
- unmapped claims

This reduces the temptation to cite manifesto labels as if the one-to-one executable registry already existed.

### The training-doc frame is tighter

The hypothesis frame now states explicitly that the current source-backed evidence covers:

- the exact-rational substrate
- the deterministic replay and governance wrapper

and does not cover:

- the later hybrid transformer / HRM / scar-engine layer

## Strongest Surviving Evidence

- October scripts and proof surfaces back geometry, lift, DEQ, resonance-side artifacts, and gate summaries
- Genesis CLI and protocol back deterministic replay, lineage batch replay, ledgers, hashes, logs, and audit summaries

## Still Open

- no one-to-one `T01-T236` executable registry exists
- holography, masked-boundary recovery, gauge-like claims, and non-bitwise equivalence receipts remain weak or unmapped
- the newer hybrid DM3 layer still survives only as compiled residue, not source

## Carry-Forward Rule

Downstream planning may cite only the collapsed or mapped families now recorded in `TEST_REFERENCE_STATUS.md`.
Anything outside that registry remains hypothesis material.

```yaml
gpd_return:
  status: completed
  files_written:
    - "docs/restart/LEGACY_BATTERY_ENTRYPOINTS.md"
    - "docs/recovery/TEST_REFERENCE_STATUS.md"
    - "docs/restart/TRAINING_DOC_HYPOTHESES.md"
    - ".gpd/phases/01-claim-map-and-contract-reset/01-01-SUMMARY.md"
  issues:
    - "No one-to-one T01-T236 executable registry exists yet."
    - "The later hybrid transformer/HRM layer remains source-missing."
  next_actions:
    - "$gpd-execute-phase 01"
    - "$gpd-show-phase 01"
```
