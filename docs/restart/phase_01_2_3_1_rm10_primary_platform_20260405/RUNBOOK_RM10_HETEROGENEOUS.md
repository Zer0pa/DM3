# Runbook RM10 Heterogeneous

## Goal

Run one bounded heterogeneous comparison only if CPU control and the comparison
surface are already explicit.

## Preconditions

- CPU control lane written and live
- GPU and NPU feasibility states documented
- one common observable family named
- handoff boundary can be logged

## Allowed Heterogeneous Patterns

- CPU authority plus bounded GPU substage
- CPU authority plus bounded assist stage
- explicit abstain if neither pattern is comparable

## Required Handoff Capture

- pre-handoff artifact
- handoff format
- post-handoff artifact
- final comparable observable

## Verdict Standard

- `PASS`: the split preserves the observable and localizes the handoff
- `FAIL`: the split changes the observable or erases comparability
- `ABSTAIN`: the split is technically real but not yet interpretable enough

## Hard Stops

- no common observable exists
- split is opaque
- drift cannot be localized
- split changes the scientific story instead of the execution path
