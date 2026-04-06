# RM10 Resonance Helper Reuse Note

Last refreshed: `2026-04-06`

## Purpose

Freeze one helper baseline and one narrow extension path for the resonance
phase so later plans reuse the existing capture discipline instead of inventing
another telemetry stack.

## Chosen Baseline

Primary helper baseline: `tools/rm10_capture.py`

Why this is the right baseline:

1. It already spans the two live families that matter here:
   - `run_f1_serious()` for the governed `F1` CPU control lane
   - `run_f2_harmonic()` for the residue-family CPU versus GPU harmonic
     compare
2. It already owns the common branch capture primitives:
   - `adb()` and `adb_shell()`
   - exact command recording
   - device identity capture
   - pre and post battery plus thermal snapshots
   - repo-custodied receipts
   - `run_identity.json` and checkpoint-style metadata
   - optional Comet offline manifest logging
3. Its artifact shape already matches the branch custody rule:
   - `identity/`
   - `logs/`
   - `telemetry/`
   - `receipts/`
   - `comparisons/` or per-run roots where needed

This means the phase does not need a second capture schema just because the
experiment is being reframed as a chamber battery.

## Supporting Helpers To Borrow From, Not Fork

### `tools/rm10_engineering_readiness.py`

Keep this as preflight and surface-localization support only.

Reuse:

- root versus legacy surface classification
- cleanroom dependency checks
- required-path listing
- comparison index generation for readiness packets

Do not turn it into the main chamber runner. Its job is to say which surface is
real before the battery starts.

### `tools/rm10_f2_outlier_capture.py`

Borrow these patterns for later same-family chamber rows:

- fixed row order under one locked session
- per-row identity, logs, telemetry, and receipts
- hard timeout control
- optional periodic sampling during unstable rows
- checkpoint and comparison index writing for the whole session

This script already solved problems that `run_f2_harmonic()` does not solve:
the row scheduler is explicit, telemetry is row-local, and the packet keeps the
top-level `F2` instability visible rather than smoothing it away.

### `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/run_smoke_lattice.py`

Borrow these patterns for repeated-window work on the `F1` control lane:

- baseline config restore before each row
- row-definition metadata with perturbation family and expectation
- explicit `device_output_dir` per row
- semantic digest extraction from receipted outputs
- short drift summaries using battery and thermal deltas

This artifact-local controller is not the new baseline helper, but it is the
best existing pattern for repeated windows and config hygiene.

## Narrow Extension Strategy

Later execution plans should extend the baseline like this:

1. Keep `tools/rm10_capture.py` as the capture spine.
2. Add one repeated-window controller on top of that spine, not a new
   telemetry system.
3. Import only three extra behaviors into that controller:
   - row scheduling and timeouts from `tools/rm10_f2_outlier_capture.py`
   - baseline config restore and row definitions from
     `run_smoke_lattice.py`
   - readiness preflight from `tools/rm10_engineering_readiness.py`

The extension must preserve the existing branch identity contract:

- exact command
- exact `cwd`
- explicit lane or role label
- explicit output root
- pre and post battery and thermal capture
- repo-custodied receipts
- one short comparable observable tuple per window

## What The Extension Must Not Do

Do not:

- create a second chamber-only manifest format
- create a second battery and thermal logger
- mix surface discovery and chamber execution into one opaque script
- promote vendor NPU inventory into a callable assist path
- hide the difference between the clean `F1` control family and the unstable
  `F2` root family

## Immediate Decision

For later plans in this phase:

- reuse `tools/rm10_capture.py` as the main capture baseline
- call `tools/rm10_engineering_readiness.py` before any `F2` chamber row set
- borrow row-order and timeout handling from `tools/rm10_f2_outlier_capture.py`
- borrow config-restore and repeated-window structure from
  `run_smoke_lattice.py`

That is the smallest reuse path that preserves identity, telemetry, and
artifact custody without inventing duplicate infrastructure.
