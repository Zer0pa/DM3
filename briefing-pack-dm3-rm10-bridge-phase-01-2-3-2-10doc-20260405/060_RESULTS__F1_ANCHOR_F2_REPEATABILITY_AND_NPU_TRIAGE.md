# Results

## Governed `F1` Anchor

- verdict: `PASS`
- `verify.json`: `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`
- `solve_h2.json`: `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- thermal status stayed `0`

## Governed Bridge Audit

- verdict: `bridge_closed`
- live `genesis_cli --help` surface exposes no accelerator-bearing selector

## Residue `F2` Repeat Matrix

| Run | Lane | Decision | `delta_E` | `coherence` | Marker |
| --- | --- | --- | ---: | ---: | --- |
| `cpu_a` | CPU | `Commit` | `76.0338` | `0.8772` | CPU forced |
| `gpu_a` | GPU-backed | `Commit` | `89.0126` | `0.7709` | GPU init |
| `cpu_b` | CPU | `Commit` | `76.0675` | `0.8771` | CPU forced |
| `gpu_b` | GPU-backed | `Commit` | `76.2307` | `0.8770` | GPU init |

Interpretation:

- same-schema callability is real
- custody and lane markers held
- one GPU-backed repeat drifted materially
- the honest classification is `unstable_feasibility`

## NPU Triage

- verdict: `ABSTAIN`
- QNN and DSP-adjacent infrastructure is visible
- no callable user-space assist path was found
