# Runbook RM10 CPU

## Goal

Use the RM10 CPU lane as the first governed control surface, while keeping the
current lane honestly labeled as prebuilt-backed device execution rather than
source-built parity.

## Run Class And Ceiling

Use exactly one of these run classes:

- `setup_probe` with `authority_status=engineering_only` when the work is only identity, wrapper, or receipt-surface verification
- `serious_run` with `authority_status=governed_non_sovereign`, `evidence_surface=cpu_control`, and `build_class=prebuilt_stub` only after the observable family, command, `cwd`, and artifact tree are fixed in advance

`source_built` is not an allowed CPU label on this branch unless a fresh
RM10-local build is separately receipted.

## Preconditions

- device model still matches `NX789J`
- device execution root is still `/data/local/tmp`
- intended `cwd` is `/data/local/tmp/SoC_runtime/workspace`
- thermal entry gate passes using HAL values: `Thermal Status=0`, battery `<= 35.0 C`, skin `<= 38.0 C`, `MemAvailable >= 8000000 kB`
- power is attached for any non-trivial run
- run manifest already declares `run_id`, `observable_family`, `command_exact`, `cwd`, `checkpoint_id`, and repo artifact root

## Toolchain And Directory Contract

- binary: `/data/local/tmp/genesis_cli`
- wrapper surface: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- governed device output root: `audit/<run_id>` under `/data/local/tmp/SoC_runtime/workspace`
- repo mirror root: `artifacts/<phase_run_root>/cpu_control/`
- shared storage is ingress or export only and may not be cited as the live execution root

The `SoC_Harness/bin/cargo` surface is execution plumbing only.
It does not justify a `source_built` claim.

## Canonical Bounded Pass

```bash
ARTIFACT_ROOT=artifacts/<phase_run_root>/cpu_control
DEVICE_CWD=/data/local/tmp/SoC_runtime/workspace
DEVICE_OUT=audit/<run_id>

mkdir -p "$ARTIFACT_ROOT"/{identity,telemetry,logs,receipts}
adb shell "cd ${DEVICE_CWD} && pwd && env" > "$ARTIFACT_ROOT/identity/env.txt"
adb shell dumpsys battery > "$ARTIFACT_ROOT/telemetry/battery_pre.txt"
adb shell dumpsys thermalservice > "$ARTIFACT_ROOT/telemetry/thermal_pre.txt"
adb shell "cd ${DEVICE_CWD} && PATH=/data/local/tmp/SoC_Harness/bin:\$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir ${DEVICE_OUT}" > "$ARTIFACT_ROOT/logs/stdout.txt" 2> "$ARTIFACT_ROOT/logs/stderr.txt"
adb pull "${DEVICE_CWD}/${DEVICE_OUT}" "$ARTIFACT_ROOT/receipts"
adb shell dumpsys battery > "$ARTIFACT_ROOT/telemetry/battery_post.txt"
adb shell dumpsys thermalservice > "$ARTIFACT_ROOT/telemetry/thermal_post.txt"
```

Record the literal shell line used in `identity/command.txt`.
If the operator changes `cwd`, wrapper surface, or output-directory semantics,
it is a new run ID.

## Required Artifact Tree

Retain:

- `identity/run_identity.json`
- `identity/command.txt`
- `identity/env.txt`
- `telemetry/battery_pre.txt` and `battery_post.txt`
- `telemetry/thermal_pre.txt` and `thermal_post.txt`
- `logs/stdout.txt` and `logs/stderr.txt`
- `receipts/` mirrored from the device `audit/<run_id>` tree
- `identity/checkpoint_index.json` once the first load-bearing receipt exists

## CPU Pass Standard

- `PASS`: the named CPU observable runs on the fixed command and fixed `cwd`, emits receipt-backed outputs, and stays within thermal and custody rules
- `FAIL`: the governed CPU question was really attempted and the lane could not preserve the observable, receipt surface, or reproducibility
- `ABSTAIN`: a path exists, but the observable family, receipt surface, or validator story is not clean enough for honest comparison yet
- `BLOCKED`: device identity drift, staging drift, artifact-mirror failure, or governance failure prevented a meaningful attempt

## Hard Stops

- current device identity no longer matches the expected RM10
- execution drifts away from `/data/local/tmp`
- thermal state leaves nominal and outputs drift
- control observable depends on the retired bundled `G2` route story
- the repo mirror cannot capture the device outputs before they are cited
