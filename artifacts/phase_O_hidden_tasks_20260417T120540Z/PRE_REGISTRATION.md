# Phase O — Hidden Task Probes (Session 5 Priority 1)

## Pre-Registration

Binary strings scan (Phase N.2) revealed callable-sounding task-like identifiers
never invoked via `--task`. This phase tests which, if any, are accepted by the
binary.

## Hypothesis

H-O1: One or more of `interference`, `holographic_memory`, `InterferenceTask`,
`run_holographic_memory` is accepted by `--task` and produces a non-empty
receipt with either the standard 6-field schema or an extended schema.

H-O2 (null): All hidden identifiers are rejected. `--task` accepts only
`harmonic` and `holography` and the rest are internal-only.

## Predictions

- P1 (task accepted): Binary returns RC=0 and emits at least one JSONL line.
- P2 (task rejected): Binary returns RC != 0 with a clap-style error, or runs
  but produces zero receipts (falls through a default path).
- P3 (new schema): If accepted, receipt contains fields not in
  `{asymmetry, coherence, decision, delta_E, duration_ms, episode}`.

## Kill Criteria

A task name is KILLED if:
- Binary rejects it with non-zero exit and empty/error receipt.
- Binary accepts but produces receipts identical in schema to harmonic and
  identical in basin structure (E≈75/89, Coh≈0.77/0.89) to N=1.

A task name is PROMOTED TO INTERESTING if:
- Returns RC=0 AND either schema differs OR E/Coh basin values differ
  qualitatively from harmonic defaults.
- Will trigger N=5 follow-up in the same phase.

## Execution Plan

All probes: `--cpu --mode train --steps 1 --output <name>.jsonl`.

Task-name candidates (via `--task <name>`):
1. `interference`
2. `holographic_memory`
3. `InterferenceTask`
4. `run_holographic_memory`
5. `K1`
6. `G2`
7. `pattern_ontology`
8. `boundary_readout`
9. `exp_i0_classifier`
10. `exp_r1_r4_campaign`
11. `r1_r4_campaign`
12. `interference_task`
13. `holographic-memory`

Mode candidates (via `--mode <name>`):
14. `--mode G2`
15. `--mode K1`
16. `--mode inference` with `--task holographic_memory`
17. `--mode inference` with `--task interference`

Plus `--gated` applied to `--task holography` and `--task harmonic` at steps=1
to confirm behaviour.

## Budget

- Target: 15-25 probes × ~60-195s/episode = 15-80 minutes.
- Hard cap: 90 minutes. Move to Priority 2 after.

## Receipt Schema Check

For each receipt file, dump full contents and note:
- Exit code
- Receipt count
- Unique field set
- Classification (HIGH/LOW/OTHER/RETRY) if 6-field
- Qualitative notes if new schema

## Deliverable

`PHASE_O_SUMMARY.md` with:
- Table: task/mode → RC, receipts, schema, classification
- List of any probes PROMOTED TO INTERESTING for follow-up
- Updated binary-task inventory
