# RM10 Capability Smoke Lattice Ledger

## Scope

Wave 2 execution for plan `01.2.3.4.1.1-02`.

Live surface:

- lane id: `rm10_f1_cleanup_control`
- workspace root: `/data/local/tmp/SoC_runtime/workspace`
- launcher: `/data/local/tmp/genesis_cli`
- wrapper surface: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- live output root: `/data/local/tmp/SoC_runtime/workspace/audit`

Forbidden inside this lattice:

- raw-workspace lane
- residue `F2`
- bundled archaeology lane
- handoff variation
- lane substitution

Default-validator failure stays telemetry only unless it directly explains a
row-classification outcome.

## Discovery Observable Contract

Declared before any row interpretation:

- anchor observable:
  `semantic_receipt_signature`, defined as the normalized SHA-256 digest of the
  pulled `verify.json`, `solve_h2.json`, and `VERIFY_SUMMARY.json` after
  stripping direct config-echo fields (`cfg_hash`) and timestamp fields
  (`timestamp`, `ts_utc`). Human-readable anchor fields come from
  `verify.gate_summary`, `VERIFY_SUMMARY.gates`, and `solve_h2.report`.
- drift observable:
  `lane_custody_and_thermal_tuple`, defined as the fixed `F1` lane identity
  tuple `{device model, device serial, binary SHA-256, cwd, wrapper surface}`
  plus before/after battery temperature and thermal status.
- abstain rule:
  `ABSTAIN` on any row whose receipts are missing or non-comparable, whose
  command leaves the declared `F1` surface, or whose apparent difference
  reduces to config echo, runtime length, validator-default exit, filenames, or
  thermal / identity drift rather than receipt semantics.

## Smoke Lattice Grid

Artifact packet:

- `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z`

Row grid:

| Row ID | Role | Config Override | Perturbation Family | Why It Exists |
| --- | --- | --- | --- | --- |
| `r00_control_default_a` | control | none | baseline | first-result control row |
| `r01_control_default_b` | control-repeat | none | baseline | repeated baseline / persistence control |
| `r10_priors_off_a` | candidate | `configs/CONFIG.no_priors.json` | priors | first-result candidate row |
| `r11_priors_off_b` | candidate-repeat | `configs/CONFIG.no_priors.json` | priors | repeated candidate row |
| `r20_lpe_off` | orthogonal-candidate | `configs/CONFIG.m2_lpe_off.json` | state-initialization | positional-encoding sensitivity probe |
| `r30_nonharmonic` | orthogonal-candidate | `configs/CONFIG.m1_nonharmonic.json` | input-family | harmonic-family sensitivity probe |

First-result gate:

- control: `r00_control_default_a`
- candidate: `r10_priors_off_a`
- fanout condition: only continue if both rows stay on the cleaned `F1` lane and
  produce comparable receipts that can be interpreted with the declared anchor
  and drift observables

## Retained References

- phase context: `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-CONTEXT.md`
- Wave 1 summary: `.gpd/phases/01.2.3.4.1.1-rm10-capability-discovery-reset-drift-purge-and-property-first-battery/01.2.3.4.1.1-01-SUMMARY.md`
- cleanup report: `docs/restart/RM10_CAPABILITY_RESET_CLEANUP_REPORT.md`
- live-surface manifest: `docs/restart/RM10_CAPABILITY_RESET_LIVE_SURFACE_MANIFEST.md`
- history observables: `docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/HISTORY_OBSERVABLES_INDEX.md`
- CPU runbook: `docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/RUNBOOK_RM10_CPU.md`
- GPU runbook: `docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/RUNBOOK_RM10_GPU.md`
- testing protocol: `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md`

## Response Table

Execution note:

- The first draft of this packet exposed a method bug: `genesis_cli --config`
  mutates `configs/CONFIG.json` in place.
- The retained table below supersedes that draft.
- Final retained rows restore the sealed Wave 1 `F1` baseline
  `configs/CONFIG.json` (`1ca44c0112ed2287579bd583bd0ac70e70daa5b8482933e789ed466c3db70fc4`)
  onto the device before every row.

Retained row table:

