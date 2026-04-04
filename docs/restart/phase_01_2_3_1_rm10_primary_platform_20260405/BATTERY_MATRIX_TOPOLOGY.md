# Battery Matrix Topology

## Question

Do topology-aware summaries detect regime changes or stability loss better than
local scalar summaries on this branch?

## Candidate Observables

- trajectory-derived point clouds from repeated control outputs
- persistence summaries over bounded run sequences
- topology change under hardware-role changes

## Required Run Classes

- repeated CPU control
- later CPU versus GPU or heterogeneous comparisons if a common observable is
  earned

## Current First-Pass Status

- battery design: ready
- executed on first pass: no
- current verdict: `ABSTAIN`

Reason:

Only one bounded CPU control run has been captured so far.
