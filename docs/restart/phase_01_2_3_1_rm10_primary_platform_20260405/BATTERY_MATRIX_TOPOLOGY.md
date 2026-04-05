# Battery Matrix Topology

## Question

Do topology-aware summaries extracted from a fixed embedding of the common RM10
CPU control observable detect regime changes better than scalar thresholds?

## Minimum Matrix Rows

| Row | Contrast | Minimum run class | Strengthens H5 if | Collapses H5 if |
| --- | --- | --- | --- | --- |
| `T-01` | baseline topology stability | `>=3` repeated CPU control runs with one fixed embedding pipeline | topological summaries are stable within the baseline family | topology is unstable even within baseline repeats |
| `T-02` | perturbed vs unperturbed separation | repeated perturbed and unperturbed families | topology separates the two families more cleanly than scalar thresholds | the two families overlap once noise is accounted for |
| `T-03` | surrogate null preserving marginals | randomized or resampled surrogates preserving scalar marginals | the topological effect exceeds surrogate structure | surrogates reproduce the same apparent topology |
| `T-04` | scalar-threshold comparator | same runs analyzed with scalar cutoffs only | topology catches regime changes missed by scalar summaries | scalar thresholds work equally well |
| `T-05` | cross-lane carry-forward | GPU or heterogeneous only after `T-01`..`T-04` pass on CPU | the same embedding and topology summary survive across lanes | lane changes force a new embedding or new observable family |

## Verdict Rule

- `strengthened`: `T-01` passes and either `T-02` or `T-04` shows topology adds stable discriminatory power beyond scalar summaries
- `collapsed`: a completed row shows topology is unstable, surrogate-explainable, or no better than scalar thresholds
- `abstain`: only one run exists, the embedding pipeline is not frozen, or the common observable cannot be embedded honestly

## Current First-Pass Status

- battery design: not yet execution-ready until the embedding pipeline and surrogate null are frozen
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

Only one bounded CPU control run has been captured so far, so there is no
honest baseline topology family yet.
