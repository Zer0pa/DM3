# RM10 First Execution Dossier

## First-Pass Verdict

- RM10 CPU: `PASS`
- RM10 GPU: `ABSTAIN`
- RM10 NPU: `ABSTAIN`
- RM10 heterogeneous: `ABSTAIN`

## CPU Control Pass

Command surface:

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/branch_01_2_3_1_cpu_20260405'
```

Artifact root:

- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/cpu_control/`

Key outputs:

- `verify.json` hash `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`
- `solve_h2.json` hash `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- run tree includes `artifacts/`, `public/`, and `receipts/`

Thermal and battery:

- pre and post battery remained at `80%`
- post battery temperature `29.0 C`
- thermal status remained `0`
- post skin temperature about `31.3 C`

Interpretation:

The branch has a clean first CPU control pass on the attached RM10 without
thermal stress or receipt loss.

## GPU Feasibility Pass

Artifact root:

- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/gpu_feasibility/`

Observed:

- `adreno` for EGL and Vulkan
- `/dev/kgsl-3d0` visible
- SurfaceFlinger confirms active graphics stack

Verdict:

- `ABSTAIN`

Reason:

No user-space comparable compute path was established for the branch control
observable on this first pass.

## NPU Feasibility Pass

Artifact root:

- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/npu_feasibility/`

Observed:

- `fastrpc-adsp-secure`
- `fastrpc-cdsp`
- `fastrpc-cdsp-secure`
- `libadsprpc.so`
- `libcdsprpc.so`
- `adsprpcd`, `cdsprpcd`, `dspservice`

Verdict:

- `ABSTAIN`

Reason:

Accelerator-adjacent libraries and daemons are visible, but a branch-grade
receiptable user-space assist role was not established.

## Heterogeneous Pass

Artifact root:

- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/heterogeneous_abstain/`

Verdict:

- `ABSTAIN`

Reason:

The first pass did not establish a common callable GPU or NPU comparison path,
so mixed execution would have broken the branch control story.
