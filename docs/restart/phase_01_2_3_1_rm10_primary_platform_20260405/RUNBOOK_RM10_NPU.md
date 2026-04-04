# Runbook RM10 NPU

## Goal

Answer the narrow branch question:

`Is there any bounded, receiptable NPU or DSP-assisted role worth testing now?`

## What Is Confirmed

- `nsp*` thermal channels exist
- `cdsp` appears in cooling-device output
- the device clearly exposes accelerator-adjacent telemetry

## What Is Not Confirmed

- a callable user-space NPU path
- an SDK or runtime usable from the branch environment
- comparability against the CPU control observable

## Allowed First Move

Probe only for bounded assist roles such as projection, tagging, or another
named substage. Whole-pipeline authority claims are forbidden.

## Verdict Standard

- `PASS`: a bounded assist role is callable, receiptable, and comparable
- `FAIL`: no usable user-space path exists
- `ABSTAIN`: a path or hint exists, but outputs are not yet receiptable or
  comparable

## Required Captures

- exact probe commands
- libraries, services, or runtime hints observed
- artifact paths for positive or negative evidence

## Hard Stops

- only vendor daemons or telemetry are visible
- outputs cannot be preserved under the branch ledger rules
- the role can only be described vaguely
