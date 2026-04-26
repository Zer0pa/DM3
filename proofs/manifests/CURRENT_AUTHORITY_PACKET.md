# Current Authority Packet

## Scope

This manifest defines the root review surface for DM3 as of 2026-04-25.
It reflects the Session 7 closeout packet plus the receipt-backed
Session 8 Phase A/A5/B3/A6 and τ additions as the current truth floor.

## Promoted Sources

- `README.md`
- `CLAIMS.md`
- `IS_AND_IS_NOT.md`
- `RETRACTIONS.md`
- `ARTEFACT_BUNDLE.md`
- `ARTEFACT_BUNDLE_REGISTER.tsv`
- `CONTACT.md`
- `TRADEMARK.md`
- `docs/restart/DM3_SESSION7_FINAL_REPORT.md`
- `docs/restart/DM3_STATUS_SNAPSHOT_20260422.md`
- `docs/restart/DM3_SESSION8_PHASE_A_INTERIM_20260423.md`
- `docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md`
- `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`
- `docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md`
- `docs/restart/DM3_SESSION8_ORCHESTRATOR_INTERIM_M1_TAU_20260424.md`
- `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md`
- `docs/restart/SOURCE_VS_PREBUILT_BOUNDARY_NOTE.md`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S1_smoke/S1_smoke_001.bin`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S2H_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S7_thermal_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S8_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S5_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S10_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_final/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/T11_cross_control/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/T2_scars_scaling/`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/T3_plasticity/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A1_mu_replicate/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A2_overfit_boundary/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A3_cross_graph/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A4_cross_dataset/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A5_peak_finder/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6a_peak_fill/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6b_post_peak/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/device_snapshot/bin/run_cell.sh`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/`
- `repo_stage/README.md`
- `repo_stage/CHARACTERIZATION_REPORT.md`
- `repo_stage/JOURNEY_LOG.md`
- `repo_stage/LIVE_PROJECT.md`
- `repo_stage/website_summary.md`
- `repo_stage/REPO_AGENT_FINDINGS.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_A5_B3_A6_FINAL_20260425.md`
- `repo_stage/CLAIM_TAU_CONFIRMED_20260424.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_ORCHESTRATOR_M1_TAU_20260424.md`
- `repo_stage/MANIFEST.tsv`

These files establish the promoted scientific truth floor currently
reflected by the root README.

## Live Engineering Lane

- `docs/restart/`
- `artifacts/`

These paths remain live engineering territory even when some specific
files are promoted onto the root surface.

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

- harmonic helper summary verdicts on Session 7 stochastic cells are
  generic deterministic-cell outputs, not the scientific authority
  surface
- the Session 7 handover's standalone gate-layer directory names
  `S2_pinned / S4_airplane / S6_core` do not appear verbatim in this
  checkout
- Session 8 Phase A has a count seam: final-report / summary total-run
  accounting says 55, while the local mirror has 52 per-run receipt/log
  pairs
- the Session 8 airplane-mode deviation affected 40 reported receipts
  and remains visible
- old `σ` and `σ′` K2 curve wordings are rejected-before-promoted;
  active `σ″` remains candidate-only until deeper shape / transfer tests
  land
- Claim `φ` remains scoped to `--steps 1` versus `20` on the tested
  default surfaces
- B3 refines κ: `exp_k3_truth_sensor` is not universally
  `--steps`-decorative, and the ratio is 75.0% at `steps=1` versus
  79.4% at `steps=20`
- source-level and x86 cross-platform claims remain blocked for the
  current hybrid `dm3_runner` because the source is not present in the
  known local repo/filesystem surface
