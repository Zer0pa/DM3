# Kill Criteria And Stopping Rules

## Purpose

This document defines when the RM10-primary branch must pause, abstain, fail a
lane, or stop a line of work entirely.

The branch exists to test a risky alternative programme.
That only works if failure is explicit and early.

## Outcome Ladder

Use these outcomes exactly:

- `continue`
- `pause_and_checkpoint`
- `abstain`
- `fail_lane`
- `stop_branch_line`

The branch should escalate to a stronger stop when a weaker one no longer
protects interpretability.

## Global Kill Criteria

| Condition | Why it matters | Required action |
| --- | --- | --- |
| no common observable survives across the lanes being compared | comparison authority is lost | `abstain` for the affected accelerator or heterogeneous lane |
| exact command, cwd, environment, or build class drifts without being re-declared | staging drift destroys comparability | `stop_branch_line` for that comparison and restart under a new run ID if still justified |
| receipt capture is missing on a path that was supposed to emit one | the branch loses interpretable evidence | `fail_lane` or `blocked` outcome; do not promote the run |
| thermal activity grows without a comparable observable or receipt | heat is replacing evidence | `stop_branch_line` |
| continuing would require unrecovered proprietary or missing DM3 code while still being called branch execution | the work has crossed into redevelopment | `stop_branch_line` and write redevelopment boundary explicitly |
| old labels or history residue start driving present-tense conclusions | clue mining has turned into authority inflation | `stop_branch_line` and demote the claim to ambiguity |

## Lane-Specific Stop Rules

### RM10 CPU

Stop the CPU control line if:

- the current CPU command path cannot be made receipt-backed
- the path changes between runs in a way that destroys comparison
- the branch starts narrating a `prebuilt_stub` or `mixed_prebuilt_backed`
  lane as source-built parity
- unresolved validator drift makes longer runs add ambiguity instead of signal

### RM10 GPU

Stop or abstain if:

- the only positive fact is `/dev/kgsl-3d0` visibility
- the CPU reference observable is not already explicit
- the GPU path changes the observable family
- comparison fields cannot be normalized or retained
- opaque vendor behavior becomes the only explanation for the result

### RM10 NPU or DSP-Adjacent

Stop or abstain if:

- only `nsp*` telemetry or DSP-adjacent presence is visible
- no callable user-space surface exists
- the role drifts from bounded assist into opaque substitution
- inputs or outputs cannot be receipted

### RM10 Heterogeneous

Stop or abstain if:

- the CPU, GPU, and NPU handoff cannot be named explicitly
- the mixed path changes the scientific question
- drift cannot be localized to one side of the split
- the mixed path exists only because no single-lane reference is stable

### History Mining

Stop mining escalation if:

- the next claim depends only on a residue label
- the mining output no longer sharpens a future engineering or battery choice
- the work begins preserving folklore rather than constraining later plans

## Interpretability-Loss Rules

These are immediate branch-line killers:

1. comparison becomes cross-observable rather than same-observable
2. checkpoint identity no longer proves continuity
3. the artifact set is insufficient for later review
4. the lane is only reachable through hidden manual intervention

When any of these happen, do not "push through".
Stop and write the blocker.

## Repetition Caps

To prevent theatre-by-retry:

- no more than `2` repeated setup probes for the same unresolved blocker
- no more than `1` feasibility probe per lane before a written review if the
  blocker is unchanged
- no more than `1` serious attempt on a lane/observable pair before pausing for
  review when the outcome is `FAIL`, `ABSTAIN`, or `BLOCKED`

If the blocker is unchanged, repetition is not new evidence.

## Meaningless Heat Rule

Stop immediately when the only thing increasing is:

- wall time
- thermal load
- log volume

without:

- a new comparable receipt,
- a resolved staging question, or
- a new bounded negative result

## Abstain Rules

`abstain` is the correct result when:

- the branch lacks a common observable family
- a lane is visible but not callable
- a lane is callable but not receiptable
- a role can be imagined but not bounded

The branch must prefer abstain over overclaim.

## Failure Rules

`fail_lane` is the correct result when:

- the governed question was really attempted,
- the same observable family was preserved,
- and the lane contradicted the desired outcome

Failure is useful because it sharpens the branch.

## Branch-Line Stops

Stop an entire branch line and hand back to science/engineering when:

- CPU control cannot be stabilized honestly
- GPU, NPU, and heterogeneous work all remain pure abstain with no route to a
  common observable
- the only remaining moves require redevelopment while still being called
  branch execution
- the branch starts weakening the anti-proxy contract to preserve the thesis

## Current Standing Ceiling

Until later plans prove otherwise, preserve these ceilings:

- RM10 GPU: `not ready now`
- RM10 NPU: `feasibility-only`
- heterogeneous embodiment: `premature`

This branch may test those ceilings.
It may not erase them by wording.

## Bottom Line

The branch should stop as soon as interpretability is what is being spent.
A clean abstain or failure is a successful use of this document.
A narratable half-result is not.
