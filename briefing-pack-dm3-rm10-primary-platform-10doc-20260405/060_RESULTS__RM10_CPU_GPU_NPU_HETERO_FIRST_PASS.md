# First-Pass Results

## Primary CPU Control Family (`F1`)

- verdict: `PASS`
- command ran from `/data/local/tmp/SoC_runtime/workspace`
- `verify.json` hash `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`
- `solve_h2.json` hash `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- thermal status remained nominal

## Bundled-Residue CPU Versus GPU Family (`F2`)

- CPU twin verdict: `PASS`
- GPU-backed twin verdict: `PASS`
- family: `dm3_harmonic_train_episode`
- CPU twin logs `Forcing CPU Mode (GPU Disabled)`
- GPU-backed twin logs `GPU MatMul Kernel Initialized` and `GPU Transformer Kernel Initialized`
- CPU receipt: `Commit`, `delta_E=74.96417236328125`, `coherence=0.8924495577812195`, `duration_ms=62378`
- GPU-backed receipt: `Commit`, `delta_E=75.55409240722656`, `coherence=0.8767133355140686`, `duration_ms=47581`
- ceiling: `feasibility_only`

## NPU

- verdict: `ABSTAIN`
- DSP/NPU-adjacent libraries and daemons are real
- no branch-grade assist role was established on this pass

## Explicit Heterogeneous Role Partition

- verdict: `ABSTAIN`
- the branch now has a GPU-backed bounded family
- it still lacks an explicit handoff artifact, drift-localization note, or same-family mixed path on the primary governed control surface
