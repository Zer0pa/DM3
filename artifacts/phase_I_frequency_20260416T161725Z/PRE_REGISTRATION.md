# Phase I Pre-Registration

Written: `2026-04-16T16:17:25Z` BEFORE any Phase I run begins.

## Inputs From Phase H

- freq=1.0 gave only 1/5 HIGH (20%) — Session 3's 2/2 (100%) was noise.
- freq=0.033 gave 2/5 HIGH (40%) — higher than freq=1.0.
- The "freq=1.0 is a resonance peak" hypothesis is already dying.
- Per PRD rule: "if freq=1.0's HIGH rate < 60%, skip I.c coupling and demote to shorter I.a only."
- Decision: run full **I.a** (10 freq values × 5 ep harmonic) and **I.b** (5 freq values × 5 ep holography). **SKIP I.c** (coupling) because the peak it would probe isn't confirmed.

## Carving Goal

Remove the ambiguity around `--freq`. Is it a resonance peak, a monotone amplitude, coupling to multiple modes, or a null-effect parameter?

## Predictions

- **Resonance driver**: HIGH rate shows single clean peak at some freq.
- **Amplitude/gain**: HIGH rate monotone in |freq|.
- **Multi-mode coupling**: HIGH rate multi-peaked across the 10 points.
- **Null-effect**: HIGH rate essentially flat across all values (±1 episode noise).

Given Phase H results, the null-effect outcome is now the prior. A weak multi-peaked or noisy result is expected.

## Kill Criteria

- If I.a HIGH rate is flat (std dev < 1.5 episodes across 10 points), `--freq` categorized as **null-effect** and H3 fully dies.
- If a peak appears at a freq value substantially different from 1.0, categorize as resonance with the true peak (not freq=1.0).
- For I.b: if holography shows basin-switching (any non-RETRY episode) at some freq, holography's monostable status is re-opened.

## Executable Plan

All with `--cpu --mode train --steps 5`.

**I.a — Harmonic freq sweep** (10 values × 5 eps):
- 0.1, 0.3, 0.5, 0.8, 1.0, 1.2, 1.5, 2.0, 5.0, 10.0

**I.b — Holography freq subset** (5 values × 5 eps, `--task holography`):
- 0.3, 0.8, 1.0, 1.5, 2.0

**I.c — SKIPPED** (PRD rule triggered by freq=1.0 < 60% at N=5).

Total: 15 runs × ~6 min = ~90 min.

## Success Gate

`--freq` is categorized into one of: {resonance, amplitude, coupling, null-effect}. For I.b, holography's response to freq is classified as {moves, doesn't move}.
