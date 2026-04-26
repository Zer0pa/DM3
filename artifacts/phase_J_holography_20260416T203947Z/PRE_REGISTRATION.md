# Phase J Pre-Registration

Written: `2026-04-16T20:39:47Z` BEFORE any Phase J run begins.

## Inputs From Earlier Phases

- Phase H: holography default-params gave 5/5 RETRY cluster (E=15.2±0.4, Coh=0.74±0.005).
- Phase I.b: holography at freq∈{0.3, 0.8, 1.0, 1.5, 2.0} all gave 5/5 RETRY. Freq does not move the attractor.
- Basin HIGH (E~88-89) and LOW (E~75) are freq-independent in harmonic task.

## Carving Goal

Distinguish three hypotheses about holography:
1. **Degenerate**: single attractor, insensitive to all parameters (confirms task is a computational dead-end for multi-stability).
2. **Narrowly-bistable**: a second attractor exists but only activates under specific parameter values.
3. **Task-parameterized same-family**: same dynamical family as harmonic, different operating point — parameters move it the way they move harmonic.
4. **Multi-stable**: three or more attractors appear under parameter variation.

## Predictions

- **Degenerate**: all holography runs across asym/rot/freq stay in RETRY cluster (E ≈ 15, Coh ≈ 0.74).
- **Narrowly-bistable**: at least one parameter setting produces a second distinct cluster.
- **Task-parameterized-same-family**: asymmetry shifts E like in harmonic (asym=-1 → deep lower, asym=+1 → elevated upper).
- **Multi-stable**: appearance of HIGH-like basin (E>82) or a third new attractor.

## Kill Criteria

- If all 9+2 (reused from I.b) runs stay in RETRY cluster (E ∈ [12, 20] ∧ Coh ∈ [0.68, 0.78]), holography is **degenerate** and the "task-parameterized-same-family" hypothesis dies.
- If asymmetry shifts holography E in a pattern matching harmonic's asymmetry response (monotonic), holography is **task-parameterized-same-family**.
- If any asym/rot/freq setting exposes an E>82 basin, **multi-stable** and new territory.

## Executable Plan

All with `--cpu --mode train --task holography --steps 5`.

**Asym arm** (5 values × 5 ep = 25 ep):
- asym=-1.0, -0.5, 0.0, 0.5, 1.0

**Rot arm** (3 values × 5 ep = 15 ep):
- rot=0, 60, 120

**Freq arm**: freq=0.5 only (freq=1.0 and freq=2.0 ALREADY COVERED IN PHASE I.b — data reused in summary).

Total new runs: 9. Reused from I.b: 2. Total effective data points: 11 configurations × 5 eps.

## Success Gate

Holography is classified as {degenerate, narrowly-bistable, task-parameterized-same-family, multi-stable}.
