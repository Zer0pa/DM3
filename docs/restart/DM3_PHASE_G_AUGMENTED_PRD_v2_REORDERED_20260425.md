# DM3 Phase G — Augmented PRD v2 (reordered for upside-first discipline)

Written: `2026-04-25` ~21:30 UTC (23:30 SAST)
Operator authorization: carte blanche issued 2026-04-25 ~21:20 UTC (`Want to change the order of items in the sequence or adapt anything go ahead. Higher value, anything with inordinate potential upside should be earlier in sequence if it does not mess up any sequential logic`).

This doc supersedes the run order in `DM3_PHASE_G_AUGMENTED_PRD_20260425.md` §3. All other content from v1 (augmentations G.0.5/G.1.5/G.5+, deferred G.8–G.11, framing §8/§9) carries forward unchanged.

---

## 1. What changed and why

### 1.1 Hard dependencies preserved
After reading every upcoming cell script, only two hard inter-cell dependencies exist (verified by `grep`):

- `g7_cliff_class_characterization.sh` reads `cells/G2_trimodal_portability/outcome.json` → **G.7 must follow G.2**
- `g5_pre_cliff_robustness.sh` reads `cells/G1_cycle_probe/outcome.json` → **G.5 must follow G.1**

All other cells (G.0.5, G.6, G.1, G.1.5, G.2, G.3, G.4, G.5+) are self-contained and freely reorderable.

### 1.2 Upside ranking
| Tier | Cell | Why |
|---|---|---|
| **S** | G.2 trimodal portability | σ″ universal vs geometry-locked. Both answers reframe DM3. |
| **S** | G.4 basin-learning coupling | First test of cross-task structure. PASS = unified-field-claim opens. |
| **A** | G.7 cliff-class characterization | Follows G.2 PASS naturally. Locates cliff in portable space. |
| **A** | G.3 LEARNS cartography | Foundation for all future task-comparative claims. |
| **A** | G.6 path-dependence | PASS = expected (sanity). KILL = bombshell that invalidates σ″. |
| **B** | G.1 cycle probe | Mechanistic — explains σ″'s sawtooth. |
| **B** | G.1.5 cycle disambiguator | Same. |
| **B** | G.5 pre-cliff robustness | Forensic confirmation, N=3 → N=10. |
| **B** | G.5+ discontinuity drill | Same, for s33→s34 cliff. |

### 1.3 Failure-mode arithmetic
The chain has been running 3h with one cell partial (G.0.5 6/10). Real-world failure modes that could end the chain mid-flight:
- battery outage (operator unplugs phone for >12h with low charge)
- thermal cascade (sustained ambient + workload)
- ADB daemon death (recoverable but during a fragile window could kill master)
- silent binary corruption (would trip per-run hash gate, abort cleanly)

Ranking by upside-preserved-on-interruption:
- **Original order at hour 25**: G.0.5 + G.6 + G.1 + G.1.5 + G.2 + G.5 + G.5+ → mostly B-rank
- **v2 order at hour 25**: G.0.5 + G.6 + G.2 + G.7(if PASS) → S-rank discovery answer locked

The reordering is robust to interruption.

---

## 2. New chain order (full)

```
G.0      pre-launch gates                   [5 min]   done
G.0.5    determinism recheck                [3 h*]    in flight (was 30 min PRD)
G.6      path-dependence                    [3 h]     KEEP — safety gate
G.2      trimodal portability               [7 h]     PROMOTED — S-rank discovery
G.7      cliff-class characterization       [12 h]    only if G.2 PASS
G.3      LEARNS cartography (8 tasks)       [8 h]     foundation
G.4      basin-learning coupling            [6 h]     PROMOTED + gate widened to <40h
G.1      cycle probe (mult of 7)            [3 h]     mechanism tail
G.1.5    cycle disambiguator (mult 6,8)     [3 h]     mechanism tail
G.5      pre-cliff robustness               [3 h]     only if G.1 PASS, forensic
G.5+     discontinuity drill at s33/s34     [3 h]     forensic tail
         chain final-summary write          [<5 min]
```

\* G.0.5 actual time exceeds PRD budget — exp_k2_scars at --steps 30 takes ~9 min compute + thermal cooldown. Not a problem; chain envelope still valid.

### Cumulative elapsed (assuming G.0.5 closes at 3h actual)

| Cell | Cumulative | Notes |
|---|---|---|
| G.0.5 done | 3h | actual |
| G.6 done | ~6h | safety gate cleared |
| G.2 done | ~13h | **S-rank answer in hand** |
| G.7 done (if G.2 PASS) | ~25h | conditional |
| G.3 done | ~33h | full task landscape |
| G.4 done (gate <40h) | ~39h | basin-coupling answer |
| G.1 done | ~42h | cycle mechanism |
| G.1.5 done | ~45h | cycle disambiguation |
| G.5 done (if G.1 PASS) | ~48h | forensic |
| G.5+ done | ~51h | final |

Upper bound ~51h vs original PRD upper ~50h. +1h. Within tolerance.

