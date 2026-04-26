# Phase K Pre-Registration

Written: `2026-04-17T01:31:26Z` BEFORE any Phase K run begins.

## Inputs From Earlier Phases

- Phase H: asymmetry=-0.1 → 4/5 HIGH (80%); asymmetry=+0.1 → 1/5 HIGH (20%). Clear sign-flip.
- Phase H: asymmetry=-1.0 → 0/5 HIGH, all deep-LOW (E~69); asymmetry=+1.0 → 1/5 HIGH (E=94.57).
- Phase J: holography E scales linearly with asymmetry (slope ~4.8 E/asym), confirming asymmetry as the primary order parameter.
- Basin thresholds: HIGH = E>82 ∧ Coh<0.82; LOW = E<82 ∧ Coh>0.82.

## Carving Goal

Distinguish whether the asymmetry HIGH→LOW transition is:
1. **Sharp critical point** (first-order phase transition): HIGH rate drops from ≥50% to ≤10% within 0.05 asym width.
2. **Smooth crossover**: HIGH rate decreases monotonically over 0.2-0.4 asym width.
3. **Non-monotone**: HIGH rate oscillates.
4. **Null**: no systematic trend visible (noise-dominated).

## Predictions

Given H data: asym=-0.1 was 80% HIGH, asym=+0.1 was 20% HIGH. The transition zone likely lies between -0.1 and +0.1, specifically around asym=0. The fine grid should resolve this.

If SHARP: a single asym value in [-0.05, 0.05] will show the flip from majority-HIGH to majority-LOW.
If SMOOTH: HIGH rate will decrease gradually across the -0.1 to +0.1 range.

## Kill Criteria

- If the 13-point sweep shows no systematic trend (HIGH rate looks like noise), the "asymmetry as order parameter" claim weakens severely.
- If HIGH rate is constant (flat line), asymmetry is NOT a basin selector in this fine range.

## Executable Plan

All with `--cpu --mode train --task harmonic --steps 5`.

13 asymmetry values from -0.30 to +0.30:
-0.30, -0.20, -0.15, -0.10, -0.05, -0.02, 0.00, 0.02, 0.05, 0.10, 0.15, 0.20, 0.30

Total: 13 runs × 5 eps = 65 episodes, ~3.5 hrs device time.
