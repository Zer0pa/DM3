# Invocation Surface Dossier

## Scope

This dossier maps the surviving same-binary invocation surface around the
preserved bundled RM10 runner:

- binary: `/data/local/tmp/dm3/dm3_runner`
- binary SHA-256:
  `d678e8d355601d13dd1608032fd5e6fdf5eaa81bdde0af5f124125ff1bcea8b1`
- retained audit root:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404`
- retained serious-pass mirror:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass`
- retained supplement root:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/supplement`
- retained combined comparison table:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/comparisons/receipt_hashes_combined.tsv`
- transient source run root:
  `/tmp/dm3_phase_01_2_3_plan01_20260404T194225Z`
- Comet offline experiment key: `81886795bff24e73bd1e948f272205fa`
- Comet offline bundle:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/cometml-runs/81886795bff24e73bd1e948f272205fa.zip`

The comparison control remains the official `01.2.2` smoke canonical:

- normalized receipt SHA-256:
  `d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9`
- canonical run id: `t1_contraction`

## Route Class Legend

- `callable smoke`: launches cleanly but normalizes to the smoke canonical.
- `callable non-smoke`: launches cleanly and produces a distinct non-smoke
  stdout and receipt class.
- `route-guarded`: the route token is explicitly rejected on the live binary.
- `dead`: no surviving live launcher or environment contract was evidenced.

## Read-Only Parser Surface

Help and parser controls were captured before the serious route pass:

- `--help` exposes only `--mode inference|train` and the task help text
  `Task name (holography, harmonic) [default: holography]`.
- `--task __bogus__ --mode inference` exits `0` and still prints
  `Running T1: Contraction...`.
- `--mode train --task __bogus__` exits `1` with `Error: Unknown task:
  __bogus__`.
- the retained parser/help outputs now live under the repo audit mirror:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/argv/help.txt`,
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/argv/bogus_task_inference_*`,
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/argv/bogus_task_train_*`

That asymmetry matters: inference-mode task acceptance is not proof of a live
semantic route, while train mode still enforces a task gate.

## Surviving Direct Invocation Surface

| Surface ID | Wrapper | CWD | Mode | Task | Asset / path form | Exit | Route class | Observable | Receipt result |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `g2_default_assets` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `inference` | `exp_g2_readout` | help defaults: `SriYantraAdj_v1.bin`, `RegionTags_v1.bin` | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `g2_explicit_assets_v2json` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `inference` | `exp_g2_readout` | explicit `SriYantraAdj_v1.bin` + `RegionTags_v2.json` | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `g2_abs_assets` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `inference` | `exp_g2_readout` | explicit absolute asset paths | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `g2_parent_cwd_abs_assets` | direct `./dm3/dm3_runner` | `/data/local/tmp` | `inference` | `exp_g2_readout` | explicit absolute asset paths, parent cwd | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `infer_holography` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `inference` | `holography` | no extra asset override | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `infer_harmonic` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `inference` | `harmonic` | no extra asset override | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `infer_boundary_alignment` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `inference` | `boundary_alignment` | no extra asset override | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `infer_boundary_power` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `inference` | `boundary_power` | no extra asset override | `0` | `callable smoke` | `Running T1: Contraction...` | `run_id=t1_contraction`, normalized `d3e721...` |
| `train_holography` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `train` | `holography` | no extra asset override | `0` | `callable non-smoke` | `Entering Resonance Mode (Legacy)...` then 100 training episodes | distinct 100-line JSONL, SHA-256 `c491a42a...` |
| `train_harmonic` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `train` | `harmonic` | no extra asset override | `0` | `callable non-smoke` | `Entering Resonance Mode (Legacy)...` then 100 training episodes | distinct 100-line JSONL, SHA-256 `bd3a9ef0...` |
| `train_exp_g2_readout` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `train` | `exp_g2_readout` | no extra asset override | `1` | `route-guarded` | `Error: Unknown task: exp_g2_readout` | no receipt emitted |
| `train_boundary_alignment` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `train` | `boundary_alignment` | no extra asset override | `1` | `route-guarded` | `Error: Unknown task: boundary_alignment` | no receipt emitted |
| `train_boundary_power` | direct `./dm3_runner` | `/data/local/tmp/dm3` | `train` | `boundary_power` | no extra asset override | `1` | `route-guarded` | `Error: Unknown task: boundary_power` | no receipt emitted |

## Decisive Evidence

### 1. Every same-binary inference candidate collapses to the same smoke route

The eight tested inference surfaces all produced the same normalized payload:

