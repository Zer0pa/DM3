# History Observables Index

## Purpose

Index the older RM10-side observable candidates that can guide branch batteries
without smuggling historical semantics into authority.

## Index

| Observable ID | Observable family | Source family | Trust class | Current status | Evidence anchor | What is actually observed | How later plans should use it | Do not infer |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `O-01` | Genesis witness tuple | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/WITNESS_LANE_REPAIR_NOTE.md`; `docs/restart/PROJECT_AND_WORKSTREAM_TESTS_SUMMARY_20260404.md` | lane-specific `verify.json` / `solve_h2.json` tuples plus default-validator vs explicit-hash split | keep RM10 CPU controls anchored to explicit, tuple-based receipt comparison | that fresh RM10 lanes are already sovereign or source-built |
| `O-02` | smoke canonical | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `docs/restart/G2_ROUTE_DECISION_OBJECT.md`; `retirement_route_matrix.tsv` | normalized SHA-256 `d3e721...` with `run_id=t1_contraction` across all justified same-binary inference routes | use as the branch's negative control for hybrid inference tasks | that any task variation beating smoke exists until a new receipt proves it |
| `O-03` | non-smoke train metrics: holography | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `serious_pass/attempts/train_holography_stdout.txt` | training loop with GPU kernel init, 100 episodes, and per-episode `Dec`, `dE`, `Coh` | candidate battery observable if branch can rebuild the same metrics under current identity and telemetry rules | that these metrics are already governed or comparable to Genesis hashes |
| `O-04` | non-smoke train metrics: harmonic | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `serious_pass/attempts/train_harmonic_stdout.txt` | same train-loop surface with different `Dec` / `dE` / `Coh` profile and intermittent reject / retry behavior | candidate comparison observable against `O-03` for role-partition or stability tests | that the harmonic family is scientifically meaningful by label alone |
| `O-05` | boundary / bulk reconstruction cue | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `candidate_strings_boundary_focus.txt` | strings such as `Holography (Boundary->Bulk)`, `k_holography`, and `Boundary -> Bulk Reconstruction Error` | justify a boundary-family battery vocabulary and logging fields | that a live boundary reconstruction metric is already exposed on the current CLI |
| `O-06` | boundary readout cue | `dm3_compiled_residue` | `residue_clue` | `historically_suggested` | `candidate_strings_boundary_focus.txt`; bundled `output_g2_*` filenames | `G2 Boundary Readout`, `R2Contrastive`, and bundled `output_g2_*` residue | preserve as a naming clue for branch notebooks and falsifiers | that the preserved `G2` family is callable now |
| `O-07` | route-guard observable | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `retirement_route_matrix.tsv` | explicit `Error: Unknown task: ...` for `train exp_g2_readout`, `train boundary_alignment`, and `train boundary_power` | treat guarded names as kill conditions when designing batteries | that a label survives just because a string survives |
| `O-08` | accelerator-adjacent telemetry | `branch_local_preflight` | `governed_clue` | `evidenced_now` | `artifacts/phase_01_2_3_1_rm10_preflight_20260405/thermal.txt` | live `GPU0..GPU7`, `nsp0..nsp6`, `skin`, `battery`, `cdsp`, `gpu` cooling-device and threshold surfaces | use as feasibility telemetry for GPU/NPU and heterogeneous runs | that telemetry visibility equals user-space accelerator execution |
| `O-09` | hardware budget observables | `branch_local_preflight` | `governed_clue` | `evidenced_now` | `battery.txt`; `meminfo.txt` | AC-powered state, 80% battery, nominal thermal status, ~23.7 GB RAM, available memory and CMA budget | bound micro vs medium battery sizes and checkpoint policy | that headroom alone says anything about semantics |
| `O-10` | output-family drift surface | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `serious_pass/preflight/dm3_listing.txt` | many `output_g2_mini_tuned_v*`, `output_gpu_phase*`, `output_gpu_no_*`, `output_gpu_true_pass`, and `output_cpu_*` files | use as an index of which observable families historically mattered enough to tune or debug | that any particular file version is a blessed target without command provenance |

## Recommended Observable Order For The Branch

1. Start with `O-01` as the CPU control and governance anchor.
2. Use `O-08` and `O-09` only as telemetry and battery-budget observables.
3. If the branch wants a hybrid-family candidate, promote `O-03` and `O-04`
   into explicit runbook targets first.
4. Keep `O-02` and `O-07` as permanent negative controls.
5. Treat `O-05`, `O-06`, and `O-10` as residue prompts until branch-local runs
   reproduce something cleaner than file names and strings.
