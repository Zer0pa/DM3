# Phase L Pre-Registration

Written: `2026-04-17T05:17:06Z` BEFORE any Phase L run begins.

## Inputs

- Phase H: rot=120 gave 0/5 HIGH, rot=60 gave 1/5 HIGH, rot=0 gave 2/5 HIGH. Rotation effect is weak and possibly suppressive.
- Phase K: asymmetry within [-0.3, +0.3] does NOT systematically control basin selection (noise-dominated). Basin positions shift monotonically.
- Combined: both rotation and fine-scale asymmetry are weak. The coupling question becomes: does combining them produce anything nonlinear that neither alone produces?

## Carving Goal

Determine whether rotation and asymmetry are independent control axes or coupled through the symmetry structure.

## Predictions

Given Phase H and K results showing both parameters are weak within the tested range, the most likely outcome is:

- **Independent (null)**: each 3×3 cell looks like its corresponding asym-only row. Rotation adds nothing.
- **Coupled**: rotation×asymmetry combinations produce HIGH rates significantly different from either parameter alone.
- **Rotation dominates**: rotation erases asymmetry's effect.
- **Asymmetry dominates**: asymmetry erases rotation's effect.

Prior: independent/null is most likely given the weak individual effects.

## Kill Criteria

- If all 9 cells are indistinguishable from their asym-only controls from Phase K, rotation has NO coupling effect and the finding is negative.

## Executable Plan

3×3 grid: rotation ∈ {0, 60, 120} × asymmetry ∈ {-0.5, 0.0, +0.5}, all with `--cpu --mode train --task harmonic --steps 5`.

9 runs × 5 eps = 45 episodes, ~2.4 hrs device time.
