# Internal Red Magic Engineering PRD

## Document Role

This is the branch-local engineering PRD for Phase `01.2.3.1` Plan `01`.
It exists to make the hypothesis branch executable without turning branch
energy, phone presence, or document count into evidence.

The governing question is not "can the phone run something?".
It is:

`Can the Red Magic 10 Pro be engineered into the primary DM3 research instrument
for this branch while keeping receipts, common observables, and anti-proxy
discipline sovereign?`

## Branch Anchors

- Branch hypothesis:
  `Engineer the Red Magic 10 Pro into the primary DM3 research instrument and treat heterogeneous CPU/GPU/NPU execution as an early first-class learning path.`
- Branch context:
  the branch order is fixed as internal pack -> RM10 engineering -> history
  mining -> testing surfaces -> battery matrix -> object-level interpretation.
- Mainline caution under test:
  RM10 GPU is `not ready now`, RM10 NPU is `feasibility-only`, and
  heterogeneous embodiment is `premature` until a different CPU-governed common
  observable exists.

This branch is allowed to test that caution directly.
It is not allowed to erase it with rhetoric.

## Current Evidence Baseline

The PRD is grounded in current branch evidence, not generic mobile-compute
ambition:

- attached device model: `NX789J`
- board platform property: `sun`
- ADB-shell execution over `/data/local/tmp` is real
- visible memory: `23662780 kB` total, `13909884 kB` available at preflight
- battery preflight: level `80`, AC powered, thermal status `0`
- `/data/local/tmp` currently exposes `genesis_cli`, `dm3_runner`,
  `SoC_Harness`, `SoC_runtime`, `snic_workspace_a83f`, bundled assets, and
  preserved residue files
- `/dev/kgsl-3d0` is visible
- thermal HAL exposes `GPU*` and `nsp*` channels

These facts justify RM10-first engineering as a branch experiment.
They do not prove GPU or NPU scientific readiness.

## Branch Objective

Engineer the RM10 into the primary branch instrument in a way that later plans
can test honestly.

The branch must produce:

1. one governance pack that fixes logging, thermal, checkpoint, and stop rules
2. one explicit CPU control lane
3. one explicit GPU feasibility lane
4. one explicit NPU or DSP feasibility lane
5. one explicit heterogeneous comparison lane that is only attempted if a
   common observable survives
6. one history-mining surface that extracts clues without inheriting authority

## Non-Goals

This PRD does not authorize:

- proving what DM3 "really is"
- reopening same-binary bundled `G2` route hunting
- using old labels as present authority
- hidden source reconstruction or undeclared redevelopment
- counting device attachment, thermal activity, or accelerator visibility as
  branch success

## Primary Instrument Hierarchy

| Lane | Role on this branch | Authority ceiling now |
| --- | --- | --- |
| RM10 CPU | primary control and branch instrument candidate | governed branch control only after explicit runbooks and common observable naming |
| RM10 GPU | acceleration or parity feasibility lane | not ready now |
| RM10 NPU or DSP-adjacent surface | bounded assist feasibility lane | feasibility-only |
| RM10 heterogeneous | role-partition experiment | premature until CPU control and one accelerator role are both interpretable |
| Mac host | support, debugging, compile, comparison, and witness-floor alignment | support lane, not branch center |

## Staging, Toolchain, And Directory Contract

Every later RM10 run must declare four roots and keep them non-interchangeable:

| Root | Canonical path or class | Contract |
| --- | --- | --- |
| repo artifact root | `artifacts/<phase_run_root>/<lane>/` | only citation-grade location for manifests, mirrors, and comparisons |
| host transient stage | operator temp root | transit only; never cited as final evidence |
| device execution root | `/data/local/tmp` | only currently evidenced live device execution root |
| device lane `cwd` | one of `/data/local/tmp/SoC_runtime/workspace`, `/data/local/tmp/snic_workspace_a83f`, `/data/local/tmp`, or `/data/local/tmp/dm3` | must be declared per run and may not drift inside one run ID |

Directory discipline for this branch is:

- `/data/local/tmp/SoC_runtime/workspace` is the governed CPU control `cwd`
- `/data/local/tmp/snic_workspace_a83f` is a separate raw-workspace lane and must be labeled separately
- `/data/local/tmp/dm3` and `/data/local/tmp/dm3_runner` are residue or archaeology surfaces, not witness-floor control
- `/sdcard` and `/storage/emulated/0` are ingress and export only, not governed execution roots

Toolchain discipline for this branch is:

