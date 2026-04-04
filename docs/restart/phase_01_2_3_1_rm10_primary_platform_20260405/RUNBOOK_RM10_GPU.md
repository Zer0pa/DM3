# Runbook RM10 GPU

## Goal

Probe GPU feasibility early on this branch without overstating readiness.

## What Is Confirmed

- `adreno` EGL and Vulkan indicators are present
- `/dev/kgsl-3d0` is visible
- GPU thermal channels are exposed

## What Is Not Confirmed

- a user-space compute path for the branch control observable
- deterministic parity rules
- a stable comparable GPU receipt surface

## Allowed First Move

One bounded feasibility probe tied to the same observable family used by the
CPU control lane, or an explicit abstain if no such probe can be defined.

## Required Questions

1. Is there a callable user-space path?
2. Does it preserve the same observable family?
3. Can its outputs be receipted and compared?

If any answer is no, record `ABSTAIN` or `FAIL`.

## Required Captures

- exact probe command
- runtime surface used
- thermal snapshots
- artifact paths
- explicit parity or non-parity note

## GPU Verdict Standard

- `PASS`: callable path plus explicit comparable observable and receipt surface
- `FAIL`: callable path exists but destroys comparability or interpretability
- `ABSTAIN`: hardware and runtime indicators are real, but no honest comparison
  path exists yet

## Hard Stops

- GPU feasibility depends on unrecovered DM3 code
- parity is undefined
- the only result is "hardware exists"
