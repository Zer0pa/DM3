# Multi-Machine Handoff Rules

Last refreshed: `2026-04-05`

## Scope

These rules govern operator-to-operator and machine-to-machine handoff on
`hypothesis/rm10-primary-platform-heterogeneous-learning`.

They freeze the current truth floor:

- `F1` governed Genesis CPU control is `PASS` as the only trustworthy
  branch-local scientific anchor.
- the current governed accelerator bridge on `F1` is closed.
- `F2` is separate residue `PASS` only at callable ceiling with
  `unstable_feasibility`.
- Mac Genesis remains the only `source_built` authority lane.
- fresh RM10 Genesis lanes remain prebuilt-backed.
- NPU and explicit heterogeneous work remain `ABSTAIN`.

## Enforceable Now

### 1. No handoff without a handoff packet

Before another operator or machine resumes, cites, or compares a run, the repo
must retain:

- branch name
- commit SHA
- `git status --short` output
- run artifact root
- `run_identity.json`
- exact command and working directory capture
- environment capture
- device serial and model
- binary hash and any residue asset hashes
- last checkpoint file set
- latest battery and thermal snapshots
- Comet packet

If any of those are missing, the next operator starts a new `run_id` or records
an abstain. They do not inherit the prior run as if continuity were proven.

### 2. Resume is narrow

A run may resume across operators or machines only when all of the following
remain unchanged:

- branch question
- `observable_family`
- `build_class`
- `device_lane`
- `compute_lane`
- command semantics
- `cwd` semantics
- binary hash
- residue asset hashes when applicable

If any of those change, start a new `run_id`.

### 3. Lane changes are never implicit

The following always start a new `run_id` and require a closing checkpoint on
the prior leg plus a fresh entry gate on the next leg:

- CPU to GPU-backed
- GPU-backed to CPU
- CPU or GPU-backed to NPU
- any single-lane path to explicit heterogeneous execution
- Mac support lane to RM10 device lane, or the reverse, when the comparison
  question changes

### 4. Device and thermal continuity travel with the run

No operator may resume a cited run unless the handoff packet includes:

- the last retained battery snapshot
- the last retained thermal snapshot
- the last retained memory snapshot for serious or cross-lane work
- checkpoint ID and parent
- explicit statement of whether the prior leg ended `PASS`, `FAIL`, `ABSTAIN`,
  or `BLOCKED`

Warm silicon without a retained checkpoint is not a handoff. It is a broken
run.

### 5. Repo mirrors outrank local machine lore

- Device-local outputs under `/data/local/tmp` do not survive as handoff
  evidence unless mirrored into the repo.
- `/tmp` staging on a host does not survive as handoff evidence unless mirrored
  into the repo.
- New packets must carry repo-relative artifact paths alongside any absolute
  path captured during the run.

### 6. Heterogeneous work stays closed until the artifact surface exists

No machine handoff may describe work as explicit heterogeneous execution unless
the packet retains, on one common observable family:

- a pre-handoff artifact
- a handoff declaration naming the transform or ownership boundary
- a post-handoff artifact
- explicit stage ownership
- a failure-localization note

Current opaque accelerator use inside one residue binary does not meet that
standard.

## Current Handoff Gaps

### Branch cleanliness must be explicit

The branch may contain live documentation or handoff edits at the moment of
handoff. That is why every handoff packet must capture the actual
`git status --short` output instead of assuming a clean tree.

### `F1` is scientifically clean but not yet handoff-hard

`artifacts/phase_01_2_3_2_f1_anchor_20260405/` proves the governed anchor and
the live bridge-closed result, but it does not retain the checkpoint packet or
Comet packet needed for a fresh operator to inherit that run without guesswork.

### `F2` is callable but not yet handoff-hard

`artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/` proves the residue
family is real and unstable, but it does not retain per-run identity packets,
checkpoint files, or a comparison ledger. A new machine cannot localize the
next outlier honestly from the current packet alone.

### Explicit heterogeneous handoff remains absent

No current branch artifact retains a same-family pre-handoff and post-handoff
pair. That is why heterogeneous work remains `ABSTAIN`, and it must stay that
way until the artifact boundary exists.

## Not Yet Enforceable

These are future goals, not current handoff gates:

- RM10 source-built parity across machines
- a same-family accelerator-bearing governed `F1` surface
- a receiptable NPU assist handoff

The branch should not pretend those gaps are solved by stronger wording.

## Highest-Priority Gaps

1. The next operator cannot safely inherit `01.2.3.2` as a hardened receipts
   precedent because the checkpoint and Comet packet are incomplete.
2. The next `F2` diagnostic would be untrustworthy across machines without
   per-run identity packets and an explicit comparison ledger.
3. Any claim of explicit heterogeneous role partition remains invalid until one
   common-family handoff packet localizes pre-state, post-state, and stage
   ownership.
