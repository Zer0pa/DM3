# Legacy Battery Entrypoints

## Purpose

This document names the strongest recoverable execution surfaces from the legacy DM3 lineage.
It is intentionally narrow:

- only real commands, scripts, or documented CLI options are included
- only source-backed receipt surfaces are cited
- missing hybrid layers remain out of scope until their source is recovered

This is the current restart answer to:

`What can we actually run, classify, and compare without inventing folklore?`

## Recoverable Strata

### Stratum A: October exact-rational substrate

Workspace root:

`recovery/zer0pamk1-DM-3-Oct/snic`

What survives here:

- exact-rational geometry and lift checks
- DEQ and resonance-side artifacts
- gate summaries and sidecar proofs
- Merkle-style receipt discipline
- CPU-first scripts for geometry, reproduce, verify, and report flows

What it does not prove:

- the newer hybrid transformer / HRM / scar-engine layer
- a governed mobile GPU or NPU replay lane

### Stratum B: Genesis deterministic governance wrapper

Workspace root:

`recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f`

What survives here:

- a documented `genesis_cli`
- deterministic environment freezing
- single-run, battery, validation, audit-report, and lineage-batch commands
- canonical hash ledgers and audit logs
- explicit cross-platform replay doctrine

What it does not prove:

- the missing DM3 hybrid source
- non-bitwise equivalence receipts for the newer compiled-only DM3 residue

## Canonical Entrypoints

| ID | Stratum | Run From | Command | Battery Class | Primary Outputs | Current Restart Use |
| --- | --- | --- | --- | --- | --- | --- |
| `O-00` | October | `snic/` | `./stage0.sh` | preflight / governance | `.zer0pa_stage0/out/stage0_report.json`, `workspace_inventory.tsv`, `merkle_root.txt` | inventory, reproducibility scan, workspace hygiene before scientific replay |
| `O-01` | October | `snic/` | `./scripts/run_phase_a.sh` | micro | `artifacts/geometry/dual_meru_geometry_report.json`, `dual_meru_mesh.ply`, `dual_meru_mesh.svg`, `artifacts/proofs/*.json`, `artifacts/summary.json` | fast geometry-only bring-up of the exact dual-meru artifact |
| `O-02` | October | `snic/` | `./scripts/VERIFY.sh` | micro | `artifacts/verify.json`, `artifacts/VERIFY.stdout.log` | gate and sidecar verification against the exact-rational substrate |
| `O-03` | October | `snic/` | `./scripts/REPRODUCE.sh` | medium | `artifacts/verify.json`, `artifacts/solve_h2.json` plus verify sidecars | re-run the substrate pipeline: `build-2d`, `lift-3d`, `solve-h2`, `verify` |
| `O-04` | October | `snic/` | `./scripts/SMOKE_TEST.sh` | micro | same as `O-03`, plus gate pass/fail on `gates_ok` and `cad_sos_present` | quick regression screen before longer October runs |
| `O-05` | October | `snic/` | `./scripts/REBUILD_FROM_CLEAN.sh` | long / canonical historical build | `artifacts/verify.json`, `artifacts/solve_h2.json`, `receipts/VERIFY_SUMMARY.json`, `receipts/MERKLE.txt` | full October rebuild-and-seal protocol |
| `O-06` | October | `snic/` | `./scripts/REPORT.sh` | support / readout | stdout summary of verify, DEQ, CAD/SOS, lift, and bareiss sidecars | human-readable inspection after a run |
| `O-07` | October | `snic/` | `./scripts/run_dual_meru_cpu.sh` | medium harness | `artifacts/summary.json` after validating expected artifacts already exist | CPU-only harness once geometry, DEQ, resonance, corpus, and proofs already exist |
| `G-00` | Genesis | `00_GENESIS_ORGANISM/snic_workspace_a83f/` | `cargo build -p genesis_cli` | bootstrap | built `genesis_cli` | dependency fetch and CLI bring-up |
| `G-01` | Genesis | `00_GENESIS_ORGANISM/snic_workspace_a83f/` | `cargo run -p genesis_cli -- --protocol --runs 1 --output-dir audit/agent_single` | micro | `audit/agent_single/hashes.tsv`, `audit/genesis.log` | lowest-risk deterministic single-run replay |
| `G-02` | Genesis | `00_GENESIS_ORGANISM/snic_workspace_a83f/` | `cargo run -p genesis_cli -- --test-battery 5 --test-output-dir audit/test_cli` | medium | `audit/test_cli/hashes.tsv`, `audit/genesis.log` | canonical clean-state reproducibility battery |
| `G-03` | Genesis | `00_GENESIS_ORGANISM/snic_workspace_a83f/` | `cargo run -p genesis_cli -- --lineage-batch --lineage-output-dir audit/lineage_batch_phase1 --lineage-runs 3` | long | `audit/lineage_batch_phase1/hashes.tsv`, per-progeny `runNN.log`, `SUMMARY.md`, copied receipts | replay of the seven sealed Phase-1 progeny workspaces |
| `G-04` | Genesis | `00_GENESIS_ORGANISM/snic_workspace_a83f/` | `cargo run -p genesis_cli -- --validate --reference-dir audit/test_cli_full/run07` | micro / verification | validation verdict on an existing run directory | re-hash and verify an existing run against canonical hashes |
| `G-05` | Genesis | `00_GENESIS_ORGANISM/snic_workspace_a83f/` | `cargo run -p genesis_cli -- --audit-report audit/report.json --report-source audit/test_cli` | support / governance | `audit/report.json`, `audit/genesis.log` | governance summary for completed runs |
| `G-06` | Genesis | `00_GENESIS_ORGANISM/snic_workspace_a83f/` | `cargo run -p genesis_cli -- --progeny agent_demo` | exploratory support | `audit/progeny/agent_demo/`, `hashes.tsv` | tagged one-off progeny creation, not current acceptance authority |

