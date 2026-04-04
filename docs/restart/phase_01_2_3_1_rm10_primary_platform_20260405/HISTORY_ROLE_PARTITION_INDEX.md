# History Role Partition Index

## Purpose

Index the older RM10-side hints about CPU/GPU/NPU and stage-wise role
partitioning, while keeping every split below present-tense authority until it
is re-tested on a common observable.

## Index

| Role ID | Proposed partition | Source family | Trust class | Current status | Evidence anchor | What the history actually says | Constraint on later runbooks | Do not infer |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `R-01` | CPU-first control lane on RM10 | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/LEGACY_BATTERY_ENTRYPOINTS.md`; `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md` | the safest device-side control remains Genesis replay under `/data/local/tmp` with explicit receipts and validation discipline | every GPU/NPU/heterogeneous battery should name an RM10 CPU control observable first | that CPU control alone proves SoC-native scientific advantage |
| `R-02` | prebuilt-backed device wrapper role | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md`; `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md` | `SoC_Harness/bin` and the stubbed `cargo` role are execution plumbing, not proof of source-built equivalence | keep wrapper logic explicit in branch runbooks and identity packets | that wrapper success is parity |
| `R-03` | stage split inside the compiled residue: inference vs train | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `retirement_route_matrix.tsv`; `serious_pass/argv/help.txt` | inference tasks collapse to smoke, while train `holography` and `harmonic` are the only current non-smoke live routes | design hybrid batteries around the train-family routes if a current common observable is needed | that train semantics are already understood or authority-bearing |
| `R-04` | GPU-attached train lane | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `train_holography_stdout.txt`; `train_harmonic_stdout.txt` | train mode prints `GPU MatMul Kernel Initialized.` and `GPU Transformer Kernel Initialized.` before entering resonance training | treat GPU as a real role clue for train-family feasibility work | that GPU parity is already established or meaningful under inference |
| `R-05` | resonance / decision loop as the operative training stage | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `train_holography_stdout.txt`; `train_harmonic_stdout.txt` | the observable loop is episode-based with `Dec`, `dE`, and `Coh`, not a conventional epoch/loss printout | if the branch reuses this family, log these three fields explicitly and compare their stability across compute lanes | that resonance vocabulary alone proves the scientific story |
| `R-06` | boundary adapter role for transformers | `training_doc_hypothesis` | `ambiguity` | `historically_suggested` | `docs/restart/TRAINING_DOC_HYPOTHESES.md` | the training-doc frame says transformers belong at the boundary as encoder/readout rather than as the hidden-state substrate | if the branch tests heterogeneous roles, keep boundary-adapter vs hidden-state takeover as an explicit falsification axis | that the surviving compiled residue actually still honors this architectural line |
| `R-07` | mobile SoC CPU/GPU/NPU role separation | `training_doc_hypothesis` | `ambiguity` | `historically_suggested` | `docs/restart/TRAINING_DOC_HYPOTHESES.md`; `HYPOTHESIS.md` | older design intent explicitly imagines phone-class CPU/GPU/NPU partitioning | useful as a hypothesis label and battery-family organizer | that a real NPU role exists now |
| `R-08` | NPU / DSP as feasibility telemetry lane first | `branch_local_preflight` | `governed_clue` | `evidenced_now` | `artifacts/phase_01_2_3_1_rm10_preflight_20260405/thermal.txt` | `nsp*` temperatures and `cdsp` / `cdsp_hw` cooling devices are visible to the shell user | early NPU work should start as telemetry and user-space reachability only | that DSP/NPU visibility is already a callable compute role |
| `R-09` | heterogeneous sequencing rule | `branch_doctrine_carry_forward` | `governed_clue` | `evidenced_now` | `docs/restart/LONG_HORIZON_EXECUTIVE_VERDICT.md`; `docs/restart/phase_01_2_3_execution_prep_20260404/RUNBOOK_HETEROGENEOUS_EMBODIMENT.md` | heterogeneous work stays premature until a single-lane CPU observable exists and GPU parity plus NPU feasibility are bounded on that same observable | branch batteries must preserve explicit prerequisites instead of skipping straight to mixed execution | that heterogeneity is a free win once the hardware is visible |
| `R-10` | boundary-tag and adjacency assets as stage-specific inputs | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | bundled `dm3_listing.txt`; `help.txt` | `SriYantraAdj_v1.bin` and `RegionTags_*` imply a stage that consumes adjacency and region-tag inputs | if branch batteries try boundary-family tasks, declare the asset contract explicitly | that these assets still map to the old readout semantics |

## Practical Role Map For The Branch

- `R-01` and `R-02` should define the first RM10 CPU control lane.
- `R-03`, `R-04`, and `R-05` are the strongest branch-local clues for a later
  GPU-shaped train-family battery.
- `R-08` is the strongest honest NPU clue today, and it is still only a
  feasibility clue.
- `R-06`, `R-07`, and `R-10` are useful architectural prompts, but they must
  stay hypotheses until re-tested.
