# Runbook RM10 NPU

## Goal

Answer one bounded question: is there a user-space reachable, receipt-backed
NPU or DSP-assisted substage worth testing now, without letting
accelerator-adjacent telemetry masquerade as a live lane?

## Run Class And Ceiling

Allowed run classes are:

- `setup_probe` with `authority_status=engineering_only`, `evidence_surface=inventory`, `build_class=inventory_only` for reachability inventory only
- `feasibility_probe` with `authority_status=feasibility_only`, `evidence_surface=assist_feasibility`, and `build_class=inventory_only` or `bundled_residue` only for a named bounded assist role

A NPU `PASS` here means bounded assist feasibility only.
It does not authorize whole-pipeline authority claims.

## Preconditions

- CPU control lane already names the reference `observable_family`
- the candidate role is explicitly bounded, such as projection, tagging, or preprocessing checked by the CPU lane
- inputs, outputs, and comparison notes can be mirrored into the repo
- thermal entry gate passes using HAL `battery`, `skin`, and `nsp*` values

## Toolchain And Directory Contract

- currently evidenced surfaces are inventory only: `fastrpc*`, `glink*cdsp*`, `libQnnHtp*`, `libQnnSystem.so`, `libadsprpc.so`, `libcdsprpc.so`, `adsprpcd`, `cdsprpcd`, `dspservice`
- no branch document currently proves an RM10-local NPU SDK or DM3-facing user-space dispatch contract
- use `artifacts/<phase_run_root>/npu_feasibility/` as the repo mirror root
- do not promote telemetry, libraries, or daemons into a live lane until the exact callable command is declared in advance

## Canonical First Probe

```bash
ARTIFACT_ROOT=artifacts/<phase_run_root>/npu_feasibility
mkdir -p "$ARTIFACT_ROOT"/{identity,telemetry,logs}

adb shell dumpsys thermalservice > "$ARTIFACT_ROOT/telemetry/thermal_pre.txt"
adb shell 'ls /dev | grep -E "fastrpc|cdsp|adsp|nsp"; ls /vendor/lib64 | grep -E "Qnn|dsp|adsprpc|cdsprpc"; ls /vendor/bin | grep -E "dsp|rpc"' > "$ARTIFACT_ROOT/logs/stdout.txt" 2> "$ARTIFACT_ROOT/logs/stderr.txt"
adb shell dumpsys thermalservice > "$ARTIFACT_ROOT/telemetry/thermal_post.txt"
```

Any step beyond inventory must add an exact callable command, mirrored inputs
and outputs, and an explicit CPU-checked comparison note.

## Verdict Standard

- `PASS`: a named bounded assist role is callable from user space, inputs and outputs are receipted, and the CPU lane can still govern the final observable
- `FAIL`: a real callable attempt was made on a named assist role and no usable path survived
- `ABSTAIN`: hints or inventory evidence exist, but the role is not yet callable, receiptable, or comparable
- `BLOCKED`: staging drift, artifact-capture failure, undefined role boundaries, or thermal-policy failure prevented a meaningful probe

## Required Captures

- exact probe commands
- libraries, services, or runtime hints observed
- artifact paths for positive or negative evidence
- an explicit note naming the bounded assist role or stating that no such role could be named

## Hard Stops

- only vendor daemons or telemetry are visible
- outputs cannot be preserved under the branch ledger rules
- the role can only be described vaguely
- the path requires proprietary redevelopment while still being called branch execution
