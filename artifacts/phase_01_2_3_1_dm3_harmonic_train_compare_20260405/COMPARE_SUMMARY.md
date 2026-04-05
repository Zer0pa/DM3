# DM3 Harmonic Train Compare Summary

## Scope

This artifact root captures a bounded on-device CPU versus GPU-backed compare on
the preserved `dm3_runner` harmonic training family.

Ceiling:

- `run_kind=feasibility_probe`
- `authority_status=feasibility_only`
- `build_class=bundled_residue`
- `observable_family=dm3_harmonic_train_episode`

This root does not speak for the primary governed Genesis control family.

## Commands

CPU twin:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/dm3_probe_train_harmonic_cpu.jsonl'
```

GPU-backed twin:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/dm3_probe_train_harmonic.jsonl'
```

## Result Table

| Lane | Key stdout evidence | Decision | delta_E | coherence | duration_ms |
| --- | --- | --- | --- | --- | --- |
| CPU | `Forcing CPU Mode (GPU Disabled)` | `Commit` | `74.96417236328125` | `0.8924495577812195` | `62378` |
| GPU-backed | `GPU MatMul Kernel Initialized`; `GPU Transformer Kernel Initialized` | `Commit` | `75.55409240722656` | `0.8767133355140686` | `47581` |

## Interpretation

- the GPU-backed path is callable from user space
- a same-family forced-CPU twin exists
- both sides emit the same one-episode JSONL schema
- this is sufficient for a bounded GPU `PASS` at feasibility ceiling
- this is not yet an explicit heterogeneous role-partition result because no
  pre-handoff and post-handoff artifacts were retained
