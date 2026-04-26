# Anchor Comparison Table

## Full Battery Results

| Anchor | Clean type | Idle | Gap since prev | Residual .jsonl | delta_E | coherence | duration_ms | Regime | Speed |
|--------|-----------|------|---------------|-----------------|---------|-----------|-------------|--------|-------|
| A | deep | 120s | first run | 0 | 75.62 | 0.878 | 200081 | LOW | SLOW |
| B | none | 0s | ~5 min after A | 1 (A output) | 88.41 | 0.770 | 200675 | HIGH | SLOW |
| C | shallow | 0s | ~27s after B | 2 (A+B outputs) | 75.66 | 0.877 | 194242 | LOW | SLOW |
| D | deep | 10s | ~7 min after C | 0 | 89.07 | 0.771 | 200011 | HIGH | SLOW |
| E | none | 0s | ~19 min after D | 1 (D output) | 88.91 | 0.768 | 199407 | HIGH | SLOW |
| F | none | 0s | ~5 min after E | 2 (D+E outputs) | 89.00 | 0.768 | 199000 | HIGH | SLOW |
| G | deep | 120s | ~8 min + 120s after F | 0 | 74.02 | 0.892 | 212839 | LOW | SLOW |

## Regime Distribution

- LOW: 3 of 7 (A, C, G) = 43%
- HIGH: 4 of 7 (B, D, E, F) = 57%

## Duration Observation

ALL anchors fell in the SLOW range (194-213s). None reached the FAST (~155s) range
seen only in the original repaired packet. The session-speed axis was NOT reproduced
in any anchor, regardless of cleanup or idle conditions.

## Regime Clusters

LOW cluster: delta_E range [74.02, 75.66], coherence range [0.877, 0.892], duration range [194242, 212839]
HIGH cluster: delta_E range [88.41, 89.07], coherence range [0.768, 0.771], duration range [199000, 200675]

The two regimes are sharply separated. No intermediate values were observed.

## Cross-Anchor Timing

| Transition | Gap | Prior regime | Next regime |
|-----------|-----|-------------|-------------|
| A → B | ~5 min | LOW | HIGH |
| B → C | ~27s | HIGH | LOW |
| C → D | ~7 min | LOW | HIGH |
| D → E | ~19 min | HIGH | HIGH |
| E → F | ~5 min | HIGH | HIGH |
| F → G | ~8 min + 120s idle | HIGH | LOW |

## Key Observations

1. Deep-clean cold with 120s idle reliably produced LOW (A=LOW, G=LOW, 2/2)
2. After a LOW run, subsequent runs with > 5 min gap produced HIGH (B, D: 2/2)
3. After a HIGH run with > 5 min gap, the regime stayed HIGH (E, F: 2/2)
4. After a HIGH run with very short gap (~27s), the regime reverted to LOW (C: 1/1)
5. Deep-clean with short idle (10s) after recent runs produced HIGH (D: 1/1)
6. All runs were SLOW (~200s). The FAST session (~155s) from the repaired packet was NOT reproduced.
