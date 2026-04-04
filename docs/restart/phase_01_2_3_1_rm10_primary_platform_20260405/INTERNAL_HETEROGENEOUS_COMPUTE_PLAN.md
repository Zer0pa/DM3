# Internal Heterogeneous Compute Plan

## Purpose

This document defines how CPU, GPU, NPU, and heterogeneous work is allowed to
enter the RM10-primary branch.

The branch hypothesis permits early heterogeneous exploration.
The inherited mainline caution still applies:

- RM10 GPU is `not ready now`
- RM10 NPU is `feasibility-only`
- heterogeneous embodiment is `premature`

This plan turns that tension into explicit lane questions instead of silent
assumptions.

## Governing Question

`Can CPU, GPU, NPU, and mixed CPU/GPU/NPU role partition be compared on one
common observable family without changing the claim ceiling or hiding missing
readiness behind accelerator rhetoric?`

## Lane State Vocabulary

Use these words exactly:

- `observed`: the hardware or telemetry surface is visible
- `callable`: a user-space command path is real
- `feasibility-only`: probing is allowed, but comparison authority is not
- `serious-ready`: the lane can participate in a same-observable governed run
- `premature`: prerequisites are missing and no live attempt is allowed
- `abstain`: the honest outcome when prerequisites are not met

## Common Observable Contract

No GPU, NPU, or heterogeneous comparison counts unless all compared runs keep:

1. the same observable family
2. the same success/failure question
3. the same input semantics
4. the same receipt fields needed for comparison
5. the same branch claim ceiling

If the accelerator path changes the observable family, it is not a comparison.
It is a different battery.

## Candidate First Observable

The first common observable family must not be the retired bundled `G2` family.

The branch should prefer a bounded RM10 CPU control that is:

- live today from `/data/local/tmp`
- small enough for repeated thermal-safe execution
- receipt-producing
- meaningful under branch logging and checkpoint rules

Until that control exists, all non-CPU lanes remain feasibility or abstain
surfaces.

## Lane Matrix

| Lane | Branch question | Current branch status | Allowed first role | Must already be true | Honest first outcome classes |
| --- | --- | --- | --- | --- | --- |
| RM10 CPU | Can the branch name one controlled, receipt-backed baseline observable on-device? | candidate control lane | direct governed control run | exact command, cwd, receipt schema, and branch logging rules exist | `pass`, `fail`, `blocked` |
| RM10 GPU | Can the phone accelerate the same CPU-governed observable without changing the story? | not ready now | parity or acceleration feasibility only | CPU control is live; reduction rules explicit; comparison ledger defined | `pass`, `fail`, `abstain` |
| RM10 NPU or DSP-adjacent | Is any bounded user-space assist role reachable and receiptable? | feasibility-only | projection, tagging, or preprocessing assist | callable user-space surface exists; CPU baseline remains sovereign | `pass`, `fail`, `abstain` |
| RM10 heterogeneous | Does stage-wise or representation-wise partition clarify the observable instead of muddying it? | premature | logged role split only after CPU plus one accelerator role are stable | CPU control live; one accelerator lane at least feasibility-proved on same observable; handoff accounting explicit | `pass`, `fail`, `abstain` |

## Allowed Role-Partition Patterns

Only these heterogeneity patterns may be tested first:

1. `CPU control / accelerator assist`
   accelerator proposes or preprocesses; CPU remains the decisive lane
2. `stage-wise split`
   one stage is accelerated while the comparison observable remains unchanged
3. `representation-wise split`
   an accelerator handles a bounded representation transform that is still
   checked by the CPU-governed lane

## Forbidden Role-Partition Patterns

Do not allow:

- whole-pipeline opaque accelerator substitution
- a GPU or NPU path that invents a new observable family for itself
- marketing-language partitions such as "AI core mode" without explicit data
  flow
- same-binary bundled `G2` resurrection framed as heterogeneity

## CPU Control Contract

The CPU lane is the branch anchor.

The first CPU control must define:

- exact executable
- exact working directory
- exact assets or datasets
- exact receipt location
- exact thermal and checkpoint capture cadence
- exact outcome vocabulary

If the CPU control is ambiguous, the accelerator plans do not advance.

## GPU Plan

The GPU question is parity or bounded acceleration of the CPU-governed
observable, not "does the GPU exist?".

GPU work remains prep or abstain unless:

1. the CPU control is already live
2. the same observable family is preserved
3. deterministic reduction or comparison discipline is written
4. build class and validator status are stated honestly

GPU does not become ready because `/dev/kgsl-3d0` is present.

## NPU Plan

The NPU question is bounded assist reachability, not sovereign execution.

NPU work is allowed to ask only:

- is there a callable user-space API or wrapper?
- can inputs and outputs be receipted?
- can the assist role stay bounded and auditable?

If the answer is no, `abstain` is the correct result.

## Heterogeneous Plan

Heterogeneous work is a late part of this branch phase, not a warm-up ritual.

It may begin only when:

1. the CPU control is stable enough to compare
2. GPU or NPU feasibility has a real artifact surface
3. the handoff between lanes is named explicitly
4. the mixed path does not change the claim under test

If any of those are missing, heterogeneous work is `premature`.

## Logging Rules For Every Lane

Every lane attempt must log:

- branch and hypothesis
- device lane and compute lane
- run kind
- authority status
- evidence surface
- build class
- observable family
- exact command
- exact working directory
- environment manifest path
- receipt path or explicit absence
- thermal and battery snapshots
- checkpoint identity
- final `pass`, `fail`, `abstain`, or `blocked` outcome

## Decision Rules

Use this ladder:

1. `pass`
   same observable preserved and comparison interpretable
2. `fail`
   same observable attempted and contradicted
3. `abstain`
   prerequisites missing, but no contradictory result was produced
4. `blocked`
   governance or staging drift prevented a meaningful attempt

`abstain` is not a pass.
`observed` is not `callable`.
`callable` is not `serious-ready`.

## Hand-Off To Later Plans

Plan `03` must turn this document into lane-specific runbooks.
Plan `04` must turn it into one hardware-role battery matrix plus explicit
CPU/GPU/NPU/heterogeneous verdicts.

## Bottom Line

The branch is allowed to explore heterogeneity early only if it stays brutally
honest about role partition, common observables, and abstain outcomes.
Otherwise it is just changing hardware while pretending the science stayed the
same.
