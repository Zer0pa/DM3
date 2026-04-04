# History Failure Pattern Index

## Purpose

Index the older RM10-side failure signatures and dead ends that should constrain
this branch.

These are warnings and kill criteria, not substitute success stories.

## Index

| Failure ID | Pattern | Source family | Trust class | Current status | Evidence anchor | What happened | Branch constraint |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `F-01` | inference-task variation still collapses to the same smoke canonical | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `retirement_route_matrix.tsv`; `G2_ROUTE_DECISION_OBJECT.md` | `exp_g2_readout`, `holography`, `harmonic`, `boundary_alignment`, and `boundary_power` all normalized to `d3e721...` in inference mode | do not treat inference-task variation as evidence of a new hybrid observable until a receipt breaks the smoke family |
| `F-02` | train-side route guard rejects historical labels | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `retirement_route_matrix.tsv` | `train exp_g2_readout`, `train boundary_alignment`, and `train boundary_power` each fail with `Error: Unknown task: ...` | any branch battery using an old task name must prove live callability first |
| `F-03` | wrapper resurrection failed | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | empty `serious_pass/wrappers/wrapper_refs.txt`; `G2_ROUTE_DECISION_OBJECT.md` | no surviving wrapper or env mutation path was found beyond the direct ADB-shell surface | do not build branch plans around launcher or wrapper folklore without new receipts |
| `F-04` | string residue overstates live capability | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `candidate_strings_boundary_focus.txt` | strings expose `R2Contrastive`, boundary names, kernel names, and task paths, but current live routes do not honor them as callable semantics | never let names outrank receipts |
| `F-05` | fresh RM10 witness lanes still fail default validation | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/WITNESS_LANE_REPAIR_NOTE.md`; `docs/restart/PROJECT_AND_WORKSTREAM_TESTS_SUMMARY_20260404.md` | SoC runtime and raw workspace are executable but remain under explicit-hash interim handling | branch CPU controls must not be promoted into sovereignty until validator repair is real |
| `F-06` | fresh RM10 witness lanes remain prebuilt-backed | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md` | the SoC lane is `prebuilt_stub`, the raw workspace lane is `mixed_prebuilt_backed` | branch engineering must keep source-built parity as an open question, not a premise |
| `F-07` | root `dm3_runner` GPU split failed to distinguish itself from smoke | `branch_doctrine_carry_forward` | `governed_clue` | `evidenced_now` | `docs/restart/PROJECT_AND_WORKSTREAM_TESTS_SUMMARY_20260404.md`; `docs/restart/LONG_HORIZON_EXECUTIVE_VERDICT.md` | default vs `--cpu` stayed smoke-only and did not justify a meaningful current GPU split | do not count GPU activity alone as branch progress |
| `F-08` | hardware visibility tempts readiness inflation | `branch_local_preflight` | `governed_clue` | `evidenced_now` | `artifacts/phase_01_2_3_1_rm10_preflight_20260405/thermal.txt`; `battery.txt` | GPU and `nsp*` telemetry, `kgsl` reachability, and cooling-device visibility are real, but they are not user-space compute proof | branch runbooks must separate reachable, measurable, callable, and scientifically usable |
| `F-09` | bundled residue shows many zero-byte or obviously partial GPU outputs | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | bundled `dm3_listing.txt` | several `output_gpu_phase1*.txt` and related variants are empty or partial, indicating repeated dead-end GPU iterations | later GPU batteries should carry explicit kill criteria for empty receipts, missing writes, and partial outputs |
| `F-10` | residue file proliferation without retained command provenance | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | bundled `dm3_listing.txt` | many tuned variants such as `output_g2_mini_tuned_v2..v10` and multiple `output_gpu_*` files survive without a clean command ledger in this branch | treat the family as hypothesis prompts and debugging residue, not as baseline targets |
| `F-11` | branch can overfit to old boundary rhetoric | `training_doc_hypothesis` | `ambiguity` | `historically_suggested` | `docs/restart/TRAINING_DOC_HYPOTHESES.md`; `candidate_strings_boundary_focus.txt` | boundary, holography, contrastive, and resonance labels are rich and attractive, but current evidence still splits live observables from historical naming | battery docs must define measurable observables before using loaded historical language |
| `F-12` | heterogeneous execution can become opaque before it becomes informative | `branch_doctrine_carry_forward` | `governed_clue` | `evidenced_now` | `docs/restart/LONG_HORIZON_EXECUTIVE_VERDICT.md`; `RUNBOOK_HETEROGENEOUS_EMBODIMENT.md` | heterogeneous work remains premature without a common CPU reference observable, GPU parity, and bounded NPU feasibility | kill any mixed-lane attempt that improves heat or throughput but destroys interpretability |

## Patterns That Should Become Kill Criteria

- `F-01`
- `F-02`
- `F-05`
- `F-06`
- `F-08`
- `F-09`
- `F-12`

## Patterns That Should Stay Warnings Until Reproduced

- `F-04`
- `F-10`
- `F-11`

These patterns are historically useful, but the branch should only harden them
into blockers after a fresh branch-local reproduction or a direct runbook tie.
