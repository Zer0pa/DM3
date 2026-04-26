# DM3 RM10 Branch GPD Operating Map

Last refreshed: `2026-04-16`

## Purpose

Map the GPD workflow to the live RM10 branch state so a new agent does not
route itself back into stale startup cleanup or older packet stories.

## Project Status

This branch is already a valid GPD project at:

- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd`

Working assumptions that remain correct:

- `state.json` is present
- `STATE.md`, `PROJECT.md`, `ROADMAP.md`, `REQUIREMENTS.md`, and
  `CONVENTIONS.md` are present
- the branch is already beyond initial bootstrap
- the next honest move is a bounded planned phase, not generic discovery

## Live Branch Ground Truth

- last completed branch phase: `01.2.3.4.1.1.3.1.2.1`
- next planned branch phase: `01.2.3.4.1.1.3.1.2.2`
- governed branch scientific anchor: RM10 `F1` Genesis CPU control
- governed RM10 validation remains under `explicit_hash` handling
- top-level `/data/local/tmp/dm3_runner` is callable under the stronger
  envelope
- the repaired four-row packet did not reproduce
- bounded localization showed the low regime can already appear at `cpu_a`
- the live blocker is the regime selector before row `cpu_a`
- homeostasis remains blocked
- NPU remains `ABSTAIN / inventory_only`
- explicit heterogeneous role partition remains `ABSTAIN`

## Startup Command Order

Use this order on takeover:

1. [$gpd-resume-work](/Users/prinivenpillay/.agents/skills/gpd-resume-work/SKILL.md)
2. [$gpd-health](/Users/prinivenpillay/.agents/skills/gpd-health/SKILL.md)
3. [$gpd-progress](/Users/prinivenpillay/.agents/skills/gpd-progress/SKILL.md)
4. read `docs/restart/RM10_AGENT_HANDOVER_20260416.md`
5. read `docs/restart/STARTUP_READING_ORDER_FREEZE.md`
6. verify the live RM10 device and path surfaces over ADB

Only after that:

7. [$gpd-plan-phase](/Users/prinivenpillay/.agents/skills/gpd-plan-phase/SKILL.md) for `01.2.3.4.1.1.3.1.2.2`
8. [$gpd-execute-phase](/Users/prinivenpillay/.agents/skills/gpd-execute-phase/SKILL.md) for `01.2.3.4.1.1.3.1.2.2`

## What GPD Is For Right Now

### Plan

Use `plan-phase` to freeze:

- the start-state capture contract
- the exact single-row `cpu_a` battery
- the artifact and telemetry bundle
- the comparison rule for high-start versus low-start anchors
- the retry rule for when the four-row packet may reopen

### Execute

Use `execute-phase` only for the bounded entrance-condition localization work.

That means:

- no widened homeostasis battery
- no new heterogeneous brief
- no speculative NPU work

### Verify

Use `verify-work` after `01.2.3.4.1.1.3.1.2.2` if the result claims a real
entrance-condition candidate.

If the result stays mixed, the correct output is an exact narrowed blocker, not
a widened pass narrative.

### Debug

Use `debug` only if the start-state bundle itself is broken or contradictory.
Do not use debugging as a substitute for a planned battery.

### Pause And Resume

Use `pause-work` to refresh the handoff if the session stops mid-phase.
Use `resume-work` whenever a new operator starts.

## Current Reading Priority

Trust these first:

1. `.gpd/STATE.md`
2. `docs/restart/RM10_AGENT_HANDOVER_20260416.md`
3. `docs/restart/ENGINEERING_GAP_LEDGER.md`
4. `docs/restart/VALIDATOR_AND_CANONICAL_GAP_LEDGER.md`
5. `docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md`
6. `docs/restart/RM10_CONFIRMATION_REPLAY_COMPARISON_LEDGER.md`
7. `docs/restart/RM10_REGIME_LOCALIZATION_LEDGER.md`
8. `docs/restart/RM10_REGIME_ENTRANCE_CONDITION_NEXT_MOVE.md`

Treat older bridge packs, bootstrap packs, and superseded resonance-phase docs
as history unless the live handover explicitly calls them in.

## What Not To Use GPD For Right Now

- do not open a new hypothesis branch for routine entrance-condition work
- do not open a paper-writing or export workflow
- do not use discovery as a substitute for the already-planned next phase
- do not treat plan creation as completion

## Bottom Line

The branch is already a functioning GPD project.
The active GPD job is exactly this:

`plan and execute 01.2.3.4.1.1.3.1.2.2 without widening the claim ceiling`

Everything else is downstream of that gate.
