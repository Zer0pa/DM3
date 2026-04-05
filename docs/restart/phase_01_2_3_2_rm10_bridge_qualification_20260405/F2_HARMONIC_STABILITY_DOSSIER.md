# F2 Harmonic Stability Dossier

## Verdict

- `f2_callable_family_verdict=PASS`
- `f2_repeatability_verdict=unstable_feasibility`
- `authority_status=feasibility_only`
- `family_class=bundled_residue`

## Identity Packet

- primary binary: `/data/local/tmp/dm3_runner`
- primary binary sha256: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- alternate residue binary also present: `/data/local/tmp/dm3/dm3_runner`
- alternate residue sha256: `d678e8d355601d13dd1608032fd5e6fdf5eaa81bdde0af5f124125ff1bcea8b1`
- `SriYantraAdj_v1.bin` sha256: `22f4bc8fa1858bb98cce445614d498b04292f7c1b54ba2bacbe5786b969f637c`
- `RegionTags_v2.bin` sha256: `2f9f1d733ac92c2d1e2bdbdf9af5e2949620519e0fa7eeb3826e2719e922a440`
- `RegionTags_v2.json` sha256: `ecb8711466494c5d516b89096fdb8c685eb252f6b9bcae566260c6f2142e450c`
- artifact root: `artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/`

## Four-Run Matrix

| Run | Lane | Stdout marker | Decision | `delta_E` | `coherence` | `duration_ms` |
| --- | --- | --- | --- | ---: | ---: | ---: |
| `phase_01_2_3_2_f2_cpu_a` | CPU | `Forcing CPU Mode (GPU Disabled)` | `Commit` | `76.03376770019531` | `0.8772012591362` | `48899` |
| `phase_01_2_3_2_f2_gpu_a` | GPU-backed | `GPU MatMul Kernel Initialized`, `GPU Transformer Kernel Initialized` | `Commit` | `89.01263427734375` | `0.770898163318634` | `57818` |
| `phase_01_2_3_2_f2_cpu_b` | CPU | `Forcing CPU Mode (GPU Disabled)` | `Commit` | `76.06745147705078` | `0.8770847320556641` | `62116` |
| `phase_01_2_3_2_f2_gpu_b` | GPU-backed | `GPU MatMul Kernel Initialized`, `GPU Transformer Kernel Initialized` | `Commit` | `76.23069763183594` | `0.8769537210464478` | `59647` |

## What Held

- all four runs preserved the same one-line JSONL receipt schema
- both CPU runs preserved the explicit CPU-forced marker
- both GPU-backed runs preserved the explicit GPU-init markers
- all four runs retained pre/post telemetry and receipt custody
- thermal status remained `0` for every post-run capture

## What Drifted

The CPU pair is internally tight:

- `delta_E` drift: about `0.0337`
- `coherence` drift: about `0.00012`

The GPU pair is not tight:

- `gpu_a` diverged to `delta_E=89.0126`, `coherence=0.7709`
- `gpu_b` returned near the CPU-family neighborhood at `delta_E=76.2307`, `coherence=0.8770`

This means the current bounded residue family is real and callable, but not yet
stable enough to be treated as a settled accelerator comparison surface.

## Thermal Envelope

| Run | Battery temp post | Thermal status post |
| --- | --- | --- |
| `cpu_a` | `31.0 C` | `0` |
| `gpu_a` | `32.0 C` | `0` |
| `cpu_b` | `32.0 C` | `0` |
| `gpu_b` | `33.0 C` | `0` |

The instability does not localize to a thermal-throttle event.

## Conclusion

`F2` remains a real bounded residue-feasibility family. It is **not** a clean
stable accelerator family yet, because the first GPU-backed repeat drifted
materially while custody, schema, and stdout markers remained intact. The
honest ceiling is therefore `unstable_feasibility`, not bridge-grade evidence.
