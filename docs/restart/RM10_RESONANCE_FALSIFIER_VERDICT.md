# RM10 Resonance Falsifier Verdict

Last refreshed: `2026-04-06`

## Strongest Surviving Story To Attack

The strongest surviving story after Plans 02 through 05 is not a chamber
science win. It is the narrower claim that:

- the same top-level chamber family can survive a minimal two-window packet
- the same family collapses at four windows
- the difference is not obviously thermal

## Attack Results

### Stale-path attack

Result: `survived`

Why:

- Plan 02 and Plan 03 used the same binary path: `/data/local/tmp/dm3_runner`
- both used the same `cwd`: `/data/local/tmp`
- both used the same controller family and cleanup discipline
- neither packet fell back to the legacy `/data/local/tmp/dm3/dm3_runner`

### Output-root and logging illusion attack

Result: `survived`

Why:

- the packets used unique row-local output paths
- Plan 02 retained real pulled receipts with non-empty tuples
- Plan 03 retained missing or zero-byte receipts
- that difference lives in retained outputs, not only in prose or logging

### Thermal-confound attack

Result: `survived`

Why:

- Plan 03 thermal status stayed `0`
- battery temperature stayed `33.0 C`
- AC power stayed `true`

The retained packet does not support a simple thermal threshold explanation.

### Residue-substitution attack

Result: `survived`

Why:

- both packets used the same top-level binary hash
- the legacy residue family stayed fenced
- the observed boundary is inside one preserved family, not between families

### Speed-only attack

Result: `collapses` for the positive chamber-effect story

Why:

- Plan 03 never preserved comparable tuples on the widened packet
- no honest `weak effect` or `structured effect` claim survived

So the exciting story collapses.
Only the narrow environment-boundary story survives.

## Falsifier Verdict

Final falsifier verdict:

- positive chamber-science story: `collapses`
- narrow environment-boundary story: `survives`

The surviving line is engineering, not science.
