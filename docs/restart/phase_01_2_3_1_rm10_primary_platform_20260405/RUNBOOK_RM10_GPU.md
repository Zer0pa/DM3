# Runbook RM10 GPU

## Goal

Probe RM10 GPU callability without inflating feasibility into authority.

## Current GPU Surfaces

### Inventory-only surface

Confirmed:

- `ro.hardware.egl=adreno`
- `ro.hardware.vulkan=adreno`
- `/dev/kgsl-3d0` is visible
- GPU thermal channels are exposed

This proves `observed`, not `callable`.

### Callable bundled-residue surface

The branch has one bounded callable GPU-backed protocol:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --output /data/local/tmp/dm3_probe_train_harmonic.jsonl'
```

Comparison twin:

```bash
adb shell 'cd /data/local/tmp && ./dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/dm3_probe_train_harmonic_cpu.jsonl'
```

This surface is:

- `observable_family=dm3_harmonic_train_episode`
- `build_class=bundled_residue`
- `authority_status=feasibility_only`

## Required Questions

1. Is the path callable from user space?
2. Does a forced-CPU twin exist on the same observable family?
3. Do both sides emit comparable receipts?
4. Is the ceiling declared honestly?

If any answer is no, record `ABSTAIN` or `BLOCKED`.

## Required Captures

- exact command
- exact working directory
- stdout and stderr
- pre and post battery and thermal snapshots when feasible
- output receipt path
- explicit note describing whether the family is `F1` or `F2`

## GPU Verdict Standard

- `PASS`: callable path, same-family CPU twin, comparable receipt schema, and explicit ceiling
- `FAIL`: callable path exists but changes the observable family or breaks interpretation
- `ABSTAIN`: hardware is visible but no honest callable comparison path exists
- `BLOCKED`: a callable attempt was justified, but receipt or identity discipline drifted

## Hard Stops

- the only evidence is hardware presence
- the GPU path changes the observable family while still being narrated as comparison
- bundled-residue success is being promoted into governed `F1` authority
- internal accelerator use is being narrated as explicit role-partition evidence without a handoff artifact
