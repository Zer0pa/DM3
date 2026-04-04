# System

The attached RM10 is a real execution target under `/data/local/tmp`.

Confirmed now:

- model `NX789J`
- platform `sun`
- about `23.66 GiB` RAM
- nominal thermal status on first pass
- `kgsl` visible
- accelerator-adjacent `nsp` telemetry visible
- SoC/Genesis and DM3 residue remain present under `/data/local/tmp`

Run-surface conclusion:

- CPU control is live
- GPU is feasibility-visible
- NPU is feasibility-visible
- heterogeneous remains blocked by the missing common callable comparison path
