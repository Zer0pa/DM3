# RM10 Execution Surface Manifest

## Purpose

Map the current RM10 execution surfaces lane by lane without promoting fresh
executability into sovereign authority.

This manifest is Phase `01.2.3` support documentation.
It does not substitute for the bundled `G2` route verdict.

## Canonical Fields

Every record below keeps these axes separate:

- `authority_status`: what claim the lane can bear
- `evidence_surface`: what kind of run or comparison the lane belongs to
- `build_class`: how the lane is currently classified

## Surface Records

### `rm10_soc_runtime_genesis`

| Field | Value |
| --- | --- |
| `authority_status` | `governed_non_sovereign` |
| `evidence_surface` | `witness_floor` |
| `build_class` | `prebuilt_stub` |
| `execution_root` | `/data/local/tmp` |
| `cwd` | `/data/local/tmp/SoC_runtime/workspace` |
| `binary_path` | `/data/local/tmp/genesis_cli` |
| `wrapper_surface` | `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`; the lane depends on `SoC_Harness/bin/cargo`, which is a stub for build/test while `run --bin snic_rust` dispatches the prebuilt binary |
| `asset_surface` | Genesis workspace and `audit/<run-name>` output tree; no separate hybrid assets |
| `validator_mode` | default validator `FAIL`; explicit-hash validation `PASS` on `f992e9... / a33c5c...` |
| `device_receipt_surface` | `audit/phase012_rm10_soc_g01/run00` as the governed reference directory; fresh replay receipts also exist under `audit/rm10_soc_runtime_g01_20260403/run00` |
| `host_receipt_anchor` | `artifacts/long_horizon_bootstrap_20260403/rm10_genesis_g01/*`; `artifacts/rm10_replay/soc_runtime_g01_20260403/*` |
| `comparison_meaning` | current governed phone witness lane; proves phone executability and receipted replay only |

### `rm10_raw_workspace_genesis`

| Field | Value |
| --- | --- |
| `authority_status` | `governed_non_sovereign` |
| `evidence_surface` | `witness_floor` |
| `build_class` | `mixed_prebuilt_backed` |
| `execution_root` | `/data/local/tmp` |
| `cwd` | `/data/local/tmp/snic_workspace_a83f` |
| `binary_path` | `/data/local/tmp/genesis_cli` |
| `wrapper_surface` | `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`; raw workspace kept runnable with reversible shebang adaptation and on-device backup at `/data/local/tmp/snic_workspace_a83f/scripts_linux_shebang_backup_20260403` |
| `asset_surface` | Genesis raw workspace and `audit/<run-name>` output tree |
| `validator_mode` | default validator `FAIL`; explicit-hash validation `PASS` on `392936... / 45d056...` |
| `device_receipt_surface` | `audit/rm10_agent_single_android/run00` |
| `host_receipt_anchor` | `artifacts/rm10_replay/raw_genesis_g01_20260403/*` |
| `comparison_meaning` | current raw-workspace phone witness lane; proves ADB-shell executability of that surface only, not Mac parity |

### `rm10_root_hybrid_smoke`

| Field | Value |
| --- | --- |
| `authority_status` | `archaeology_only` |
| `evidence_surface` | `archaeology` |
| `build_class` | `exploratory_compiled_residue` |
| `execution_root` | `/data/local/tmp` |
| `cwd` | `/data/local/tmp` |
| `binary_path` | `/data/local/tmp/dm3_runner` |
| `wrapper_surface` | direct binary launch; no surviving wrapper is required for the fresh micro probe beyond optional `--cpu` |
| `asset_surface` | no bundled asset pair required for the smoke probe |
| `validator_mode` | not applicable to Genesis validation; route classification is by smoke receipt comparison against normalized `ccd34fbc...` |
| `device_receipt_surface` | `phase012probe_20260403T152224Z_root_default.jsonl`; `phase012probe_20260403T152224Z_root_cpu.jsonl` |
| `host_receipt_anchor` | `artifacts/long_horizon_bootstrap_20260403/rm10_probe_20260403T152224Z/*`; `artifacts/long_horizon_bootstrap_20260403/rm10_dm3_micro/*` |
| `comparison_meaning` | smoke-only executable residue and GPU-split control surface; not meaningful task recovery |

### `rm10_bundled_hybrid_g2_target`

| Field | Value |
| --- | --- |
| `authority_status` | `archaeology_only` |
| `evidence_surface` | `archaeology` |
| `build_class` | `exploratory_compiled_residue` |
| `execution_root` | `/data/local/tmp` |
| `cwd` | `/data/local/tmp/dm3` |
| `binary_path` | `/data/local/tmp/dm3/dm3_runner` |
| `wrapper_surface` | direct binary launch from the bundled directory; cwd matters because the runner sits beside the preserved bundled assets and residue outputs |
| `asset_surface` | explicit adjacency `SriYantraAdj_v1.bin` plus tag file `RegionTags_v2.json` |
| `validator_mode` | not applicable to Genesis validation; route classification is by comparison against the preserved `G2 Boundary Readout / R2Contrastive` family and smoke canonical `d3e721e7...` |
| `device_receipt_surface` | `phase0122_g2_attempt_receipts_20260403.jsonl` |
| `host_receipt_anchor` | `artifacts/phase_01_2_2_non_stub_attempt_20260403/*` |
| `comparison_meaning` | chosen bundled archaeology target; callable and asset-rich, but the current live route still collapses to smoke |

## Preserved Comparison Reference That Is Not A Current Surface

| Field | Value |
| --- | --- |
| `lane_id` | `historical_rm10_genesis_parity` |
| `authority_status` | `comparison_only` |
| `evidence_surface` | `comparison_only` |
| `build_class` | `not_applicable` |
| `execution_root` | preserved historical native RM10 lane; no current live execution root is asserted here |
| `host_receipt_anchor` | `artifacts/rm10_replay/historical_t1_t7_20251028/*` |
| `comparison_meaning` | preserves the fact that RM10 once matched the Mac Genesis tuple; does not upgrade the fresh device lanes today |

## Manifest Bottom Line

- The current governed Genesis execution surfaces on RM10 are the SoC runtime
  lane and the raw-workspace lane.
- The current hybrid execution surfaces on RM10 are the root smoke lane and the
  bundled archaeology target.
- None of the RM10 device surfaces above are `sovereign`, and none should be
  narrated as source-built unless a separate proof lands.
- The bundled lane remains the correct archaeology target, but its present
  executability is still an `archaeology` fact, not a routed `G2` success.
