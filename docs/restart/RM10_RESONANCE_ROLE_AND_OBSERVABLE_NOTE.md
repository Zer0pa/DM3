# RM10 Resonance Role And Observable Note

Last refreshed: `2026-04-06`

## Purpose

Translate Training Doc #5 into an honest current-surface map for the RM10 and
freeze the first executable observable contract for the heterogeneity-first
phase.

## Role Map

### CPU

Role: scheduler, arbiter, and recovery anchor.

Current surfaces:

- governed control lane:
  `/data/local/tmp/SoC_runtime/workspace` + `/data/local/tmp/genesis_cli`
- chamber-local CPU forcing:
  `/data/local/tmp/dm3_runner --mode train --task harmonic --steps 1 --cpu`

How to use it in this phase:

- `genesis_cli` remains the branch-local governed instrument
- `dm3_runner --cpu` is the chamber-local control comparator inside the same
  observable family as the coupled GPU rows

### GPU

Role: fast coupled update / relaxation operator.

Current surface:

- top-level chamber candidate:
  `/data/local/tmp/dm3_runner --mode train --task harmonic --steps 1`

Interpretation:

- this is not yet explicit stage ownership
- it is an executable coupled-lane state transition on the same row schema as
  the CPU-forced chamber rows
- for this phase it is the first real heterogeneous chamber surface

### NPU

Role: optional projection / priming / tagging assist.

Current surface:

- inventory and infrastructure only
- no retained callable DM3-facing user-space path yet

Interpretation:

- NPU is optional in this phase
- the main chamber does not wait for it
- the phase probes for a bounded assist path in parallel and either uses it as
  an extra lane or records explicit abstain

### Persistence Medium

Role: bounded packet and boundary memory.

Current surface:

- per-row JSONL output packet
- explicit asset set
- stable `cwd`
- stable device-side output path
- repeated row order inside one battery packet

Interpretation:

- this phase does not claim direct cache-level introspection
- instead it treats packet custody, repeated row order, and explicit asset
  state as the practical persistence medium available on the branch now

## Chamber Choice

Primary chamber:

- binary: `/data/local/tmp/dm3_runner`
- `cwd`: `/data/local/tmp`
- task family: `train harmonic`
- explicit assets for all chamber rows:
  - `SriYantraAdj_v1.bin`
  - `RegionTags_v1.bin`

Reason:

- top-level `F2` is the only current branch surface with a live CPU/GPU same-
  family comparison path
- fixing explicit assets removes hidden-default ambiguity and turns the battery
  into an actual environment rather than a default-path accident

Legacy `/data/local/tmp/dm3/dm3_runner` remains comparison-only and may not be
silently substituted for the primary chamber.

## Anchor Observable

Anchor observable: the receipt-bearing chamber tuple emitted by `dm3_runner`:

- `decision`
- `delta_E`
- `coherence`
- `duration_ms`

This is the strongest current branch-local observable family that:

- exists on both CPU-forced and GPU-coupled rows
- stays inside one receipt schema
- can be retained under exact row custody

## Drift Observable

Drift observable: row-to-row cluster movement on the same tuple.

Primary comparisons:

1. `cpu_a` vs `cpu_b`
2. `gpu_a` vs `gpu_b`
3. `gpu_a` and `gpu_b` vs the CPU bracket

Secondary drift markers:

- timeout or zero-byte output
- missing receipt
- thermal co-variation without tuple change

## Abstain Rule

Return `ABSTAIN` if any of the following hold:

- the chamber cannot be run without implicit defaults or silent surface
  substitution
- the coupled rows do not emit usable receipt-bearing packets
- the observable family collapses into runtime, heat, or log-style differences
  only
- NPU remains unavailable and the battery cannot honestly claim explicit stage
  ownership beyond CPU+GPU coupling

## What This Phase Will And Will Not Claim

Allowed:

- CPU and GPU form a practical coupled chamber on the current branch
- NPU is optional and separately probed
- packet-level structured response is the first thing to test

Not allowed:

- that the training document is thereby proved
- that the GPU row equals explicit internal stage ownership
- that NPU is live because Qualcomm Hexagon exists in the SoC
- that heat or runtime alone are evidence of resonance
