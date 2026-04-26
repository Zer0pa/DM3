# Phase 01.2.3.4.1.1 Cleanup Smoke

Artifact root: `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z`

## Declared Live Lane

- Device: `FY25013101C8` (`NX789J`)
- Workspace: `/data/local/tmp/SoC_runtime/workspace`
- Launcher: `/data/local/tmp/genesis_cli`
- Wrapper surface: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- Device output dir: `audit/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z`

## Exact Command

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z'
```

## Result

- Protocol exit: `0`
- `adb pull` exit: `0`
- Default validation exit: `1`
- Explicit-hash validation exit: `0`
- `verify.json` SHA-256: `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1`
- `solve_h2.json` SHA-256: `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364`
- Canonical validation mode: `explicit_hash`

## Telemetry

- Battery pre/post: level `61 -> 61`, temperature `340 -> 340`
- Thermal pre/post status: `0 -> 0`

## Interpretation

The cleaned `F1` lane booted from the declared live path only. The lane still
inherits the known stale compiled default-validator target, so the honest route
outcome remains `explicit_hash` rather than a repaired default pass.
