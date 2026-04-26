# Repo Agent Findings

Last updated: `2026-04-25`

This file records seams that matter to a hostile reviewer and should
stay visible until cleared.

## F1 — Harmonic helper summaries are generic, not the scientific verdict

Paths:

- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S2H_final/S2H_stat_summary.json`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S7_thermal_final/S7_thermal_summary.json`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S8_final/S8_battery_summary.json`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S5_final/S5_basin_volume_summary.json`

Finding:

These helper summaries are produced by a deterministic-cell
`summarize_cell.sh` path and therefore mark harmonic cells as `FAIL`
when they see more than one canonical SHA. That is appropriate for a
deterministic gate surface and wrong for stochastic harmonic receipts.
The promoted Session 7 dynamics claim therefore uses Wilson-CI overlap
on the underlying `.bin` receipts, not the helper verdict strings.

## F2 — Session 7 gate-layer directory names in the docs do not match the local checkout

Paths:

- `docs/restart/DM3_STATUS_SNAPSHOT_20260422.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_20260422.md`
- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/`

Finding:

The status snapshot and handover name standalone gate-layer directories
`S2_pinned / S4_airplane / S6_core`. The local checkout does not expose
those directory names verbatim under the Session 7 harness tree. It
does expose the smoke receipt, the later `S2H_* / S7_* / S8_* / S5_* /
S10_* / S11_* / T*` trees, and the final Session 7 report that closes
the gate-layer substrate-null line. The repo therefore keeps the
gate-layer closeout claim and this naming mismatch visible together.

## F3 — `exp_k3_truth_sensor` writes its scientific content to `.log`, not `.bin`

Paths:

- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S10_final/`

Finding:

The S10 `.bin` files are empty by design. The task writes KPI content to
stdout, so the scientific payload lives in the nine `.log` files plus
the summary JSON. The empty-file canonical SHA
`e3b0c44298fc...` is not evidence loss here.

## F4 — `resonance_v2` task-side investigation narrowed by B3

Path:

- `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/T1_cartography/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/`

Finding:

The older Session 7 cartography note found `resonance_v2` unhelpful on
that tested surface and treated it as a task-side investigation item.
B3 narrows the present repo-facing statement: at `--steps 1` versus
`20`, `resonance_v2` is `--steps`-decorative on primary output. This
does not prove every `resonance_v2` entrypoint is null; it only records
the tested CLI axis.

## F5 — Session 8 Phase A total-run count differs from local per-run anchors

Paths:

- `docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/`

Finding:

The Session 8 Phase A final report says Phase A closed with 55 receipts
across A.1/A.2/A.3/A.4. The local mirror now contains the A-cell trees,
but the directly countable per-run receipt/log pairs are 52:
A.1=10, A.2=21, A.3=12, A.4=9. The summary files report
`total_runs = 22/13/10` for A.2/A.3/A.4 while also listing
`unique_receipt_sha256 = 21/12/9`. The summary SHAs match the
handover. The repo promotes only statements supported by the local
per-run logs and keeps this accounting seam visible.

## F6 — Session 8 thermal-gate patch is mirrored with pre-patch backup

Paths:

- `docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/device_snapshot/bin/run_cell.sh`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/device_snapshot/bin/run_cell.sh.pre_cpugate_bak`

Finding:

The final report records a real engineering-side finding: the old
all-sensor thermal gate on RM10 was being held open by the PMIC sensor
long after CPU zones cooled, so the live harness rule was patched to
CPU/GPU-only thermal gating. The local Phase A mirror now includes both
the patched `run_cell.sh` and `run_cell.sh.pre_cpugate_bak`. Any mixed
old-gate / new-gate split inside A.2 remains visible in the progress
logs and final report.

## F7 — Repo-agent Phase A promotion decisions

Paths:

- `repo_stage/HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md`
- `docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md`
- `repo_stage/CLAIMS.md`
- `repo_stage/IS_AND_IS_NOT.md`

Finding:

The engineer-agent requested scrutiny on three Phase A
publication-surface questions. Current repo-agent decision:

- Claim `σ` was recorded as CANDIDATE and coarse, not CONFIRMED, during
  the Phase A integration. F8 supersedes this: A5/A6 killed `σ` and
  `σ′` before promotion and replaced them with candidate `σ″`.
- Claim `ρ` is recorded as CANDIDATE and scoped to `RA+v2+steps=20`,
  not as a broad RA+v2 capability ceiling.
- The airplane-mode deviation is surfaced in the ledger and findings.
  It is not sanitized; the affected receipt JSONs are mirrored locally.

## F8 — A5/B3/A6 supersedes the old `σ` curve wording before promotion

Paths:

- `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_A5_B3_A6_FINAL_20260425.md`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A5_peak_finder/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6a_peak_fill/`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A6b_post_peak/`
- `repo_stage/CLAIMS.md`

Finding:

The earlier Phase A `σ` wording described a coarse 30/40 peak and the
A5 interim `σ′` wording described a bimodal curve. The A6 fills kill
both before promotion. The active candidate is now `σ″`: a trimodal
sawtooth on the scoped baseline `exp_k2_scars` surface with local
maxima at `s33`, `s41`, and `s49`. The rejected-before-promoted history
stays visible because it shows the kill criterion firing rather than a
smooth story being retrofitted.

## F9 — B3 summary `FAIL` is a generic-script limitation, not a science fail

Paths:

- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/B3_cli_audit_summary.json`
- `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`

Finding:

The B3 cell intentionally mixes all twelve callable tasks at
`--steps 1` and `--steps 20`. Its summary JSON reports `verdict=FAIL`
because the generic deterministic-cell summarizer sees seven canonical
output classes across heterogeneous tasks. The scientific finding comes
from per-task comparisons: nine tasks respond to `--steps`, three are
decorative at `1` versus `20`, and `exp_k3_truth_sensor` is partial.

## F10 — κ handover wording needed numeric tightening

Paths:

- `repo_stage/HANDOVER_TO_REPO_AGENT_A5_B3_A6_FINAL_20260425.md`
- `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/B3_cli_audit_exp_k3_truth_sensor_steps1.log`
- `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/B3_cli_audit/B3_cli_audit_exp_k3_truth_sensor_steps20.log`
- `repo_stage/CLAIMS.md`
- `repo_stage/IS_AND_IS_NOT.md`

Finding:

The handover asks to refine κ without weakening or retracting it, and
also says the error-reduction ratio is fixed near 79.4% across
`--steps`. The local B3 logs show a more precise result: at
`steps=1`, `baseline_error=89.255325`, `sensor_error=22.317333`, and
the reduction ratio is about 75.0%; at `steps=20`,
`baseline_error=108.164818`, `sensor_error=22.292860`, and the ratio is
about 79.4%. The public repo surface therefore preserves Session 7
sensor-strength / threshold invariance, but does not promote a
universal `--steps`-invariant ratio story.

## F11 — τ is promoted from a separate cross-platform lane

Paths:

- `repo_stage/CLAIM_TAU_CONFIRMED_20260424.md`
- `repo_stage/HANDOVER_TO_REPO_AGENT_ORCHESTRATOR_M1_TAU_20260424.md`
- `docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/`

Finding:

τ is independent of the A5/B3/A6 phone chain. It confirms bit-exact
`exp_k2_scars` KPI matches between RM10 native Android and an Apple M1
Android ARM64 emulator at `--steps {20,30,40,45,50}`. The public
surface promotes τ as cross-platform ARM64 determinism only for the
tested binary and inputs; it does not claim x86/source-rebuild parity.
