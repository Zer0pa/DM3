# Phase 01.2.3.4.1 Manifest Index

Last refreshed: `2026-04-05`

## Purpose

Index the retained run-manifest and run-identity surfaces for phase
`01.2.3.4.1`, including explicit cases where no Comet or offline bundle exists.

## Retained Manifest Surfaces

| Packet | Manifest or identity surface | Comet or offline bundle status |
| --- | --- | --- |
| validator-default reverse engineering | packet-local identity files only under `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/identity/` | no Comet or offline bundle retained in this packet |
| top-level same-family instability localization | packet-local identity files only under `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/identity/` | no Comet or offline bundle retained in this packet |
| official same-family rerun | `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/identity/run_manifest.json` and row-level `run_identity.json` files for completed rows | no Comet or offline bundle retained because the packet blocked before logger completion |
| heterogeneous micro abstain packet | `artifacts/phase_01_2_3_4_1_heterogeneous_micro_20260405T184748Z/identity/run_identity.json` | no Comet or offline bundle retained because no execution was admissible |

## Canonical Identity Paths

- official same-family session manifest:
  `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/identity/run_manifest.json`
- official same-family completed row identities:
  - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/cpu_a/identity/run_identity.json`
  - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/gpu_a/identity/run_identity.json`
  - `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/rows/gpu_b/identity/run_identity.json`
- heterogeneous abstain identity:
  `artifacts/phase_01_2_3_4_1_heterogeneous_micro_20260405T184748Z/identity/run_identity.json`

## Manifest Verdict

Phase `01.2.3.4.1` retains full packet identity where execution completed and
records explicit absence where it did not. No hidden Comet success surface
exists for this phase.
