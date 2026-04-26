# RM10 Width-Boundary Falsifier Ledger

Last refreshed: `2026-04-15`

## Purpose

Attack the repaired four-row replay against the simplest collapse or illusion
stories before promoting any next move.

## Attack Lines

### 1. Wrapper-Ceiling As The Sole Explanation

Verdict: `not proven`

Evidence:

- the repaired `cpu_b` row completed under the stronger envelope
- but its retained internal duration was `154554 ms`, which is below the old
  `180`-second timeout ceiling

Interpretation:

- the stronger envelope repaired the packet
- the retained evidence does not prove that the old hard timeout alone caused
  the earlier failure

### 2. Late-Session Hang

Verdict: `rejected for this packet`

Evidence:

- the exact four-row replay reached and completed `cpu_b`
- `cpu_b` retained a real receipt and exited `0`

Interpretation:

- a hard unavoidable closing-row hang is no longer the active explanation on
  this environment envelope

### 3. Stale-Path Substitution

Verdict: `rejected`

Evidence:

- the retained manifest names `/data/local/tmp/dm3_runner` as the binary under
  test
- the recorded top-level binary sha256 is
  `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- the legacy `/data/local/tmp/dm3/dm3_runner` hash was recorded separately and
  not used

### 4. Receipt Corruption

Verdict: `rejected for this packet`

Evidence:

- all four rows produced retained non-empty receipts
- all four rows have distinct receipt sha256 values

### 5. Thermal Emergency

Verdict: `rejected as the primary story`

Evidence:

- thermal status stayed `0`
- battery temperature ranged only from `24.0 C` to `26.0 C`

Important caveat:

- this packet ran materially cooler than the older widened packet that sat at
  `33.0 C`
- so a broader environment-sensitivity story is still live even though a
  thermal alarm story is not

## Strongest Surviving Uncertainty

The repaired packet is real, but the repair mechanism is not yet localized.

The surviving uncertainty is:

- did the stronger envelope repair the packet because of timeout headroom,
  cooler ambient conditions, or another environment factor that has not yet
  been isolated?

## Falsifier Verdict

The old hard closing-row failure is falsified as an active invariant.

What survives is narrower:

- one repaired same-family packet
- one unresolved repair mechanism
- one surviving `gpu_a` outlier pattern that still needs a reproducibility
  check
