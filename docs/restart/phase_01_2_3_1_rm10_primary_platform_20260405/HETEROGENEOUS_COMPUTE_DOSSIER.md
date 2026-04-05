# Heterogeneous Compute Dossier

## Current Branch Result

The branch now has two distinct accelerator-relevant outcomes:

- `gpu_feasibility_verdict=PASS` on the bounded bundled-residue family `F2: dm3_harmonic_train_episode`
- `heterogeneous_role_partition_verdict=ABSTAIN` for explicit mixed execution

## Evidence Basis

### Primary controlled family: `F1`

The branch retains one governed RM10 CPU control family:

- executable: `/data/local/tmp/genesis_cli`
- cwd: `/data/local/tmp/SoC_runtime/workspace`
- outputs: `verify.json=f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`, `solve_h2.json=a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- ceiling: `governed_non_sovereign`
- build class: `prebuilt_stub`

No accelerator lane has yet preserved `F1`.

### Bounded accelerator family: `F2`

The branch also established one lower-ceiling CPU versus GPU feasibility family
on the preserved bundled residue:

| Lane | Command shape | Key stdout evidence | Receipt outcome |
| --- | --- | --- | --- |
| CPU | `/data/local/tmp/dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/dm3_probe_train_harmonic_cpu.jsonl` | `Forcing CPU Mode (GPU Disabled)` | `decision=Commit`, `delta_E=74.96417236328125`, `coherence=0.8924495577812195`, `duration_ms=62378` |
| GPU-backed | `/data/local/tmp/dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/dm3_probe_train_harmonic.jsonl` | `GPU MatMul Kernel Initialized`, `GPU Transformer Kernel Initialized` | `decision=Commit`, `delta_E=75.55409240722656`, `coherence=0.8767133355140686`, `duration_ms=47581` |

`F2` proves a bounded callable GPU-backed path on-device.
It does not prove source-built parity, explicit role partition, or carry-forward
to `F1`.

### NPU or DSP-adjacent surface

NPU-adjacent infrastructure is real:

- `libQnnHtp.so`
- `libQnnHtpPrepare.so`
- `libQnnSystem.so`
- `libadsprpc.so`
- `libcdsprpc.so`
- `adsprpcd`, `cdsprpcd`, `dspservice`

No receiptable user-space assist command has been established.

## Why GPU Is `PASS` At Feasibility Ceiling

- the GPU-backed `F2` run is callable from user space
- a forced-CPU twin exists on the same family
- both sides emit comparable one-episode JSONL receipts
- the GPU-backed path declares accelerator initialization in stdout

This is enough for `feasibility_only PASS`.

## Why Explicit Heterogeneous Role Partition Is Still `ABSTAIN`

- no pre-handoff and post-handoff artifacts exist
- the mixed behavior lives inside one opaque binary invocation
- no drift-localization artifact separates CPU-owned and GPU-owned stages
- the only same-family accelerator evidence is on `F2`, not on the primary governed family `F1`

## Why NPU Is Still `ABSTAIN`

- infrastructure is visible
- no callable CLI or wrapper has been named
- no receiptable transform or assist role exists yet

## Preconditions For Promotion

Promotion beyond the current ceiling requires:

1. one accelerator lane on the same family as the primary governed CPU control
2. explicit handoff ownership
3. retained pre-handoff and post-handoff artifacts
4. drift localization
5. no ceiling inflation from `bundled_residue` into `governed_non_sovereign`

## Most Useful Next Step

Stabilize and repeat `F2` with a full identity packet and telemetry capture,
then either:

- carry a callable accelerator path onto `F1`, or
- explicitly declare `F2` a separate bundled-residue accelerator line that does
  not speak for the primary governed control family.
