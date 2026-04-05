# Internal Heterogeneous Compute Plan

## Purpose

This document defines how CPU, GPU, NPU, and explicit heterogeneous work enter
the RM10-primary branch without collapsing distinct evidence surfaces into one
story.

The branch is allowed to explore heterogeneity early.
It is not allowed to promote visibility, heat, or opaque binary behavior into
role-partition evidence.

## Governing Question

`Can the branch carry one primary governed RM10 CPU control family and one lower-ceiling accelerator comparison family without confusing feasibility with authority?`

## Lane State Vocabulary

Use these words exactly:

- `observed`: hardware, driver, or telemetry surface is visible
- `callable`: a user-space command path emits durable outputs
- `serious-ready`: a lane can participate in a governed same-family comparison
- `feasibility-only`: the lane can be probed honestly, but claim ceiling stays low
- `premature`: prerequisites are missing and an explicit mixed attempt is not allowed
- `abstain`: the honest outcome when prerequisites or logging discipline are missing
- `blocked`: a run was justified but staging, identity, or receipt discipline failed

## Common Observable Contract

No comparison counts unless all compared runs preserve:

1. the same observable family
2. the same success or failure question
3. the same input semantics
4. the same receipt schema needed for comparison
5. the same declared claim ceiling

If the accelerator path changes the observable family, it is not a comparison.
It is a different battery.

## Observable Family Split

### Family `F1`: `rm10_genesis_protocol_tuple`

This is the branch's primary RM10 control family.

- `lane_role`: governed branch baseline
- `command`: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/branch_01_2_3_1_cpu_20260405`
- `cwd`: `/data/local/tmp/SoC_runtime/workspace`
- `receipt_tuple`: `verify.json=f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`, `solve_h2.json=a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- `authority_status`: `governed_non_sovereign`
- `build_class`: `prebuilt_stub`
- `validator_state`: default validator `FAIL`; explicit-hash tuple comparison `PASS`

No accelerator lane has yet preserved `F1`.

### Family `F2`: `dm3_harmonic_train_episode`

This is a lower-ceiling bundled-residue comparison family that the branch can
use for accelerator feasibility work.

- `cpu_command`: `/data/local/tmp/dm3_runner --mode train --task harmonic --steps 1 --cpu --output cpu_train_harmonic.jsonl`
- `gpu_backed_command`: `/data/local/tmp/dm3_runner --mode train --task harmonic --steps 1 --output gpu_train_harmonic.jsonl`
- `cwd`: `/data/local/tmp`
- `receipt_schema`: one JSONL episode record carrying `decision`, `delta_E`, `coherence`, and `duration_ms`
- `stdout_evidence`: CPU run logs `Forcing CPU Mode (GPU Disabled)`; GPU-backed run logs `GPU MatMul Kernel Initialized` and `GPU Transformer Kernel Initialized`
- `build_class`: `bundled_residue`
- `authority_status`: `feasibility_only`

`F2` does not replace `F1`.
It is admissible only for bounded CPU versus GPU feasibility work on the
preserved bundled residue.

## Lane Matrix

| Lane | Ceiling now | `F1` state | `F2` state | Current evidence | Next admissible move | Promotion blocker |
| --- | --- | --- | --- | --- | --- | --- |
| RM10 CPU | `governed_non_sovereign` on `F1`; `feasibility_only` on `F2` | `serious-ready` | `callable` | receipted `genesis_cli` control on `F1`; forced-CPU one-episode harmonic run on `F2` | keep `F1` as branch anchor and use `F2` only for bounded accelerator compare | `F1` still depends on `prebuilt_stub`; no accelerator carry-forward on `F1` |
| RM10 GPU | `feasibility_only` | `observed` | `callable` | Adreno properties and `/dev/kgsl-3d0`; bounded `dm3_runner` harmonic run emits comparable JSONL and logs GPU kernel initialization on `F2` | repeat `F2` with full identity packet and explicit telemetry capture | no same-family GPU path on `F1`; no explicit handoff artifact for a mixed role claim |
| RM10 NPU or DSP-adjacent | `feasibility-only` | `observed` | `observed` | `libQnnHtp*`, `libQnnSystem.so`, `adsprpcd`, `cdsprpcd`, `dspservice`, FastRPC surfaces | find one callable CLI or wrapper with receiptable inputs and outputs | no user-space receiptable assist path |
| RM10 heterogeneous role partition | `premature` | `abstain` | `abstain` | no explicit pre-handoff or post-handoff artifact exists; current GPU-backed `F2` path is inside one opaque binary | do not start until a split can be named and logged explicitly | no explicit handoff boundary, drift-localization artifact, or same-family mixed ledger |

