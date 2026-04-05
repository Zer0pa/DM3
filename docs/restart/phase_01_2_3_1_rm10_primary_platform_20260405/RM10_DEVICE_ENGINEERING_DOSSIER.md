# RM10 Device Engineering Dossier

## Purpose

Summarize the attached RM10 surface that this branch can honestly engineer
against right now.

## Attached Device

- model: `NX789J`
- board platform property: `sun`
- kernel: Android 15 era `6.6.56`
- total RAM visible: about `23.66 GiB`
- battery state at capture: AC powered, `80%`
- thermal status at capture: `0`

Artifacts:

- `artifacts/phase_01_2_3_1_rm10_preflight_20260405/adb_identity.txt`
- `artifacts/phase_01_2_3_1_rm10_preflight_20260405/battery.txt`
- `artifacts/phase_01_2_3_1_rm10_preflight_20260405/meminfo.txt`
- `artifacts/phase_01_2_3_1_rm10_preflight_20260405/thermal.txt`
- `artifacts/phase_01_2_3_1_rm10_preflight_20260405/tmp_listing.txt`

## Execution Split

The RM10 package has one evidenced execution root and several
non-interchangeable lane surfaces:

| Lane | Device `cwd` or probe root | Runtime surface | Current label |
| --- | --- | --- | --- |
| CPU control | `/data/local/tmp/SoC_runtime/workspace` | `/data/local/tmp/genesis_cli` with `PATH=/data/local/tmp/SoC_Harness/bin:$PATH` | `prebuilt_stub` |
| Raw-workspace CPU variant | `/data/local/tmp/snic_workspace_a83f` | `/data/local/tmp/genesis_cli` with the same wrapper family | `mixed_prebuilt_backed` |
| GPU feasibility inventory | `/data/local/tmp` | `getprop`, `/dev/kgsl-3d0`, SurfaceFlinger, thermal HAL | `inventory_only` until a callable comparable runtime exists |
| NPU feasibility inventory | `/data/local/tmp` | `fastrpc*`, `lib*dsprpc*`, daemon inventory, thermal HAL | `inventory_only` until a callable bounded assist role exists |
| Archaeology residue | `/data/local/tmp` or `/data/local/tmp/dm3` | `dm3_runner` surfaces and bundled assets | `bundled_residue` or archaeology only |

Shared storage such as `/sdcard` or `/storage/emulated/0` is ingress and
export only. Repo-retained artifacts are the citation surface.

## Live Surfaces Present

### CPU

- `genesis_cli` survives on device
- SoC runtime and harness directories survive on device
- CPU is still the safest branch control lane

### GPU

- `ro.hardware.egl` and `ro.hardware.vulkan` both report `adreno`
- `/dev/kgsl-3d0` is visible
- GPU thermal channels are exposed
- bundled `dm3_runner` harmonic training can initialize GPU kernels on-device

Interpretation:

- GPU feasibility is justified
- one bounded bundled-residue GPU comparison family is callable
- GPU authority on the primary governed control family is not yet justified

### NPU or DSP-adjacent

- `nsp*` thermal channels are exposed
- thermal output includes `cdsp` cooling-device entries
- `libQnnHtp*`, `libQnnSystem.so`, `libadsprpc.so`, and `libcdsprpc.so` are present under `/vendor/lib64`
- `adsprpcd`, `cdsprpcd`, and `dspservice` are present under `/vendor/bin`

Interpretation:

- NPU or DSP feasibility probing is justified
- user-space callable compute is still unproven

## Device-Side Residue Worth Respecting

The `/data/local/tmp` listing still contains:

- `dm3_runner`
- paired geometry and region-tag assets
- historical JSONL receipts and experiment logs
- `snic_workspace_a83f`

These are useful branch clues and runbook inputs.
They are not automatic authority.

## Engineering Consequences

- start branch execution from CPU control
- preserve the split between the primary governed Genesis family and the lower-ceiling bundled-residue harmonic family
- keep NPU in feasibility or abstain territory until a receiptable user-space assist role exists
- treat explicit heterogeneous execution as a bounded comparison question, not as a higher-status lane by default
- do not let inventory-only lanes inherit the CPU control ceiling
