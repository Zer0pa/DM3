# Witness Lane Repair Note

## Purpose

Freeze the Phase `01.2.3` witness-floor comparison contract with explicit
structured lane labels.

This note is subordinate governance support only.
It does not answer the bundled `G2` route question, and it does not promote
fresh RM10 executability into sovereign authority.

## Witness-Floor Lane Table

| Lane | `verify.json` | `solve_h2.json` | `authority_status` | `evidence_surface` | `build_class` | `validator_mode` | Comparison meaning |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Mac Genesis `G-01` / `G-02` | `e8941414a25c7c8e1aed6b3f5c032c00a69e85ae6964555301ff48dee44009e3` | `62897b8c26de3af1a78433807c5607fb8c82f061d1457e9c43e2aa5d35fe7780` | `sovereign` | `witness_floor` | `source_built` | fresh source-built replay is internally stable; the published Genesis `verify.json` canonical remains stale against this live lane | safest current authority lane and baseline for witness-floor comparisons |
| historical RM10 Genesis parity witness | `e8941414a25c7c8e1aed6b3f5c032c00a69e85ae6964555301ff48dee44009e3` | `62897b8c26de3af1a78433807c5607fb8c82f061d1457e9c43e2aa5d35fe7780` | `comparison_only` | `comparison_only` | `not_applicable` | preserved historical parity receipts matched the Mac tuple; the current device default validator now rejects `verify.json` on that historical bundle | proves an RM10 witness floor once matched Mac; does not grant today's phone-local lanes parity |
| fresh RM10 SoC runtime | `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1` | `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364` | `governed_non_sovereign` | `witness_floor` | `prebuilt_stub` | default validator `FAIL`; explicit-hash validation `PASS` on the lane-local tuple | proves current governed phone executability and receipt reproducibility only, not sovereign authority or repaired canonical validation |
| fresh RM10 raw workspace | `39293656dc231540a110c7c3ccea8554de58a2d9f140b9c1873f9d181930c24d` | `45d0560d95fb8acd435630e3decd0ab756dc6bedc922ad9896eea7b3668f319b` | `governed_non_sovereign` | `witness_floor` | `mixed_prebuilt_backed` | default validator `FAIL`; explicit-hash validation `PASS` on the lane-local tuple after reversible Android shebang adaptation | proves current ADB-shell raw-workspace executability only; it is not Mac parity and not source-build proof |

## Interim Validator Rule

The witness floor still uses an explicit-hash interim rule for the fresh RM10
Genesis lanes.

That means:

1. the SoC runtime and raw-workspace lanes keep
   `canonical_validation_mode=explicit_hash` until the canonical target is
   repaired
2. `verify.json` and `solve_h2.json` must be compared as a tuple
3. an explicit-hash pass does not raise `authority_status`
4. historical parity remains `comparison_only`; it is evidence that clean RM10
   parity once existed, not a shortcut around current validator drift

## Non-Witness Surfaces Kept Out Of The Witness Floor

| Surface | `authority_status` | `evidence_surface` | `build_class` | Why it stays out of the witness floor |
| --- | --- | --- | --- | --- |
| root RM10 `dm3_runner` smoke lane | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | useful for smoke callability, receipt capture, and GPU-split falsification only |
| bundled RM10 `dm3/dm3_runner` lane | `archaeology_only` | `archaeology` | `exploratory_compiled_residue` | useful for bundled `G2` router archaeology and blocker proof only |

Those hybrid surfaces remain parallel evidence.
They do not enter Genesis witness-floor sovereignty.

## Evidence Used

- `docs/restart/phase_01_2_3_execution_prep_20260404/RUNBOOK_WITNESS_FLOOR.md`
- `docs/restart/phase_01_2_3_execution_prep_20260404/AUTHORITY_ORDER_MEMO.md`
- `docs/restart/PROJECT_AND_WORKSTREAM_TESTS_SUMMARY_20260404.md`
- `artifacts/mac_replay/ledger.md`
- `artifacts/rm10_replay/ledger.md`
- `docs/restart/RUN_LEDGER_20260403_LONG_HORIZON.md`
- `docs/restart/DOUBLE_MERU_RUNTIME_TRUTH_TABLE.md`

## Bottom Line

The witness floor is now explicit on all active Genesis comparison lanes:

- Mac is the only current `sovereign` lane and the only `source_built` witness
  baseline.
- historical RM10 parity is a `comparison_only` witness, not present-tense
  sovereignty.
- fresh RM10 SoC and raw-workspace lanes are real, receipted,
  `governed_non_sovereign` lanes that still rely on the explicit-hash interim
  rule.
- hybrid residue stays outside the witness floor and remains archaeology-only.
