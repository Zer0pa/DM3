# Battery Matrix Persistence

## Question

Does the branch control surface retain useful history, residue, or scar under
repeat perturbation, or is it just sticky noise?

## Candidate Observables

- repeated bounded runs with and without reset
- residue decay over short repeated sequences
- readout stability after staged perturbations

## Required Run Classes

- repeated CPU control
- later mixed or accelerated variants only if the same persistence metric can
  be compared honestly

## Current First-Pass Status

- battery design: ready
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

The branch has captured only the first clean control run, not the sequence
needed to assess persistence.
