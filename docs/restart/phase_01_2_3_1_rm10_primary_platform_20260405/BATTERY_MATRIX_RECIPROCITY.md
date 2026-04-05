# Battery Matrix Reciprocity

## Question

Does a branch-defined swap operator induce an invariant or predictably
transformed response on the common RM10 CPU control observable?

## Minimum Matrix Rows

| Row | Contrast | Minimum run class | Strengthens H6 if | Collapses H6 if |
| --- | --- | --- | --- | --- |
| `R-01` | swap-definition sanity check | one predeclared swap map plus double-swap replay | the swap is well-defined and double-swap returns to baseline mapping | the swap is undefined, non-involutive, or changes staging itself |
| `R-02` | unswapped vs swapped | matched CPU runs with one honest swap | the swapped response matches a predicted invariant or anti-invariant transform | the response changes arbitrarily |
| `R-03` | arbitrary relabeling null | same runs plus a cosmetic relabeling control | the true swap outperforms arbitrary relabeling | arbitrary relabeling explains the same effect |
| `R-04` | directional perturbation pair | perturb both directions on the same observable | reciprocity error stays bounded and reproducible | asymmetry is large, unstable, or one-direction-only |
| `R-05` | cross-lane carry-forward | GPU or heterogeneous only after `R-01`..`R-04` pass on CPU | the same swap semantics survive across lanes | the accelerator path forces a new swap story |

## Verdict Rule

- `strengthened`: `R-01` passes and either `R-02` or `R-04` shows a reproducible symmetry relation that beats the relabeling null
- `collapsed`: a completed row shows the effect depends on cosmetic labeling, unstable normalization, or staging changes rather than a real reciprocal structure
- `abstain`: no honest swap operator is defined, or the protocol changes the observable family while claiming reciprocity

## Current First-Pass Status

- battery design: not yet execution-ready until the swap operator is defined in branch-native terms
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

The branch has not yet defined a settled paired-role protocol on the first
control family, so any reciprocity claim would still be decorative.
