# Phase H Pre-Registration

Written: `2026-04-16T14:35:44Z` BEFORE any Phase H run begins.

## Carving Goal

Remove the possibility that Session 3's main findings are 2-episode noise.

## Predictions (expected outcomes at N=5)

- **H2 kill replication**: HAM (layernorm=false) HIGH rate ≤ 30%, LN (layernorm=true) HIGH rate ≥ 50%. If these don't hold, the H2 kill is weaker than stated.
- **Asymmetry order parameter**: at asym=-1.0, all 5 episodes have E < 74 & Coh > 0.85 (deep-low cluster); at asym=+1.0, at least one episode has E > 90.
- **Rotation differentiation**: rot=120° HIGH rate significantly different from at least one of {60°, 0°}.
- **freq=1.0 robustness**: HIGH rate ≥ 80% (5/5 or 4/5).
- **Holography cluster**: all 5 runs stay in E=12-18, Coh=0.70-0.76 Retry cluster (no basin-switching).
- **Truth sensor bias**: HIGH rate ≤ 20% overall across 10 episodes (2 configs × 5).

## Kill Criteria

- If HAM HIGH rate ≥ 50% at N=5, REOPEN H2 and note confusion.
- If asym=-1.0 gives any episode with E > 82, the order-parameter claim softens.
- If rot=120 HIGH rate is indistinguishable from rot=0 at N=5, H6/H8 soften.
- If freq=1.0 HIGH rate < 60% at N=5, H3's strongest claim dies.
- If holography shows ANY basin-switching at N=5, "monostable third attractor" dies.
- If asym=-0.1 gives LOW majority at N=5, the prior "HIGH at asym=-0.1" claim softens.

## Basin Classification Thresholds (locked from Session 3)

- HIGH: E > 82 AND Coh < 0.82
- LOW: E < 82 AND Coh > 0.82
- OTHER: anything outside either box — reported as OTHER, NOT forced into HIGH/LOW
- For holography: Retry cluster = E in [12, 18] AND Coh in [0.70, 0.76]

## Execution Plan (14 runs × 5 episodes)

| Run | Config | Purpose |
|-----|--------|---------|
| H.1 | `--use-layernorm false` | HAM (H2 replay) |
| H.2 | `--use-layernorm true` | LN control |
| H.3 | `--asymmetry=-1.0` | deep-low replay |
| H.4 | `--asymmetry=-0.1` | HIGH boundary replay |
| H.5 | `--asymmetry=0.1` | mixed boundary replay |
| H.6 | `--asymmetry=1.0` | elevated/split replay |
| H.7 | `--rotation 120` | C3 replay |
| H.8 | `--rotation 60` | non-gen replay |
| H.9 | `--rotation 0` | zero-point |
| H.10 | `--freq 1.0` | freq=1.0 lock replay |
| H.11 | `--freq 0.033` | freq low replay |
| H.12 | `--task holography` | holography cluster replay |
| H.13 | `--enable-truth-sensor` | truth sensor default |
| H.14 | `--enable-truth-sensor --sensor-threshold 0.1 --sensor-strength 0.9` | truth sensor strong |

All with `--cpu --mode train --task harmonic --steps 5` unless specified otherwise.

## Outputs

- `H.N.jsonl` per run (5 JSONL episodes)
- `log.txt` (cumulative stdout)
- `phase_H_summary.json` (basin counts + kill-criterion evaluation)
