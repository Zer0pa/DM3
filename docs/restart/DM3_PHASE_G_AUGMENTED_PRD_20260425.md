# DM3 Phase G — Augmented PRD (engineer pass over orchestrator brief)

Written: `2026-04-25` ~18:30 UTC (20:30 SAST)
Operator authorization: orchestrator brief 2026-04-25 (this doc augments, does not supersede)
Chain status: **LIVE** under nohup, launched 18:25:54 UTC, G.0 PASSED, G.0.5 in flight

---

## What this doc is

The orchestrator's Phase G PRD (2026-04-25) is the authoritative scope. This doc records three engineer-augmentations the orchestrator authorized ("U may augment and refine"), plus one set of deferred-but-flagged ideas the engineer-agent recommends for later sessions.

All augmentations are **inserted into the chain**, not bolted on. Run order documented in §3 below.

---

## 1. Engineer augmentations to the orchestrator's chain

### G.0.5 — Pre-chain determinism re-check (NEW)
**Insertion point**: between G.0 pre-launch and G.6 path-dependence.
**Cost**: ~30 min device time (10 runs).
**Why**: Before committing to a 30-hour chain that depends on σ″ baseline values, verify those values still hold. N=5 at s30 (1.644524) and N=5 at s33 (1.873756). If either drifts, abort the chain before the long sub-phases burn budget.

**Pass**: 5/5 at s30 = 1.644524 AND 5/5 at s33 = 1.873756.
**Kill**: any value differs at any decimal place. Chain aborts with a clear escalation event.

This is cheap insurance against silent-binary-corruption / silent-input-corruption / clock-skew-induced anomalies that would invalidate the σ″-based hypotheses driving G.1, G.2, G.5, G.7.

### G.1.5 — Cycle-length disambiguator (NEW)
**Insertion point**: directly after G.1 cycle probe.
**Cost**: ~3 hours device time (24 runs).
**Why**: G.1 tests multiples of 7 specifically. If the actual internal cycle is 6 or 8 steps long (the nominal estimate is "~6–8"), G.1 will FAIL even though the cycle hypothesis is correct (just off by one). G.1.5 disambiguates by sampling multiples of 6 and 8 alongside G.1's 7s.

**Sweep**: `--steps ∈ {6, 8, 12, 16, 18, 24, 32, 48}`, N=3 each = 24 runs. Multiples of 6 (6, 12, 18, 24) and multiples of 8 (8, 16, 32, 48) overlap at 24 and 48 — 24 unique step values total.
**Verdict**: PARTIAL by design (operator interprets). Mean amplitude per cycle hypothesis vs G.1's mult-7 result distinguishes which cycle length actually generates σ″'s sawtooth.

### G.5+ — Discontinuity drill at s33→s34 (NEW)
**Insertion point**: between G.5 (conditional) and G.7 (conditional).
**Cost**: ~3 hours device time (20 runs).
**Why**: σ″'s most striking feature is the **0.503 single-step drop from s33 (1.873756) to s34 (1.370651)**. A.6a tested N=3 at each. G.5+ raises this to N=10 at each — total N=20 — to nail down whether the cliff is bit-stable under high-replication or has any sub-step structure that could appear at higher N.

**Pass**: 10/10 at s33 = 1.873756 AND 10/10 at s34 = 1.370651. Drop is bit-stable.
**Kill**: any divergence — would suggest sub-step or replicate-time-dependent instability that A.6a missed.

