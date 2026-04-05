# System

The attached RM10 is a real execution target under `/data/local/tmp`.

Confirmed now:

- model `NX789J`
- platform `sun`
- about `23.66 GiB` RAM
- nominal thermal status on branch preflight
- `kgsl` visible
- accelerator-adjacent `nsp` telemetry visible
- SoC/Genesis and DM3 residue remain present under `/data/local/tmp`

Run-surface split:

| Surface | Device root or `cwd` | Current role | Ceiling |
| --- | --- | --- | --- |
| primary CPU control | `/data/local/tmp/SoC_runtime/workspace` | governed RM10 baseline | `governed_non_sovereign` |
| raw-workspace CPU variant | `/data/local/tmp/snic_workspace_a83f` | alternate prebuilt-backed lane | `mixed_prebuilt_backed` |
| bundled residue | `/data/local/tmp` and `/data/local/tmp/dm3` | archaeology and bounded accelerator feasibility | `bundled_residue` |
| GPU inventory | `/data/local/tmp` | graphics-stack visibility | `inventory_only` |
| NPU inventory | `/data/local/tmp` | DSP/NPU infrastructure visibility | `inventory_only` |

Run-surface conclusion:

- CPU control is live on the governed Genesis family
- GPU is callable on one bounded bundled-residue family, but not yet on the primary governed family
- NPU remains infrastructure-visible only
- explicit heterogeneous role partition remains below promotion
