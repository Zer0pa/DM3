# Phase 01.2.3.4.1 Artifact Index

Last refreshed: `2026-04-05`

## Retained Packets

| Workstream | Packet | Key retained files |
| --- | --- | --- |
| validator-default reverse engineering | `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/` | `SUMMARY.md`, `OUTCOME.md`, `identity/reference_hashes.txt`, `identity/embedded_hash_strings.txt` |
| top-level same-family instability localization | `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/` | `SUMMARY.md`, `OUTCOME.md`, `summary.json`, `identity/required_path_listing.txt` |
| official same-family rerun | `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/` | `OUTCOME.md`, `comparisons/index.json`, `identity/run_manifest.json`, `rows/*/metrics/metrics.json` |
| heterogeneous micro verdict | `artifacts/phase_01_2_3_4_1_heterogeneous_micro_20260405T184748Z/` | `SUMMARY.md`, `OUTCOME.md`, `comparisons/index.json`, `identity/run_identity.json` |

## Command Transcripts

The retained command transcripts for this phase are:

- validator-default packet:
  - `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/identity/default_command.txt`
  - `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/identity/explicit_command.txt`
- top-level same-family packet:
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/probes/root_cpu_default/command.txt`
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/probes/root_cpu_explicit_assets/command.txt`
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/probes/cleanroom_minimal_cpu/command.txt`
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/probes/cleanroom_regiontags_v1_cpu/command.txt`
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/probes/legacy_dm3_gpu_train/command.txt`
- official same-family rerun packet:
  - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/cpu_a/identity/command.txt`
  - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/gpu_a/identity/command.txt`
  - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/gpu_b/identity/command.txt`
  - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/cpu_b/identity/command.txt`

## Telemetry Bundle

The retained telemetry bundle for this phase is:

- validator-default packet:
  - `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/telemetry/pre_battery.txt`
  - `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/telemetry/post_battery.txt`
  - `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/telemetry/pre_thermal.txt`
  - `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/telemetry/post_thermal.txt`
- top-level same-family packet:
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/telemetry/pre_battery.txt`
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/telemetry/post_battery.txt`
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/telemetry/pre_thermal.txt`
  - `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/telemetry/post_thermal.txt`
- official same-family rerun packet:
  - completed rows:
    - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/cpu_a/telemetry/`
    - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/gpu_a/telemetry/`
    - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/gpu_b/telemetry/`
  - timed-out row:
    - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/cpu_b/telemetry/pre_battery.txt`
    - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/cpu_b/telemetry/pre_thermal.txt`
    - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/cpu_b/telemetry/pre_meminfo.txt`

## Ledger Set

The retained ledgers and route notes for this phase are:

- `docs/restart/VALIDATOR_DEFAULT_RULE_LEDGER.md`
- `docs/restart/F2_TOPLEVEL_INSTABILITY_LEDGER.md`
- `docs/restart/OBSERVABLE_CONTRACT_NOTE.md`
- `docs/restart/F2_OFFICIAL_OUTLIER_RERUN_LEDGER.md`
- `docs/restart/NARROW_HETEROGENEOUS_MICRO_LEDGER.md`
- `docs/restart/PHASE_01_2_3_4_1_MANIFEST_INDEX.md`
- `docs/restart/PHASE_01_2_3_4_1_BOUNDED_VERDICT.md`
