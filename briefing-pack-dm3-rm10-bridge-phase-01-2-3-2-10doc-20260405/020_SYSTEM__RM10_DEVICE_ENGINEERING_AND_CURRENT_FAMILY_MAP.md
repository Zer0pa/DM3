# System

The attached RM10 remains a real execution target under `/data/local/tmp`.

Confirmed branch surfaces now:

| Surface | Root or `cwd` | Role now | Ceiling |
| --- | --- | --- | --- |
| governed Genesis control `F1` | `/data/local/tmp/SoC_runtime/workspace` | primary scientific control family | `governed_non_sovereign` |
| governed Genesis accelerator bridge | live `genesis_cli --help` surface | closed on current executable surface | none |
| bundled residue `F2` | `/data/local/tmp` | bounded accelerator-feasibility witness | `feasibility_only` |
| NPU or DSP infrastructure | `/dev`, `/vendor/lib64`, `/vendor/bin` | inventory only | `inventory_only` |
| explicit heterogeneous handoff | not surfaced | no live evidence yet | not open |

Key system conclusion:

- the phone is a governed CPU instrument now
- the phone is also an accelerator-rich hardware body
- the current governed executable does not surface that accelerator body as a
  same-family callable path
- the residue executable does surface bounded GPU-backed behavior, but only on a
  separate lower-ceiling family
