# RM10 GPU Parity Prep Runbook

## Exact Phase Verdict

- `phase_outcome=PASS`
- `route_outcome=FAIL`
- The preserved bundled G2 family is retired on the current callable same-binary surface.
- The blocker is no longer "which same-binary route should we try?"; it is whether the historical bundled G2 residue belongs to a neighboring launcher generation or requires explicit redevelopment.

## Purpose

Prepare a bounded RM10 GPU parity programme without inflating it into present
authority.

## Current Lane Status

- `authority_status=engineering_only`
- `evidence_surface=engineering_feasibility` until a real parity comparison is
  live
- the retired same-binary bundled `G2` family cannot be used as the reference
  observable

## Entry Gate

GPU parity work may start only if all of the following are true:

1. a different already-live CPU reference observable is named explicitly under
   the governed witness floor
2. the same observable can be receipted on RM10 without changing the scientific
   story
3. deterministic reduction and serialization rules are written before the run
4. fresh RM10 build-class and validator status are labeled honestly

Without those conditions, GPU work remains prep only.

## Required Parity Evidence

Every live GPU parity attempt must capture:

- exact command surface
- runtime identity, driver/runtime string, and GPU selection
- CPU reference receipt bundle and GPU receipt bundle
- normalized comparison output
- stdout/stderr
- pre/post battery and thermal telemetry
- explicit `authority_status`, `evidence_surface`, `build_class`,
  `phase_outcome`, and `route_outcome`

## Serious-Run Inheritance

Any live GPU run must inherit:

- the identity packet from `RUNBOOK_RM10_SYSTEMS.md`
- the manifest and outcome encoding from `COMET_SCHEMA_AND_TAGGING.md`
- the checkpoint contract from `CHECKPOINT_RESUME_POLICY.md`

## Kill Criteria

Stop immediately if:

- the CPU reference observable is not already live
- the GPU path changes the observable family
- reduction order cannot be stated or enforced
- receipt fields block comparison
- thermal stress and drift cannot be separated
- unrecovered hybrid logic or opaque vendor behavior becomes the only path

## Output Package

The GPU package must end with:

- identity packet and Comet anchor
- runtime identity note
- deterministic reduction-order note
- parity evidence ledger
- thermal note
- explicit micro verdict or blocker note

## Current Readiness Sentence

RM10 GPU parity is not ready now; because `phase_outcome=PASS` and
`route_outcome=FAIL` retired the preserved bundled G2 family on the current
callable same-binary surface, GPU work may start only if a different
already-live CPU reference observable is named explicitly under the governed
witness floor.
