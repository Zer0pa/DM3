# RM10 First Execution Dossier

## First-Pass Verdict

- primary governed CPU control (`F1`): `PASS`
- bundled-residue CPU versus GPU feasibility family (`F2`): `PASS`
- NPU or DSP assist: `ABSTAIN`
- explicit heterogeneous role partition: `ABSTAIN`

## Family `F1`: Governed RM10 CPU Control

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

The branch has one clean governed RM10 CPU control pass without thermal stress
or receipt loss.

## Family `F2`: Bundled-Residue CPU Versus GPU Feasibility

Artifact root:

- `artifacts/phase_01_2_3_1_dm3_harmonic_train_compare_20260405/`

CPU twin:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/dm3_probe_train_harmonic_cpu.jsonl'
```

GPU-backed twin:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/dm3_probe_train_harmonic.jsonl'
```

Observed compare result:

| Lane | Stdout evidence | Receipt summary |
| --- | --- | --- |
| CPU | `Forcing CPU Mode (GPU Disabled)` | `Commit`, `delta_E=74.96417236328125`, `coherence=0.8924495577812195`, `duration_ms=62378` |
| GPU-backed | `GPU MatMul Kernel Initialized`, `GPU Transformer Kernel Initialized` | `Commit`, `delta_E=75.55409240722656`, `coherence=0.8767133355140686`, `duration_ms=47581` |

Interpretation:

This is a real same-schema CPU versus GPU feasibility family on-device.
Its ceiling is still `feasibility_only` because it is `bundled_residue`, not
the primary governed family.

## NPU Feasibility Pass

Artifact root:

- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/npu_feasibility/`

Observed:

- `libQnnHtp.so`
- `libQnnHtpPrepare.so`
- `libQnnSystem.so`
- `libadsprpc.so`
- `libcdsprpc.so`
- `adsprpcd`, `cdsprpcd`, `dspservice`

Verdict:

- `ABSTAIN`

Reason:

Accelerator-adjacent libraries and daemons are visible, but a branch-grade
receiptable user-space assist role was not established.

## Explicit Heterogeneous Role-Partition Pass

Artifact root:

- `artifacts/phase_01_2_3_1_rm10_batteries_20260405/heterogeneous_abstain/`

Verdict:

- `ABSTAIN`

Reason:

The branch now has a GPU-backed bounded family, but it does not yet have an
explicit handoff artifact or a same-family mixed path on the primary governed
control surface.
