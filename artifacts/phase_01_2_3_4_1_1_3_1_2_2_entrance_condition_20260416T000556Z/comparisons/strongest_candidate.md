# Strongest Entrance-Condition Candidate

## Result Classification

**Phase outcome: `entrance_condition_narrowed`**

The entrance condition was not fully localized to one controllable pre-run variable.
Instead, the battery narrowed the field:

### Ruled Out

1. Residual output files in CWD — regime appeared in both clean and dirty states
2. Idle duration alone — 10s and 120s idles produced opposite regimes
3. Thermal state — all runs at 24.0C, thermal status 0, no variation
4. Operator-visible cleanup protocol — deep, shallow, and no-clean all produced both regimes

### Narrowed To

1. **Internal RNG seed interacting with a bistable training landscape** — the binary
   appears to have two basins of attraction for the harmonic task, and the initial
   condition (likely RNG-seeded) determines which basin is reached
2. **Binary/library page cache warmth as a bias** — deep-clean cold after extended
   idle reliably produced LOW (2/2), while runs after recent invocations biased HIGH
   (4/5), suggesting cache state modulates seed timing or initial conditions

### Session-Speed Axis Unresolved

The FAST session (~155s duration) observed only in the original repaired packet was
NOT reproduced in any of the 7 anchors. All durations fell in [194-213s]. The fast
session may require conditions not present in the current test setup or may have been
a transient device state.

## Implication For The Branch

The branch now knows:
1. The regime selector is NOT an operator-controlled environmental variable
2. The regime is most likely seed-dependent and bistable
3. Reliable HIGH-regime entry cannot be guaranteed without either:
   a. Explicit RNG seed control (requires source modification — out of scope)
   b. A warm-up run protocol (run once throwaway, then the second run biases HIGH ~80%)
   c. Multiple runs with per-run classification and discard of undesired regime
4. The FAST session remains unexplained and unreproduced
