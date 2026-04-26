# RM10 Organism Environment Spec

Last refreshed: `2026-04-06`

## Purpose

Define one bounded RM10 environment in which the resonance-chamber thesis can
be tested without hidden defaults, lane substitution, or ambiguous custody.

## Environment

### Primary Chamber

- binary: `/data/local/tmp/dm3_runner`
- `cwd`: `/data/local/tmp`
- mode: `train`
- task: `harmonic`
- steps: `1`

### Fixed Asset Contract

Use the same explicit assets on every primary chamber row:

- `--adj SriYantraAdj_v1.bin`
- `--tags RegionTags_v1.bin`

Rationale:

- top-level `F2` is already known to need explicit environment control
- explicit assets make the chamber a chosen environment instead of an inherited
  default path
- this removes one major ambiguity when comparing CPU-forced and GPU-coupled
  rows

### Output Contract

Each row writes one JSONL file under `/data/local/tmp` and is pulled into the
local artifact packet immediately after execution.

Row-local packet must retain:

- command
- stdout and stderr
- pre and post battery snapshot
- pre and post thermal snapshot
- pulled receipt file
- parsed row summary

## Row Order

Primary row order:

1. `cpu_a`
2. `gpu_a`
3. `gpu_b`
4. `cpu_b`

Meaning:

- `cpu_a`: chamber-local control anchor
- `gpu_a`: first coupled perturbation
- `gpu_b`: repeat coupled perturbation
- `cpu_b`: recovery or persistence check after coupled execution

This order keeps the spirit of the earlier same-family bracket while placing it
inside an explicit-asset environment.

## Control Surfaces Outside The Chamber

### Governed branch control

- `/data/local/tmp/SoC_runtime/workspace`
- `/data/local/tmp/genesis_cli`

Use:

- identity and governance anchor only
- not as part of the chamber observable family

### Legacy residue comparison

- `/data/local/tmp/dm3/dm3_runner`

Use:

- optional comparison-only control if the primary chamber blocks
- never as a silent substitute

## Observable Contract

### Anchor

Per-row tuple:

- `decision`
- `delta_E`
- `coherence`
- `duration_ms`

### Drift

- CPU bracket spread: `cpu_a` vs `cpu_b`
- GPU repeat spread: `gpu_a` vs `gpu_b`
- CPU-to-GPU distance
- timeout or zero-byte receipt

### Verdict Classes

- `structured_signal`: coupled rows form a response class distinct from CPU
  control and that difference survives repeat
- `weak_signal`: some non-random chamber movement appears but is narrow or only
  partially stable
- `empty_line`: coupled rows collapse back to CPU-family behavior or to noise
- `exact_blocker`: the environment breaks in one exact way, such as timeout,
  zero-byte receipt, asset drift, or output-schema collapse

## Telemetry

Every row captures:

- `adb shell dumpsys battery` before and after
- `adb shell dumpsys thermalservice` before and after
- exact device command
- device props and binary hashes at packet level

No signal claim is allowed from telemetry without paired observable change.

## Optional NPU Hook

The environment reserves one optional assist slot:

- projection
- priming
- tagging

It is activated only if a callable user-space tool is found.
Otherwise the environment remains a CPU+GPU chamber and the NPU result is
logged as exact abstain.

## Hard Stops

- missing explicit assets
- chamber row emits only a zero-byte output
- packet custody fails
- primary chamber is silently replaced by the legacy surface
- stage ownership is claimed without explicit handoff evidence
