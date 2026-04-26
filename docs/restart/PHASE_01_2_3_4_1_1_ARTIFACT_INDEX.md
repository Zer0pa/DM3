# Phase 01.2.3.4.1.1 Artifact Index

Last refreshed: `2026-04-05`

## Retained Packets

| Workstream | Packet | Key retained files |
| --- | --- | --- |
| rescue boundary and cleanup quarantine | `artifacts/phase_01_2_3_4_1_1_rescue_pack_20260405T202422Z/` | `FILE_MAP.md`, `repo_snapshot/`, `device_surfaces/`, `raw_workspace_witness/` |
| cleaned `F1` smoke after purge | `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/` | `README.md`, `identity/run_identity.json`, `live_surface_post.txt`, `logs/validate_*`, `telemetry/` |
| capability smoke lattice | `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/` | `README.md`, `run_smoke_lattice.py`, `comparisons/row_summaries.json`, `comparisons/semantic_matrix.json` |
| falsifier closeout packet | `artifacts/phase_01_2_3_4_1_1_falsifier_20260405T211759Z/` | `README.md`, `attack_matrix.json` |

## Plans Closed Without New Packets

These plans closed on gate logic rather than by creating a new run packet:

- Wave 3 property mapping:
  - output: `docs/restart/RM10_PROPERTY_MAP.md`
  - why no packet: Wave 2 produced one semantic family only, so no focused
    rerun battery was admissible
- Wave 4 same-family handoff:
  - output: `docs/restart/RM10_SAME_FAMILY_HANDOFF_TRUTH_LEDGER.md`
  - why no packet: no mapped property existed to carry across the same-family
    boundary
- Wave 5 lane contrast:
  - output: `docs/restart/RM10_LANE_CONTRAST_LEDGER.md`
  - why no packet: no usable CPU-versus-accelerator lane pair existed under
    the property-first contract

## Command And Identity Anchors

- cleanup serious run:
  - `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/identity/command.txt`
  - `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/identity/run_identity.json`
- capability lattice helper and retained row identity:
  - `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/run_smoke_lattice.py`
  - `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/comparisons/row_summaries.json`

## Telemetry Anchors

- cleanup smoke telemetry:
  - `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/telemetry/battery_pre.txt`
  - `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/telemetry/battery_post.txt`
  - `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/telemetry/thermal_pre.txt`
  - `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/telemetry/thermal_post.txt`
- capability lattice telemetry lives per row inside:
  - `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/rows/*/telemetry/`

## Ledger Set

Core reports for the full reset package:

- `docs/restart/RM10_CAPABILITY_RESET_CLEANUP_REPORT.md`
- `docs/restart/RM10_CAPABILITY_RESULT.md`
- `docs/restart/RM10_PROPERTY_MAP.md`
- `docs/restart/RM10_SAME_FAMILY_HANDOFF_TRUTH_LEDGER.md`
- `docs/restart/RM10_LANE_CONTRAST_LEDGER.md`
- `docs/restart/RM10_CAPABILITY_FALSIFIER_VERDICT.md`
- `docs/restart/RM10_CAPABILITY_DISCOVERY_RESET_VERDICT.md`

## Summary Stack

- `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-01-SUMMARY.md`
- `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-02-SUMMARY.md`
- `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-03-SUMMARY.md`
- `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-04-SUMMARY.md`
- `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-05-SUMMARY.md`
- `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-06-SUMMARY.md`

## Bottom Line

This phase retains one clean `F1` bring-up packet, one bounded capability
lattice packet, one falsifier packet, and four closeout ledgers that
progressively close property, handoff, lane, and final recommendation routes.
The package is complete without inventing packets for gates that never opened.
