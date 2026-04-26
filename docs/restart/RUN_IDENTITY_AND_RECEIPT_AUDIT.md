# Run Identity And Receipt Audit

Last refreshed: `2026-04-05`

## Scope

This audit governs the next cited RM10 branch executions on
`hypothesis/rm10-primary-platform-heterogeneous-learning`.

It does not widen authority:

- `F1` governed Genesis CPU control is the only branch-local scientific instrument.
- the live governed accelerator bridge on `F1` is closed.
- `F2` is residue classification work only.
- NPU and explicit heterogeneous work remain `ABSTAIN`.

## Evidence Base

This note is grounded in the current retained evidence:

- `artifacts/phase_01_2_3_2_f1_anchor_20260405/`
- `artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/`
- `artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/`
- `docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/COMET_SCHEMA_AND_LEDGER_RULES.md`
- `docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/THERMAL_AND_CHECKPOINT_POLICY.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/RM10_F1_ANCHOR_DOSSIER.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/F2_HARMONIC_STABILITY_DOSSIER.md`

The `01.2.3` serious archaeology packet proves that fuller checkpoint and
Comet retention is already achievable on this branch. The `01.2.3.2` artifacts
therefore have to be judged against an existing branch precedent, not against
wishful future infrastructure.

## Enforceable Now

### 1. Run class and ceiling must be declared before launch

- The next governed `F1` execution must be `run_kind=serious_run`,
  `authority_status=governed_non_sovereign`, and `build_class=prebuilt_stub`.
- The next residue `F2` outlier-localization pass may remain
  `run_kind=feasibility_probe`, but it must carry the same identity packet
  discipline as a serious run because it is the only justified accelerator
  diagnostic before the next brief.
- CPU, GPU-backed, NPU, and explicit heterogeneous legs never share one
  `run_id`. Every lane change starts a new `run_id`.

### 2. Every cited run must retain one complete identity packet

Before any result is cited, the repo artifact root must contain:

- `identity/run_identity.json`
- `identity/command.txt`
- `identity/env.txt`
- `identity/device_props.txt`
- `identity/checkpoint_index.json`
- `identity/checkpoint_policy.txt`
- `logs/stdout.txt`
- `logs/stderr.txt`
- `telemetry/battery_pre.txt`
- `telemetry/battery_post.txt`
- `telemetry/thermal_pre.txt`
- `telemetry/thermal_post.txt`

For `serious_run` and any cross-lane `F2` diagnostic, also retain:

- `telemetry/meminfo_pre.txt`
- `telemetry/meminfo_post.txt`

`run_identity.json` must at minimum declare:

- `run_id`, `branch`, `phase`, `plan`, `hypothesis_branch`
- `run_kind`, `authority_status`, `build_class`
- `observable_family`, `battery_family`, `battery_class`
- `device_lane`, `compute_lane`, `machine_class`
- `command_surface`, `command_exact`, `cwd`, `artifact_root`
- `device_serial`, `device_model`
- `binary_path`, `binary_sha256`
- asset hashes when residue assets are used
- `receipt_expected`, `primary_receipt_path_or_none`
- `checkpoint_id`, `checkpoint_parent`
- `phase_outcome`, `route_outcome`

### 3. Receipt completeness is a gate, not a suggestion

- `F1` work is invalid if the mirrored device tree does not retain the emitted
  governed receipts under the repo artifact root.
- `F2` work is invalid if the JSONL receipt, the lane marker in stdout, the
  binary hash, and the telemetry packet cannot all be tied to the same `run_id`.
- If `receipt_expected=true` and the receipt is missing, the run must close as
  `FAIL` or `BLOCKED`. It does not get narrated as a pass.
- `/tmp` or device-local-only outputs do not count as branch evidence until the
  repo mirror is complete.

### 4. Comparison packets need explicit linkage

- A multi-run `F2` compare needs one phase-root comparison index that lists
  every included `run_id`, lane, receipt path, metric path, and branch question.
- A later operator must be able to tell which runs belong to one comparison
  family without reconstructing that grouping from filename prefixes alone.

## Not Yet Enforceable

These are not current branch requirements because the evidence surface does not
support them yet:

- RM10 `source_built` parity
- a receiptable NPU assist path
- explicit heterogeneous role-partition claims on any common observable family

Already closed on current evidence:

- the live governed accelerator bridge on `F1` is closed

Those remaining items are blockers or abstains, not missing paperwork.

## Current Audit

| Surface | What is present now | What is missing now | Trust consequence |
| --- | --- | --- | --- |
| `F1` anchor `artifacts/phase_01_2_3_2_f1_anchor_20260405/` | `identity/run_identity.json`, exact command, env capture, device props, binary hash, mirrored governed receipts, battery and thermal pre/post captures | no `identity/checkpoint_index.json`; no `identity/checkpoint_policy.txt`; current `run_identity.json` omits `phase`, `plan`, `run_kind`, `command_surface`, `receipt_expected`, `primary_receipt_path_or_none`, and checkpoint IDs | scientifically `PASS` as the governed anchor, but not yet a fully hardened next-brief serious-run packet |
| `F2` repeat family `artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/` | per-run commands, stdout and stderr, JSONL receipts, pre/post battery and thermal captures, binary and asset hashes, per-run metrics | no per-run `run_identity.json`; no `env.txt`; no `device_props.txt`; no meminfo capture; no checkpoint files; no phase-root comparison index | scientifically `PASS` at callable ceiling with `unstable_feasibility`, but not yet enough to localize future drift cleanly across machines or resumes |
| `01.2.3` serious archaeology packet `artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/` | `run_identity.json`, `checkpoint_index.json`, `checkpoint_policy.txt`, `resume_events.jsonl`, Comet key and offline bundle, command capture | already complete enough to serve as a branch precedent | proves the missing `01.2.3.2` controls are enforceable now, not aspirational |

## Highest-Priority Gaps

1. The next cited `F2` diagnostic would be untrustworthy without a per-run
   identity packet and a phase-root comparison index. The current four-run
   matrix preserves receipts, but not the ledger needed to localize a future
   outlier to lane, environment, or resume boundary.
2. The next cited `F1` serious run would be untrustworthy without checkpoint
   identity. The branch currently has a clean governed anchor, but not the
   checkpoint file set that proves what was resumed, rerun, or carried forward.
3. Any future lane transition without a new `run_id`, explicit receipt
   expectation, and mirrored artifacts would collapse back into convenience
   theater and cannot support the next brief.
