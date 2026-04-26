# F2 Toplevel Instability Ledger

Last refreshed: `2026-04-05`

## Purpose

Freeze the top-level same-family `F2` instability for phase `01.2.3.4.1` under
locked identity, without falling back to the legacy residue surface or
pretending that simple callability is stability.

## Fresh Phase-Local Packet

- Fresh packet:
  `artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/`
- Prior retained packet:
  `artifacts/rm10_f2_surface_probe_20260405T170543Z/`
- Prior official same-family outlier packet:
  `artifacts/rm10_f2_outlier_20260405T171018Z/`

The fresh packet adds:

- pre and post battery snapshots
- pre and post thermal snapshots
- retained help output for both the top-level and legacy runners
- retained required-path listing, including missing paths

## Locked-Identity Findings

The top-level same-family surface is still callable on its own boundary:

- `root_cpu_default`
  - `classification=callable`
  - `delta_E=75.2957`
  - `coherence=0.877630`
  - `duration_ms=54278`
- `root_cpu_explicit_assets`
  - `classification=callable`
  - `delta_E=88.9966`
  - `coherence=0.770491`
  - `duration_ms=73053`

The cleanroom dependency split also remains real:

- `cleanroom_minimal_cpu`
  - `classification=missing_ambient_dependency`
  - exits immediately with `os error 2`
- `cleanroom_regiontags_v1_cpu`
  - `classification=callable`
  - `delta_E=88.9451`
  - `coherence=0.770185`
  - `duration_ms=79968`

The legacy runner remains callable as a separate surface only:

- `legacy_dm3_gpu_train`
  - `classification=callable`
  - `decision=Retry`
  - `delta_E=0.002055872`
  - `coherence=0.154882`
  - `duration_ms=164`

## Exact Runtime Boundary Now Localized

The fresh packet sharpens the instability into two exact boundary facts.

### 1. Startup dependency boundary still exists

`cleanroom_minimal_cpu` still fails on a missing ambient dependency, while
adding back `RegionTags_v1.bin` is enough to make the cleanroom callable.

That means the top-level runner is still not hermetic. At least one undeclared
ambient dependency remains real on the top-level family.

### 2. Same-family runtime split now appears inside the callable boundary

The fresh top-level packet does not reproduce the old near-equivalence between
`root_cpu_default` and `root_cpu_explicit_assets`.

Instead:

- the default top-level CPU row lands on the low cluster
  (`delta_E≈75.30`, `coherence≈0.878`)
- the explicit-assets top-level CPU row lands on the high cluster
  (`delta_E≈89.00`, `coherence≈0.770`)
- the cleanroom `RegionTags_v1` row also lands on the high cluster
  (`delta_E≈88.95`, `coherence≈0.770`)

So the remaining same-family instability is no longer just "can the root
runner start?" It now includes a live split inside the callable top-level
surface between:

- a low CPU anchor-like state
- a high CPU state that matches the earlier same-family instability family

## Required-Path Listing

The fresh retained path listing records:

- present:
  - `/data/local/tmp/SriYantraAdj_v1.bin`
  - `/data/local/tmp/RegionTags_v1.bin`
  - `/data/local/tmp/RegionTags_v2.bin`
  - `/data/local/tmp/RegionTags_v2.json`
  - `/data/local/tmp/data/xnor_train.jsonl`
- missing:
  - `/data/local/tmp/PhonemePatterns_v1.bin`

The help output confirms that `dm3_runner` still advertises
`PhonemePatterns_v1.bin` as the default patterns file.

This does not yet prove that the missing patterns file is the sole cause of the
same-family split. It does prove that the current top-level identity packet was
missing a declared default sidecar and that the phase must keep it visible.

## Run-To-Run Classification

Classification: `unstable_but_localized`

What is repaired:

- top-level callability remains real on `/data/local/tmp/dm3_runner`
- the cleanroom startup gate is still sharply tied to undeclared ambient
  dependencies and specifically to `RegionTags_v1.bin`

What is not repaired:

- the callable top-level same-family surface still splits between incompatible
  low and high CPU states under nominally equivalent invocations
- the exact driver of that low/high split is not yet eliminated

## Exact Boundaries That Now Matter

The next same-family rerun must keep these distinctions visible:

1. default top-level CPU invocation
2. explicit-assets top-level CPU invocation
3. cleanroom plus `RegionTags_v1.bin`
4. official CPU/GPU/GPU/CPU same-family outlier session

If the official rerun reproduces the high cluster while a fresh default root
row reproduces the low cluster, drift is entering between the callable top-level
surface and the official same-family bracket, not before startup.

## Verdict

Verdict: `sharply_localized_not_stable`

The top-level same-family `F2` surface is callable, but it is not yet stable
enough to claim a preserved observable. The instability is now sharply bounded
to:

- undeclared ambient dependency at startup outside cleanroom
- plus an internal same-family split between low and high CPU states inside the
  callable top-level boundary

## Next Admissible Move

The next admissible move is the official same-family outlier rerun under the
phase `01.2.3.4.1` observable contract, using this ledger as the runtime
boundary note.

