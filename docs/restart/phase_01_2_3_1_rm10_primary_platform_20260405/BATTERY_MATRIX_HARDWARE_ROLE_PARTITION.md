# Battery Matrix Hardware Role Partition

## Question

What can each processor role honestly do now on this branch, and on which
observable family?

## Control Objective

Keep lane ceilings, observable families, and outcome classes separate.
The branch currently has one primary governed CPU family and one lower-ceiling
CPU versus GPU feasibility family.

## First-Pass Results

| Track | Ceiling now | Family `F1: rm10_genesis_protocol_tuple` | Family `F2: dm3_harmonic_train_episode` | Result | Evidence basis | Promotion blocker |
| --- | --- | --- | --- | --- | --- | --- |
| RM10 CPU | `governed_non_sovereign` on `F1`; `feasibility_only` on `F2` | `PASS` | `PASS` | `PASS` | receipted `genesis_cli` control on `F1`; forced-CPU `dm3_runner` harmonic run on `F2` | `F1` is still `prebuilt_stub`; no accelerator carry-forward on `F1` |
| RM10 GPU | `feasibility_only` | `ABSTAIN` | `PASS` | `PASS` at feasibility ceiling | Adreno properties and `/dev/kgsl-3d0`; GPU-backed `dm3_runner` harmonic run logs kernel init and emits same-schema JSONL as CPU twin | no same-family GPU path on `F1`; no explicit handoff artifact |
| RM10 NPU | `feasibility_only` | `ABSTAIN` | `ABSTAIN` | `ABSTAIN` | `libQnnHtp*`, FastRPC, DSP daemons, and DSP libraries visible | no receiptable user-space assist role |
| RM10 heterogeneous role partition | `premature` | `ABSTAIN` | `ABSTAIN` | `ABSTAIN` | no explicit pre-handoff and post-handoff artifacts; no drift-localization note | no explicit mixed ledger on either family |

## Promotion Rule

Do not promote GPU, NPU, or explicit heterogeneous status beyond the table
above until:

1. the lane is callable in user space
2. the observable family, inputs, and receipt schema are unchanged
3. handoff ownership is explicit
4. the result stays within its declared ceiling

`F2` GPU success is real.
It does not promote `F1` automatically.
