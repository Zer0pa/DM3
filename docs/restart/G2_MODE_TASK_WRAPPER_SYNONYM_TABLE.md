# G2 Mode Task Wrapper Synonym Table

## Evidence Root

- retained audit root:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404`
- serious-pass mirror:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass`
- supplement comparison table:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/supplement/comparisons/receipt_hashes_boundary.tsv`
- binary: `/data/local/tmp/dm3/dm3_runner`
- binary SHA-256:
  `d678e8d355601d13dd1608032fd5e6fdf5eaa81bdde0af5f124125ff1bcea8b1`

## Mode / Task / Wrapper Table

| Token or surface | Kind | Provenance | Current live meaning on the bundled binary | Plan 02 use |
| --- | --- | --- | --- | --- |
| `train` | mode token | help text and live runs | real legacy resonance training branch | may be cited only to show the binary still has live non-smoke train work |
| `inference` | mode token | help text and live runs | live callable branch, but every tested task collapses to `t1_contraction` smoke | cannot be assumed to preserve task semantics |
| `holography` | help-listed task | help text plus strings plus live runs | train: live non-smoke; inference: smoke collapse | not a `G2` candidate |
| `harmonic` | help-listed task | help text plus strings plus live runs | train: live non-smoke; inference: smoke collapse | not a `G2` candidate |
| `exp_g2_readout` | residue task token | strings, historical bundled outputs, prior `01.2.2`, current live runs | inference: accepted argv that still collapses to smoke; train: rejected as unknown task | do not treat as a surviving routed `G2` task |
| `boundary_alignment` | string-backed residue candidate | `BOUNDED_NON_STUB_TARGET_SELECTION.md`, prior repo strings residue, supplement live runs | inference: accepted argv that still collapses to smoke; train: rejected as unknown task | retired; not a surviving routed task |
| `boundary_power` | string-backed residue candidate | `BOUNDED_NON_STUB_TARGET_SELECTION.md`, prior repo strings residue, supplement live runs | inference: accepted argv that still collapses to smoke; train: rejected as unknown task | retired; not a surviving routed task |
| `R2Contrastive` | output label residue | historical bundled `output_*` files and strings | preserved residue only; not surfaced as a live CLI mode token | residue only |
| `G2 Boundary Readout` | output header residue | historical bundled `output_*` files and strings | preserved residue only; never emitted by current live route census | residue only |
| `./dm3_runner` from `/data/local/tmp/dm3` | launcher | live direct invocation | canonical live launcher for the bundled binary | the only direct launcher Plan 02 may cite |
| `./dm3/dm3_runner` from `/data/local/tmp` | cwd variant | live direct invocation | live, but smoke-equivalent to the canonical launcher when given absolute assets | not a surviving non-smoke candidate |
| `dm3_termux_probe.sh` | script residue | top-level device script | Termux environment probe only; no `dm3_runner` invocation | not a launcher |
| wrapper script mentioning `dm3_runner` | wrapper surface | recursive `/data/local/tmp*.sh` search | none found | absent |

## Asset And Path Tokens

| Token | Provenance | Current status | Observed outcome |
| --- | --- | --- | --- |
| `SriYantraAdj_v1.bin` | help default and co-located device asset | live file | default and explicit forms both smoke-collapse |
| `RegionTags_v1.bin` | help default tag asset | live file | default-asset `exp_g2_readout` still smoke-collapses |
| `RegionTags_v2.json` | co-located device asset and historical `G2` residue anchor | live file | explicit and absolute forms still smoke-collapse |
| absolute asset paths | bounded archaeology probe | live surface | smoke-equivalent to relative co-located invocation |
| parent cwd with explicit binary path | bounded archaeology probe | live surface | smoke-equivalent to bundled cwd |

## Negative Controls

| Control | Result | Meaning |
| --- | --- | --- |
| `--task __bogus__ --mode inference` | exit `0`, `Running T1: Contraction...` | inference-mode task acceptance does not prove semantic routing |
| `--mode train --task __bogus__` | exit `1`, `Error: Unknown task: __bogus__` | train mode still enforces a task gate |

## Canonical Synonym Verdict

The current bundled runner exposes two real mode families:

- `train` = live legacy resonance training for the help-listed tasks only
- `inference` = live callable smoke family for every justified task tested so
  far, including `exp_g2_readout`

It does not expose any live synonym where `exp_g2_readout`, `R2Contrastive`,
`boundary_alignment`, `boundary_power`, or `G2 Boundary Readout` maps to a
distinct current observable. Those names are either inference-side smoke
aliases or residue-only labels.
