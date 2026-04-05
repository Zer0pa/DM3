# Evidence Index

## New Phase Artifact Roots

| Root | Meaning |
| --- | --- |
| `artifacts/phase_01_2_3_2_f1_anchor_20260405/` | fresh governed `F1` anchor, live help surface, telemetry, mirrored receipts |
| `artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/` | four-run bounded `F2` CPU/GPU repeat matrix with identity and telemetry |
| `artifacts/phase_01_2_3_2_npu_triage_20260405/` | bounded NPU or DSP inventory and callable-surface probe |

## Phase Documents

- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/RM10_F1_ANCHOR_DOSSIER.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/F1_ACCELERATOR_SURFACE_AUDIT.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/F2_HARMONIC_STABILITY_DOSSIER.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/RM10_NPU_TRIAGE_DOSSIER.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/RM10_BRIDGE_AND_HANDOFF_DECISION.md`

## Key Commands

Governed `F1` anchor:

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/branch_01_2_3_2_f1_cpu_a'
```

Governed `F1` help surface:

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --help'
```

Residue `F2` CPU/GPU matrix:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/phase_01_2_3_2_f2_cpu_a.jsonl'
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/phase_01_2_3_2_f2_gpu_a.jsonl'
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/phase_01_2_3_2_f2_cpu_b.jsonl'
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/phase_01_2_3_2_f2_gpu_b.jsonl'
```

NPU or DSP callable-surface probe:

```bash
adb shell 'for name in qnn-net-run qnn-context-binary-generator qnn-profile-viewer qnn-op-package-generator fastrpc_shell adsprpcd cdsprpcd dspservice; do printf "== %s ==\n" "$name"; command -v "$name" || true; done'
```
