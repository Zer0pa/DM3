# RM10 Width-Boundary Environment Manifest

Last refreshed: `2026-04-15`

## Purpose

Freeze the live device and surface identity for Phase `01.2.3.4.1.1.3.1`.

## Attached Device

- ADB status: one live device attached
- model: `NX789J`
- branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`

## Surface Under Test

- primary binary: `/data/local/tmp/dm3_runner`
- primary binary sha256:
  `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- alternate binary recorded but not used: `/data/local/tmp/dm3/dm3_runner`
- alternate binary sha256:
  `d678e8d355601d13dd1608032fd5e6fdf5eaa81bdde0af5f124125ff1bcea8b1`
- cwd: `/data/local/tmp`

## Replay Envelope

- packet: `full_replay`
- rows: `cpu_a,gpu_a,gpu_b,cpu_b`
- row timeout: `420` seconds
- periodic telemetry sampling: `15` seconds
- artifact root:
  `artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay`

## Required Sidecars Present

- `/data/local/tmp/SriYantraAdj_v1.bin`
- `/data/local/tmp/RegionTags_v1.bin`
- `/data/local/tmp/RegionTags_v2.bin`
- `/data/local/tmp/RegionTags_v2.json`
- `/data/local/tmp/data/xnor_train.jsonl`

## Thermal And Power Envelope

Retained per-row telemetry stayed inside a mild envelope:

- battery temperature ranged from `24.0 C` to `26.0 C`
- thermal status stayed `0` on all rows

This packet was materially cooler than the older widened chamber packet that
reported `33.0 C`, so ambient environment remains a live consideration even
though no thermal alarm fired.

## Identity Anchors

- run manifest:
  [run_manifest.json](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay/identity/run_manifest.json)
- binary hashes:
  [binary_hashes.txt](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay/identity/binary_hashes.txt)
- row comparison index:
  [index.json](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_1_width_boundary_20260415T000001Z_full_replay/comparisons/index.json)

## Environment Verdict

The live packet stayed on the intended top-level same-family surface and
retained enough identity and telemetry to support a truthful replay verdict.
