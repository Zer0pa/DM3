# Evidence Index

## Artifact Roots And Required Minima

| Root | Intended run class | Meaning now |
| --- | --- | --- |
| `artifacts/phase_01_2_3_1_rm10_preflight_20260405/` | `setup_probe` | entry-gate anchor only |
| `artifacts/phase_01_2_3_1_rm10_batteries_20260405/cpu_control/` | `serious_run` | governed RM10 CPU control reference |
| `artifacts/phase_01_2_3_1_rm10_batteries_20260405/gpu_feasibility/` | `feasibility_probe` | graphics-stack and device-node visibility only |
| `artifacts/phase_01_2_3_1_rm10_batteries_20260405/npu_feasibility/` | `feasibility_probe` | DSP/NPU infrastructure visibility only |
| `artifacts/phase_01_2_3_1_rm10_batteries_20260405/heterogeneous_abstain/` | `abstain_record` | explicit non-execution, not missing work |
| `artifacts/phase_01_2_3_1_dm3_harmonic_train_compare_20260405/` | `feasibility_probe` | bounded bundled-residue CPU versus GPU compare on one family |

## Key Commands

Primary CPU control:

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/branch_01_2_3_1_cpu_20260405'
```

GPU feasibility inventory:

```bash
adb shell 'getprop ro.hardware.egl; getprop ro.hardware.vulkan; ls -l /dev/kgsl-3d0; dumpsys SurfaceFlinger | head -40'
```

Bundled-residue CPU versus GPU compare:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/dm3_probe_train_harmonic_cpu.jsonl'
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/dm3_probe_train_harmonic.jsonl'
```

NPU feasibility inventory:

```bash
adb shell 'ls /dev | grep -E "fastrpc|cdsp|adsp|nsp"; ls /vendor/lib64 | grep -E "Qnn|dsp|adsprpc|cdsprpc"; ls /vendor/bin | grep -E "dsp|rpc"'
```

Interpretation rule:

- the Genesis CPU command is the only command here that currently supports a governed branch comparison claim
- the `dm3_runner` pair is real, but its ceiling is `feasibility_only` on bundled residue
- the GPU inventory and NPU inventory commands are infrastructure probes, not readiness proof
