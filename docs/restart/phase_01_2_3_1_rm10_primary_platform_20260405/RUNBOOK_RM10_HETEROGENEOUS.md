# Runbook RM10 Heterogeneous

## Goal

Run one bounded explicit heterogeneous comparison only when the handoff is
logged rather than merely implied.

## Preconditions

- one CPU family is already callable and receipt-backed
- one accelerator lane is callable on that same family
- the observable family is named explicitly
- pre-handoff and post-handoff artifacts can be retained
- checkpoint identity is frozen before the split

## Important Distinction

A GPU-backed run inside one opaque binary is not automatically an explicit
heterogeneous role-partition result.

Current branch standing:

- `dm3_runner` harmonic training proves a bounded GPU-backed family exists
- it does **not** yet prove an explicit CPU->GPU handoff with localized drift

## Allowed Heterogeneous Patterns

- CPU authority plus bounded GPU substage
- CPU authority plus bounded NPU assist stage
- explicit abstain if neither pattern is comparable

## Required Handoff Capture

- pre-handoff artifact
- handoff format or transform description
- post-handoff artifact
- final comparable observable
- statement naming which side owns which stage

## Verdict Standard

- `PASS`: the split preserves the observable, localizes the handoff, and stays within its declared ceiling
- `FAIL`: the split changes the observable or erases comparability
- `ABSTAIN`: a mixed path may exist, but the branch cannot interpret it honestly yet
- `BLOCKED`: a mixed attempt was justified, but identity or receipt capture drifted

## Hard Stops

- no common observable exists
- the split is opaque
- drift cannot be localized
- the split changes the scientific story instead of the execution path
- one binary's internal accelerator use is being narrated as explicit role partition without handoff evidence
