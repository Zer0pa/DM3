# RM10 Geometric Environment Spec

Last refreshed: `2026-04-06`

## Purpose

Define one bounded repeated-window environment for the resonance phase that is
explicit enough to support later chamber, NPU, and persistence batteries
without hidden defaults, stale outputs, or silent surface substitution.

## Environment Split

### External governance anchor

The governed control anchor remains outside the repeated-window chamber
controller:

- binary: `/data/local/tmp/genesis_cli`
- wrapper surface: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- `cwd`: `/data/local/tmp/SoC_runtime/workspace`
- output root: `audit/<run_id>`
- role: custody, identity, and branch-level control reference only

This lane does not participate in the chamber tuple family. It governs honesty
and custody across the phase.

### Primary repeated-window chamber

The repeated-window environment itself stays on the only honest same-family
CPU/GPU chamber candidate identified in Plan 01:

- surface id: `f2_root_chamber_candidate`
- binary: `/data/local/tmp/dm3_runner`
- `cwd`: `/data/local/tmp`
- per-window output path: `/data/local/tmp/<run_prefix>_<row>.jsonl`
- observable family: `f2_harmonic_residue`

Rows in this environment select the chamber lane only by explicit command
surface:

- CPU-forced row: add `--cpu`
- accelerator-backed row: omit `--cpu`

The legacy `/data/local/tmp/dm3/dm3_runner` residue family stays fenced. It is
not part of this environment.

## Fixed State And Baseline-Restore Rules

Before a chamber session starts:

1. capture `adb devices -l`, device props, shell environment, binary help, and
   binary hash
2. snapshot any live `dm3_runner` processes
3. terminate stale `dm3_runner` processes
4. snapshot the runner state again after cleanup

Before every window:

1. terminate any stale `dm3_runner` process
2. snapshot the runner state
3. remove the target output file for that exact row
4. capture pre-window battery and thermal state

After every window:

1. capture stdout, stderr, and exit code
2. capture post-window battery and thermal state
3. pull the exact row receipt into the repo packet immediately
4. parse and retain the first JSONL tuple for comparison

No row may reuse an existing output file as evidence.

## Window Identity

Each window must retain:

- `row_name`
- `surface_id`
- `lane`
- exact command
- binary path
- `cwd`
- output path
- receipt path
- pre and post telemetry

The session packet must retain:

- session question
- checkpoint policy
- checkpoint index
- row set
- session-level battery and thermal pre/post captures
- runner snapshots before cleanup, after cleanup, and after the session

## Minimal Smoke Contract

The smallest admissible environment smoke is:

1. one CPU-forced chamber row on `f2_root_chamber_candidate`
2. one accelerator-backed chamber row on the same `f2_root_chamber_candidate`

Both rows must emit the same tuple family:

- `decision`
- `delta_E`
- `coherence`
- `duration_ms`
- `marker`

This smoke is not a behavior claim. It is only a proof that the environment
can execute bounded windows with explicit surface selection and comparable
receipts.

## Telemetry Contract

Required telemetry for the smoke:

- `dumpsys battery` before and after each row
- `dumpsys thermalservice` before and after each row
- session-level battery and thermal captures
- runner snapshots at cleanup boundaries

Optional telemetry may be added later, but no extra telemetry is needed for
the environment smoke to count.

## Abstain And Failure Conditions

Return `BLOCKED` or fail the smoke if any of the following happen:

- the selected binary or `cwd` drifts from the declared surface
- a row silently falls back to a different surface
- a row relies on a stale existing output
- a receipt is missing or zero-byte
- the pulled tuple is not comparable across the selected rows
- hidden state cannot be fenced tightly enough to explain what was run

## Immediate Reuse Rule

Later plans may reuse this environment only if they preserve:

- the same `f2_root_chamber_candidate` family for chamber rows
- the same row-level identity fields
- the same cleanup and pull discipline
- the same separation between the external `F1` governance anchor and the
  chamber environment itself
