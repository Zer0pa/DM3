# History Clue Index

## Purpose

Index executable clues, path expectations, wrapper assumptions, asset pairings,
and naming conventions from the older RM10-side histories.

Each item is tagged by source family and trust class so later plans can reuse
only the actionable parts.

## Index

| Clue ID | Category | Item | Source family | Trust class | Current status | Evidence anchor | Branch use | Keep out of scope |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `C-01` | execution_root | `/data/local/tmp` is the canonical RM10 execution root | `branch_local_preflight` | `governed_clue` | `evidenced_now` | `artifacts/phase_01_2_3_1_rm10_preflight_20260405/tmp_listing.txt` | use as the default root for CPU, GPU-feasibility, NPU-feasibility, and heterogeneous passes | do not execute from shared storage |
| `C-02` | execution_root | governed Genesis cwd survives at `/data/local/tmp/SoC_runtime/workspace` | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`; preflight `tmp_listing.txt` | safest first RM10 CPU control lane and copied-reference validation lane | do not narrate it as source-built parity |
| `C-03` | execution_root | raw Genesis workspace survives at `/data/local/tmp/snic_workspace_a83f` | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`; preflight `tmp_listing.txt` | second RM10 CPU control lane with reversible script-adaptation history | do not narrate it as Mac parity |
| `C-04` | wrapper_assumption | `PATH=/data/local/tmp/SoC_Harness/bin:$PATH` remains the historical wrapper surface; `cargo` there is a stub | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`; `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md` | keep RM10 CPU control batteries honest about prebuilt-backed execution | do not infer local source-build equivalence |
| `C-05` | wrapper_assumption | no surviving wrapper or env mutation path was found for bundled `dm3_runner` route recovery | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `docs/restart/G2_ROUTE_DECISION_OBJECT.md`; empty `serious_pass/wrappers/wrapper_refs.txt` | later branch runbooks should prefer direct binary calls unless a new wrapper is freshly evidenced | do not resurrect launcher folklore from memory |
| `C-06` | probe_surface | `dm3_termux_probe.sh` survives as a historical environment-probe script | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `serious_pass/wrappers/dm3_termux_probe.sh.txt` | useful as a checklist for what a Termux-like environment would need if revisited | not proof that Termux is the current correct execution surface |
| `C-07` | asset_pair | bundled `dm3` cwd still co-locates `SriYantraAdj_v1.bin`, `RegionTags_v2.json`, `RegionTags_v1.bin`, and `RegionTags_v2.bin` | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `serious_pass/preflight/dm3_listing.txt`; branch preflight `tmp_listing.txt` | use as explicit asset expectation for any boundary-tag or adjacency battery | do not assume these assets recover the retired same-binary `G2` family |
| `C-08` | task_name | help-listed live tasks are `holography` and `harmonic` | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `serious_pass/argv/help.txt` | candidate first hybrid control family because the names are live on the current binary | do not assume they already map cleanly to scientific observables |
| `C-09` | task_name | `exp_g2_readout` remains callable only as smoke-equivalent inference and is guarded in train mode | `dm3_compiled_residue` | `governed_clue` | `evidenced_now` | `retirement_route_matrix.tsv`; `G2_ROUTE_DECISION_OBJECT.md` | use only as a negative control and anti-folklore reminder | do not reopen same-binary route hunting in this branch |
| `C-10` | task_name | `boundary_alignment` and `boundary_power` are string-promoted candidates that inference accepts only as smoke-equivalent aliases and train rejects as unknown tasks | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `retirement_route_matrix.tsv`; `candidate_strings_boundary_focus.txt` | possible naming prompts for future battery docs or residue search | do not treat them as live boundary batteries without fresh proof |
| `C-11` | output_family | bundled residue keeps `output_g2_*`, `output_gpu_*`, `output_cpu_*`, `exp_i*`, and train probe JSONLs | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `serious_pass/preflight/dm3_listing.txt` | mine these names into observables, role partitions, and failure classes | do not inherit their semantics uncritically |
| `C-12` | default_knob | live CLI defaults still name `SriYantraAdj_v1.bin`, `RegionTags_v1.bin`, `data/xnor_train.jsonl`, and `PhonemePatterns_v1.bin` | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `serious_pass/argv/help.txt` | use as asset and dataset expectation prompts when building bounded runbooks | default-path names do not prove the files are correct or scientifically relevant |
| `C-13` | command_family | recoverable source-backed control commands remain `G-01`, `G-04`, `G-02`, and October `O-01..O-04` | `governed_soc_genesis` | `governed_clue` | `evidenced_now` | `docs/restart/LEGACY_BATTERY_ENTRYPOINTS.md` | use these as the branch's CPU-first bring-up order | do not skip them in favor of prettier hybrid residue tasks |
| `C-14` | naming_convention | later compiled residue repeatedly uses boundary, harmonic, holography, resonance, contrastive, and readout language | `dm3_compiled_residue` | `residue_clue` | `evidenced_now` | `candidate_strings_boundary_focus.txt`; `serious_pass/preflight/dm3_listing.txt` | good vocabulary for battery labels and observable families | language alone is not an existence proof |
| `C-15` | role_prompt | old training-doc posture says mobile SoC execution and CPU/GPU/NPU role separation were first-class targets | `training_doc_hypothesis` | `ambiguity` | `historically_suggested` | `docs/restart/TRAINING_DOC_HYPOTHESES.md` | useful as a branch hypothesis prompt for heterogeneous batteries | remains a hypothesis until a common observable survives on the current RM10 |

## Actionable Clue Filter

### Reuse directly

- `C-01` through `C-05`
- `C-08`
- `C-13`

### Reuse only as test prompts

- `C-06`
- `C-07`
- `C-10`
- `C-11`
- `C-12`
- `C-14`
- `C-15`

### Never promote on their own

- any string-only task name
- any output filename family
- any remembered launcher or Termux story without a fresh local proof surface
