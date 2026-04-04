# DM3 Project And Workstream Tests Summary

**Date:** 2026-04-04

## Exact Phase Verdict

- `phase_outcome=PASS`
- `route_outcome=FAIL`
- The preserved bundled G2 family is retired on the current callable same-binary surface.
- The blocker is no longer "which same-binary route should we try?"; it is whether the historical bundled G2 residue belongs to a neighboring launcher generation or requires explicit redevelopment.

## Scope

This summary covers the decisive restart tests and result classes through Phase
`01.2.3`.
It names what passed, what failed, what remains abstained, and what the current
evidence ceiling still forbids.

## Topline Status

- Source-backed Double Meru geometry probe: `PASS`
- Mac Genesis witness floor executability: `PASS`
- Mac Genesis repeatability battery: `PASS`
- October smoke / proof-harness replay: `PASS`
- Genesis documented-canonical agreement on `verify.json`: `FAIL`
- Historical RM10 Mac-parity witness lane: `PASS` historically, but current
  default validator still rejects its `verify.json`
- Fresh RM10 SoC witness lane: `PASS` for executability, `FAIL` for default
  validation, `PASS` for explicit-hash validation, `ABSTAIN` on source-build
  parity
- Fresh RM10 raw-workspace witness lane: `PASS` for executability, `FAIL` for
  default validation, `PASS` for explicit-hash validation, `ABSTAIN` on Mac
  parity
- Fresh RM10 root hybrid micro probe: `PASS` for launch and receipt capture,
  `FAIL` as evidence for a meaningful current GPU split
- Fresh bundled `G2` bounded attempt: `PASS` for bounded execution,
  `FAIL` for living non-stub recovery, `PASS` for exact blocker proof
- Phase `01.2.3` same-binary route archaeology: `PASS` at the phase level,
  `FAIL` at the route level, with exact retirement proof for the current
  callable same-binary surface

## Decisive Test And Run Inventory

