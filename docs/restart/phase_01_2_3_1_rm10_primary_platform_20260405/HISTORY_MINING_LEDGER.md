# History Mining Ledger

## Purpose

Record which older RM10-side history surfaces are being mined on this branch,
what kind of clue each surface can honestly contribute, and where authority
must stop.

This ledger is a mining aid, not a recovery verdict.
It may sharpen branch engineering and battery design, but it may not promote
old residue into present truth.

## Classification Rules

### Trust classes

| Token | Meaning |
| --- | --- |
| `governed_clue` | source-backed or audited branch-local evidence that can directly constrain runbooks or batteries |
| `residue_clue` | retained compiled residue or historical artifact presence that can suggest tests but not settle meaning |
| `ambiguity` | remembered, documentary, or partial hint that should shape caution only until re-tested |

### Source families

| Token | Meaning |
| --- | --- |
| `governed_soc_genesis` | older governed SoC / Genesis replay doctrine and witness-lane carry-forward |
| `dm3_compiled_residue` | later on-device DM3 binary, assets, outputs, strings, and train/inference surfaces |
| `branch_local_preflight` | current branch-local 2026-04-05 RM10 identity, staging, memory, and telemetry receipts |
| `branch_doctrine_carry_forward` | branch-local closeout docs that preserve current ceilings and anti-proxy rules |
| `training_doc_hypothesis` | old design intent carried only as hypothesis prompts, not executable fact |

## Custody-Aware Mining Ledger

| ID | Source family | Local anchor | Trust class | Current status | What can be mined | Branch relevance | Authority boundary |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `L-01` | `branch_local_preflight` | `artifacts/phase_01_2_3_1_rm10_preflight_20260405/adb_identity.txt` | `governed_clue` | `evidenced_now` | device identity `NX789J`, board `sun`, Android 15 shell environment | fixes the branch to one real RM10 target and current shell surface | says nothing by itself about CPU/GPU/NPU scientific usefulness |
| `L-02` | `branch_local_preflight` | `artifacts/phase_01_2_3_1_rm10_preflight_20260405/tmp_listing.txt` | `governed_clue` | `evidenced_now` | surviving `/data/local/tmp` paths, bundled assets, `SoC_Harness`, `SoC_runtime`, `snic_workspace_a83f`, `genesis_cli`, root `dm3_runner`, bundled `dm3/` | identifies the current staging and execution roots the branch can actually probe | does not prove any listed binary is source-built, authoritative, or semantically live |
| `L-03` | `governed_soc_genesis` | `docs/restart/LEGACY_BATTERY_ENTRYPOINTS.md` | `governed_clue` | `evidenced_now` | documented October and Genesis entrypoints `O-00..O-07` and `G-00..G-06` | gives the safest command families for RM10 CPU control and copied-reference validation | excludes missing hybrid source and any undeclared GPU/NPU authority lane |
| `L-04` | `branch_doctrine_carry_forward` | `docs/restart/WITNESS_LANE_REPAIR_NOTE.md`, `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`, `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md` | `governed_clue` | `evidenced_now` | lane labels, execution roots, validator split, and build-class ceilings | keeps branch history mining anchored to current witness-floor and execution-surface honesty | does not authorize source-built parity or sovereignty for the fresh RM10 lanes |
| `L-05` | `branch_doctrine_carry_forward` | `docs/restart/LONG_HORIZON_EXECUTIVE_VERDICT.md`, `docs/restart/LONG_HORIZON_BLOCKER_MEMO.md`, `docs/restart/LONG_HORIZON_NEXT_PHASE_RECOMMENDATION.md` | `governed_clue` | `evidenced_now` | same-binary `G2` retirement, GPU not-ready, NPU feasibility-only, heterogeneous premature | supplies the non-promotion ceiling the branch is explicitly testing | does not forbid branch experiments, but it forbids narrating them as inherited readiness |
| `L-06` | `dm3_compiled_residue` | `artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/preflight/dm3_listing.txt` | `residue_clue` | `evidenced_now` | bundled asset inventory plus `output_g2_*`, `output_gpu_*`, `output_cpu_*`, `exp_i*`, and probe JSONLs | exposes historical task families, asset expectations, and likely failure clusters worth indexing | file presence alone does not prove the outputs remain reproducible or meaningful |
| `L-07` | `dm3_compiled_residue` | `artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/argv/help.txt`, `help_task_exp_g2_readout.txt`, `help_mode_inference.txt` | `governed_clue` | `evidenced_now` | live CLI contract: `mode={inference,train}`, help-listed tasks `holography` and `harmonic`, default assets and dataset knobs | constrains branch batteries to real help-surfaced task knobs before any string-promoted guesses | help text does not prove richer task families are callable |
| `L-08` | `dm3_compiled_residue` | `docs/restart/G2_ROUTE_DECISION_OBJECT.md`, `artifacts/phase_01_2_3_g2_invocation_archaeology_20260404T201849Z/comparisons/retirement_route_matrix.tsv` | `governed_clue` | `evidenced_now` | smoke-equivalent inference routes, callable non-smoke train routes, and train-side guarded names | separates live tasks from dead labels so the branch can reuse only the actionable ones | does not reopen same-binary `G2` hunting |
| `L-09` | `dm3_compiled_residue` | `artifacts/phase_01_2_3_plan01_invocation_audit_20260404/supplement/strings/candidate_strings_boundary_focus.txt` | `residue_clue` | `evidenced_now` | source-path names, kernel names, `R2Contrastive`, boundary labels, GPU-transformer init strings | suggests observable and role-partition candidates for explicit testing | strings alone are not route proof or architecture proof |
| `L-10` | `branch_local_preflight` | `artifacts/phase_01_2_3_1_rm10_preflight_20260405/thermal.txt`, `battery.txt`, `meminfo.txt` | `governed_clue` | `evidenced_now` | GPU and `nsp*` telemetry channels, cooling devices, battery state, memory budget | bounds feasible battery classes and identifies accelerator-adjacent telemetry surfaces | telemetry visibility is not a user-space compute path |
| `L-11` | `dm3_compiled_residue` | `artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/attempts/train_holography_stdout.txt`, `train_harmonic_stdout.txt` | `residue_clue` | `evidenced_now` | non-smoke train-mode metrics: `Dec`, `dE`, `Coh`, resonance-loop episodes, GPU kernel init lines | offers a candidate observable family for RM10-first battery design after governance is rebuilt | does not yet define an accepted CPU/GPU/NPU common observable |
| `L-12` | `training_doc_hypothesis` | `docs/restart/TRAINING_DOC_HYPOTHESES.md` | `ambiguity` | `historically_suggested` | boundary-transformer role, SoC CPU/GPU/NPU role partition, structure-first mobile target | useful for hypothesis naming and battery prompts | remains design intent until branch-local execution proves a role split on a common observable |

## Ledger Bottom Line

- The strongest governed mining inputs are the current RM10 preflight, the
  recoverable Genesis/October entrypoints, the witness-floor labels, and the
  audited route-retirement package.
- The strongest residue inputs are the bundled `dm3` directory inventory, the
  live CLI help surface, the retained train-mode outputs, and the boundary /
  GPU string residue.
- The branch should treat every mined item as one of three things only:
  a directly actionable governed clue, a test prompt from residue, or an
  ambiguity that must stay below authority until re-tested.
