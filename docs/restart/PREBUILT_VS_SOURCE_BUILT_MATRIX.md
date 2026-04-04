# Prebuilt Vs Source-Built Matrix

## Purpose

Keep `build_class` explicit across the live comparison lanes so replay success
does not get misread as source-build parity.

This matrix is a governance aid.
It does not soften the unresolved canonical-target question or the bundled
`G2` route blocker.

## Classification Matrix

| Lane | `authority_status` | `evidence_surface` | `build_class` | Execution provenance | Validator mode | What this class justifies | What it does not justify |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Mac Genesis `G-01` / `G-02` | `sovereign` | `witness_floor` | `source_built` | direct host `cargo build` / `cargo run` replay from the Genesis workspace under `/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f` | stable source-built replay; published Genesis `verify.json` canonical is stale against the live lane | current authority language, witness-floor baselining, and governance debugging | automatic sovereignty for any RM10 lane or any hybrid science claim |
| historical RM10 Genesis parity witness | `comparison_only` | `comparison_only` | `not_applicable` | preserved historical native RM10 receipts only | historical parity receipt matched Mac; current device default validator rejects `verify.json` on that bundle | proof that a clean RM10 parity surface existed | present-tense parity for fresh phone-local lanes |
| fresh RM10 SoC runtime | `governed_non_sovereign` | `witness_floor` | `prebuilt_stub` | `/data/local/tmp/SoC_runtime/workspace` with `/data/local/tmp/genesis_cli` and `SoC_Harness/bin/cargo` stub dispatching prebuilt binaries | default validator `FAIL`; explicit-hash validation `PASS` | current phone executability, receipts, and lane-local reproducibility | source-build parity, sovereign status, or repaired canonical validation |
| fresh RM10 raw workspace | `governed_non_sovereign` | `witness_floor` | `mixed_prebuilt_backed` | `/data/local/tmp/snic_workspace_a83f` with reversible Android shebang adaptation and no rebuilt parity proof | default validator `FAIL`; explicit-hash validation `PASS` | current raw-workspace executability and receipted replay on device | Mac parity or a true local source build |
| RM10 root `dm3_runner` smoke lane | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | direct launch of `/data/local/tmp/dm3_runner` from `/data/local/tmp` | Genesis validator not applicable; route meaning comes from smoke receipt comparison | smoke-level callability, receipt capture, and GPU-split falsification | living non-stub recovery or a meaningful GPU success |
| RM10 bundled `dm3/dm3_runner` lane | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | direct launch of `/data/local/tmp/dm3/dm3_runner` from the bundled cwd with explicit `SriYantraAdj_v1.bin` and `RegionTags_v2.json` | Genesis validator not applicable; route meaning comes from bundled `G2` versus smoke comparison | bundled router archaeology, blocker proof, and asset-pairing evidence | a recovered live `G2` route or any authority promotion |

## Rules This Matrix Freezes

1. `source_built` applies only where a direct source build and replay are
   evidenced.
2. `prebuilt_stub` applies only where the device lane depends on prebuilt
   binaries plus a cargo stub.
3. `mixed_prebuilt_backed` applies only where a raw-workspace run exists
   without rebuilt parity proof.
4. `exploratory_compiled_residue` applies to late-hybrid runners that survive
   as compiled residue and archaeology targets.
5. `not_applicable` is the honest label for preserved historical comparison
   receipts whose current build provenance is not the claim being made.

## Bottom Line

- The Mac lane remains the only `source_built` authority lane in the current
  workstream.
- No fresh RM10 lane has crossed from prebuilt-backed executability into true
  source-build parity.
- No hybrid residue lane belongs in witness-floor or source-build narratives.
