# Heterogeneous Handoff Requirements Note

Last refreshed: `2026-04-05`

## Current Verdict

- `heterogeneous_handoff_verdict=ABSTAIN`
- A same-family `F2` handoff now exists on the top-level
  `/data/local/tmp/dm3_runner` family through the official packets
  `artifacts/rm10_f2_outlier_20260405T171018Z/` and
  `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/`, but the fresh
  rerun still failed to close custody because `cpu_b` timed out and emitted no
  usable receipt.
- No preserved same-family observable currently survives that handoff well
  enough to justify a narrow heterogeneous split.

## Opening Gate

A future heterogeneous claim is not open unless all of these are true first:

- the CPU lane and accelerator lane are on the same declared observable family
- the CPU-only twin is already callable and receipt-backed
- the accelerator substage is callable on that same family
- checkpoint identity is frozen before the split

If any of those conditions are absent, the branch remains at `ABSTAIN`.

## Required Artifact Set

| Artifact | Minimum content | Why it is required | If missing |
| --- | --- | --- | --- |
| Family declaration packet | observable family name, build class, authority ceiling, checkpoint identity, and run purpose | proves the mixed claim belongs to one family rather than two stories spliced together | verdict stays `ABSTAIN` |
| Pre-handoff artifact | serialized or otherwise receipted state immediately before the accelerator-owned stage, with path, hash, timestamp, and schema or shape note | establishes what the CPU lane actually handed off | verdict stays `ABSTAIN` |
| Handoff declaration | explicit statement of stage ownership, handoff format, command or API boundary, and invariants expected across the boundary | makes the split inspectable instead of implied | verdict stays `ABSTAIN` |
| Post-handoff artifact | serialized or otherwise receipted state immediately after the accelerator-owned stage, with path, hash, timestamp, and schema or shape note | establishes what came back from the accelerator-owned stage | verdict stays `ABSTAIN` |
| Final comparable observable | same-family final receipt compared against a CPU-only twin | proves the mixed path did not silently change the scientific object | verdict stays `ABSTAIN` |
| Per-stage logs and telemetry | logs that identify stage entry and exit plus the relevant per-stage telemetry | localizes drift or failure to a segment rather than to the whole run | verdict stays `ABSTAIN` |
| Failure-localization note | one short note naming where mismatch would be attributed if the mixed path drifts | prevents vague mixed-success claims | verdict stays `ABSTAIN` |

## What Counts As A Valid Pre-Handoff Artifact

A valid pre-handoff artifact must be more than a final receipt. It must retain:

- the exact state or payload handed to the accelerator-owned stage
- a stable path and hash
- enough schema, shape, or format detail to compare it to the post-handoff
  artifact

## What Counts As A Valid Post-Handoff Artifact

A valid post-handoff artifact must retain:

- the exact state or payload returned from the accelerator-owned stage
- a stable path and hash
- enough schema, shape, or format detail to compare it to the pre-handoff
  artifact and the final observable

## Explicit Non-Examples

None of the following is sufficient for a heterogeneous claim:

- one opaque binary that logs GPU initialization internally
- a final output with no pre-handoff artifact
- a pre-handoff artifact with no post-handoff artifact
- different observable families before and after the claimed split
- NPU or GPU inventory evidence without a bounded stage owner

## Boundary Consequence

Until the full artifact set exists on a common family, heterogeneous execution
remains `ABSTAIN`. The current official same-family `F2` packets are useful
because they prove the handoff exists on the top-level family, but they still
do not meet the heterogeneous gate because the session itself is unstable, the
fresh rerun does not close the CPU anchor under custody, and no explicit
pre-handoff / post-handoff stage artifact exists.
