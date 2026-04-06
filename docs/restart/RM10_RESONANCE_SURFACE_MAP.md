# RM10 Resonance Surface Map

Last refreshed: `2026-04-06`

## Purpose

Freeze the exact RM10 surfaces this phase can honestly touch now for
resonance-oriented work. This is a callable-surface map, not a hardware wish
list.

## Live Surface Inventory

| Surface ID | Role now | Binary and wrapper | Device `cwd` | Device output root | Observable family | Distinguishing retained evidence | Current ceiling |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `F1_CPU_CONTROL` | Governed CPU control and contrast anchor | `/data/local/tmp/genesis_cli` via `PATH=/data/local/tmp/SoC_Harness/bin:$PATH` | `/data/local/tmp/SoC_runtime/workspace` | `audit/<run_id>` under the workspace | `genesis_protocol` with receipted `verify.json`, `solve_h2.json`, and `VERIFY_SUMMARY.json` | `artifacts/rm10_f1_serious_20260405T122831Z/` plus `RUNBOOK_RM10_CPU.md` | Callable at `authority_status=governed_non_sovereign`, `build_class=prebuilt_stub`; this is the clean control lane, not a heterogeneous chamber proof |
| `F2_ROOT_CHAMBER_CANDIDATE` | Top-level same-family chamber candidate for forced-CPU and GPU-backed harmonic rows | `/data/local/tmp/dm3_runner` | `/data/local/tmp` | Session-local JSONL receipts such as `/data/local/tmp/<row>.jsonl`, mirrored into the repo packet root | `f2_harmonic_residue` / one-episode harmonic tuple: `decision`, `delta_E`, `coherence`, `duration_ms`, `episode` | `artifacts/rm10_f2_surface_probe_20260405T170543Z/`, `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/`, and `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/` | Callable, but still `unstable_but_localized`; same-family CPU and GPU work exists, but the official bracket still loses the closing `cpu_b` anchor under the current boundary |
| `F2_LEGACY_RESIDUE_CONTROL` | Older residue-family control surface for bounded GPU-backed feasibility only | `/data/local/tmp/dm3/dm3_runner` | `/data/local/tmp/dm3` | Session-local JSONL receipts such as `/data/local/tmp/dm3/legacy_gpu_train.jsonl` | `dm3_harmonic_train_episode` | `artifacts/phase_01_2_3_1_dm3_harmonic_train_compare_20260405/` and `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/probes/legacy_dm3_gpu_train/` | Callable feasibility control only; separate surface, separate ceiling, and not an admissible substitute for the top-level root family |
| `NPU_ASSIST_ROUTE` | Bounded NPU or DSP assist probe only if a user-space command can be named | No DM3-facing callable binary or API is proven yet | None proven | Canonical mirror root remains `artifacts/<phase_run_root>/npu_feasibility/` if reopened | None yet; current evidence is inventory and path search only | `artifacts/phase_01_2_3_2_npu_triage_20260405/`, `NPU_ABSTAIN_JUSTIFICATION_NOTE.md`, and `RUNBOOK_RM10_NPU.md` | `ABSTAIN / inventory_only`; no honest assist lane exists until a command, bounded role, and receiptable I/O chain are declared |

## Exact Live Command Table

### `F1_CPU_CONTROL`

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/<run_id>'
```

Source:

- `artifacts/rm10_f1_serious_20260405T122831Z/identity/run_identity.json`
- `docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/RUNBOOK_RM10_CPU.md`

### `F2_ROOT_CHAMBER_CANDIDATE` forced CPU row

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/<row>.jsonl'
```

### `F2_ROOT_CHAMBER_CANDIDATE` GPU-backed row

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/<row>.jsonl'
```

Source:

- `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/summary.json`
- `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/*/identity/command.txt`

### `F2_LEGACY_RESIDUE_CONTROL` GPU-backed row

```bash
adb shell 'cd /data/local/tmp/dm3 && ./dm3_runner --mode train --task harmonic --steps 1 -o /data/local/tmp/dm3/legacy_gpu_train.jsonl'
```

Source:

- `artifacts/phase_01_2_3_1_dm3_harmonic_train_compare_20260405/COMPARE_SUMMARY.md`
- `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/summary.json`

### `NPU_ASSIST_ROUTE` inventory probe only

```bash
adb shell 'ls /dev | grep -E "fastrpc|cdsp|adsp|nsp"; ls /vendor/lib64 | grep -E "Qnn|dsp|adsprpc|cdsprpc"; ls /vendor/bin | grep -E "dsp|rpc"'
```

Source:

- `artifacts/phase_01_2_3_2_npu_triage_20260405/identity/probe_commands.txt`
- `docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/RUNBOOK_RM10_NPU.md`

## Boundary Notes That Matter For Later Plans

1. The only clean governed lane is still `F1_CPU_CONTROL`. It is the control
   anchor for later chamber comparisons, but it is not itself a coupled
   chamber surface.
2. The only same-family CPU and GPU chamber candidate today is the top-level
   `F2_ROOT_CHAMBER_CANDIDATE` on `/data/local/tmp/dm3_runner`.
3. Cleanroom probes show that the top-level root family is still not hermetic.
   `cleanroom_minimal_cpu` fails on a missing ambient dependency, while
   `cleanroom_regiontags_v1_cpu` becomes callable once `RegionTags_v1.bin` is
   restored.
4. The live instability is no longer "can the root start at all." It is the
   low/high split inside the callable root family plus the official bracket's
   failure to retain the closing `cpu_b` receipt.
5. The legacy `/data/local/tmp/dm3/dm3_runner` family remains useful only as
   an older residue control. It cannot silently stand in for the top-level
   same-family chamber candidate.
6. NPU remains a missing-path problem, not a callable lane. Vendor libraries,
   RPC daemons, and thermal channels do not change that classification.

## Verdict

The current phase has one honest control surface, one honest same-family
CPU/GPU chamber candidate, one fenced legacy residue control surface, and one
explicit NPU missing path.

Anything stronger than that would be mythology rather than surface mapping.
