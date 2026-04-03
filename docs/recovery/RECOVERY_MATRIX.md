# Recovery Matrix

## Scope

This matrix separates what is recoverable from source control, what is only evidenced locally in compiled residue, and what appears to connect the two layers.

## Recoverable From GitHub

Primary lineage:

- Repo: `https://github.com/Zer0pa/zer0pamk1-DM-3-Oct`
- Local clone: `/Users/Zer0pa/DM3/recovery/zer0pamk1-DM-3-Oct`

Later wrapper lineage:

- Repo: `https://github.com/Zer0pa/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025`
- Local clone: `/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025`

Recoverable crates in the October SNIC workspace:

- `geometry_core`
- `yantra_2d`
- `lift_3d`
- `dynamics_deq`
- `deq_core`
- `yantra_3d_dual`
- `resonance_cpu`
- `proof_gates`
- `pipeline_cpu`
- `checks`
- `dual_cli`
- `io_cli`
- `invariants`
- `snic_tests`

Evidence:

- `/Users/Zer0pa/DM3/recovery/zer0pamk1-DM-3-Oct/snic/Cargo.toml`
- `/Users/Zer0pa/DM3/recovery/zer0pamk1-DM-3-Oct/snic/crates/pipeline_cpu/src/main.rs`
- `/Users/Zer0pa/DM3/recovery/zer0pamk1-DM-3-Oct/snic/crates/yantra_3d_dual/src/lib.rs`

What this preserves:

- the double-meru geometry layer
- the DEQ / contraction layer
- resonance and proof-gate instrumentation
- deterministic CPU pipeline structure

## Evidenced Locally But Source-Missing

Local compiled residue proves a later hybrid DM3 existed beyond the older GitHub source:

- `dm3_gpu`
- `dm3_microtx`
- `dm3_hrm_bridge`
- `scar_engine`
- `lyra_tagging`
- `lyra_tagging_v2`
- `yantra_tagger`
- `phoneme_patterns`
- `dm3_runner`

Shared overlap with the old lineage still visible in residue:

- `geometry_core`
- `lift_3d`
- `yantra_2d`
- `yantra_3d_dual`
- `deq_core`

Evidence:

- Binary: `/Users/Zer0pa/DM3/target/debug/dm3_runner`
- Fingerprints: `/Users/Zer0pa/DM3/target/debug/.fingerprint`

Concrete source-path strings preserved in the binary:

- `src/runner/src/tasks/hrm.rs`
- `src/microtx/src/lib.rs`
- `src/scar_engine/src/memory.rs`
- `src/scar_engine/src/basis.rs`
- `src/runner/src/tasks/l_branch/phoneme_learning.rs`
- `src/yantra_3d_dual/src/lib.rs`
- `src/dm3_gpu/src/shaders.wgsl`

Concrete runtime evidence preserved in the binary:

- `k_transformer_fused`
- `DM3_ALLOW_HOST_RUN`
- `SriYantraAdj_v1.bin`
- `RegionTags_v1.bin`
- `PhonemePatterns_v1.bin`

This supports the existence of a later stack with:

- GPU / WGSL execution
- micro-transformer kernels
- an HRM bridge layer
- tagging / phoneme asset generation
- a SoC-preferred heavy-run path

## Likely Conceptual Bridges

These are the most defensible links between the recoverable old source and the newer source-missing layer:

1. Geometry continuity
   - `yantra_2d`, `lift_3d`, and `yantra_3d_dual` exist in the old source and in local residue.
   - The newer system appears to retain the dual-meru geometry as substrate rather than replacing it.

2. DEQ / settling continuity
   - Old source contains `dynamics_deq` and `deq_core`.
   - New residue still contains `deq_core` and host warnings about heavy experiments settling correctly only on SoC.
   - The most likely continuity is that DEQ-style settling remained the state-update backbone while learned modules were added around it.

3. Resonance-to-learning expansion
   - Old source has `resonance_cpu`, `proof_gates`, and deterministic checks.
   - New residue adds `dm3_microtx`, `dm3_hrm_bridge`, `scar_engine`, and phoneme/tagging components.
   - The most likely bridge is: geometric resonance core first, then learned routing / readout / memory layers on top.

4. Artifact schema expansion
   - Old source is mostly config- and report-driven.
   - New residue references adjacency, region tags, phoneme patterns, datasets, and receipts.
   - The likely change was a move from pure geometry/proof artifacts toward trainable or semi-trainable asset pipelines.

## What Is Not Recovered

Not recovered in source form:

- the full `dm3_gpu` crate
- the full `dm3_microtx` crate
- the full `dm3_hrm_bridge` crate
- the full `scar_engine` crate
- the newer tagging / phoneme asset generators
- the exact dataset and asset-generation logic for `RegionTags_v1.bin` and `PhonemePatterns_v1.bin`

## Practical Boundary

Current best boundary:

- Reuse the old GitHub lineage as the recoverable substrate.
- Treat the newer hybrid layer as archaeology, not as recovered code.
- Rebuild only after the science and acceptance gates are reset.