| ID | Class | Scope | Current result | Key evidence anchors |
| -- | ----- | ----- | -------------- | -------------------- |
| T-01 | Double Meru geometry probe | Fresh source-backed geometry reconstruction via `dual_cli` | `PASS`: all five geometry gates passed and `proof_ok = true` | `docs/restart/DOUBLE_MERU_GEOMETRY_DOSSIER.md`; `artifacts/double_meru_geometry_probe_20260403/*` |
| T-02 | Mac Genesis `G-01` replay | Fresh deterministic witness replay on Mac | `PASS`: `verify = e894...`, `solve = 62897...` | `artifacts/mac_replay/ledger.md` |
| T-03 | Mac Genesis `G-02` repeated battery | Five-run repeatability battery on Mac | `PASS`: all five runs identical at `verify = e894...`, `solve = 62897...` | `artifacts/mac_replay/ledger.md`; `artifacts/mac_replay/genesis_g02_20260403/*` |
| T-04 | October smoke replay | Fresh smoke/proof harness on recoverable October workspace | `PASS`: `gates_ok = true`, `cad_sos_present = true` | `artifacts/mac_replay/ledger.md`; `artifacts/mac_replay/october_smoke_20260403/*` |
| T-05 | Historical RM10 Mac-parity witness | Historical native RM10 Genesis lane compared against fresh Mac | `PASS` historically: old RM10 hashes match fresh Mac `e894...` / `62897...` | `artifacts/rm10_replay/ledger.md`; `artifacts/rm10_replay/historical_t1_t7_20251028/*` |
| T-06 | Fresh RM10 SoC runtime witness lane | Fresh ADB-shell governed replay using `genesis_cli` and SoC runtime workspace | `PASS` executable, `FAIL` default validation, `PASS` explicit-hash validation, `ABSTAIN` source-build parity | `artifacts/rm10_replay/ledger.md`; `docs/restart/RUN_LEDGER_20260403_LONG_HORIZON.md`; `artifacts/long_horizon_bootstrap_20260403/rm10_genesis_g01/*` |
| T-07 | Fresh RM10 raw Genesis workspace lane | Fresh ADB-shell replay against the raw workspace with reversible Android script adaptation | `PASS` executable, `FAIL` default validation, `PASS` explicit-hash validation, `ABSTAIN` Mac parity | `artifacts/rm10_replay/ledger.md`; `artifacts/rm10_replay/raw_genesis_g01_20260403/*` |
| T-08 | Host late-hybrid smoke lane | Current compiled host `dm3_runner` callability from the late hybrid residue | `PASS` for smoke-level callability, `ABSTAIN` for substantive semantics | `authority-pack-dm3-hybrid-20260403/070_RUN_LEDGER.md`; `docs/restart/DOUBLE_MERU_RUNTIME_TRUTH_TABLE.md` |
| T-09 | Fresh RM10 root hybrid micro probe | Root `/data/local/tmp/dm3_runner` default vs `--cpu` on the attached RM10 | `PASS` for launch and receipt capture, `FAIL` as evidence for a distinct current GPU path, smoke-only result retained | `docs/restart/RUN_LEDGER_20260403_LONG_HORIZON.md`; `docs/restart/THERMAL_AND_TELEMETRY_LEDGER.md` |
| T-10 | Fresh bundled `G2` bounded attempt | Official Phase `01.2.2` call against `/data/local/tmp/dm3/dm3_runner` with explicit tags and adjacency | `PASS` for bounded execution, `FAIL` for living non-stub recovery, `PASS` for exact blocker proof | `docs/restart/BOUNDED_NON_STUB_RECOVERY_LEDGER.md`; `artifacts/phase_01_2_2_non_stub_attempt_20260403/*` |
| T-11 | Phase `01.2.3` same-binary route close | Bundled runner route census plus retirement packet and verdict | `phase_outcome=PASS`, `route_outcome=FAIL`: exact retirement proof for the current callable same-binary surface | `.gpd/phases/01.2.3-g2-invocation-surface-archaeology-and-router-recovery/01.2.3-01-SUMMARY.md`; `.gpd/phases/01.2.3-g2-invocation-surface-archaeology-and-router-recovery/01.2.3-02-SUMMARY.md`; `docs/restart/phase_01_2_3_execution_prep_20260404/G2_SAME_BINARY_ROUTE_VERDICT.md` |

## Derived Results

### 1. Runtime truth

- The geometry probe and Mac Genesis witness lane remain the strongest current
  authority surfaces.
- Fresh RM10 witness lanes are real but still governed and non-sovereign.
- Root and bundled hybrid runners remain archaeology-class surfaces.

### 2. Final Phase `01.2.3` result class

- `phase_outcome=PASS` because the phase answered the same-binary route question
  exactly.
- `route_outcome=FAIL` because no approved same-binary non-smoke `G2` route
  survives on `/data/local/tmp/dm3/dm3_runner`.
- The preserved bundled G2 family is retired on the current callable
  same-binary surface.

### 3. Later-lane ceiling

- RM10 GPU is not ready now.
- RM10 NPU remains feasibility-only.
- Heterogeneous embodiment remains premature.

## Current Blockers And Gaps

- The blocker is no longer "which same-binary route should we try?"; it is
  whether the historical bundled G2 residue belongs to a neighboring launcher
  generation or requires explicit redevelopment.
- The authoritative Genesis `verify.json` target is still unresolved across the
  fresh Mac lane, the historical RM10 parity lane, and the newer phone-local
  lanes.
- Fresh RM10 replay lanes still do not justify source-built parity.
- No governed GPU lane has been re-established.
- No restart-grade user-space NPU path has been recovered.
- No claim of full field-computer proof is justified yet.

## Current Bottom Line

The restart is no longer blocked on whether the object exists, whether the
witness floor is real, or whether a same-binary bundled `G2` route still needs
more route hunting.

It is blocked on:

1. launcher-generation versus redevelopment classification for the historical
   bundled `G2` residue
2. witness-lane canonical governance and source-build classification

That is the current authority-preserving next gate.
