# Fresh Clone

This is the minimum path for a new machine or collaborator.

## Clone And Recover

```bash
git clone https://github.com/Zer0pa/DM3-2026-Restart.git
cd DM3-2026-Restart
./tools/bootstrap_recovery.sh
./tools/check_legacy_october.sh
```

That is baseline recovery only. It does not restore current branch truth by
itself.

## Current Branch Entry Point

For the active RM10-primary branch, read in this order:

1. `/Users/Zer0pa/DM3/AGENTS.md`
2. `.gpd/STATE.md`
3. `.gpd/PROJECT.md`
4. `.gpd/ROADMAP.md`
5. `docs/restart/RM10_AGENT_HANDOVER_20260416.md`
6. `docs/restart/ENGINEERING_GAP_LEDGER.md`
7. `docs/restart/VALIDATOR_AND_CANONICAL_GAP_LEDGER.md`
8. `docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md`
9. `docs/restart/RM10_CONFIRMATION_REPLAY_COMPARISON_LEDGER.md`
10. `docs/restart/RM10_REGIME_LOCALIZATION_LEDGER.md`
11. `docs/restart/RM10_REGIME_ENTRANCE_CONDITION_NEXT_MOVE.md`
12. `docs/restart/AGENT_STARTUP_PROMPT.md`

For the exact frozen order, use `docs/restart/STARTUP_READING_ORDER_FREEZE.md`.

## Truth Floor

- `F1` governed Genesis CPU control is the trustworthy branch-local instrument.
- the live governed accelerator bridge on `F1` is closed.
- governed RM10 validation still depends on `explicit_hash` handling.
- the top-level `/data/local/tmp/dm3_runner` root family is callable under the
  stronger envelope.
- the repaired four-row packet did not reproduce.
- bounded localization showed the low regime can already appear at `cpu_a`.
- the live blocker is now entrance-condition selection before row 1.
- no preserved same-family observable currently supports a narrow
  heterogeneous split.
- NPU remains `ABSTAIN`.
- explicit heterogeneous role partition remains `ABSTAIN`.
- Mac Genesis remains the only `source_built` authority lane.

## Immediate Branch Task

Do not start with a full four-row rerun.
The immediate branch task is:

1. keep governed `F1` work under explicit-hash handling while the live
   validator rule remains a stale compiled pair
2. run the planned entrance-condition localization battery for fresh single-row
   `cpu_a` anchors under controlled start states
3. only after that decide whether a full same-family confirmation replay may
   reopen
