# F2 Outlier Localization Plan

Last refreshed: `2026-04-05`

## Purpose

Define the exact official `F2` residue diagnostic while making the current
entry gate explicit: do not run this packet until the top-level
`/data/local/tmp/dm3_runner` root surface is proven callable by the retained
`01.2.3.3` surface probe.

## Frozen Truth Floor

- `F1` governed Genesis CPU control remains the branch scientific anchor
- the current governed accelerator bridge on `F1` is `bridge_closed`
- `F2` remains `PASS` only at callable ceiling with
  `f2_repeatability_verdict=unstable_feasibility`
- NPU and explicit heterogeneous remain `ABSTAIN`
- the official `F2` outlier packet is currently `BLOCKED` behind root-surface
  readiness

## Entry Gate

Proceed only if all of the following are true first:

- a retained `rm10_f2_surface_probe` summary exists
- that retained summary classifies `root_cpu_default` as `callable`
- identity capture includes `RegionTags_v1.bin` and `data/xnor_train.jsonl`
  alongside the existing residue files
- process-table snapshots before and after cleanup are retained

If any gate fails, record `BLOCKED`.

## Single Technical Question

Once the gate is open, the official question is unchanged:

Does the earlier `F2` GPU-backed drift localize to startup or order sensitivity
under locked identity capture, or does the residue family remain too unstable
to interpret even at the current feasibility ceiling?

## Scope Lock

Allowed:

- the exact `F2` observable family:
  `dm3_runner --mode train --task harmonic --steps 1`
- the exact top-level root residue binary at `/data/local/tmp/dm3_runner`
- one bounded session containing the CPU twin and GPU-backed twin only
- identity, telemetry, and receipt capture strict enough to classify the
  outlier honestly

Forbidden:

- any `F1` execution surface change or accelerator-bridge narration
- any binary swap to `/data/local/tmp/dm3/dm3_runner` inside the diagnostic
- any task, mode, step-count, cwd, or output-schema change
- any NPU, DSP, or heterogeneous handoff experiment
- any pass narrative beyond `F2` residue classification

## Frozen Command Family

Use only these command shapes from `/data/local/tmp` once the gate is open:

- CPU rows:
  `adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/f2_outlier_<row>.jsonl'`
- GPU-backed rows:
  `adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/f2_outlier_<row>.jsonl'`

Declared row names are `cpu_a`, `gpu_a`, `gpu_b`, and `cpu_b`.

## Identity Lock

Freeze before the first official row:

- device serial, model, build fingerprint, and relevant GPU properties
- binary path and sha256 for `/data/local/tmp/dm3_runner`
- explicit note that `/data/local/tmp/dm3/dm3_runner` exists but is not used
- sha256 for:
  - `/data/local/tmp/SriYantraAdj_v1.bin`
  - `/data/local/tmp/RegionTags_v1.bin`
  - `/data/local/tmp/RegionTags_v2.bin`
  - `/data/local/tmp/RegionTags_v2.json`
  - `/data/local/tmp/data/xnor_train.jsonl`
- exact cwd: `/data/local/tmp`
- exact commands for CPU and GPU-backed rows
- PATH and any non-default env values that affect execution
- declared row order and output paths

If any identity field changes mid-session, stop and classify the pass as
`BLOCKED`.

## Minimal Session Design

Run exactly one bounded session with this row order:

1. CPU baseline row using `--cpu`
2. GPU-backed row 1 without `--cpu`
3. GPU-backed row 2 without any intervening binary, cwd, or env change
4. CPU confirmation row using `--cpu`

## Allowed Outcome Classes

- `startup_sensitive_gpu_outlier`
- `persistent_gpu_instability`
- `whole_session_instability`
- `uninterpretable`
- `BLOCKED`

## Non-Allowed Conclusions

This diagnostic cannot, by itself:

- reopen the governed accelerator bridge on `F1`
- upgrade `F2` into a same-family witness for `F1`
- promote NPU or DSP work out of `ABSTAIN`
- promote opaque accelerator use into explicit heterogeneous handoff evidence

The best possible result is a better localized `F2` residue classification.

## Required Outputs

- a run manifest naming the frozen question and row order
- a session table comparing `delta_E`, `coherence`, duration, lane markers, and
  telemetry for all four rows
- one branch note stating which allowed outcome class was reached
- one explicit failure-localization note
- an explicit sentence stating that the result is residue classification only,
  not bridge progress