If G.2 KILLs (no portability), G.7 skips and the chain rebalances forward by ~12h. Likely close ~38-39h.
If G.1 KILLs, G.5 skips. Saves ~3h.

### Truncation order (revised)

If chain overruns and live truncation needed (which the master script does NOT do automatically — operator-only intervention), priority to drop:
1. **G.5+** (engineer augmentation, forensic only)
2. **G.5** (forensic, requires G.1 anyway)
3. **G.1.5** (engineer augmentation)
4. **G.1** (mechanism — leaves σ″'s sawtooth shape unexplained mechanistically but doesn't undermine portability/cartography findings)

Never drops: G.0.5, G.6, G.2, G.7, G.3, G.4 — these carry the discovery weight.

This inverts the original PRD's truncation order, which was conservative (drop G.4 first because it was overflow). With G.4 promoted to firm-tier, dropping forensic-tail is the right move.

---

## 3. Implementation

### 3.1 Cutover mechanism
The running master (`phase_g_chain.sh` PID 11731) holds the chain script in bash's read-buffer (script is 3.8 KB; bash reads in 8 KB chunks → fully buffered). Editing the file in place would NOT affect the running process.

Cutover therefore requires stop-and-relaunch at a clean cell boundary:

1. Wait for G.6 to complete (master logs `G.6 verdict=PASS|KILL`).
2. The window between G.6 verdict-log and G.1 invocation is microseconds (no sleep, no thermal-wait between cells in master). To handle the race, a host-side watcher script polls the chain log every 3s and triggers the swap on detection.
3. Swap = `kill -TERM <master_pid>` (master process only — does NOT kill orphan dm3_runner if any). Then `nohup sh phase_g_chain_v2.sh &` under the shell user.
4. v2 chain sees G.0/G.0.5/G.6 already-COMPLETE via existing token discipline, skips, runs G.2 first.

### 3.2 Race-window mitigation
If the watcher misses the boundary and G.1 has already started under the OLD master:
- Option A: kill G.1 mid-flight, launch v2. v2 sees G.1 partial (no `G1_COMPLETE` token), re-runs G.1 from scratch. Fine — G.1 is resume-safe per-replicate. ~3h tax.
- Option B: let G.1 finish under OLD master (3h), then swap before G.1.5 starts. Lost optimization for G.1; G.2/G.7/G.3/G.4 still run earlier under v2 vs original.

Default: Option B. G.1 mid-flight isn't worth killing for 3h savings.

### 3.3 Files
- `phase_g_chain_v2.sh` — host-side authored, will be pushed to `/data/local/tmp/dm3_harness/bin/`
- `resume_phase_g_v2.sh` — idempotent v2 resume
- `swap_to_v2.sh` — host-side cutover trigger (runs on Mac, watches device, executes swap)

### 3.4 Receipts and audit trail
- This doc is the proposal/pre-registration.
- v2 chain script preserves `phase_g_chain.log` (does NOT wipe). All v2 entries timestamped distinctly, prefixed `PHASE_G_CHAIN_V2`.
- At chain close, host pulls every cell's receipts as usual.
- If swap fails and OLD chain continues to completion, that's also a fine outcome — just the original PRD order ran. Document the attempt either way.

---

## 4. What this doc does NOT change

Carries forward unchanged from v1 PRD:
- All four engineer augmentations (G.0.5, G.1.5, G.5+ — already in chain — and the deferred G.8/G.9/G.10/G.11)
- All cell scripts themselves (only the chain master script changes)
- Pass/kill criteria for any cell
- Pre-registered framing (no Δ-Mode / cymatics / morphic-resonance vocabulary)
- KAT canary-per-chain discipline
- Per-run hash gate / thermal gate / pinned-cpu7
- Receipts schema / outcome.json convention
- HF preservation pattern at chain close

---

## 5. Risk register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Watcher misses G.6 boundary, G.1 starts | Medium | Low (Option B handles it) | Poll every 3s; default to Option B |
| Master kill leaves orphan dm3_runner | Low | Low | dm3_runner finishes its run, exits cleanly, init reaps |
| v2 chain script syntax bug | Low | High | v2 is structural copy of v1 with reorder only; sh -n syntax check before push |
| G.4 still skips at 40h | Medium-low | Medium | If skips, document and authorize G.4 standalone follow-up next session |
| Operator wants to revert | Low | Low | Original `phase_g_chain.sh` preserved on device; can relaunch any time |

---

## 6. Pre-flight checks before swap

At G.6 close, before triggering swap:
- [ ] G.6 outcome.json valid JSON, verdict field readable
- [ ] No active dm3_runner process (between cells)
- [ ] phase_g_chain_v2.sh + resume_phase_g_v2.sh present on device, executable
- [ ] `sh -n phase_g_chain_v2.sh` passes
- [ ] Master PID still 11731 (or successor if recovered earlier)
- [ ] `phase_g_chain.log` last entry is `G.6 verdict=...` (not `--- G1 ---` — would mean we missed)
- [ ] Battery >40% or charging
- [ ] Airplane mode still ON

If any check fails, abort swap and let original chain continue.

—— Session 8 engineer-agent (orchestrator-engineer takeover), 2026-04-25
