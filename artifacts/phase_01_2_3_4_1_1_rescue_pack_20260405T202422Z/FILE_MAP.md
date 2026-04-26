# Phase 01.2.3.4.1.1 Rescue Pack File Map

Rescue pack root: `artifacts/phase_01_2_3_4_1_1_rescue_pack_20260405T202422Z`

This pack is rescue-only. It is not part of the declared live execution path.

## Repo Snapshot

- `repo_snapshot/restart-hypothesis-rm10-primary-platform.tgz`
  Working-tree snapshot of the restart repo at the moment before cleanup.
- `repo_snapshot/branch.txt`
  Active branch name.
- `repo_snapshot/head.txt`
  HEAD commit recorded before cleanup.
- `repo_snapshot/git_status.txt`
  Dirty worktree status preserved as-received.
- `repo_snapshot/git_diff_stat.txt`
  Diff stat for tracked modifications.
- `repo_snapshot/git_diff_name_status.txt`
  File-level tracked diff inventory.
- `repo_snapshot/dirty_file_list.txt`
  Modified and untracked file list.

## Device Snapshot

### `device_snapshot/inventories`

- `precleanup_paths.txt`
  Pre-cleanup live-path inventory from the device.
- `precleanup_sha256sums.txt`
  Hashes for `genesis_cli`, both `dm3_runner` binaries, and key root assets.
- `precleanup_sizes.txt`
  Size summary for the main device surfaces.
- `f1_workspace_tree.txt`
  Governed `F1` workspace tree before cleanup.
- `raw_workspace_tree.txt`
  Raw-workspace witness tree inventory.
- `bundled_surface_tree.txt`
  Bundled archaeology tree inventory.
- `root_drift_candidates.txt`
  Root-level stale-output candidates identified before quarantine.
- `battery_precleanup.txt`
  Battery state before cleanup.
- `thermal_precleanup.txt`
  Thermal state before cleanup.
- `phase_01_2_3_4_1_1_rescue_*.out|err`
  `adb pull` receipts for the sealed rescue copy.

### `device_snapshot/f1_workspace`

- Pulled copy of `/data/local/tmp/SoC_runtime/workspace`, including the full
  pre-cleanup `audit/` tree.

### `device_snapshot/f1_runtime`

- `genesis_cli`
  Live governed device binary before cleanup.
- `bin/`
  Pulled copy of `/data/local/tmp/SoC_Harness/bin`.

### `device_snapshot/root_surface`

- `dm3_runner`
  Top-level residue runner preserved before cleanup.

### `device_snapshot/bundled_surface`

- Pulled copy of `/data/local/tmp/dm3`.

### `device_snapshot/raw_workspace_key_receipts`

- `receipts/`
  Raw-workspace receipt set.
- `artifacts/`
  Raw-workspace artifact set.
- `rm10_agent_single_android/`
  Key RM10 raw-workspace replay receipt anchor.
- `RedMagic_T1-T7_20251028T093042Z/`
  Historical RM10 parity receipt anchor.

## Recovery Rule

If later cleanup or bring-up invalidates the lane, restore from this pack
instead of reviving drift inside the declared live surface.
