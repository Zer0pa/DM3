# Runbook: Drift Elimination And Authority Control

Last refreshed: `2026-04-05`

## Purpose

Use this runbook to remove startup and control-surface drift without damaging
provenance.

This runbook is for doc truth, startup truth, and authority classification.
It is not a license to rewrite evidence packs or scientific verdicts.

## Ground Rule

If a surface is wrong and active, fix or quarantine it.
If a surface is old but historically meaningful, preserve it and demote it.

Never solve drift by letting two contradictory startup surfaces coexist.

## Required Inputs

Read first:

- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/.gpd/STATE.md`
- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/briefing-pack-dm3-rm10-bridge-phase-01-2-3-2-10doc-20260405/000_START_HERE__RM10_BRIDGE_PHASE_GUIDE.md`
- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/briefing-pack-dm3-rm10-bridge-phase-01-2-3-2-10doc-20260405/010_EXECUTIVE__RM10_BRIDGE_PHASE_BRANCH_VERDICT.md`
- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/briefing-pack-dm3-rm10-bridge-phase-01-2-3-2-10doc-20260405/080_NEXT__ENGINEERING_MOVE_AND_DECISION_ROUTE.md`
- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md`
- `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/docs/restart/RM10_EXECUTION_SURFACE_MANIFEST.md`

## Classification Vocabulary

Every candidate surface must be labeled exactly once:

- `authority_anchor`
- `active_work_surface`
- `historical_reference`
- `stale_duplicate`
- `quarantine_candidate`
- `safe_delete_candidate`

## Procedure

### Step 1: Build the candidate list

Scan:

- startup prompts
- operating maps
- README / clone guides
- branch metadata
- current packs
- older packs still likely to be mistaken as current

Known mandatory checks:

- `docs/restart/AGENT_STARTUP_PROMPT.md`
- `docs/restart/GPD_OPERATING_MAP.md`
- `.gpd/hypotheses/rm10-primary-platform-heterogeneous-learning/HYPOTHESIS.md`
- `README.md`
- `docs/restart/FRESH_CLONE.md`

### Step 2: Test each surface against live state

For each candidate, ask:

1. Does it point at the correct repo root?
2. Does it describe the current phase state correctly?
3. Does it preserve the `F1` / `F2` split correctly?
4. Does it preserve `source_built` vs `prebuilt_stub` vs
   `mixed_prebuilt_backed` correctly?
5. Does it send a fresh agent to the current branch evidence pack before older
   material?
6. Does it widen any hardware claim beyond the current branch verdict?

If any answer is no, the surface is not safe as an active startup/control doc.

### Step 3: Decide action

Use this decision table:

- active and wrong: fix immediately
- historical and wrong only in present tense: preserve, label as history, and
  demote below current surfaces
- duplicate and misleading: quarantine or delete
- unknown and possibly important: quarantine first, decide later

### Step 4: Record custody

Every quarantine or delete action must be logged in:

- `QUARANTINE_LEDGER.md`
- `SAFE_DELETE_LEDGER.md`

Each entry must include:

- path
- previous role
- reason for action
- authority risk if left active
- where the replacement truth surface lives

### Step 5: Re-test startup

After corrections:

- read the startup prompt cold
- verify the reading order is sufficient without oral context
- verify the next agent would land on `01.2.3.2` branch truth, not on older
  mainline or `01.2.3.1` assumptions

## Known Present-Tense Drift Risks

These are already known to be high-risk if left active:

- any document that still points to `/Users/Zer0pa/DM3/restart` as the live repo
  for this branch
- any startup surface that instructs an agent to read `/Users/Zer0pa/DM3/AGENTS.md`
- any operating surface that still frames the work as pre-`01.2.3.2`
- any text that treats `F2` accelerator feasibility as bridge progress
- any text that implies NPU or heterogeneous work has crossed out of abstain

## Do Not Touch

Do not delete or rewrite these without a separate custody reason:

- branch evidence packs
- phase closeout verdicts
- receipts
- thermal ledgers
- artifact indexes
- historical provenance packs

If a historical surface is misleading, demote it. Do not erase it casually.

## Required Outputs

This runbook is complete only when it yields:

- `DRIFT_INVENTORY.md`
- `AUTHORITY_SURFACE_CLASSIFICATION.md`
- `QUARANTINE_LEDGER.md`
- `SAFE_DELETE_LEDGER.md`
- an updated startup prompt if startup drift existed
- an updated operating map if operating drift existed

## Failure Conditions

Stop and escalate if:

- the current truth depends on contradicting sources you cannot reconcile
- deletion would erase provenance you cannot preserve elsewhere
- the only way to make the docs agree is to soften a verdict

If that happens, preserve the contradiction explicitly and hand back a blocker.
