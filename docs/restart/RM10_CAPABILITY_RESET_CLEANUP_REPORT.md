# RM10 Capability Reset Cleanup Report

## Scope

Wave 1 cleanup and bring-up for Phase `01.2.3.4.1.1-01`.

Objective: seal one rescue boundary, reduce the RM10-primary live story to one
honest `F1` execution lane, and prove that the cleaned lane still boots without
reusing quarantined outputs.

## Outcome

- Rescue pack sealed at
  `artifacts/phase_01_2_3_4_1_1_rescue_pack_20260405T202422Z`
- Quarantine boundary created at
  `/data/local/tmp/phase_01_2_3_4_1_1_quarantine_20260405T202459Z`
- Cleaned smoke packet captured at
  `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z`
- Cleaned `F1` boot: `PASS` from the declared live path
- Default validator repair: still `BLOCKED`; explicit-hash validation remains
  the honest telemetry route

## Kept Live

- RM10 execution root: `/data/local/tmp`
- Live RM10 workspace root: `/data/local/tmp/SoC_runtime/workspace`
- Live launcher: `/data/local/tmp/genesis_cli`
- Live wrapper surface: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- Live output root: `/data/local/tmp/SoC_runtime/workspace/audit`
- Current live output leaf:
  `/data/local/tmp/SoC_runtime/workspace/audit/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z`
- Mac support root:
  `/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f`

## Rescue Boundary

The rescue pack preserves:

- the current repo working-tree snapshot
- the governed `F1` workspace and runtime
- the top-level residue runner and bundled archaeology directory
- key raw-workspace receipts and historical RM10 witness anchors
- pre-cleanup hashes, trees, sizes, and battery/thermal inventories

The pack is marked rescue-only via
`artifacts/phase_01_2_3_4_1_1_rescue_pack_20260405T202422Z/FILE_MAP.md`.

## Quarantined

Moved into
`/data/local/tmp/phase_01_2_3_4_1_1_quarantine_20260405T202459Z`:

- `62` root-surface stale outputs, probe receipts, root-level logs, clean-room
  probe directories, and prior residue capture packets
- `12` prior `F1` audit entries, including the old `genesis.log` and all
  pre-cleanup governed audit run directories

Preserved but declared non-live:

- `/data/local/tmp/snic_workspace_a83f` raw-workspace witness lane
- `/data/local/tmp/dm3_runner` top-level residue runner
- `/data/local/tmp/dm3` bundled archaeology directory

These surfaces were not used for the Wave 1 bring-up.

## Deleted

None. Cleanup used quarantine only.

## Cleaned Bring-Up

Exact command:

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z'
```

Observed result:

- protocol exit `0`
- pull-back exit `0`
- default validation exit `1`
- explicit-hash validation exit `0`
- `verify.json = f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`
- `solve_h2.json = a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- battery level `61 -> 61`
- battery temperature `340 -> 340`
- thermal status `0 -> 0`

Smoke evidence lives in:

- `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/README.md`
- `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/identity/run_identity.json`
- `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z/live_surface_post.txt`

## Remaining Worries

- The cleaned lane still inherits the stale compiled default-validator target,
  so cleanup did not and should not manufacture a default-validation pass.
- The raw-workspace and residue families remain present on-device for history
  and later bounded work; they must stay outside the live `F1` story.
- Because `genesis_cli` is still a prebuilt-backed binary, hidden fallback
  logic inside the binary cannot be ruled out by path cleanup alone.