- `g2_default_assets`
- `g2_explicit_assets_v2json`
- `g2_abs_assets`
- `g2_parent_cwd_abs_assets`
- `infer_holography`
- `infer_harmonic`
- `infer_boundary_alignment`
- `infer_boundary_power`

Each normalized to:

```json
{"run_id":"t1_contraction","abi_version":"v0.1","schema_hash":"0000","jit_hash":"54bcc21667c6be3435e9241525d7458d514dc98c64cbaaa90be908aa4fd73a66","driver_hash":"Host-CPU-Sim","workgroup_size":[64,1,1],"subgroup_size":32,"device_id":"sim_gpu","thermal_state":"nominal","clocks":"max","build_mode":"release","input_hash":"cb9e4fa49dbfcf55bf5eac6cf4429573adfaa58f0c321775b64ca9da17553ebe","state_hash_before":"469c1e5bcecf7628b988214ae5ffa331ca14d4de24dbfb06847c7705bd576da9","state_hash_after":"469c1e5bcecf7628b988214ae5ffa331ca14d4de24dbfb06847c7705bd576da9","metrics":{"delta_e_trace":[],"ecc":0.0,"coherence":1.0,"isotropy":"RADIAL","holo_err":0.0,"principal_angle_drift":0.0},"verdict":"PASS","previous_hash":"0000000000000000000000000000000000000000000000000000000000000000"}
```

No inference-side asset form, cwd form, or tested task token produced any
observable more specific than the already-known smoke control.

### 2. Train mode still has a real task gate

Train mode remains live, but only for the help-listed task family and it
rejects the string-backed residue candidates:

- `train_holography`: exit `0`, 100-episode JSONL, non-smoke legacy resonance
  stdout.
- `train_harmonic`: exit `0`, 100-episode JSONL, non-smoke legacy resonance
  stdout.
- `train_exp_g2_readout`: exit `1`, stderr `Error: Unknown task:
  exp_g2_readout`, no receipt.
- `train_boundary_alignment`: exit `1`, stderr `Error: Unknown task:
  boundary_alignment`, no receipt.
- `train_boundary_power`: exit `1`, stderr `Error: Unknown task:
  boundary_power`, no receipt.

That split matters because it shows `exp_g2_readout` is not a generally live
task synonym on the current binary. It is inference-accepted residue that still
lands on smoke, not a train-visible routed task.

### 3. The string-backed `boundary_*` candidates are now explicitly retired

The verifier gap on `boundary_alignment` and `boundary_power` is closed with
receipted same-binary probes, not a prose-only retirement:

- candidate promotion provenance is retained at
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/supplement/strings/boundary_string_residue_from_prior_repo_extract.txt`,
  which preserves both names inside one metric/output residue line rather than
  in help-listed task text
- `infer_boundary_alignment` and `infer_boundary_power` each exit `0`, print
  `Running T1: Contraction...`, and normalize to the same smoke canonical
  `d3e721...`
- `train_boundary_alignment` and `train_boundary_power` each exit `1` with
  `Error: Unknown task: ...`

So both names behave exactly like residue-only candidates on the live binary:
inference-accepted argv without distinct semantics, plus train-side route
guards.

### 4. No wrapper, cwd, or env rescue surface survived

- No shell script under `/data/local/tmp` referenced `dm3_runner`,
  `/data/local/tmp/dm3`, or `exp_g2_readout`.
- The only nearby script, `/data/local/tmp/dm3_termux_probe.sh`, is a Termux
  environment probe and never launches the bundled runner.
- The parent-cwd direct binary route with absolute assets still normalized to
  `d3e721...`, so there is no surviving cwd-specific non-smoke route.
- The adb-shell environment baseline contains no DM3-specific override and no
  wrapper evidence justified an env mutation probe.

## Surface Exhaustion Verdict

For the current bundled binary hash, the surviving live surface is exhausted as
follows:

- `callable smoke`: all justified inference surfaces, including every tested
  `G2` asset/cwd form, both help-listed inference tasks, and the explicit
  `boundary_alignment` / `boundary_power` supplement probes
- `callable non-smoke`: `train+holography` and `train+harmonic` only
- `route-guarded`: `train+exp_g2_readout`,
  `train+boundary_alignment`, and `train+boundary_power`
- `dead`: wrapper-dependent and env-dependent `G2` launcher stories on the
  current device surface

No same-binary live route into `G2 Boundary Readout / R2Contrastive` survived
this census, and the two string-backed `boundary_*` candidates are now retired
with repo-retained receipts.
