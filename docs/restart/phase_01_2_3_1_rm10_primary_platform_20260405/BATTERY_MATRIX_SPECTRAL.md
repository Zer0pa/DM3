# Battery Matrix Spectral

## Question

Does the branch control surface show mode sensitivity, settle-pattern structure,
or causal-order sensitivity that is hidden by low-frequency summaries?

## Candidate Observables

- settle traces across repeated bounded runs
- perturb-and-settle comparisons
- mode or band summaries if the control output can be transformed cleanly

## Required Run Classes

- repeated CPU control
- perturbed CPU control
- later GPU or heterogeneous derivative only if comparability survives

## Current First-Pass Status

- battery design: ready
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

The branch has a control lane but has not yet run the repeated or perturbed
trace family needed for spectral interpretation.
