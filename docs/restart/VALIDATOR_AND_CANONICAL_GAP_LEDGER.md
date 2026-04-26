# Validator And Canonical Gap Ledger

Last refreshed: `2026-04-16`

## Purpose

Freeze the live Genesis validator-default gap after the retained
`01.2.3.3` validator probe, without promoting fresh RM10 executability into
source parity or repaired default validation.

This remains a real open gap, but it is not the immediate front-line empirical
gate. The front-line gate is now top-level `F2` entrance-condition
localization before row `cpu_a`.

## Truth Floor

- Mac Genesis remains the only live `source_built` authority lane.
- Historical RM10 Genesis parity remains preserved comparison evidence.
- Fresh RM10 governed work is still executable and receipt-backed.
- Fresh governed RM10 work remains under `canonical_validation_mode=explicit_hash`.
- Explicit-hash success is an interim handling rule, not default-validator
  repair.

## What The Retained Probe Established

The retained validator probe on the historical RM10 parity witness shows:

- default validation exit: `1`
- explicit-hash validation exit: `0`
- explicit validated tuple: `e894... / 62897...`

The live failure class is therefore no longer “RM10 bundle corruption” in the
general sense. The shortest retained explanation is:

- the live device validator still carries a stale default target or stale
  default-selection rule
- explicit comparison against the historical witness tuple still works

This localizes the engineering problem to device-side default handling, not to
the existence of the retained witness bundle itself.

## Canonical Surfaces And Their Status

| Surface | `verify.json` | `solve_h2.json` | Status here | What it may support | What it may not support |
| --- | --- | --- | --- | --- | --- |
| documented Genesis recovery canonical | `97bd...` | `62897...` in recovery source pins | `stale_documented_target` | proof that an older documented target exists and is still influencing the live device binary | automatic trust as the present default target |
| live Mac Genesis `G-01` / `G-02` | `e894...` | `62897...` | `authoritative_live_observable` | source-built witness-floor baseline | proof that the device default validator is already repaired |
| historical RM10 Genesis parity witness | `e894...` | `62897...` | `retained_parity_witness` | proof that a clean RM10 parity witness exists and still validates under explicit hashes | proof that the current default validator is correct |
| fresh RM10 SoC runtime `F1` | `f992...` | `a33...` | `lane_local_comparable_only` | current branch-local governed executability under explicit hashes | source parity, default-validator parity, or new canonical promotion |
| fresh RM10 raw workspace | `3929...` | `45d0...` | `lane_local_comparable_only` | current raw-workspace executability under explicit hashes | Mac parity, source-built parity, or canonical promotion |

## Remaining Unresolved Gaps

1. Which exact default target or selection rule is embedded in the live device
   validator now?
2. Should the live Mac tuple replace that target, or does the device validator
   need a deeper rule repair beyond the baked-in hash?
3. What principled rule, if any, would justify promoting either fresh RM10
   lane-local tuple into a new canonical target?

## Bottom Line

The validator gap is still open, but it is now localized.

What is proven:

- live Mac authority
- historical RM10 parity as preserved comparison evidence
- fresh RM10 governed executability under explicit-hash handling
- stale device-side default validation on the live validator path

What is not proven:

- repaired default Genesis validation on the current device
- present-tense RM10 default-validator parity
- source-built parity for any fresh RM10 lane
