# RM10 Property Map

Plan: `01.2.3.4.1.1-03`

Classification: `explicit no-signal stop`

Wave 2 gate input:

- `docs/restart/RM10_CAPABILITY_RESULT.md` classified the cleaned RM10 `F1`
  lane as `no capability found`
- `docs/restart/RM10_CAPABILITY_SMOKE_LATTICE_LEDGER.md` retained exactly one
  semantic receipt family across the full six-row smoke lattice
- `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/comparisons/semantic_matrix.json`
  shows `same_semantic_digest=true` for every retained row pair

## Observable Contract Reused For The Gate

- anchor observable:
  `semantic_receipt_signature`, the normalized semantic digest built from
  `verify.json`, `solve_h2.json`, and `VERIFY_SUMMARY.json` after stripping
  direct config-echo fields and timestamps
- drift observable:
  `lane_custody_and_thermal_tuple`, the fixed cleaned-`F1` identity tuple plus
  before/after battery and thermal telemetry
- abstain logic:
  do not call a property if the apparent difference reduces to config echo,
  runtime length, validator-default exit, filenames, or thermal / identity
  drift rather than retained receipt semantics

## Gate Basis

The property map does not open.

Why:

1. The retained smoke lattice never produced a second semantic family. Control
   rows, repeated candidate rows, and both orthogonal perturbations all
   collapsed to semantic digest
   `53d477f605117a935285716029129a225c9497c15d373e289658d90ee29d675a`.
2. The repeated control rows and repeated candidate rows proved short-window
   stability of the single family, not persistence of a changed state.
3. The drift observable stayed nominal throughout the retained battery: same
   cleaned `F1` lane identity, `Thermal Status 0 -> 0`, and battery
   `34.0 C -> 34.0 C`, so there is no thermal excursion to reinterpret as a
   hidden threshold or recovery curve.
4. The phase context explicitly allows a fast honest negative when every
   apparent effect collapses under simple falsification.

## Property-Family Admissibility

| Property family | Verdict | Reason |
| --- | --- | --- |
| Thresholds / mode flips | not admissible | No perturbation axis detached from the control family under the anchor observable. |
| Persistence across short reruns | not admissible | Repeats only reproduced the same family; they did not preserve a changed response. |
| Hysteresis | not admissible | No state change appeared, so there is no loop to trace. |
| Recovery after perturbation | not admissible | Nothing left the control family, so there is nothing to recover from. |
| Boundary / window sensitivity | not admissible | Wave 2 exposed no retained boundary-window observable on the cleaned `F1` surface. |
| Packet-format sensitivity | not admissible | Raw receipt hash churn reduced to stripped config echo; no semantic packet split survived. |
| Lane sensitivity hints | not opened here | Battery E is downstream and requires an interpretable alternate lane; Battery C did not produce a property to carry forward. |

## Failure Modes Fenced Off

- `noise-as-surface`: blocked. One-family collapse means variance, raw hash
  churn, or logging differences cannot be rebranded as thresholds,
  persistence, or hysteresis.
- `thermal theatre`: blocked. The thermal baseline stayed nominal and flatter
  than the retained governed `F1` envelope, so temperature cannot rescue a
  missing semantic split.
- `history substitution`: blocked. Historical observables were used only as
  candidate vocabulary; none became a live property because the fresh lattice
  never surfaced a retained response family.

## Stop Verdict

Wave 3 stops here with an explicit no-signal note.

- no focused rerun battery was executed
- no `artifacts/phase_01_2_3_4_1_1_property_map_*` packet was created
- no property family is available to carry into same-family handoff testing

The next honest move is not deeper property mapping. A later battery would need
to surface a second retained semantic family on the cleaned `F1` lane before
this plan could reopen.

## Wave 4 Consequence

Plan `01.2.3.4.1.1-04` may not run a real same-family property-preservation
battery from this result. If Wave 4 is executed next, it should do so only on
its explicit `claim-handoff-abstain` path, using this no-signal stop as the
gate input.
