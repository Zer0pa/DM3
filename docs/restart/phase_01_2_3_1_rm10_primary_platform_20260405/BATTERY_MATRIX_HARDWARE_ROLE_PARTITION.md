# Battery Matrix Hardware Role Partition

## Question

What can each processor role honestly do now on this branch?

## Control Objective

Keep one common CPU-governed observable family and compare every other lane to
it honestly.

## First-Pass Results

| Track | Result | Why |
| --- | --- | --- |
| RM10 CPU | `PASS` | one bounded control run completed with receipts, hashes, and stable thermal state |
| RM10 GPU | `ABSTAIN` | hardware and graphics runtime surfaces are real, but no callable comparable compute path was established |
| RM10 NPU | `ABSTAIN` | DSP or NPU-adjacent surfaces are visible, but no receiptable user-space assist role was established |
| RM10 heterogeneous | `ABSTAIN` | no common GPU or NPU compute path was earned, so mixed execution would have changed the comparison story |

## Promotion Rule

Do not promote GPU, NPU, or heterogeneous status beyond `ABSTAIN` until each
lane can preserve the same stated control observable.