| Row ID | Config Override | Baseline Restore SHA | Protocol / Validator Telemetry | Raw Hash Relation | Semantic Receipt Relation | Drift Notes | Row Reading |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `r00_control_default_a` | none | `1ca44c...70fc4` | `protocol=0`, `default=1`, `explicit=0` | `verify=f992e9...`, `solve=a33c5c...` | control semantic digest `53d477f6...` | thermal `0 -> 0`, battery `34.0C -> 34.0C`, level `44`, `AC=false` | baseline control |
| `r01_control_default_b` | none | `1ca44c...70fc4` | `protocol=0`, `default=1`, `explicit=0` | identical to `r00` | identical to `r00` | thermal `0 -> 0`, battery `34.0C -> 34.0C`, level `44`, `AC=false` | repeated control proves short-window control stability |
| `r10_priors_off_a` | `configs/CONFIG.no_priors.json` | `1ca44c...70fc4` | `protocol=0`, `default=1`, `explicit=0` | raw `verify` / `solve` differ from control | semantic digest identical to control | thermal `0 -> 0`, battery `34.0C -> 34.0C`, level `44`, `AC=false` | candidate row changes config echo only |
| `r11_priors_off_b` | `configs/CONFIG.no_priors.json` | `1ca44c...70fc4` | `protocol=0`, `default=1`, `explicit=0` | identical raw pair to `r10` | identical semantic digest to `r10` and control | thermal `0 -> 0`, battery `34.0C -> 34.0C`, level `44`, `AC=false` | repeated candidate confirms no semantic signal |
| `r20_lpe_off` | `configs/CONFIG.m2_lpe_off.json` | `1ca44c...70fc4` | `protocol=0`, `default=1`, `explicit=0` | new raw `verify` / `solve` pair | semantic digest identical to control | thermal `0 -> 0`, battery `34.0C -> 34.0C`, level `44`, `AC=false` | orthogonal perturbation still collapses semantically |
| `r30_nonharmonic` | `configs/CONFIG.m1_nonharmonic.json` | `1ca44c...70fc4` | `protocol=0`, `default=1`, `explicit=0` | new raw `verify` / `solve` pair | semantic digest identical to control | thermal `0 -> 0`, battery `34.0C -> 34.0C`, level `44`, `AC=false` | harmonic-family perturbation still collapses semantically |

Retained packet anchors:

- packet root:
  `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z`
- row summaries:
  `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/comparisons/row_summaries.json`
- semantic matrix:
  `artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/comparisons/semantic_matrix.json`

Key observations:

1. The repeated control rows `r00` and `r01` matched exactly on raw hashes and
   semantic digests once the baseline config was restored before each row.
2. The repeated candidate rows `r10` and `r11` matched each other on raw hashes
   and semantic digests, but their semantic digest still matched the control
   family exactly.
3. The orthogonal `lpe_off` and `nonharmonic` rows produced distinct raw
   `verify.json` / `solve_h2.json` hashes, yet the normalized semantic digest
   remained identical to the control family.
4. `VERIFY_SUMMARY.json` stayed byte-identical across all six rows.
5. Default validation remained `exit 1` and explicit-hash validation remained
   `exit 0` on every row; this was retained as telemetry only.
6. Thermal status stayed nominal and battery temperature stayed flat at
   `34.0 C` across the entire battery; the phone was not AC powered during the
   run, but no thermal drift accompanied that state.

## Comparison And Classification Rule

Interpret rows in this order:

1. Confirm the drift observable still names the same cleaned `F1` lane.
2. Compare repeated baseline rows to establish whether the anchor observable is
   stable under short repeats.
3. Compare repeated candidate rows to determine whether any candidate response
   survives a repeat.
4. Compare orthogonal perturbations against the control family.
5. Classify only from retained receipt semantics:
   `no capability found`, `weak capability found`, `structured capability found`,
   or `unresolved`.

Observed comparison verdict:

- repeated baseline family count: `1`
- repeated candidate family count: `1`
- total semantic response family count across all six rows: `1`
- strongest observable family: one stable semantic receipt family
- weakest disconfirming observation: even the orthogonal `lpe_off` and
  `nonharmonic` perturbations changed only raw config-echo hashes while
  `verify.gate_summary`, `VERIFY_SUMMARY.gates`, and `solve_h2.report`
  semantics remained unchanged

## Classification

Classification: `no capability found`

Reason:

- This bounded smoke lattice found one stable semantic receipt family across the
  cleaned `F1` control rows, the repeated priors-off candidate rows, and the
  two orthogonal perturbations.
- Config overrides did alter raw `verify.json` and `solve_h2.json` hashes, but
  those differences disappeared when direct config-echo and timestamp fields
  were stripped, leaving one unchanged semantic digest
  (`53d477f605117a935285716029129a225c9497c15d373e289658d90ee29d675a`).
- Under the contract for this battery, callability plus config-echo hash churn
  is not capability.

Wave 3 readiness:

- `NO`
- Property mapping should not proceed from this lattice because there is no
  retained capability signal to map on the cleaned `F1` surface.

## Status

- lattice packet root created
- observables frozen before interpretation
- six-row baseline-restored lattice executed
- classification written from retained row semantics
