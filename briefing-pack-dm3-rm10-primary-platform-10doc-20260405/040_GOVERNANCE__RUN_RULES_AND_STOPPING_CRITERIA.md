# Governance

## Serious Run Minimum

A serious branch run must retain the exact command, `command_surface`, exact
working directory, `run_id`, phase and plan, branch thesis, device serial and
model, device lane, compute lane, `battery_class`, `battery_family`,
`observable_family`, `build_class`, `authority_status`, receipt expectation,
stdout and stderr, thermal and battery pre and post, checkpoint identity, and
explicit `phase_outcome` plus `route_outcome`.

## Non-Negotiable Stops

- do not promote hardware visibility, node presence, or telemetry into readiness
- do not turn a missing receipt into a pass narrative
- do not resume across command, `cwd`, environment, build, or lane drift
- CPU to GPU to NPU to heterogeneous changes are new run IDs, not resumes
- stop when the common observable disappears or the handoff changes the scientific question
- stop when progress would require hidden redevelopment or opaque vendor behavior
- prefer `ABSTAIN` over proxy claims and `FAIL` over folklore

## Retry Rule

- max `2` setup probes per unchanged blocker
- max `1` feasibility probe per lane per unchanged blocker before review
- max `1` serious attempt per lane or observable pair before review after `FAIL`, `ABSTAIN`, or `BLOCKED`
