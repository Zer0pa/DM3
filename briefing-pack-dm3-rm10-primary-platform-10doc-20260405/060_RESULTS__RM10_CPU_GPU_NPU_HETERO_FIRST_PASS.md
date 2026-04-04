# First-Pass Results

## CPU

- verdict: `PASS`
- command ran from `/data/local/tmp/SoC_runtime/workspace`
- `verify.json` hash `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`
- `solve_h2.json` hash `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- thermal status remained nominal

## GPU

- verdict: `ABSTAIN`
- graphics runtime indicators are real
- no comparable compute path was established on this pass

## NPU

- verdict: `ABSTAIN`
- DSP/NPU-adjacent libraries and daemons are real
- no branch-grade assist role was established on this pass

## Heterogeneous

- verdict: `ABSTAIN`
- mixed execution was not promoted because the common GPU/NPU comparison path
  did not exist yet
