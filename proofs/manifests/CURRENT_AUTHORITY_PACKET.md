# Current Authority Packet

## Scope

This manifest defines the root review surface for DM3 as of 2026-04-22.

## Promoted Sources

- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S1_smoke/S1_smoke_001.bin`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S2H_harmonic/S2H_stat_summary.json`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S7_thermal_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S8_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_partial/S11_r3_flip_B_RA_tagsV2_s50_001.bin`
- `CLAIMS.md`
- `IS_AND_IS_NOT.md`
- `RETRACTIONS.md`
- `ARTEFACT_BUNDLE.md`
- `ARTEFACT_BUNDLE_REGISTER.tsv`
- `CONTACT.md`
- `TRADEMARK.md`
- `repo_stage/CHARACTERIZATION_REPORT.md`
- `repo_stage/REPO_AGENT_FINDINGS.md`

These files establish the promoted scientific truth floor currently reflected by
the root README.

## Live Engineering Lane

- `docs/restart/DM3_SESSION7_PRD_v2.md`
- `docs/restart/`
- `artifacts/`

These paths remain live engineering territory. Session 7 ARM receipts stay in
that lane until a deliberate sync pass promotes them.

## Readiness

- Verdict: `STAGED`
- Confidence: `70%`
- Governing check: `validation/results/repo_surface_preflight.json`
- Legal source: `LICENSE` (`LicenseRef-Zer0pa-DM3-RRL-1.0`)

## Canonical Reference Surfaces

- Artefact Bundle Register: `ARTEFACT_BUNDLE.md` and `ARTEFACT_BUNDLE_REGISTER.tsv`
- Claims Document: `CLAIMS.md`
- Is/Is-Not Document: `IS_AND_IS_NOT.md`
- Retractions Register: `RETRACTIONS.md`
- Licensor Contact / Identity: `CONTACT.md`
- Trademark Register: `TRADEMARK.md`

## Open Structural Residue

- the full Session 7 gate-layer null battery is described in the live session
  but not fully mirrored under `phase_S7_P0...` in this checkout yet
- Session 7 truth-sensor outputs are not mirrored into this workspace yet
