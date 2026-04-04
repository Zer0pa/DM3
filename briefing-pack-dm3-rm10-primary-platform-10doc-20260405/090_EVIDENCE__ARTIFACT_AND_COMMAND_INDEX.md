# Evidence Index

## Key Artifact Roots

- `artifacts/phase_01_2_3_1_rm10_preflight_20260405/`
- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/cpu_control/`
- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/gpu_feasibility/`
- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/npu_feasibility/`
- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/heterogeneous_abstain/`

## Key Commands

CPU control:

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/branch_01_2_3_1_cpu_20260405'
```

GPU feasibility:

```bash
adb shell 'getprop ro.hardware.egl; getprop ro.hardware.vulkan; ls -l /dev/kgsl-3d0; dumpsys SurfaceFlinger | head -40'
```

NPU feasibility:

```bash
adb shell 'ls /dev | grep -E "fastrpc|cdsp|adsp|nsp"; ls /vendor/lib64 | grep -E "dsp|adsprpc|cdsprpc"; ls /vendor/bin | grep -E "dsp|rpc"'
```
