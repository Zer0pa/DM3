# Phase P2a — Intra-Session Basin Selection Correlation (draft)

## Hypothesis

H-P2a-independent: Within a multi-episode session, basin selection is
independent across episodes (memoryless). P(ep_k=HIGH | ep_{k-1}=HIGH) =
P(ep_k=HIGH | ep_{k-1}=LOW) = base rate.

H-P2a-lock: Once the first episode enters a basin, subsequent episodes stay
correlated. P(same basin | k and k+1) > 0.5.

H-P2a-drift: Basin rate drifts with episode index (cache warming, thermal,
etc.), so P(HIGH) is not constant over k.

## Experiment

Run `--mode train --task harmonic --cpu --steps 20` (20 episodes in one
session), N=5 sessions. At default params (asym=0).

For each session, record the basin sequence. Compute:
- Marginal P(HIGH), P(LOW), P(OTHER) across all 100 episodes
- Transition matrix: P(basin_k | basin_{k-1})
- Per-index marginal: P(HIGH | k=1), P(HIGH | k=2), ..., P(HIGH | k=20)
- Run-length distribution of same-basin streaks

## Kill Criteria

H-P2a-independent CONFIRMED if:
- Transition matrix rows equal within ±15 percentage points
- No monotone trend in per-index marginal

H-P2a-lock CONFIRMED if:
- P(same | consecutive) > 0.70 AND different from base rate by > 15 pp

H-P2a-drift CONFIRMED if:
- Per-index marginal has monotone trend over ≥10 episodes by >30 pp, OR
- Early-session vs late-session P(HIGH) differ by >20 pp

## Budget

- 20 episodes/session, ~60s each (warm), one session ~20 min (cold+warm mix)
- N=5 sessions = 100 episodes, target 90-150 min total.

## Execution

Detached on-device script that runs 5 sequential training sessions with
--steps 20, pulls each after completion. Between sessions, brief idle (30s)
to allow minor cache cooling but not full cold start.
