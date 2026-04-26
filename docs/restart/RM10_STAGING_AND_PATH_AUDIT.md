# RM10 Staging And Path Audit

Last refreshed: `2026-04-05`

## Purpose

Freeze the current RM10 path truth for startup so later work does not confuse
execution roots, binary identities, or residue surfaces.

## Live Path Inventory

Re-verified live on `2026-04-05`:

| Surface | Live path | Current meaning |
| --- | --- | --- |
| primary device root | `/data/local/tmp` | canonical ADB-shell execution root |
| governed Genesis workspace | `/data/local/tmp/SoC_runtime/workspace` | `F1` governed CPU control `cwd` |
| governed Genesis binary | `/data/local/tmp/genesis_cli` | `F1` executable, still prebuilt-backed |
| governed wrapper path | `/data/local/tmp/SoC_Harness/bin` | wrapper and stub toolchain surface, not source-build proof |
| raw Genesis workspace | `/data/local/tmp/snic_workspace_a83f` | separate raw-workspace witness lane |
| residue root runner | `/data/local/tmp/dm3_runner` | residue-only callable compare surface |
| bundled archaeology directory | `/data/local/tmp/dm3` | preserved bundled asset and runner directory |
| bundled archaeology runner | `/data/local/tmp/dm3/dm3_runner` | archaeology target, not the same binary as the root residue runner |

## Exact Lane Separation

### Governed `F1`

- `cwd` must be `/data/local/tmp/SoC_runtime/workspace`
- binary must be `/data/local/tmp/genesis_cli`
- wrapper semantics remain `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- device output root is `audit/<run_id>` under the workspace
- build class remains `prebuilt_stub`

### Raw-workspace witness lane

- `cwd` is `/data/local/tmp/snic_workspace_a83f`
- binary is still `/data/local/tmp/genesis_cli`
- this lane is a separate witness surface, not the governed `F1` anchor

### Residue `F2`

- current residue compare work lives at `/data/local/tmp`
- the callable compare binary is `/data/local/tmp/dm3_runner`
- this surface is residue-only, currently `PASS` only at callable ceiling with
  `unstable_feasibility`, and may not be narrated as a governed bridge

### Bundled archaeology target

- archaeology `cwd` is `/data/local/tmp/dm3`
- bundled runner path is `/data/local/tmp/dm3/dm3_runner`
- bundled asset adjacency still matters here
- this surface remains archaeology-only even though the directory survives

## Drift Risks Visible Right Now

### Two different `dm3_runner` binaries are live on the device

Live listing shows:

- `/data/local/tmp/dm3_runner` size `9554600`, timestamp `2026-02-09 18:34`
- `/data/local/tmp/dm3/dm3_runner` size `9199920`, timestamp `2025-11-22 02:37`

That is path-sensitive drift risk. A note that only says "run `dm3_runner`"
is not trustworthy.

### The root execution directory is crowded with residue and historical files

`/data/local/tmp` currently contains:

- old JSONL receipts
- old stdout and telemetry files
- both root-level and bundled asset copies
- multiple historical run directories

Directory presence alone is not a current manifest.

### Workspace audit directories already contain prior run IDs

Live listing under `/data/local/tmp/SoC_runtime/workspace/audit` includes:

- `branch_01_2_3_1_cpu_20260405`
- `branch_01_2_3_2_f1_cpu_a`
- `phase012_rm10_soc_g01`
- `rm10_soc_runtime_g01_20260403`

Reusing an old `audit/<run_id>` path would contaminate receipt custody.

### Wrapper presence can be misread as source parity

`/data/local/tmp/SoC_Harness/bin/cargo` is still present, but the execution
surface is still the prebuilt `genesis_cli`. The wrapper is plumbing, not a
fresh RM10-local build proof.

## Required Staging Discipline

Before any later serious or feasibility run:

- record the exact device `cwd`
- record the exact binary path
- record the exact wrapper surface or direct-launch surface
- allocate a fresh `audit/<run_id>` path for governed Genesis work
- mirror cited outputs into the repo before treating them as branch evidence
- keep shared storage or export paths out of the live execution-root story

## Bottom Line

The device still holds all three major path families:

- governed Genesis
- residue `F2`
- bundled archaeology

The path families are live and stable now. What remains incomplete is receipt,
checkpoint, and custody hardening on top of them. Trustworthy startup requires
naming the exact path family every time. Path ambiguity is current drift, not
harmless shorthand.
