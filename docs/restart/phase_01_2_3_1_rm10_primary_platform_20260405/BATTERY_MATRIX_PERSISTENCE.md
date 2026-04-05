# Battery Matrix Persistence

## Question

Does the common RM10 CPU control family exhibit bounded memory or scar beyond
run-to-run noise, reset effects, and thermal or runtime drift?

## Minimum Matrix Rows

| Row | Contrast | Minimum run class | Strengthens H7 if | Collapses H7 if |
| --- | --- | --- | --- | --- |
| `P-01` | clean-reset repeatability floor | `>=3` clean-reset CPU control runs | baseline drift is bounded tightly enough to define a noise floor | baseline drift already looks like memory |
| `P-02` | no-reset carryover | short consecutive no-reset sequence on the same observable | lag similarity or carryover exceeds the reset baseline reproducibly | no-reset looks identical to reset baseline |
| `P-03` | perturb-then-continue | bounded perturbation followed by continued runs | perturbation leaves a structured after-effect or decay curve | the effect vanishes immediately or is pure noise |
| `P-04` | hard-reset washout control | perturbation followed by an honest hard reset | reset erases the claimed scar in the expected way | the scar survives only because reset accounting was not honest |
| `P-05` | thermal or runtime drift null | matched no-perturbation time-control sequence | the memory metric exceeds the drift baseline | apparent memory tracks heat, wall time, or runtime drift |

## Verdict Rule

- `strengthened`: `P-01` passes and either `P-02` or `P-03` survives both the hard-reset washout control and the drift null
- `collapsed`: a completed row shows the claimed persistence vanishes under honest reset accounting or is explained by thermal or runtime drift
- `abstain`: only single-run captures exist, or reset state semantics are not explicit and receiptable

## Current First-Pass Status

- battery design: not yet execution-ready until reset semantics and drift controls are fixed
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

The branch has captured only the first clean control run, not the sequence
needed to separate memory from noise or drift.
