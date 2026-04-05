# RM10 Bridge And Handoff Decision

## Final Decisions

- `bridge_decision=separate_residue_line`
- `heterogeneous_handoff_verdict=ABSTAIN`

## Decision Basis

### Governed family `F1`

- fresh governed hashes reproduced exactly
- the live `genesis_cli` surface exposes no accelerator-bearing selector
- the governed bridge is therefore closed on the current executable surface

### Bundled-residue family `F2`

- the family is real and callable on both CPU and GPU-backed rows
- the family retained schema, custody, and lane markers
- one GPU-backed row drifted materially, so the repeatability verdict is only `unstable_feasibility`

### NPU

- infrastructure exists
- no callable user-space assist surface exists

## Why The Bridge Is Closed

`F2` does not speak for `F1`.

The branch now has:

- one governed CPU control family on `F1`
- one separate bounded residue-feasibility family on `F2`

It does **not** have:

- a same-family accelerator-bearing `F1` variant
- a preserved `F1` observable under acceleration
- any explicit pre-handoff and post-handoff artifacts on a common family

## Why Explicit Heterogeneous Execution Stays `ABSTAIN`

The only accelerator-relevant callable evidence lives inside the residue binary
family. No artifact localizes:

- CPU-owned stage
- accelerator-owned stage
- handoff format
- pre-handoff state
- post-handoff state

Without those pieces, opaque accelerator use cannot be promoted to explicit
heterogeneous role partition.

## Consequence

The branch should freeze `F2` as a separate residue-feasibility line and stop
using it as bridge rhetoric for the governed Genesis family. Any future bridge
attempt must come from a newly evidenced same-family surface, not from
reinterpretation of current residue behavior.
