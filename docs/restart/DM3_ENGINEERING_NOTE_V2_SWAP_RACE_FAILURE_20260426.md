# DM3 Engineering Note — v2 Chain-Swap Race Failure (Engineering IS-NOT #002)

Written: `2026-04-26` ~16:15 UTC (18:15 SAST)
Status: post-incident; v1 chain alive and recoverable; cleanup applied; G.4 follow-on armed
Class: process-engineering finding, first-class alongside scientific IS-NOT findings

---

## Incident summary

The Phase G v2 reorder cutover (planned at G.6 close per `DM3_PHASE_G_AUGMENTED_PRD_v2_REORDERED_20260425.md`) **failed cleanly into a parallel-execution state**: v1 master continued running while v2 chain executed and "completed" in 11 minutes, polluting 5 cells with hollow `outcome.json` + `_COMPLETE` tokens.

The science is **not corrupted** because the per-run `pidof dm3_runner` parallel-runner gate refused every v2 dm3_runner invocation. v2's cells produced 0 receipts; their outcome files explicitly carry `runs=0 unique_canonical=0`. All real data on device is from the v1 master's legitimate execution.

Recovery applied: hollow outcomes deleted (with backups), G.5+ progress.txt's `_COMPLETE` token removed so v1 will re-run G.5+ when it gets there. G.4 follow-on launcher armed to run G.4 after chain end (v1's elapsed-gate would otherwise skip it).

---

## Timeline

| Time UTC | Event |
|---|---|
| 2026-04-25 18:25:54 | v1 chain launched |
| 2026-04-25 23:21:57 | G.0.5 verdict=PASS (real, ~5h, σ″ baseline confirmed) |
| 2026-04-26 03:48:29 | G.6 verdict=PASS (real) |
| 2026-04-26 03:48:30 | swap watcher detected G.6 close — but G.1 already started 1s earlier ("`--- G1 ---`" line in chain log). Watcher correctly took deferred path → wait for G.1 close. |
| 2026-04-26 03:48:30 → 14:50:55 | G.1 ran legitimately under v1 (~11h, exp_k2_scars × 8 step values × 3 reps) |
| 2026-04-26 14:50:55 | v1 master logged `G.1 verdict=PASS`; immediately invoked `g1_5_disambiguator.sh` (cell child PID 16194) |
| 2026-04-26 14:50:59 | swap watcher detected G.1 close (4s lag); attempted swap |
| 2026-04-26 14:52:05 | swap watcher launched v2 master (PID 17555) |
| 2026-04-26 14:52:02 → 15:02:49 | v2 master ran every cell in 11 min total. Every dm3_runner invocation blocked by parallel-runner gate. v2 logged `PHASE_G_CHAIN_V2_COMPLETE`. |
| 2026-04-26 16:06 | new orchestrator detected anomaly during reconnect health-check; diagnosed, cleaned, armed G.4 launcher |
| 2026-04-26 16:15 | post-incident, v1 still legitimately in G.1.5 on s16_r1 (16 real receipts, ~2h to G.1.5 close) |

---

## Root causes — three compounding failures

### 1. Kill of v1 master never landed

The swap watcher's deferred path:
```sh
MASTER_PID=$(pgrep -f "phase_g_chain.sh" | grep -v "v2" | head -1)
if [ -n "$MASTER_PID" ]; then
  pkill -TERM -P "$MASTER_PID" 2>/dev/null
  kill -TERM "$MASTER_PID" 2>/dev/null
  sleep 2
fi
```

The watcher logged "v2 launched (deferred) PID=17555" but **did not log a `pkill`/`kill` outcome**, and v1 master PID 11731 is observably still alive at 16:15 UTC — so the kill silently failed.

Three plausible causes (un-disambiguated):
- `pgrep -f "phase_g_chain.sh"` may have returned empty due to busybox/toybox `pgrep` quirk on Android (full-command search semantics differ across Android shells)
- Even if `MASTER_PID` was correctly captured, `kill -TERM` to a `sh` process with a long-running child can be ineffective if the shell is in `wait` state and the child catches the signal first
- The watcher script ran as user `shell`, master as user `shell` — same UID — so permissions are not the cause

The bug is silent-failure: no exit-code check, no post-kill verification.

### 2. v2 master ran a "complete" chain on a hollow workspace

