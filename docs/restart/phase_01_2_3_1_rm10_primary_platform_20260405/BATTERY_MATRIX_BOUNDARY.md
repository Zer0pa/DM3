# Battery Matrix Boundary

## Question

Does a boundary-defined derivative of the governed RM10 CPU control observable
carry reproducible explanatory signal beyond size-matched interior and random
mask controls?

## Minimum Matrix Rows

| Row | Contrast | Minimum run class | Strengthens H3 if | Collapses H3 if |
| --- | --- | --- | --- | --- |
| `B-01` | repeatability floor | `>=3` repeated CPU control runs | the boundary metric is stable enough that between-condition differences exceed within-condition noise | the metric wanders across repeats |
| `B-02` | boundary vs size-matched interior | same runs with a fixed interior comparator | the boundary effect exceeds the interior effect at matched support | the interior comparator matches or exceeds the boundary effect |
| `B-03` | boundary vs size-matched random masks | same runs plus random-mask nulls | the boundary effect sits outside the random-mask distribution | random masks explain the effect equally well |
| `B-04` | boundary-local vs interior-local perturbation | matched perturbation family on the same observable | boundary-local perturbation changes the boundary metric more than interior-local perturbation | the response is non-local or indiscriminate |
| `B-05` | cross-lane carry-forward | GPU or heterogeneous only after `B-01`..`B-04` pass on CPU | the same metric survives unchanged across lanes | the lane change also changes the observable family |

## Verdict Rule

- `strengthened`: `B-01` passes and at least one of `B-02`..`B-04` beats its matched null on the same observable family
- `collapsed`: a completed row shows interior or random controls explain the claimed boundary effect equally well or better
- `abstain`: no predeclared boundary metric, no matched null, or only single-run evidence exists

## Current First-Pass Status

- battery design: not yet execution-ready until the boundary metric and comparator masks are locked in the ledger
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

The branch has a CPU control lane, but not yet a predeclared boundary metric
with honest matched controls.

## Next Trigger

Lock the boundary mask, size-matched interior mask, and random-mask generator
first, then run `B-01`..`B-03` before any hardware derivative.
