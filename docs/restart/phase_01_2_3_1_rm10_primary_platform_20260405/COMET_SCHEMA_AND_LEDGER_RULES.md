# Comet Schema And Ledger Rules

## Purpose

This document defines the branch run-identity contract for all later RM10 work.

It covers:

- exact run metadata
- Comet key versus offline bundle handling
- repo-retained artifact custody
- receipt and comparison requirements
- the difference between setup probes, feasibility probes, serious runs, and
  abstain records

No later run may count as interpretable branch evidence unless it satisfies this
schema.

## Governance Principle

Comet is an anchor, not the artifact of record.
The repo ledger is an anchor, not a substitute for the real run artifacts.
Both are required for serious work.

The branch rejects:

- `/tmp`-only evidence
- UI-only Comet evidence
- receipt files with no exact command or working directory
- exact command capture with no retained outputs

## Run Classes

| Run class | Meaning | Allowed authority ceiling |
| --- | --- | --- |
| `setup_probe` | inventory, wrapper check, preflight, environment capture | `engineering_only` |
| `feasibility_probe` | bounded GPU or NPU reachability test with no same-observable claim | `feasibility_only` |
| `serious_run` | a governed run on a named observable family with full logging and comparison intent | `governed_non_sovereign` or `serious_branch_evidence` |
| `abstain_record` | explicit record that a run class was considered but not honestly executable | `abstain` |

## Required Run Identity Fields

Every run manifest must carry these fields:

| Field | Meaning |
| --- | --- |
| `run_id` | unique branch run identifier |
| `branch` | `hypothesis/rm10-primary-platform-heterogeneous-learning` |
| `phase` | phase number, e.g. `01.2.3.1` |
| `plan` | plan number |
| `hypothesis_branch` | branch thesis under test |
| `device_serial` | e.g. `FY25013101C8` |
| `device_model` | e.g. `NX789J` |
| `device_lane` | RM10 lane label |
| `compute_lane` | `cpu | gpu | npu | heterogeneous` |
| `run_kind` | `setup_probe | feasibility_probe | serious_run | abstain_record` |
| `battery_class` | `micro | medium | long` |
| `battery_family` | boundary, spectral, topology, reciprocity, persistence, hardware-role, or explicit control label |
| `observable_family` | named observable under test |
| `authority_status` | `engineering_only | feasibility_only | governed_non_sovereign | serious_branch_evidence | abstain` |
| `evidence_surface` | `inventory | cpu_control | parity_feasibility | assist_feasibility | heterogeneous_split | negative_result` |
| `build_class` | `source_built | prebuilt_stub | mixed_prebuilt_backed | bundled_residue | inventory_only` |
| `phase_outcome` | `PASS | FAIL | ABSTAIN | BLOCKED` |
| `route_outcome` | `PASS | FAIL | ABSTAIN | NOT_APPLICABLE` |
| `command_exact` | full command string |
| `cwd` | exact working directory |
| `env_manifest_path` | retained environment dump path |
| `receipt_paths` | one or more output receipt paths, or explicit `none` |
| `stdout_path` / `stderr_path` | retained logs |
| `thermal_pre_path` / `thermal_post_path` | retained thermal snapshots |
| `battery_pre_path` / `battery_post_path` | retained battery snapshots |
| `meminfo_pre_path` / `meminfo_post_path` | retained memory snapshots when required |
| `checkpoint_id` | current checkpoint identifier |
| `checkpoint_parent` | prior checkpoint identifier or `none` |
| `comet_mode` | `online | offline` |
| `comet_experiment_key` | required when online |
| `comet_offline_bundle_path` | required when offline |

## Required Artifact Layout

Every serious or feasibility run must retain a repo-rooted artifact tree with:

- `identity/run_identity.json`
- `identity/command.txt`
- `identity/env.txt`
- `identity/checkpoint_index.json`
- `telemetry/`
- `receipts/`
- `logs/stdout.txt`
- `logs/stderr.txt`

If a comparison is performed, also retain:

- `comparisons/`

If the run ends in abstain, retain:

- `abstain_reason.txt`

## Comet Rules

### Online mode

Allowed only when the run still retains:

- experiment key
- manifest export
- repo-retained identity packet

### Offline mode

Default fallback when online upload is unavailable or undesirable.
Offline mode is valid only if the run retains:

- offline bundle path
- manifest file
- repo-retained artifact mirror

### Hard rule

Serious runs are invalid if they have neither:

- a Comet experiment key, nor
- an offline bundle path

## Exact Command And Environment Capture

Every later run must retain:

- the literal command line
- the literal working directory
- the shell or wrapper surface used
- the environment manifest actually seen by the process

Do not summarize this in prose only.
Retain the real values.

## Receipt Rules

Receipts are required whenever the executable claims to emit them.

If a path is expected to emit a receipt but does not:

- record the absence explicitly
- mark the run `FAIL`, `ABSTAIN`, or `BLOCKED` as appropriate
- do not silently downgrade the run into a log-only success narrative

## Comparison Rules

A cross-lane comparison is allowed only when:

1. `observable_family` matches
2. receipt fields needed for comparison match
3. the branch question is unchanged
4. `build_class` changes, if any, are declared rather than hidden

If one of those fails, the run may still be useful, but it is not a same-family
comparison.

## Required Outcome Language

Later docs must use these labels exactly:

- `PASS`: the intended governed question was answered positively
- `FAIL`: the intended governed question was answered negatively
- `ABSTAIN`: prerequisites were not met, so the branch refused to overclaim
- `BLOCKED`: staging drift, artifact loss, or governance failure prevented a
  meaningful result

These labels apply to run classes, not to the branch mood.

## Repo Retention Rule

The branch may stage work under `/tmp` or device-local temp paths during a run,
but serious artifacts must be mirrored into the repo before they are cited.

Plan `02`, `03`, and `04` must therefore cite repo-retained artifacts, not
transient temp roots.

## Setup Versus Serious Work

The following do not count as serious evidence on their own:

- device presence
- hardware node visibility
- wrapper listings
- thermal snapshots
- log-only activity

They matter only when tied to a named run class and later receipt surface.

## Bottom Line

If a later executor cannot tell exactly what ran, where it ran, what it
produced, how it was checkpointed, and where its Comet anchor lives, then the
run does not count as interpretable branch evidence.