v2's `run_sub` for each unrun cell saw no `_COMPLETE` token (cell hadn't run yet) and invoked the cell script. The cell script's per-run `run_cell.sh` checks `pidof dm3_runner` first thing and aborts with `DM3_RUNNER_ALREADY_RUNNING pid=<v1's PID>`. Every invocation aborted. The cell script's outer loop kept iterating through (s, n, config) tuples, all aborting. After the loop, it ran `summarize_cell.sh` (verdict=FAIL on 0 runs), then computed a final cell-level outcome from empty values, wrote `outcome.json` with verdict=KILL/PARTIAL, and wrote a `_COMPLETE` token to `progress.txt`.

This is **correct behavior in isolation** — the cell script doesn't know about the parallel-runner; it just iterates and reports honestly that it ran 0 successful invocations. But the chain-level master interprets this as "cell ran, here's its verdict" and continues.

**The harness has no in-band signal that distinguishes "cell ran 0 invocations because no work to do" from "cell ran 0 invocations because all were blocked"**. They produce indistinguishable outputs.

### 3. TAG-vs-CELL token-format inconsistency (latent bug, accidentally helpful)

The chain master's `run_sub` uses `grep -q "${TAG}_COMPLETE"` where TAG is the short identifier (e.g., "G2"). Cell scripts write `_COMPLETE` tokens but the **token prefix is inconsistent across cells**:

| Cell | TAG | Token written by cell script | Match? |
|---|---|---|---|
| G.0.5 | `G0_5` | `G0_5_COMPLETE` | ✓ TAG form |
| G.6 | `G6` | `G6_COMPLETE` | ✓ TAG form |
| G.1 | `G1` | `G1_COMPLETE` | ✓ TAG form |
| G.5+ | `G5plus` | `G5plus_COMPLETE` | ✓ TAG form |
| G.2 | `G2` | `G2_trimodal_portability_COMPLETE` | ✗ CELL form |
| G.3 | `G3` | `G3_learns_cartography_COMPLETE` | ✗ CELL form |
| G.4 | `G4` | `G4_basin_learning_coupling_COMPLETE` | ✗ CELL form |
| G.5 | `G5` | `G5_pre_cliff_robustness_COMPLETE` | ✗ CELL form |

In the recovery path, the CELL-form mismatch was a happy accident — v1's `run_sub` for G.2/G.3/G.4/G.5 saw no `G2_COMPLETE`/etc. token and will re-run those cells fresh (without our intervention). Only G.5+ used TAG form and would have been silently skipped on v1's pass.

**This is a latent bug** that needs fixing (see hardening below). It happened to save us this time. It will not always save us.

---

## Recovery applied

1. **Deleted hollow `outcome.json`** for G2_trimodal_portability, G3_learns_cartography, G4_basin_learning_coupling, G5_pre_cliff_robustness, G5plus_discontinuity_drill. Backups retained at `outcome.v2hollow.json.backup` per cell directory.
2. **Edited G5plus_discontinuity_drill/progress.txt** to remove the `G5plus_COMPLETE` line so v1's `run_sub G5plus` does not skip. Backup retained at `progress.txt.v2hollow.backup`.
3. **Did NOT touch G1_5_disambiguator** — v1 master is actively running it (cell PID 16194, dm3_runner currently on s16_r1). v1 will overwrite outcome.json + write its own COMPLETE token at end. Self-resolves.
4. **Armed `post_chain_g4_launcher.sh`** (device-side, nohup PID 28711) — polls for `PHASE_G_CHAIN_COMPLETE` in master log; when detected, manually invokes `g4_basin_learning_coupling.sh` because v1's `elapsed_hours <30h` gate will SKIP G.4 organically (chain has been running ~22h, by G.4's slot it'll be ~50h+).

---

## Receipts and audit trail

- **All v1 receipts intact**: G.0 (PASS, real), G.0.5 (PASS, σ″ baseline N=10/10 bit-exact), G.6 (PASS), G.1 (PASS, ~24 receipts), G.1.5 (in flight, 16/24 receipts so far)
- **No real receipts polluted**: v2's per-run dm3_runner invocations were 100% blocked → 0 receipt files created. Pollution was confined to outcome.json / progress.txt / _COMPLETE tokens at the cell-summary layer.
- **Backups retained on device** at the cell-level for forensic re-examination
- **Master log preserved in full** at `/data/local/tmp/dm3_harness/phase_g_chain.log`
- **Swap watcher log preserved** at `/data/local/tmp/dm3_harness/swap_watcher.log`

---

## Engineering IS-NOT findings (first-class, ledger-class)

### IS-NOT #002.A — "kill -TERM is sufficient to swap a chain master"
The chain master is an Android `sh` process with a long-running cell script child holding the runtime. `kill -TERM` to the master alone, while the cell script is mid-execution, is unreliable in busybox-sh-on-Android. We cannot trust silent-success of the kill.

### IS-NOT #002.B — "the parallel-runner gate is sufficient to prevent chain pollution"
The gate prevents per-run dm3_runner collisions (its actual job — and it did its job perfectly here, 0 receipts polluted). It does NOT prevent a parallel-running chain master from writing hollow cell-level outcomes that an unsuspecting `run_sub` would later honor as "cell complete."

### IS-NOT #002.C — "swap-time atomicity from a polling watcher is achievable on Android sh"
The watcher polled every 3s. The window between v1's `G.1 verdict=PASS` log line and v1's `--- G1_5 ---` invocation is microseconds. Polling cannot close this window. Detection-based swap is fundamentally racy on multi-second polling.

### IS-NOT #002.D — "chain script run_sub's `_COMPLETE` grep is consistent across cells"
TAG-vs-CELL token-format inconsistency (table above) is a latent harness bug. Confirmed today by the v2 incident creating CELL-form pollution on cells where TAG-form was expected.

---

## Hardening recommendations (do BEFORE Phase H or any future autonomous chain)

1. **Replace polling-watcher swap with cooperative handoff**. Idea: master script sources a *next-cell list* from a config file at each loop iteration. Operator updates the config file mid-chain (atomic file-write), master picks up the new list at next iteration. No kill, no race, no parallel masters. Implementation cost: ~30 lines of shell.

2. **Fix `_COMPLETE` token convention**. Two options:
   - (Cheap) Refactor `run_sub`'s grep to match `_COMPLETE` regardless of prefix:  
     `grep -q "_COMPLETE" "$PROG"`  
     This is over-broad — any line with `_COMPLETE` matches. Use `grep -q "${TAG}.*_COMPLETE\|${CELL}_COMPLETE"` for both forms.
   - (Right) Standardize on TAG form across all cell scripts. Audit and fix the 4 cells that use CELL form (G.2, G.3, G.4, G.5). Adds boilerplate but eliminates the inconsistency.

3. **Add chain-level `pidof phase_g_chain` check** at start of each chain master script:
   ```sh
   if pgrep -f "phase_g_chain" | grep -v $$ | head -1 > /dev/null; then
     echo "another chain master alive — abort" >> $LOG; exit 3
   fi
   ```
   Prevents two masters running simultaneously.

4. **Add post-cell verdict sanity check** in master:
   ```sh
   verdict=$(read_verdict $CELL)
   runs=$(grep -oE "runs=[0-9]+" $CELL/progress.txt | tail -1 | sed 's/runs=//')
   if [ "$runs" = "0" ] && [ "$verdict" != "SKIP" ]; then
     echo "ALERT: cell $CELL reported verdict=$verdict on runs=0 — possible blocked-execution" >> $LOG
   fi
   ```
   Detects hollow outcomes; lets the operator catch them in real-time.

5. **Add idempotency lock at swap time**:
   ```sh
   LOCK=/data/local/tmp/dm3_harness/.swap_lock
   if [ -e $LOCK ]; then exit 0; fi
   touch $LOCK
   ```
   Prevents double-swap if both Mac and device watchers fire.

---

## Current state (2026-04-26 16:15 UTC)

| Item | Value |
|---|---|
| v1 master | ALIVE (PID 11731, in G.1.5) |
| dm3_runner | ALIVE (PID 27356, exp_k2_scars --steps 16 r1) |
| G.1.5 progress | 16 receipts (s6/s8/s12/s24 done × 3, mid-s16) |
| Cells cleaned | G.2, G.3, G.4, G.5, G.5+ outcome.json removed; G.5+ progress.txt token-stripped |
| G.4 follow-on | armed (PID 28711, polling for chain complete) |
| Swap watcher | exited cleanly (chain-complete check would also exit) |
| Battery | 21% AC powered (was 68% Discharging at last reconnect; fast-charging now) |
| Airplane | ON |
| Thermal | cpu_worst 44.8°C (well under 70°C ceiling) |

---

## What v1 will do next

1. **G.1.5 finishes** (~2h remaining): s16/s18/s32/s48 × 3 reps each, ~12 dm3_runner invocations × 10 min
2. **G.2 trimodal portability** (~7h, fresh after cleanup): test σ″ shape under 3 cross-config variants
3. **G.5 pre-cliff robustness** (~3h, runs because G.1=PASS): forensic on s49 N=10
4. **G.5+ discontinuity drill** (~3h, runs because we cleaned its token): N=10 at s33/s34
5. **G.7 cliff-class** (~12h, conditional on G.2=PASS): narrow scan around s50
6. **G.3 LEARNS cartography** (~8h): 8-task --steps responsiveness landscape
7. **G.4 SKIPPED organically** (elapsed >30h gate); follow-on launcher takes over
8. **G.4 basin-learning coupling** (~6h via follow-on): probe basin-learning interactions

ETA chain end (everything including follow-on G.4): ~2026-04-27 22:00–23:00 UTC.

---

## Confidence

- **Recovery cleanly applied**: HIGH confidence v1 will run G.2/G.3/G.5/G.5+ legitimately on its current pass.
- **G.4 follow-on**: HIGH confidence the launcher will fire correctly when chain ends. No race risk (chain end is a single explicit event, not a polling window).
- **Science integrity**: HIGH confidence — v2's pollution did not corrupt any real receipt; only cell-summary metadata was affected and has been cleaned.
- **Future repeatability**: LOW confidence in the swap mechanism. Hardening recommendations above need to land before any future chain attempts swap-mid-flight.

—— DM3 orchestrator-engineer (Session 8 takeover), 2026-04-26
