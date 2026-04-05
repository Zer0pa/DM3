# Battery Matrix Spectral

## Question

Does the governed RM10 CPU control family contain reproducible mode structure or
causal-order sensitivity that is not captured by low-order scalar summaries?

## Minimum Matrix Rows

| Row | Contrast | Minimum run class | Strengthens H4 if | Collapses H4 if |
| --- | --- | --- | --- | --- |
| `S-01` | repeatability floor | `>=5` repeated CPU control traces if cheap, otherwise `>=3` serious runs | dominant modes or settle times are stable beyond run-to-run noise | spectral peaks drift or disappear across repeats |
| `S-02` | perturb-and-settle family | matched perturbed runs on the same observable | perturbation shifts spectral structure systematically | only total amplitude changes, with no stable mode structure |
| `S-03` | low-order-summary null | same runs reduced to mean, variance, or final-scalar summaries | spectral metrics separate conditions better than scalar summaries | scalar summaries capture all apparent separation |
| `S-04` | order-destruction null | time-shuffled or phase-scrambled surrogates of the same traces | destroying order erases the claimed signal | shuffled surrogates preserve the effect |
| `S-05` | cross-lane carry-forward | GPU or heterogeneous only after `S-01`..`S-04` pass on CPU | the same trace semantics survive across lanes | the accelerator path changes what the trace means |

## Verdict Rule

- `strengthened`: `S-01` passes and either `S-02` or `S-04` shows stable mode or order structure beyond scalar or null explanations
- `collapsed`: a completed row shows the claimed spectral effect is unstable, or low-order summaries and shuffled surrogates explain it equally well
- `abstain`: no ordered trace exists, repeated runs are missing, or the branch cannot preserve a common trace semantics

## Current First-Pass Status

- battery design: not yet execution-ready until the trace representation and null transformation are fixed
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

The branch has a control lane but has not yet run the repeated or perturbed
trace family needed for spectral interpretation.
