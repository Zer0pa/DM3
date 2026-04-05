# RM10 Branch Next Move Recommendation

## Single Best Next Move

Run one narrow outlier-localization diagnostic on the exact same residue `F2`
CPU/GPU harmonic family under locked identity and telemetry capture.

## Why

This phase already closed the bigger questions on the current live surface:

- `F1` is governed and reproducible
- `F1` has no current accelerator-bearing selector
- `F2` is residue-only and not repeatably stable enough to speak for `F1`

That leaves one live accelerator question worth bounded engineering effort:
is the first GPU-backed outlier a one-off disturbance or evidence that the
residue family itself is too unstable to retain even `feasibility_only` weight?

## Execution Consequence

The next branch phase should:

1. rerun the exact `dm3_runner --mode train --task harmonic --steps 1` residue
   family under locked preflight and identity capture
2. decide whether the GPU outlier localizes to startup disturbance or to family
   instability
3. keep `F1` as the scientific anchor and refuse any bridge upgrade from the
   diagnostic result alone

## Not The Next Move

- do not narrate the diagnostic pass as bridge progress or explicit heterogeneous proof
- do not promote inventory-only QNN or DSP infrastructure
- do not claim explicit heterogeneous execution without handoff artifacts
