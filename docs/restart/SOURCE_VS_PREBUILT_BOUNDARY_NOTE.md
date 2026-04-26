# Source Vs Prebuilt Boundary Note

Last refreshed: `2026-04-05`

## Purpose

Freeze lane-by-lane authority, build provenance, and claim ceilings so replay
success on RM10 does not get narrated as source-build parity or repaired
validator authority.

## Boundary Rules

1. `source_built` applies only where direct source build and replay are both
   evidenced on that lane.
2. `prebuilt_stub` and `mixed_prebuilt_backed` are execution facts, not
   near-source synonyms.
3. Historical comparison evidence is not a live build lane.
4. Family-level feasibility does not upgrade an underlying lane's build class.
5. Residue callability does not enter Genesis witness-floor or canonical
   narratives.

## Live Lane Registry

| Live lane | `authority_status` | `evidence_surface` | `build_class` | Execution provenance | What the lane may support | What the lane may not support |
| --- | --- | --- | --- | --- | --- | --- |
| Mac Genesis `G-01` / `G-02` | `sovereign` | `witness_floor` | `source_built` | direct host `cargo build` and `cargo run` replay from `/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f` | current authority language, witness-floor baselining, governance debugging | automatic promotion of any RM10 lane, any residue lane, or any heterogeneous story |
| RM10 SoC runtime Genesis lane | `governed_non_sovereign` | `witness_floor` | `prebuilt_stub` | `/data/local/tmp/SoC_runtime/workspace` using `/data/local/tmp/genesis_cli` with `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`; the `cargo` on-path is a stub dispatch surface, not a proved local rebuild | governed phone executability, intact receipts, branch-local `F1` CPU control, and lane-local reproducibility | source-built parity, repaired canonical validation, sovereign status, or same-family accelerator proof |
| RM10 raw-workspace Genesis lane | `governed_non_sovereign` | `witness_floor` | `mixed_prebuilt_backed` | `/data/local/tmp/snic_workspace_a83f` with reversible Android shebang adaptation, live `/data/local/tmp/genesis_cli`, and no rebuilt parity proof | raw-workspace ADB-shell executability and bounded witness-floor engineering | Mac parity, source-built parity, or canonical promotion |
| RM10 root `dm3_runner` smoke lane | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | direct launch of `/data/local/tmp/dm3_runner` from `/data/local/tmp` | smoke callability, receipt capture, and GPU-split falsification | witness-floor authority, live non-stub recovery, or Genesis comparison authority |
| RM10 bundled `dm3/dm3_runner` lane | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | direct launch of `/data/local/tmp/dm3/dm3_runner` from `/data/local/tmp/dm3` with live bundled assets beside the binary | bundled router archaeology, asset-pairing evidence, and blocker proof | recovered live `G2` route, witness-floor promotion, or source parity |

## Preserved Comparison Reference That Is Not A Live Lane

| Surface | `authority_status` | `evidence_surface` | `build_class` | Provenance | What it may support | What it may not support |
| --- | --- | --- | --- | --- | --- | --- |
| historical RM10 Genesis parity witness | `comparison_only` | `comparison_only` | `not_applicable` | preserved native RM10 receipts matching the fresh Mac tuple | proof that a clean RM10 parity surface once existed | any present-tense build claim for fresh RM10 lanes or the current validator |

## Family Overlays That Do Not Change Lane Build Class

| Family label | Underlying live lane or surface | `authority_status` ceiling | Build/provenance note | What the family may support | What the family may not support |
| --- | --- | --- | --- | --- | --- |
| `F1` governed Genesis CPU control | RM10 SoC runtime Genesis lane | `governed_non_sovereign` | remains `prebuilt_stub`; current anchored command is `genesis_cli --protocol` from `/data/local/tmp/SoC_runtime/workspace` with exact fresh tuple `f992... / a33...`; the live governed accelerator bridge on this surface is closed | trustworthy RM10 branch-local CPU control, serious-run receipt discipline, the current branch scientific anchor, and an explicit bridge-closed result | source-built parity, repaired validator authority, or an accelerator-bearing same-family bridge |
| `F2` residue harmonic callable family | residue `dm3_runner` surfaces | `feasibility_only` | the callable family lives on residue binaries whose lane-level class remains `exploratory_compiled_residue`; one GPU-backed repeat drifted materially, so the family ceiling is `unstable_feasibility` | bounded residue CPU-versus-GPU feasibility, marker-preserving repeat capture, and outlier-localization work | any statement that `F2` upgrades the residue lanes into witness-floor authority, proves stable accelerator parity, or speaks for `F1` |

`F2` is the critical boundary case.
Its callable-feasibility verdict is a family-level `PASS` only at callable
ceiling inside residue space.
It does not rewrite the lane-level provenance of the residue binaries or speak
for `F1`.

## Surfaces With No Live Claim-Bearing Lane Yet

| Surface | Current status | Provenance state | What it may support | What it may not support |
| --- | --- | --- | --- | --- |
| NPU or DSP assist | `ABSTAIN`; `inventory_only` ceiling | QNN libraries, RPC libraries, and daemons are visible, but no callable user-space assist surface is evidenced | inventory statements and future gating rules | any claim of receipted assist execution |
| explicit heterogeneous handoff | `ABSTAIN` | no same-family pre-handoff artifact, handoff declaration, or post-handoff artifact is evidenced | a truthful abstain and future prerequisite list | any role-partition or mixed-ownership execution claim |

## Claim Discipline

When a note says "works on RM10", it must also say one of:

- `build_class=prebuilt_stub`
- `build_class=mixed_prebuilt_backed`
- `build_class=exploratory_compiled_residue`

If none of those labels is present, the note is too loose to trust.

## Bottom Line

- Mac Genesis remains the only live `source_built` authority lane.
- RM10 SoC runtime is the branch-local governed `F1` instrument, but it remains
  `prebuilt_stub`.
- RM10 raw workspace is live and useful, but it remains
  `mixed_prebuilt_backed`.
- Residue runners remain compiled archaeology surfaces even when a bounded
  family like `F2` is callable.
- Historical parity remains evidence, not a shortcut around current build-class
  and validator gaps.

## Evidence Used

- `.gpd/STATE.md`
- `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md`
- `docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`
- `docs/restart/WITNESS_LANE_REPAIR_NOTE.md`
- `docs/restart/WRAPPER_AND_ENV_PROVENANCE_NOTE.md`
- `docs/restart/phase_01_2_3_execution_prep_20260404/AUTHORITY_ORDER_MEMO.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/RM10_F1_ANCHOR_DOSSIER.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/F1_ACCELERATOR_SURFACE_AUDIT.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/F2_HARMONIC_STABILITY_DOSSIER.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/RM10_BRIDGE_AND_HANDOFF_DECISION.md`
