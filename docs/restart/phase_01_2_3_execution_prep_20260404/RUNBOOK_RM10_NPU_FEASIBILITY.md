# RM10 NPU Feasibility Prep Runbook

## Exact Phase Verdict

- `phase_outcome=PASS`
- `route_outcome=FAIL`
- The preserved bundled G2 family is retired on the current callable same-binary surface.
- The blocker is no longer "which same-binary route should we try?"; it is whether the historical bundled G2 residue belongs to a neighboring launcher generation or requires explicit redevelopment.

## Purpose

Answer one bounded question:

`Is there any user-space reachable, bounded, receiptable NPU-assist role on the RM10 that helps the restart without changing the authority metric?`

A negative result remains valid.

## Current Lane Status

- `authority_status=feasibility_only`
- `evidence_surface=engineering_feasibility`
- same-binary bundled `G2` retirement does not promote NPU work into a recovery
  lane

## Feasibility Standard

The NPU lane counts as real only if all of the following are demonstrated:

1. a user-space callable API, runtime, or wrapper exists
2. the role is bounded and explicitly named
3. inputs and outputs can be receipted
4. the result can be compared against a CPU-governed baseline

## Allowed First Roles

- projection or coordinate proposal
- embedding or tagging pre-pass
- bounded preprocessing assist that is still checked by the CPU-governed lane

Forbidden first roles:

- whole-pipeline authority run
- opaque accelerator substitution
- any role that erases the comparable CPU observable

## Serious-Run Inheritance

Any live device-side NPU feasibility pass beyond inventory-only inspection must
inherit:

- the identity packet from `RUNBOOK_RM10_SYSTEMS.md`
- the manifest and outcome encoding from `COMET_SCHEMA_AND_TAGGING.md`
- the checkpoint contract from `CHECKPOINT_RESUME_POLICY.md`

## Kill Criteria

Stop with a negative or abstaining result if:

- only hardware-adjacent presence is visible
- the callable surface cannot be reached from user space
- inputs or outputs cannot be receipted
- the path requires unrecovered proprietary DM3 code
- the role drifts from bounded assist into opaque substitution

## Output Package

The NPU package must end with:

- identity packet and Comet anchor
- reachability inventory
- callable-proof note or negative-result note
- bounded assist-role note if applicable
- explicit `authority_status`, `evidence_surface`, `build_class`,
  `phase_outcome`, and `route_outcome`

## Current Status Sentence

RM10 NPU work is feasibility-only; because `phase_outcome=PASS` and
`route_outcome=FAIL` retired the preserved bundled G2 family on the current
callable same-binary surface, only user-space reachability or a bounded
receiptable assist role may be tested, and a clean negative result is
sufficient.
