# Executive Summary

## What Was Achieved In This Thread

### 1. Operational Stability Was Restored

Emergency disk pressure on the MacBook Air was reduced by offloading large safe
trees to the attached RedMagic 10 Pro over ADB.
The offload receipt is:

- `/Users/Zer0pa/DM3/OFFLOAD_MANIFEST_20260405.md`

Documented result:

- free space improved from roughly `1.3 GiB` to roughly `25 GiB`

### 2. The Branch Now Has A Real Readiness Phase

The branch was moved off the stale “outlier first” route and onto a real
readiness gate:

- Phase `01.2.3.3`
- `RM10 Validator-Default Localization, F2 Root-Surface Repair, And Heterogeneous Brief Readiness`

This is now recorded in:

- `.gpd/ROADMAP.md`
- `.gpd/STATE.md`
- `.gpd/state.json`

### 3. The Live Validator Gap Was Localized

The retained validator probe showed:

- default validation fails on the historical RM10 parity witness
- explicit-hash validation passes on that same witness

This narrows the current problem to stale device-side default handling, not
generic bundle corruption.

Retained packet:

- `artifacts/rm10_validator_probe_20260405T132730Z/`

### 4. The Top-Level `F2` Root Problem Was Localized

The retained `F2` surface probe showed:

- the top-level `/data/local/tmp/dm3_runner` family has a hidden
  `RegionTags_v1.bin` dependency
- even with that dependency cleared, the top-level root family still stalls
  after resonance start
- the legacy `/data/local/tmp/dm3/dm3_runner` remains callable, but it is a
  separate surface and cannot substitute for the top-level root family

Retained packet:

- `artifacts/rm10_f2_surface_probe_20260405T132732Z/`

### 5. The Official `F2` Entry Point Now Fails Safely

The official `F2` outlier entrypoint was made governance-safe.
It no longer fails open.
It now writes a retained `BLOCKED` packet when the latest readiness probe says
the top-level root family is not ready.

Retained packet:

- `artifacts/rm10_f2_outlier_20260405T132921Z/`

### 6. Drift Was Reduced Aggressively

I deleted stale packs and stale cleanup/readiness theater surfaces that could
mislead operators or the science engineering team.
The dev workstream is now much closer to being the single canonical truth
surface.

## Executive Verdict

The thread succeeded as engineering readiness work.
It did not produce a new heterogeneous-compute claim.
It produced something better:

- exact localization of the live gate
- a controlled blocked boundary where the branch was previously vulnerable to
  drift
- a cleaner branch handoff surface for the team
