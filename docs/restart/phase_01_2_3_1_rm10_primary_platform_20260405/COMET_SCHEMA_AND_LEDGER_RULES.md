# Comet Schema And Ledger Rules

## Purpose

This document defines the branch run-identity contract for all later RM10 work.
It separates run class, claim ceiling, artifact validity, and Comet anchoring
so feasibility work cannot masquerade as serious evidence.

## Canonical Tokens

Use `run_kind` to describe what the run did, and `authority_status` to describe
its ceiling. Do not invent branch-only authority tokens.

- allowed `run_kind`: `setup_probe`, `feasibility_probe`, `serious_run`, `abstain_record`
- allowed `authority_status`: `comparison_only`, `engineering_only`, `feasibility_only`, `governed_non_sovereign`, `abstain`
- allowed `phase_outcome`: `PASS`, `FAIL`, `ABSTAIN`, `BLOCKED`
- allowed `route_outcome`: `PASS`, `FAIL`, `ABSTAIN`, `NOT_APPLICABLE`
- allowed `comet_mode`: `online`, `offline`, `not_applicable`

## Governance Principle

Comet is an anchor, not the artifact of record.
The repo ledger is an index, not a substitute for run artifacts.
Serious work needs both.

The branch rejects:

- `/tmp`-only evidence
- UI-only Comet evidence
- receipt files with no exact command or working directory
- exact command capture with no retained outputs

## Required Manifest Fields

Every run manifest must retain:

- `run_id`, `branch`, `phase`, `plan`, `hypothesis_branch`
- `device_serial`, `device_model`, `device_lane`, `compute_lane`
- `run_kind`, `battery_class`, `battery_family`, `observable_family`
- `authority_status`, `build_class`
- `command_surface`, `command_exact`, `cwd`, `env_manifest_path`, `artifact_root`
- `receipt_expected`, `primary_receipt_path_or_none`
- `stdout_path`, `stderr_path`
- `thermal_pre_path`, `thermal_post_path`
- `battery_pre_path`, `battery_post_path`
- `meminfo_pre_path_or_none`, `meminfo_post_path_or_none`
- `checkpoint_id`, `checkpoint_parent`
- `phase_outcome`, `route_outcome`
- `comet_mode`, `comet_experiment_key_or_none`, `comet_bundle_path_or_none`

## Artifact Validity Rules

### Serious runs

`serious_run` is invalid unless the repo-retained artifact root contains:

- `identity/run_identity.json`
- `identity/command.txt`
- `identity/env.txt`
- `identity/checkpoint_index.json`
- `logs/stdout.txt`
- `logs/stderr.txt`
- `telemetry/`
- either `receipts/` with real files or `identity/no_receipt_expected.txt`

### Feasibility runs

`feasibility_probe` must retain:

- `identity/run_identity.json`
- `identity/command.txt`
- `logs/`
- `telemetry/`
- either real receipts or an explicit statement that the probe was inventory-only

### Abstain records

`abstain_record` must retain:

- `identity/run_identity.json`
- `abstain_reason.txt`
- any blocker reference needed to explain why no run occurred

## Comet Rules

- `comet_mode=online` requires an experiment key plus a repo-retained manifest export
- `comet_mode=offline` requires a retained bundle path and repo mirror
- `comet_mode=not_applicable` is allowed only for `setup_probe` and `abstain_record`
- a `serious_run` is invalid without either an online key or an offline bundle path

## Exact Command And Environment Capture

Every later run must retain:

- the literal command line
- the literal working directory
- the command surface or wrapper used
- the environment manifest actually seen by the process

Do not summarize this in prose only.
Retain the real values.

## Receipt Rules

Receipts are required whenever the executable claims to emit them.

If `receipt_expected=true` and no receipt exists:

- record the absence explicitly
- mark the run `FAIL` or `BLOCKED` as appropriate
- do not narrate the run as a pass

## Comparison Rules

A cross-lane comparison is allowed only when:

1. `observable_family` matches
2. receipt fields needed for comparison match
3. the branch question is unchanged
4. `build_class` differences are declared rather than hidden

If any of those fail, the run may still be useful, but it is not a same-family
comparison.

## Repo Retention Rule

The branch may stage work under `/tmp` or device-local temp paths during a run,
but cited artifacts must be mirrored into the repo before they are referenced
in pack documents.

## Bottom Line

If a later executor cannot tell exactly what ran, where it ran, what it
produced, how it was checkpointed, what ceiling it claimed, and where its Comet
anchor lives, then the run does not count as interpretable branch evidence.
