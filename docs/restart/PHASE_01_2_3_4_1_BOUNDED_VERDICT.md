# Phase 01.2.3.4.1 Bounded Verdict

## What Was Repaired

- The live RM10 validator-default defect is no longer vague. The exact failure
  site is now pinned to the stale compiled `verify` constant inside the device
  `genesis_cli`, while `solve_h2.json` still matches and explicit-hash override
  still passes the retained witness.
- The top-level same-family `F2` defect is no longer vague. The callable root
  family now has one named instability shape: low `cpu_a`, high `gpu_a`, low
  `gpu_b`, then a timed-out `cpu_b` that leaves a zero-byte output path under
  locked identity.
- The branch now has a minimal observable contract, a fresh official rerun
  ledger, and an explicit heterogeneous abstain packet grounded in that rerun
  rather than in older hand-waving.

## What Remains Blocked

- The validator-default rule is still not repaired on-device. Governed `F1`
  work remains honest only under explicit-hash handling until a rebuild or
  operator-policy change replaces the stale compiled `verify` target.
- The top-level same-family `F2` surface still does not preserve one honest
  observable. The GPU rows disagree, the closing CPU anchor is missing, and the
  fresh official packet does not close custody.
- Heterogeneous compute remains `ABSTAIN`. No admissible split can be named
  while the same-family observable fails before the split boundary.

## What One Next Move Is Now Justified

- Run one more locked-identity official same-family CPU/GPU/GPU/CPU replay on
  `/data/local/tmp/dm3_runner` with the same branch, binary, cwd, assets, row
  order, and observable contract, but with a timeout and periodic telemetry
  policy strong enough to decide whether the final `cpu_b` break is a genuine
  late-session hang or only a `180` second wrapper-ceiling artifact. Do not
  reopen heterogeneous work or NPU work before that boundary closes.
