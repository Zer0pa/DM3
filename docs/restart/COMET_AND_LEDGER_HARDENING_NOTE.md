# Comet And Ledger Hardening Note

Last refreshed: `2026-04-05`

## Scope

Comet is an anchor. The repo artifact ledger is the record.

This note hardens the next governed `F1` run and the next residue `F2`
diagnostic without inflating either ceiling:

- `F1` remains the only governed branch instrument.
- `F2` remains residue classification work.
- NPU and explicit heterogeneous work remain `ABSTAIN`.

## Evidence Base

The branch already contains both a strong precedent and a current regression:

- `artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/`
  retains `identity/comet_manifest.json`,
  `identity/comet_experiment_key.txt`,
  `identity/comet_offline_bundle_path.txt`,
  `identity/comet_logger_stdout.txt`,
  `identity/comet_logger_stderr.txt`,
  `identity/checkpoint_index.json`, and `identity/run_identity.json`.
- `artifacts/phase_01_2_3_2_f1_anchor_20260405/` and
  `artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/` retain no
  branch-local Comet packet.

The tooling already exists at `tools/comet_manifest_logger.py`.
This is a discipline problem, not an infrastructure blocker.

## Enforceable Now

### 1. Logging mode

- Use `comet_mode=offline` by default for RM10 device-side work and any unstable
  network situation.
- Use `comet_mode=online` only when connectivity is stable and the run is not
  secret-constrained.
- `comet_mode=not_applicable` is not allowed for the next cited `F1` run or the
  next cited `F2` diagnostic.

### 2. Required retained Comet packet

Every next cited `F1` or `F2` run must retain all of the following under the
repo artifact root:

- `identity/comet_manifest.json`
- `identity/comet_experiment_key.txt`
- `identity/comet_logger_stdout.txt`
- `identity/comet_logger_stderr.txt`
- `identity/comet_offline_bundle_path.txt` for offline mode

Offline mode additionally requires the actual bundle zip to be mirrored under
the artifact root, not merely referenced in a user home or temp directory.

### 3. Minimum manifest content

The Comet manifest must at least encode these facts:

| Section | Required now |
| --- | --- |
| `tags` | `restart`, `dm3`, current branch, current phase, run family (`f1` or `f2`), `run_kind`, `authority_status`, `build_class`, `machine_class`, `device_lane`, `compute_lane` |
| `parameters` | `run_id`, `phase`, `plan`, `hypothesis_branch`, `observable_family`, `battery_family`, `battery_class`, `command_surface`, `cwd`, `artifact_root`, `device_serial`, `device_model`, `binary_sha256`, `receipt_expected`, `checkpoint_id`, `checkpoint_parent` |
| `metrics` | exit code, receipt-complete flag, thermal nominal pre/post flag, battery pre/post temperature, phase outcome code, route outcome code |
| `others` | path to `command.txt`, path to `run_identity.json`, path to `checkpoint_index.json`, path to the primary receipt, path to telemetry root, repo-relative artifact path, bundle path or experiment URL |

### 4. Ledger precedence

- The Comet UI does not replace repo-retained artifacts.
- The Comet key alone does not replace the offline bundle or the local manifest.
- The repo ledger for a cited run is the combined packet:
  `run_identity.json`, command capture, env capture, telemetry, checkpoint
  files, receipt files, and Comet packet.
- If any one of those is missing, the run may remain useful engineering memory,
  but it is not a hardened branch precedent.

### 5. Relative path rule

Historical packets on this branch preserve some absolute paths under
`/Users/Zer0pa/DM3/restart/...`.
Those remain locally useful, but new packets must also retain a repo-relative
path for every artifact root, primary receipt, and offline Comet bundle so a
different machine or clone can resolve the handoff without oral history.

## Current Regression

| Surface | Current Comet / ledger state | Consequence |
| --- | --- | --- |
| `01.2.3` serious archaeology packet | full offline Comet packet plus checkpoint ledger is retained | branch proves this discipline is achievable now |
| `01.2.3.2` `F1` anchor | no retained Comet manifest, key, logger outputs, or offline bundle path | strong scientific anchor, weak operations precedent |
| `01.2.3.2` `F2` repeat family | no retained Comet packet and no comparison ledger tying four runs into one named question | future outlier-localization would be too easy to narrate without enough audit structure |

## Not Yet Required

These are useful later, but they are not the immediate gate:

- automatic Comet upload after offline capture
- dashboard-level cross-run rollups
- automatic completeness scoring scripts

The next honest requirement is simpler: retain the Comet packet and the repo
ledger every time, with no exceptions for convenience.

## Highest-Priority Gaps

1. Phase `01.2.3.2` set the current scientific floor, but it did not set a
   hardened Comet or ledger precedent. That gap must be closed before the next
   brief cites a new `F1` or `F2` run.
2. The next `F2` diagnostic needs both a per-run Comet packet and a comparison
   ledger, or the branch will not be able to prove whether a future GPU outlier
   belongs to the lane, the environment, or the logging surface.
3. Absolute-path-only Comet references are not a safe handoff contract. New
   packets must include repo-relative paths alongside the captured absolute
   paths.
