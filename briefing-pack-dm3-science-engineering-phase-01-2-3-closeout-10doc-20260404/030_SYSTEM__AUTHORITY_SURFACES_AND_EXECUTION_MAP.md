# Authority Surfaces And Execution Map

## Purpose

This document merges the current witness-floor, execution-surface, and
build-class picture into one system map.

## Current Lane Table

| Lane | `authority_status` | `evidence_surface` | `build_class` | Execution surface | Current meaning |
| --- | --- | --- | --- | --- | --- |
| Mac Genesis `G-01` / `G-02` | `sovereign` | `witness_floor` | `source_built` | host source build and replay | strongest current governed authority surface |
| historical RM10 Genesis parity | `comparison_only` | `comparison_only` | `not_applicable` | preserved historical receipts | proves RM10 once matched Mac, not that fresh phone-local lanes do today |
| fresh RM10 SoC runtime | `governed_non_sovereign` | `witness_floor` | `prebuilt_stub` | `/data/local/tmp/SoC_runtime/workspace` plus `/data/local/tmp/genesis_cli` | current governed phone witness lane, executable but not sovereign |
| fresh RM10 raw workspace | `governed_non_sovereign` | `witness_floor` | `mixed_prebuilt_backed` | `/data/local/tmp/snic_workspace_a83f` plus `/data/local/tmp/genesis_cli` | current raw-workspace phone witness lane, executable but not Mac parity |
| RM10 root `dm3_runner` | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | `/data/local/tmp/dm3_runner` | smoke-only callable residue and control surface |
| RM10 bundled `dm3/dm3_runner` | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | `/data/local/tmp/dm3/dm3_runner` | richest callable residue, but current same-binary `G2` route is retired |

## Validator And Build-Class Status

| Surface | Validator status | What this proves | What it does not prove |
| --- | --- | --- | --- |
| Mac Genesis | source-built replay stable; published canonical stale | current witness-floor baseline is real | that stale `verify.json` docs are still authoritative |
| historical RM10 parity | historically matched Mac; current validator rejects that bundle | older clean RM10 parity existed | fresh device sovereignty |
| fresh RM10 SoC runtime | default validator `FAIL`; explicit-hash `PASS` | governed phone executability and receipt reproducibility | source-built parity or sovereignty |
| fresh RM10 raw workspace | default validator `FAIL`; explicit-hash `PASS` | governed raw-workspace executability | Mac parity or source-built proof |
| hybrid residue lanes | Genesis validator not applicable | archaeology and pairing evidence only | witness-floor authority |

## RM10 Device Facts That Matter

- device model: `NX789J` Red Magic 10 Pro
- execution root for live device work: `/data/local/tmp`
- bundled archaeology target: `/data/local/tmp/dm3/dm3_runner`
- practical system split:
  - witness-floor Genesis lanes are real but non-sovereign
  - hybrid runners are callable residue, not authority surfaces

## System Bottom Line

- Mac Genesis is still the only current `sovereign` and `source_built` lane.
- Fresh RM10 Genesis lanes are real and governed, but still sit below source
  parity and below sovereignty.
- The bundled runner remains relevant only as archaeology evidence and
  retirement proof, not as a living same-binary `G2` lane.

## Canonical Source Docs

- `/Users/Zer0pa/DM3/restart/docs/restart/WITNESS_LANE_REPAIR_NOTE.md`
- `/Users/Zer0pa/DM3/restart/docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`
- `/Users/Zer0pa/DM3/restart/docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md`
- `/Users/Zer0pa/DM3/restart/docs/restart/LIVE_STATE_SNAPSHOT_V1_20260403.md`
