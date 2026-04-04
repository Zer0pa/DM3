# Heterogeneous Compute Dossier

## Current Branch Result

Current first-pass heterogeneous verdict: `ABSTAIN`

## Why It Is Not A Fail

- the attached device clearly exposes GPU and accelerator-adjacent surfaces
- there is a plausible future path to bounded split testing
- the branch has not yet disproved the usefulness of role partition

## Why It Is Not A Pass

- no common callable GPU or NPU comparison path was established
- no handoff boundary was logged on a live mixed run
- no mixed run preserved the CPU control observable

## Meaning

The first pass teaches that heterogeneous compute is scientifically worth
keeping alive on this branch, but not promotable yet.

## Preconditions For Promotion

- explicit CPU control observable
- explicit GPU or bounded NPU assist path
- explicit handoff artifact
- explicit drift localization

## Most Useful Next Step

Find the smallest GPU or bounded assist derivative that preserves the same
control observable as the CPU pass.
