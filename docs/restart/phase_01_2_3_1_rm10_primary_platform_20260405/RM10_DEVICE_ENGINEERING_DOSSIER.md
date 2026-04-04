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

- `/data/local/tmp` is the practical executable surface for ADB-shell work
- shared storage is ingress and export, not the live binary surface
- the current branch should preserve this split rigidly

## Live Surfaces Present

### CPU

- `genesis_cli` survives on device
- SoC runtime and harness directories survive on device
- CPU is still the safest branch control lane

### GPU

- `ro.hardware.egl` and `ro.hardware.vulkan` both report `adreno`
- `/dev/kgsl-3d0` is visible
- GPU thermal channels are exposed

Interpretation:

- GPU feasibility is justified
- GPU authority is not yet justified

### NPU or DSP-adjacent

- `nsp*` thermal channels are exposed
- thermal output includes `cdsp` cooling-device entries

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
- keep GPU and NPU in feasibility or abstain territory until a common
  observable survives
- treat heterogeneous execution as a bounded comparison question, not as a
  higher-status lane by default