- host orchestration may use `adb`, shell utilities, hashing tools, and optional Comet logging
- device CPU control currently uses `/data/local/tmp/genesis_cli`
- `PATH=/data/local/tmp/SoC_Harness/bin:$PATH` is execution plumbing only; the `cargo` found there is a stub and does not justify `source_built`
- no live branch document may assume Termux, a local RM10 Rust build, or an NPU SDK unless separately receipted

## Run-Class Loading Requirements

No lane is loaded until its run template declares:

- `run_kind`
- `authority_status`
- `evidence_surface`
- `build_class`
- `command_exact`
- `cwd`
- `checkpoint_id`
- `thermal_pre_path` and `thermal_post_path`
- `battery_pre_path` and `battery_post_path`
- repo-retained artifact root

## Required Execution Order

The order is fixed:

1. write the internal governance pack
2. engineer the Red Magic system and runbooks
3. mine older governed and DM3-residue histories
4. stand up testing surfaces
5. run bounded battery matrices
6. decide what the branch learned

If later work skips forward, it is out of contract.

## Serious-Run Gate

The branch serious-run gate is closed at the end of Plan `01`.
It opens only when all of the following are true:

1. the six Plan `01` governance docs exist and agree
2. the Plan `02` history indexes exist and classify clues by trust class
3. the Plan `03` device dossier and CPU/GPU/NPU/heterogeneous runbooks exist
4. one CPU-governed common observable family is named explicitly
5. the run identity schema, custody rules, thermal policy, and kill criteria
   are all loaded into the run class
6. GPU, NPU, and heterogeneous attempts can be labeled `pass`, `fail`, or
   `abstain` before the first serious comparison starts
7. the repo mirror layout `identity/`, `telemetry/`, `receipts/`, `logs/`, and optional `comparisons/` is fixed before the command is issued

Before those conditions hold, outputs may be:

- `setup_probe`
- `engineering_only`
- `feasibility_only`
- `abstain`

They may not be narrated as branch execution success.

## First Common-Observable Rule

This branch may not begin with the retired bundled `G2` family.

The first branch comparison must instead use a different CPU-governed observable
family that is:

- live on the current RM10 surface
- receiptable on repeated runs
- small enough for thermal-safe repetition
- comparable across lanes without changing the scientific story

Until such a family is named, GPU, NPU, and heterogeneous work remain prep or
feasibility work.

## Workstream Contract

### 1. RM10 engineering

Goal:
turn the attached phone into a governed execution instrument rather than a
symbolic target.

Outputs:

- device dossier
- CPU/GPU/NPU/heterogeneous runbooks
- live preflight receipts

### 2. Heterogeneous compute

Goal:
test whether role partition yields interpretable learning rather than noisy
acceleration folklore.

Outputs:

- lane taxonomy
- readiness states
- abstain rules
- common-observable comparison requirements

### 3. Old-history mining

Goal:
mine the governed SoC line and later DM3 residue into clues, not authority.

Outputs:

- mining ledger
- clue index
- observable index
- role-partition index
- failure-pattern index

### 4. Battery bootstrap

Goal:
produce bounded early branch batteries across boundary, spectral, topology,
reciprocity, persistence, and hardware-role partition questions.

Outputs:

- explicit battery matrices
- first receipted CPU/GPU/NPU/heterogeneous pass or abstain outcomes

## Required Labels For Later Plans

Later plans must preserve these branch labels:

- `run_kind`: `setup_probe | feasibility_probe | serious_run | abstain_record`
- `authority_status`: `comparison_only | engineering_only | feasibility_only | governed_non_sovereign | abstain`
- `evidence_surface`: `inventory | cpu_control | parity_feasibility | assist_feasibility | heterogeneous_split | negative_result`
- `build_class`: `source_built | prebuilt_stub | mixed_prebuilt_backed | bundled_residue | inventory_only`
- `phase_outcome`: `PASS | FAIL | ABSTAIN | BLOCKED`
- `route_outcome`: `PASS | FAIL | ABSTAIN | NOT_APPLICABLE`

These labels are not decoration.
They are what stop branch optimism from collapsing distinct states together.

## Anti-Proxy Rules

The branch rejects the following proxies:

- document existence as evidence of readiness
- visible hardware nodes as proof of usable compute
- historical residue labels as proof of current semantics
- phone heat as a substitute for a comparable observable
- branch enthusiasm as a reason to loosen the mainline caution

## Handoff To Later Plans

Plan `02` must consume this PRD as the scope ceiling for history mining.
Plan `03` must consume it as the RM10-first systems contract.
Plan `04` must consume it as the seriousness gate and verdict vocabulary.

## Outcome Statement

If this PRD succeeds, the branch becomes interpretable.
If the branch later fails, it should fail under explicit labels and receipts,
not because the branch was allowed to improvise its own rules mid-run.
