# Hypothesis Verdicts

## H1: Residual output files in CWD select the regime

**Verdict: RULED OUT**

Evidence:
- Anchor D: deep-clean removed ALL .jsonl (0 residuals), yet produced HIGH
- Anchor A: deep-clean removed ALL .jsonl (0 residuals), yet produced LOW
- If residual files controlled the regime, both deep-cleans should produce the same regime

The regime is NOT determined by the presence or absence of prior output files.

## H2: Filesystem page cache / binary warmth selects the regime

**Verdict: STRONGEST CANDIDATE, but not fully proven**

Evidence:
- Anchor A (first run of session, after 120s idle, cold cache): LOW
- Anchor G (after ~8 min gap + 120s idle, cooled cache): LOW
- Anchors B, D, E, F (all after recent runs within minutes, warm cache): HIGH (4/4)
- Anchor C is the exception: LOW despite being 27s after B (warm cache)

The pattern is consistent with binary warmth as a factor, but C breaks the
prediction. Possible explanations for C:
- Very short gap (~27s) may not be enough for some OS scheduling state to settle
- Quasi-random component means cache warmth is a bias, not a deterministic selector

## H3: CPU frequency governor state selects the regime

**Verdict: INCONCLUSIVE, but unlikely as sole factor**

Evidence:
- All runs produced SLOW durations (194-213s), regardless of regime
- The CPU governor should be at similar states for runs only minutes apart
- No FAST session was reproduced, even after long idle

CPU frequency is not excluded as a contributor, but it cannot be the sole regime
selector because HIGH and LOW both occurred at SLOW duration.

## H4: Internal binary mmap or tempfile residue

**Verdict: NOT DIRECTLY TESTABLE without root access**

No hidden temp files were observed in `/data/local/tmp`. This hypothesis requires
checking `/proc/PID/maps` during execution or examining `/tmp` or other system
directories, which was not done in this battery.

## H5: Random initialization seed

**Verdict: MOST LIKELY primary mechanism**

Evidence:
- The binary prints identical startup messages for both regimes
- The same code path ("Entering Resonance Mode (Legacy)") executes regardless
- The delta_E values fall into two sharply separated clusters with no intermediates
- The pattern (LOW=43%, HIGH=57%) is roughly consistent with a binary random variable
- The apparent correlation with cache warmth could be a confound if the RNG seed
  is derived from process startup timing, which varies with page cache state

The most parsimonious explanation: the binary seeds its internal RNG from a
time-dependent source (e.g., current nanosecond timestamp or /dev/urandom), and the
resulting initial condition falls into one of two basins of attraction in the
harmonic training. The probability of each basin may be influenced by binary loading
speed (which depends on page cache state), but the fundamental mechanism is the
interaction between the seed and the dynamical landscape.

## Combined Verdict

The regime is most likely determined by an internal RNG seed that interacts with the
harmonic training landscape to produce two basins. The operator cannot reliably select
the regime through file cleanup, idle duration, or thermal management alone. The
session-speed axis (~155s vs ~200s) observed in the repaired packet was not reproduced
and may have been a one-time artifact of device conditions on 2026-04-15 that are
no longer accessible.
