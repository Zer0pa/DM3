# RM10 Regime Entrance Condition Next Move

Last refreshed: `2026-04-16`

## Reduced Problem

The live problem is no longer "can the four-row packet complete?" or "what
environmental variable selects the regime?"

The live problem is now:

`the regime selector is internal to the binary (RNG seed interacting with a
bistable training landscape), biased by page cache warmth but not operator-
controllable through cleanup, idle, or thermal management`

## What Phase 01.2.3.4.1.1.3.1.2.2 Ruled Out

- not residual output files in CWD
- not idle/cooldown duration alone
- not thermal state (all runs at 24.0C, thermal status 0)
- not third-row position
- not `gpu_b` specifically
- not a simple replay-timeout story

## What Phase 01.2.3.4.1.1.3.1.2.2 Found

- The regime is sharply bimodal (HIGH: delta_E ~88-89 vs LOW: delta_E ~74-76)
  with zero intermediate values across 7 anchors
- Deep-clean cold with extended idle reliably produces LOW (2/2)
- Runs after recent invocations bias HIGH (~80%), with one exception
- The FAST session (~155s) from the repaired packet was NOT reproduced; all
  7 anchors were SLOW (~194-213s)
- The strongest candidate is internal RNG seeding

## Exact Next Move

See `docs/restart/RM10_ENTRANCE_CONDITION_RETRY_RULE.md` for the full retry rule.

The immediate next move is one of:

1. **Attempt the gated full-replay protocol** — run a throwaway warm-up, then
   a classification anchor, and if HIGH, proceed to the full four-row replay
2. **Investigate the FAST session mystery** — the repaired packet's ~155s
   duration was never reproduced; this may require different device conditions
   or binary invocation parameters
3. **Investigate binary internals** — if the branch wants deterministic regime
   control, it needs either source-level RNG seed control or a reverse-
   engineered understanding of what seeds the initial condition

## Gate Rule

Do not retry homeostasis or broader chamber interpretation until a full four-row
confirmation replay has been completed with ALL rows in the HIGH regime under
the gated retry protocol.
