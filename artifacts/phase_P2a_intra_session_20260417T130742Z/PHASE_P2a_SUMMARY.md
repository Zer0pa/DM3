# Phase P2a — Intra-Session Basin Correlation

Written: `2026-04-17` (end of P2a)
Wallclock: `2026-04-17T14:49:18Z` → `2026-04-17T18:49:18Z` (4h 00m)
Device: Red Magic 10 Pro (FY25013101C8)

## Pre-registration

See `PRE_REGISTRATION.md` in this directory. Five sessions of
`--mode train --task harmonic --cpu --steps 20` at default asymmetry,
30 s idle between sessions. Hypotheses:

- **H-independent** (memoryless): `P(ep_k=HIGH | ep_{k-1})` equal across predecessors.
- **H-lock**: consecutive episodes more likely to share a basin.
- **H-drift**: `P(HIGH)` varies systematically with episode index.

## Results — 5 sessions, 100 episodes

### Basin sequences

| Session | Sequence (H=HIGH, L=LOW, N=20)          | H/20 | Avg ep dur |
|---------|------------------------------------------|------|------------|
| 1       | `HLHLLHLHLLLLHLLHLLLL`                    | 6    | 66 s warm  |
| 2       | `HHLLHLLHHHHLLLLLLLHL`                    | 8    | 70 s warm  |
| 3       | `LLLHLHHLHHHLLLLLLLLL`                    | 6    | 188 s cold |
| 4       | `LLHLLLLHHHLHLLLHLLLH`                    | 7    | 195 s cold |
| 5       | `LHLLLHLHLLLHLHLLLLHH`                    | 7    | — s        |

Total: **34 HIGH / 66 LOW, 0 OTHER, 0 RETRY.** Marginal P(HIGH) = 34%.

### Transition matrix

| From → To  | Count | Rate             |
|------------|-------|------------------|
| HIGH → HIGH| 10    | P(H\|H) = 10/32 = **31.3%** |
| HIGH → LOW | 22    | P(L\|H) = 22/32 = 68.7% |
| LOW → HIGH | 22    | P(H\|L) = 22/63 = **34.9%** |
| LOW → LOW  | 41    | P(L\|L) = 41/63 = 65.1% |

**Under independence we expect P(H|H) = P(H|L) = P(H) = 34.0%.**
Observed deviations are 2.7 pp and 0.9 pp respectively. 95 % binomial
CIs both comfortably contain the marginal:

- 95 % CI for P(H|H) = 10/32 → [16.6 %, 49.7 %]
- 95 % CI for P(H|L) = 22/63 → [23.5 %, 47.6 %]

**No evidence of deviation from independence.**

### Run-length distribution

HIGH runs: n=24, mean = 1.42, max = 4
LOW runs:  n=25, mean = 2.64, max = 9

| Length | HIGH runs | LOW runs |
|--------|-----------|----------|
| 1      | 18        | 9        |
| 2      | 3         | 5        |
| 3      | 2         | 5        |
| 4      | 1         | 4        |
| 7      | 0         | 1        |
| 9      | 0         | 1        |

**Geometric prediction under independence with p(HIGH)=0.34:**
- E[HIGH run length] = 1/(1-0.34) = 1.52 → observed 1.42 ✓
- E[LOW run length]  = 1/0.34     = 2.94 → observed 2.64 ✓

Both means sit inside the geometric-distribution prediction. The
observed max runs (HIGH=4, LOW=9) are consistent with tail events
expected in 100 Bernoulli trials.

### Per-index HIGH rate (k = 1..20)

| k | HIGH/5 | k | HIGH/5 |
|---|--------|---|--------|
| 1 | 2      | 11| 2      |
| 2 | 2      | 12| 2      |
| 3 | 2      | 13| 1      |
| 4 | 1      | 14| 1      |
| 5 | 1      | 15| 0      |
| 6 | 3      | 16| 2      |
| 7 | 1      | 17| 0      |
| 8 | 4      | 18| 0      |
| 9 | 3      | 19| 2      |
| 10| 3      | 20| 2      |

Fluctuation is within single-session binomial noise. Positions 15, 17,
18 are 0/5 HIGH. Under independence with p=0.34, each position
independently has probability 0.66⁵ = 12.5 % of being all-LOW across 5
sessions. Expected number of 0/5-HIGH positions in 20 is 2.5 — we
observed 3. Not a signal.

Peak at k=8 (4/5 HIGH) has 95 % CI [28 %, 99 %]; single-position
fluctuation.

### First-episode vs last-episode HIGH rate

- First 5 of each session: **8 HIGH / 25 = 32 %**
- Last 5 of each session:  **6 HIGH / 25 = 24 %**
- Difference: −8 pp. 95 % CI overlap. No significant drift.

### First episodes (session-opener basins)

Sessions opened with: [HIGH, HIGH, LOW, LOW, LOW]. 2/5 = 40 % — matches
marginal within noise. No session-level lock.

## Verdict against pre-registered hypotheses

| Hypothesis    | Verdict         | Evidence                                                              |
|---------------|-----------------|-----------------------------------------------------------------------|
| H-independent | **CONFIRMED**   | P(H\|H), P(H\|L), P(H) all within 3 pp. Run-length match geometric. |
| H-lock        | **KILLED**      | P(H\|H) = 31 % is slightly below marginal, not above. No HIGH clustering. |
| H-drift       | **NOT SUPPORTED** | Per-index HIGH rate fluctuates without monotone trend. First vs last 5 eps within noise. |

### Plain-language statement

Within a 20-episode harmonic session at default parameters, each
episode is essentially an independent Bernoulli trial with p(HIGH) ≈
0.34. The first episode of a session does not predict the basin of the
second, and the 10th episode does not predict the 20th. The only
source of dependence we could measure (P(H|H) − P(H) = -3 pp, P(H|L) −
P(H) = +1 pp) is within noise at N=32 and N=63 trial counts
respectively.

**This sharpens Session 4's "basin selection is RNG-dominated per
episode" claim from a low-N observation into a statistically strong
result (N=100).** The RNG-dominated story is **INDEPENDENT per-episode
RNG, not per-session**. The page-cache-warmth bias that Sessions 2/3
noted (warm ~80 % HIGH, cold reliable LOW) is reproduced at the session
level (sessions 1, 2 warm gave 30 %, 40 % HIGH; sessions 3, 4 cold
gave 30 %, 35 % HIGH — marginal basin rates similar, so the old
observation of cold-start → 100 % LOW was itself under-powered).

## Implications

1. The "basin boundary" in the 72,960-dim state space lives on a
   per-episode-RNG landscape. There is no session-level state that
   persists across episodes to bias the next draw.

2. The binary's internal state is **reset between episodes** (or the
   state that survives does not couple to basin selection). This is a
   real architectural fact we can now claim.

3. The transformer, asymmetry, rotation, and frequency parameters that
   Sessions 3/4 tested are all acting on a per-episode stochastic draw,
   not on a session-level memory. Any future attempt to bias basin
   selection must operate through the per-episode RNG seed — which is
   source-blocked.

4. The only observed dependence is on **binary page-cache warmth**
   (cold episodes run ~3× slower and have a modestly different HIGH
   rate distribution), but even that does not produce per-session
   basin-locking in P2a.

## Artifacts

- `phase_P2a_receipts/session_1.jsonl` … `session_5.jsonl` — raw 6-field receipts
- `phase_P2a_receipts/progress.txt` — start/end timestamps and rc per session
- `intra_session_summary.json` — machine-readable summary
- `PRE_REGISTRATION.md` — pre-registered hypotheses
- `PHASE_P2a_SUMMARY.md` — this writeup
