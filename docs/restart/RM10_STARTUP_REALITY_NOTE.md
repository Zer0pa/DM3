# RM10 Startup Reality Note

Last refreshed: `2026-04-05`

## Scope

This note records what was re-verified live during startup on `2026-04-05`
and what remains inherited from prior branch artifacts.

No new science run was executed for this note.

## Live Startup Facts Re-Verified In This Session

Commands used:

- `adb devices -l`
- `adb -s FY25013101C8 shell getprop ro.product.model`
- `adb -s FY25013101C8 shell getprop ro.hardware.vulkan`
- `adb -s FY25013101C8 shell getprop ro.hardware.egl`
- `adb -s FY25013101C8 shell 'ls -ld /data/local/tmp /data/local/tmp/dm3 /data/local/tmp/SoC_runtime/workspace'`
- `adb -s FY25013101C8 shell 'ls -l /data/local/tmp /data/local/tmp/SoC_runtime /data/local/tmp/SoC_runtime/workspace /data/local/tmp/dm3 /data/local/tmp/genesis_cli /data/local/tmp/dm3_runner /data/local/tmp/SoC_Harness/bin 2>/dev/null'`
- `adb -s FY25013101C8 shell dumpsys battery`
- `adb -s FY25013101C8 shell dumpsys thermalservice`
- `adb -s FY25013101C8 shell 'cat /proc/meminfo | sed -n "1,40p"'`

Confirmed live:

- repo root is `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform`
- git branch is `hypothesis/rm10-primary-platform-heterogeneous-learning`
- attached Android serial is `FY25013101C8`
- reported model is `NX789J`
- graphics properties are `ro.hardware.vulkan=adreno` and
  `ro.hardware.egl=adreno`
- `/data/local/tmp` exists and is writable by `shell`
- `/data/local/tmp/SoC_runtime/workspace` exists
- `/data/local/tmp/dm3` exists
- `/data/local/tmp/genesis_cli` exists
- `/data/local/tmp/dm3_runner` exists
- `/data/local/tmp/dm3/dm3_runner` exists
- `/data/local/tmp/SoC_Harness/bin` exists and still contains the wrapper
  toolchain surface
- current battery service reports `AC powered: true`, `level: 70`,
  `temperature: 290`
- current thermal service reports `Thermal Status: 0`
- current memory sample reports `MemAvailable: 13675052 kB`

## Inherited Branch Conclusions Still Governing Startup

These items remain branch truth, but they were not re-measured in this startup
probe:

- governed Genesis CPU control on `F1` remains `PASS` as the only trustworthy
  branch-local scientific instrument
- the current governed accelerator bridge on `F1` remains `CLOSED`
- `F2` remains separate residue `PASS` only at callable ceiling with
  `unstable_feasibility`
- NPU remains inventory-only and `ABSTAIN`
- explicit heterogeneous work remains `ABSTAIN`
- Mac Genesis remains the only `source_built` authority lane

Supporting branch sources:

- `.gpd/STATE.md`
- `docs/restart/ENGINEERING_GAP_LEDGER.md`
- `docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md`
- `docs/restart/phase_01_2_3_2_rm10_bridge_qualification_20260405/RM10_F1_ANCHOR_DOSSIER.md`

## Startup Truth By Lane

### `F1` governed CPU control

- live binary path: `/data/local/tmp/genesis_cli`
- live governed `cwd`: `/data/local/tmp/SoC_runtime/workspace`
- live wrapper family: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- retained governed anchor run ID:
  `branch_01_2_3_2_f1_cpu_a`

### `F2` callable residue

- live residue compare surface still exists at `/data/local/tmp`
- live residue binary path `/data/local/tmp/dm3_runner` still exists
- this is not the same path as the bundled archaeology target in
  `/data/local/tmp/dm3/dm3_runner`

### Bundled archaeology target

- bundled directory `/data/local/tmp/dm3` still exists
- bundled runner `/data/local/tmp/dm3/dm3_runner` still exists beside the
  preserved bundled assets
- present existence does not reopen routed `G2` success

## Facts Not Established By This Startup Probe

This startup note does not prove any of the following:

- fresh RM10 source parity
- a repaired default validator outcome
- a same-family accelerator-bearing `F1` bridge
- a callable NPU assist path
- an explicit heterogeneous handoff surface

## Bottom Line

The RM10 startup surface is live and stable now. The incomplete part is
receipt, checkpoint, Comet, and handoff hardening, not startup viability.
Trustworthy startup still requires the operator to keep the branch split exact:

- `F1` means `/data/local/tmp/genesis_cli` from
  `/data/local/tmp/SoC_runtime/workspace`
- `F2` means residue work only
- bundled `dm3` archaeology is separate from both

Presence on the device is not source parity, and RM10 executability is not a
license to widen authority claims.