This is *not* a sub-step probe (that would need fractional `--steps`, which the binary doesn't accept). It's a high-replication confirmation that the integer-step drop is structurally clean.

### Per-cell KAT discipline (clarification, not new)
The orchestrator's G.0 calls KAT at chain start. The harness already runs binary-hash-gate + thermal-gate per-run via `run_cell.sh`. KAT is per-chain, not per-cell. For a 30+ hour chain, this is acceptable — the binary's SHA is verified at every invocation by `run_cell.sh`'s gate-1 check, which is the strongest integrity check available.

---

## 2. Deferred — flagged for post-Phase-G consideration

The engineer-agent identified these but did NOT add them to this chain. They warrant operator authorization in a follow-on:

### G.8 — Flag-axis probe on `exp_k2_scars` at peak (~5h)
The DM3 binary exposes `--asymmetry, --rotation, --angle, --use-layernorm, --freq, --gated, --enable-truth-sensor` flags that are **completely unprobed for `exp_k2_scars`**. From the original H1 hypothesis (`MULTI_HYPOTHESIS_LONG_HORIZON_PRD`), `--asymmetry` should bias basin selection. If any flag shifts the trimodal peak's location or amplitude, that's a major finding — the σ″ shape would be a default-flag-coupled phenomenon, not algorithm-intrinsic.

Suggested test at the s33 primary peak: sweep `--asymmetry ∈ {-0.5, 0.0, 0.5}`, `--rotation ∈ {0, 60, 120}`, `--use-layernorm ∈ {true, false}`. ~9 conditions × N=3 ≈ 27 runs.

### G.9 — Secondary-flag probe on decorative tasks (~3h)
`resonance_r3` and `resonance_v2` are `--steps`-decorative per Session 7 ν and Session 8 φ. But they expose `--freq`, `--gated`, `--rotation` — which might be where their semantics actually live. If `--freq` produces canonical-SHA divergence on these tasks, φ as written needs scoping ("`--steps`-decorative, but other flags responsive").

Suggested: each of `resonance_r3, resonance_v2` × 2 settings of `--freq` × N=3.

### G.10 — `--soak` semantics probe (~2h)
The `--soak <N>` flag is documented in `--help` as "Run soak test for N steps" but is **completely unprobed**. Could be an alternate cycle-driver, or an entirely different execution mode. Two invocations (`--soak 100`, `--soak 1000`) would scope what it is.

### G.11 — Long-time-scale determinism (~30 min) [requires fresh-day window]
ξ is verified across hours/days within Session 8. Verifying it across **weeks** (re-run `exp_k2_scars --steps 20` at the next session) extends ξ to time-scale invariance. Trivial cost — should be the first cell of any future session.

---

## 3. Final chain order (with engineer augmentations inserted)

```
G.0    pre-launch gates                      [5 min  | always]
G.0.5  determinism recheck (NEW)              [30 min | always]
G.6    path-dependence                       [2 h    | always]
       └─ G.6 reverse-confirm                 [+2 h   | only if G.6 KILL]
G.1    cycle probe (multiples of 7)          [3 h    | always]
G.1.5  cycle disambiguator (NEW, mult 6,8)    [3 h    | always]
G.2    trimodal portability                  [7 h    | always]
G.5    pre-cliff robustness                  [3 h    | only if G.1 PASS]
G.5+   discontinuity drill at s33/34 (NEW)    [3 h    | always]
G.7    cliff-class characterization          [12 h   | only if G.2 PASS]
G.3    LEARNS cartography (8 tasks)          [8 h    | always]
G.4    basin-learning coupling               [6 h    | only if elapsed <30h]
       chain final-summary write             [<5 min | always]
```

**Always-runs total**: ~26h
**Lower bound (no conditionals)**: ~26h (G.5/G.7/G.4 all skip)
**Upper bound (all conditionals + reverse-confirm + overflow)**: ~50h

The orchestrator's PRD said 24–42h. Engineer additions (G.0.5 + G.1.5 + G.5+) add +6.5h to the lower bound and +6.5h to the upper bound. Within budget tolerance — operator authorized "see what we have not seen as we pursue scientific discovery."

---

## 4. Truncation order (if the chain overruns)

Per the orchestrator's PRD plus engineer augmentations, the truncation priority on overrun is:

1. **G.4 drops first** (overflow tier, single-claim test).
2. **G.7 drops next** (12h conditional, large block).
3. **G.5+ drops next** (engineer augmentation, sharpens but doesn't open new lanes).
4. **G.3 partial** (drop tail tasks one at a time).
5. **G.5 drops** (engineer augmentation prerequisite-coupled).
6. **G.1.5 drops** (engineer augmentation, distinct from G.1).

**Never drops**: G.0, G.0.5, G.6, G.1, G.2 — these are the always-runs that settle the three open questions.

The chain script's runtime check `elapsed_hours()` is consulted only for G.4 (overflow). All other cells run to completion or skip-on-precondition. There's no live truncation logic — by design, on overrun, the chain simply runs past its budget. The orchestrator's "if it runs beyond, fine" stance applies.

---

## 5. Auto-follow-on conditional logic

`phase_g_chain.sh` parses `outcome.json` per cell and reads the verdict field:

```
G.6 verdict=PASS      → continue                 (no reverse-confirm)
G.6 verdict=KILL      → run G.6 reverse-confirm  (operator escalation point)
G.1 verdict=PASS      → enable G.5
G.1 verdict=KILL      → skip G.5
G.2 verdict=PASS      → enable G.7
G.2 verdict=KILL      → skip G.7
G.4 elapsed >= 30h    → skip G.4
```

Each cell writes a `cells/<CELL>/outcome.json` at close. Format:
```json
{
  "cell": "<NAME>",
  "verdict": "PASS|KILL|PARTIAL|SKIP",
  "summary": "one-line outcome",
  "metrics": {...},
  "next_actions": ["enable_<X>" | "skip_<X>"]
}
```

The chain script is resume-safe: if it dies mid-cell, `resume_phase_g.sh` relaunches under nohup; `_COMPLETE` tokens prevent already-finished cells from re-running.

---

## 6. What this chain does NOT cover (carried from orchestrator's PRD)

- Mode A scaffold (Phase E — separate workstream)
- Δ-Mode / cymatics / morphic-resonance interpretive vocabulary (framing risk for public claims)
- x86 cross-platform (source-blocked)
- NPU paths (ABSTAIN)
- Sub-step granularity (`--steps` is integer)
- Compute-headroom revisit (confirmed null in Session 8)

Plus engineer-flagged-but-deferred:
- Flag-axis probe (G.8 — strongly recommended for next session)
- Secondary-flag decorative-task probe (G.9)
- `--soak` semantics (G.10)
- Long-time-scale ξ (G.11)

---

## 7. Receipts and preservation

All artifacts under `artifacts/phase_S8_PG_followup_<timestamp>/cells/G{0,1,2,3,4,5,6,7,...}*/` on host after pull. HF preservation triggered at chain close to `Zer0pa/DM3-artifacts` dataset repo.

---

## 8. Pre-registered framing — same as orchestrator

Every G hypothesis predicts a measurable quantity that takes one of two values: DM3 has the property or doesn't. No "Δ-Mode-like behavior" language. No "cymatics signature" language. No "morphic resonance" language.

Confirmations close additional nulls. Falsifications open scoped mechanism questions.

The framework documents gave us hypotheses. The receipts give us answers. Vocabulary transfers only where the predictions check.

---

## 9. Scientific-discovery framing of the augmentations

Each engineer-augmentation extends the orchestrator's plan by closing a *specific scientific blind spot* identified from prior receipt analysis:

| Augmentation | Blind spot it closes |
|---|---|
| **G.0.5** | "Does σ″ baseline still hold today?" — never tested across multi-day gaps. Cheap insurance. |
| **G.1.5** | "What if cycle length is 6 or 8, not 7?" — orchestrator assumed 7 but the data is consistent with 6, 7, or 8. Disambiguates. |
| **G.5+** | "Is the s33→s34 drop bit-stable under high replication, or does it fluctuate at higher N?" — A.6a was N=3, this is N=10. Forensic confidence. |

None of these change the orchestrator's three open questions or the always-runs sub-phases. They sharpen the data the always-runs sub-phases produce.

---

## 10. Launch confirmation

| Item | Status |
|---|---|
| Operator authorization | Orchestrator brief 2026-04-25 + engineer augmentation authorization in same brief |
| Chain script | `phase_g_chain.sh` on device, executable |
| Resume script | `resume_phase_g.sh` on device, executable |
| 13 cell scripts | All on device under `/data/local/tmp/dm3_harness/bin/` |
| G.0 verified | PASS at 18:25:54 UTC 2026-04-25 — battery 44% Charging, airplane ON, hashes OK, KAT OK, thermal OK |
| Chain running | nohup PID 11731 alive, dm3_runner PID 12736 active on G.0.5 first run |
| HF preservation | Zer0pa/DM3-artifacts active; cell dirs will be uploaded at chain close |

Launch time: **2026-04-25 18:25:54 UTC (20:25:54 SAST)**.
Expected close (lower bound): **2026-04-26 ~20:00 UTC**.
Expected close (upper bound): **2026-04-27 ~20:00 UTC** (if all conditionals + overflow fire).

—— Session 8 engineer-agent, 2026-04-25