## Receipt Surfaces That Matter

### October receipt surfaces

- `artifacts/verify.json`
- `artifacts/solve_h2.json`
- `artifacts/proofs/egraph_proof.json`
- `artifacts/proofs/dep_cert.json`
- `artifacts/proofs/yantra_GC_invariants.json`
- `receipts/VERIFY_SUMMARY.json`
- `receipts/MERKLE.txt`

### Genesis receipt surfaces

- `audit/<context>/hashes.tsv`
- `audit/genesis.log`
- `audit/<context>/<run>/runNN.log`
- `audit/<context>/<run>/MERKLE.txt`
- `audit/<context>/<run>/VERIFY_SUMMARY.json`
- `audit/report.json`
- `audit/<context>/SUMMARY.md`

## What Each Stratum Is Good For

### Best use of October now

- exact geometry bring-up
- exact-rational gate inspection
- substrate-level falsification
- recovering what the pre-hybrid DM3 could actually prove

### Best use of Genesis now

- deterministic replay doctrine
- reproducibility governance
- cross-platform battery structure
- ledger and audit discipline for the restart

## Known Limits

### October limits

- `REBUILD_FROM_CLEAN.sh` writes a realtime `ts_utc` into `receipts/VERIFY_SUMMARY.json`, so its receipt layer is weaker than the later Genesis canonicalisation discipline
- `run_dual_meru_cpu.sh` is a harness over pre-existing artifacts, not a full pipeline bring-up by itself
- the surviving October commands are CPU-first and do not establish a governed mobile GPU or NPU acceptance lane

### Genesis limits

- the protocol proves exact deterministic replay, not the missing hybrid DM3 architecture
- it expects exact-hash agreement across supported platforms; it does not preserve the manifesto's later non-bitwise-equivalence receipt logic as a source-backed restart-ready standard

### Shared limit

None of these recoverable entrypoints cover the compiled-only hybrid residue seen in `target/debug/dm3_runner`, including:

- `dm3_microtx`
- `dm3_hrm_bridge`
- `scar_engine`
- the later WGSL / Metal / WebGPU lane

Those remain recovery or rebuild targets, not current authority surfaces.

## RM10 Pro Bring-Up Order

The phone should inherit the legacy battery stack conservatively.

### Safe first

- `G-01` deterministic single run
- `G-04` validation of copied reference runs

### Safe next

- `G-02` clean-state reproducibility battery
- `O-01` Phase A geometry bring-up, if the toolchain and file layout are stable on-device

### Not yet authoritative

- any RM10 GPU-accelerated replay
- any NPU-assisted path
- any attempt to use the phone as proof of the missing hybrid layer

## Restart Rule

Phase 01 and later plans should build batteries by composing or adapting the entrypoints above.
If a proposed battery cannot be traced back to one of these surfaces or to a new source-backed command, it is not yet part of the governed restart.
