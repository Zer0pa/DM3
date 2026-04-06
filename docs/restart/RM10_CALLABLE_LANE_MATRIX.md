# RM10 Callable Lane Matrix

Last refreshed: `2026-04-06`

## Purpose

Translate the training-document role language into current callable branch
surfaces without pretending that hardware inventory already gives a live lane.

## Matrix

| Chamber role or lane claim | Current surface | Classification now | Observable family or comparison basis | Retained evidence | Why the ceiling stops here |
| --- | --- | --- | --- | --- | --- |
| `CPU scheduler / verifier / custody` | `F1_CPU_CONTROL` on `/data/local/tmp/genesis_cli` | `CALLABLE` | `genesis_protocol` receipts under `audit/<run_id>/run00` | `artifacts/rm10_f1_serious_20260405T122831Z/`, `RUNBOOK_RM10_CPU.md` | Governed control is real, but this is still a prebuilt-backed CPU lane rather than a coupled chamber result |
| `CPU row on same-family chamber candidate` | Forced-CPU harmonic row on top-level `/data/local/tmp/dm3_runner` | `CALLABLE_WITH_DRIFT` | `f2_harmonic_residue` one-episode JSONL tuple | `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/summary.json`, `F2_TOPLEVEL_INSTABILITY_LEDGER.md` | Same-family CPU callability is real, but the root family still splits between low and high clusters and is not hermetic |
| `GPU-backed relaxation candidate on same family` | Default harmonic row on top-level `/data/local/tmp/dm3_runner` | `CALLABLE_WITH_INSTABILITY` | Same `f2_harmonic_residue` tuple as the forced-CPU root row | `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/`, `F2_TOPLEVEL_INSTABILITY_LEDGER.md` | GPU-backed rows exist, but the official CPU/GPU/GPU/CPU bracket still loses `cpu_b`, so the family does not yet preserve one honest closing observable |
| `GPU-backed residue control` | Legacy `/data/local/tmp/dm3/dm3_runner` harmonic training family | `CALLABLE_CONTROL_ONLY` | `dm3_harmonic_train_episode` | `artifacts/phase_01_2_3_1_dm3_harmonic_train_compare_20260405/COMPARE_SUMMARY.md` | Good feasibility control, but cross-family relative to `F1` and not a valid stand-in for the top-level root chamber |
| `Explicit CPU -> GPU handoff artifact` | None retained | `ABSTAIN` | None retained | `RUNBOOK_RM10_HETEROGENEOUS.md`, `RM10_LANE_CONTRAST_LEDGER.md` | Current GPU-backed work is still opaque internal accelerator use inside `dm3_runner`, not a retained handoff packet |
| `NPU projection / priming assist` | Inventory and path search only | `ABSTAIN` | None yet | `artifacts/phase_01_2_3_2_npu_triage_20260405/`, `NPU_ABSTAIN_JUSTIFICATION_NOTE.md`, `RUNBOOK_RM10_NPU.md` | No user-space callable command, no bounded assist role, and no receipted assist-stage I/O chain exist yet |
| `Explicit CPU -> NPU assist handoff artifact` | None retained | `ABSTAIN` | None retained | `NPU_ABSTAIN_JUSTIFICATION_NOTE.md`, `RUNBOOK_RM10_HETEROGENEOUS.md` | Nothing beyond inventory has been surfaced, so there is no honest handoff artifact to compare |

## Minimal Classification Rules For Later Plans

1. `CPU` is live now only in the sense of callable, receipted control.
2. `GPU` is live now only on the residue-family harmonic surfaces.
3. `NPU` is not live now as a DM3-facing lane.
4. `Heterogeneous chamber` is a candidate experimental framing on the
   top-level `F2` root family, not an already-cleared role-partition fact.

## What Later Plans May Reuse Directly

- A later chamber battery may compare forced-CPU and GPU-backed rows only on
  the top-level `/data/local/tmp/dm3_runner` family if it preserves the same
  JSONL tuple and keeps the instability visible.
- A later control battery may reuse `F1_CPU_CONTROL` as the authority anchor
  for run identity, telemetry, and custody discipline.
- A later NPU probe may reopen only if it can name one exact command and one
  bounded assist role before execution begins.

## Non-Promotions

- Adreno visibility is not a GPU lane by itself.
- Hexagon, `fastrpc`, `Qnn`, and `dspservice` visibility are not an NPU lane by
  themselves.
- Internal accelerator use inside one opaque binary is not an explicit
  heterogeneous handoff.
- Faster runtime, higher utilization, or hotter thermals are not behavioral
  signal.

## Verdict

The callable matrix is:

- `CPU`: live control
- `GPU`: live residue-family candidate with instability
- `NPU`: explicit abstain
- `explicit heterogeneous handoff`: not yet open