## Allowed Role-Partition Patterns

Only these mixed patterns may be tested first:

1. `CPU authority / accelerator assist`
   the accelerator proposes or preprocesses, but the CPU-governed lane remains decisive
2. `stage-wise split`
   one bounded stage is accelerated while the final observable family is unchanged
3. `representation-wise split`
   an accelerator handles a bounded transform that is still checked by a CPU-governed output

## Forbidden Role-Partition Patterns

Do not allow:

- whole-pipeline opaque accelerator substitution
- a GPU or NPU path that invents a new observable family for itself
- vendor-marketing labels such as "AI core mode" without explicit data flow
- same-binary bundled `G2` resurrection framed as heterogeneity
- internal accelerator use inside one opaque binary being narrated as explicit handoff proof

## CPU Control Contract

The CPU lane is the branch anchor.

Every CPU control family must declare:

- exact executable
- exact working directory
- exact assets or datasets
- exact receipt location or explicit receipt absence
- thermal and checkpoint capture cadence
- exact ceiling: `governed_non_sovereign` or `feasibility_only`

If the CPU control is ambiguous, accelerator plans do not advance.

## GPU Plan

The GPU question is not "does the GPU exist?".
It is:

- can the GPU back a bounded same-family comparison?
- can the result stay within the declared ceiling?
- can the branch say what changed and what did not?

Current standing:

- `F1`: `observed` only, no same-family GPU path
- `F2`: `callable`, because the harmonic train family emits comparable receipts and explicitly logs GPU kernel initialization

## NPU Plan

The NPU question is bounded assist reachability, not sovereign execution.

NPU work is allowed to ask only:

- is there a callable user-space API or wrapper?
- can inputs and outputs be receipted?
- can the assist role stay bounded and auditable?

If the answer is no, `abstain` is the correct result.

## Explicit Heterogeneous Plan

Explicit heterogeneous work begins only when:

1. one CPU family is already stable enough to compare
2. one accelerator lane is callable on that same family
3. pre-handoff and post-handoff artifacts are retained
4. drift can be localized to one side of the split
5. the mixed path does not change the question under test

Internal GPU-backed execution inside one binary may count as accelerator-backed
feasibility.
It does not count as explicit heterogeneous role-partition evidence until the
handoff is logged.

## Logging Rules For Every Lane

Every lane attempt must log:

- branch and hypothesis
- device lane and compute lane
- run kind
- authority status
- build class
- observable family
- exact command
- exact working directory
- receipt path or explicit absence
- thermal and battery snapshots
- checkpoint identity
- final `PASS`, `FAIL`, `ABSTAIN`, or `BLOCKED` outcome

## Decision Rules

Use this ladder:

1. `PASS`
   same-family attempt completed and stayed within its declared ceiling
2. `FAIL`
   same-family attempt completed and contradicted the claim under test
3. `ABSTAIN`
   prerequisites, handoff logging, or receipt discipline were missing
4. `BLOCKED`
   staging, identity, or receipt drift prevented a meaningful attempt

`observed` is not `callable`.
`callable` is not `serious-ready`.
`F2` success does not raise `F1` authority.

## Bottom Line

The branch now has:

- one governed RM10 CPU control family on `F1`
- one bounded CPU versus GPU feasibility family on `F2`
- no explicit heterogeneous role-partition win
- no NPU callability yet

That is enough to keep accelerator exploration alive honestly.
It is not enough to narrate heterogeneity as already solved.
