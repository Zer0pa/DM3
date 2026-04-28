# DM3 Retractions Register

Last updated: `2026-04-28`.

This file is the canonical Retractions Register for DM3 under License
Section 19.3(d). Retractions remain first-class public artifacts. They
stay visible here and in [`CLAIMS.md`](CLAIMS.md). Historical claims
are not deleted; they are marked and linked to the killing or
superseding evidence.

## Status semantics

- **RETRACTED** — a previously promoted claim whose pre-registered
  kill criterion was met. The claim is removed from the active ledger
  and the killing evidence is recorded.
- **REJECTED-BEFORE-PROMOTED** — a candidate claim that was caught and
  superseded inside the same workstream before it was added to the
  promoted ledger. Recorded as a process win, not a retraction in the
  License sense.
- **WEAKENED** — a claim whose statement was narrowed in light of new
  evidence. The earlier wording is preserved in the retired-claims
  section of `CLAIMS.md` and linked here.

## Current entries

| Claim | Status | First recorded | Summary | Evidence |
|---|---|---|---|---|
| `H2` | RETRACTED / KILLED | 2026-04-16 | The transformer does not create bistability. Geometry is sovereign; bistability survives Hamiltonian-mode replay without transformer dependence. | `docs/restart/DM3_MULTI_HYPOTHESIS_FINAL_REPORT.md`, `docs/restart/DM3_SESSION4_FINAL_REPORT.md` |
| `γ` | RETRACTED | 2026-04-17 | `rot=60°` does not uniquely break C3 under asymmetry. Session 5 pooled replication removed the claimed `60°`-specific effect. | `artifacts/phase_P2b_coupling/PHASE_P2b_SUMMARY.md`, `CLAIMS.md` |
| `δ.3` | WEAKENED | 2026-04-22 | The Session 6 reading that R3 "payload-moves along `--steps`" is weakened. SY-default surface saturates at `operational_steps == 10`; requested `--steps > 20` no longer advances payload. R3 remains structurally unreachable from the exposed CLI. | `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_final/`, `CLAIMS.md` |
| `σ` | REJECTED-BEFORE-PROMOTED | 2026-04-25 | The Session 8 Phase A draft "coarse 30/40 peak" wording for the `exp_k2_scars` learning curve was caught and superseded by the A5 one-step sweep before it reached the promoted ledger. | `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`, `CLAIMS.md` retired-claims block |
| `σ′` | REJECTED-BEFORE-PROMOTED | 2026-04-25 | The A5 interim "bimodal s32/s41" wording was caught and superseded by the A6a/A6b fills before it reached the promoted ledger. The active candidate is `σ″` (trimodal sawtooth). | `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`, `CLAIMS.md` retired-claims block |
| `θ` (Session 7 wording) | SUPERSEDED | 2026-04-25 | The Session 7 wording of `θ` ("harmonic dynamics layer is substrate-invariant") is reused in the Session 8 ledger for the closed compound-axis `R1+R2` flip with `r4.transfer_ratio` doubling, and the older substrate-null line is now carried under `ι`. The change is bookkeeping; the underlying evidence is preserved in both anchor cells. | `CLAIMS.md` claims `θ` and `ι`, `artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/S11_final/` |

## Related lineage notes

- The `σ → σ′ → σ″` lineage is preserved in `CLAIMS.md` and is
  promoted as a process win, not buried. The discipline is that draft
  wordings are caught inside the workstream that produced them.
- The R3 weakening is paired with the SY-default `operational_steps`
  saturation finding; the weakened wording remains visible alongside
  the strengthened evidence base.

## Operating rule

- A claim enters this register when its pre-registered kill criterion
  is met, when a stronger receipted result explicitly retracts it, or
  when a candidate is caught and superseded inside its source
  workstream before promotion.
- Retractions are prospective and binding on the public DM3 surface
  from the moment they are published here.
- Historical wordings are not deleted; they are marked and linked to
  the killing or superseding evidence. The lineage stays visible.
