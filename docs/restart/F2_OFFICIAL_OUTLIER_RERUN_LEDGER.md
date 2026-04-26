# F2 Official Outlier Rerun Ledger

Last refreshed: `2026-04-05`

## Purpose

Freeze the fresh official same-family `F2` rerun for phase `01.2.3.4.1`
without narrating a partial packet as preserved observability.

## Fresh Phase-Local Packet

- Fresh packet:
  `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/`
- Prior official packet:
  `artifacts/rm10_f2_outlier_20260405T171018Z/`
- Observable contract:
  `docs/restart/OBSERVABLE_CONTRACT_NOTE.md`

The fresh rerun did not close a four-row governed packet. It blocked on the
final `cpu_b` row after reproducing a low/high/low split across the first three
rows.

## Locked-Identity Session Result

The retained session manifest in
`artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/identity/run_manifest.json`
keeps the exact row order:

1. `cpu_a`
2. `gpu_a`
3. `gpu_b`
4. `cpu_b`

The retained rows are:

- `cpu_a`
  - `decision=Commit`
  - `delta_E=75.4414`
  - `coherence=0.891960`
  - `duration_ms=57397`
- `gpu_a`
  - `decision=Commit`
  - `delta_E=88.7139`
  - `coherence=0.769979`
  - `duration_ms=74544`
- `gpu_b`
  - `decision=Commit`
  - `delta_E=76.1168`
  - `coherence=0.877275`
  - `duration_ms=98214`
- `cpu_b`
  - no retained JSON receipt
  - device output path was created as a zero-byte file
  - row command timed out at `180` seconds and the runner was terminated

The packet `OUTCOME.md` therefore records:

- `outcome_class=BLOCKED`
- `reason=row_cpu_b_failed`

## Handoff Boundary Note

The same-family boundary is still the official top-level
`/data/local/tmp/dm3_runner` CPU/GPU/GPU/CPU bracket, not the legacy
`/data/local/tmp/dm3/dm3_runner` surface.

The retained receipt schema for completed rows is still the same JSONL object
family used in prior packets:

- `decision`
- `delta_E`
- `coherence`
- `duration_ms`
- `episode`

Custody holds for the first three rows through retained row-level command files,
receipt files, metrics, and telemetry. Custody breaks on `cpu_b` because the
row never emitted a usable receipt.

## Observable Comparison Note

The anchor observable cannot pass because the CPU bracket never closed.

The drift observable also does not support a same-family PASS:

- `gpu_a` lands on the high cluster
  (`delta_E≈88.71`, `coherence≈0.7700`)
- `gpu_b` returns to the low cluster
  (`delta_E≈76.12`, `coherence≈0.8773`)

So even before `cpu_b` failed, the GPU rows were already not mutually stable on
the observable contract.

Thermal honesty does not rescue the packet:

- retained battery temperature stayed in the `33.0C` to `34.0C` range across
  the completed rows
- retained `thermal_status_pre` and `thermal_status_post` remain `0` on those
  rows

That means the packet does not support a clean thermal-throttling excuse for
the low/high/low split already visible before the final timeout.

## Exact Boundary Now Localized

The fresh rerun sharpens the same-family boundary to one narrower failure
pattern than the older `whole_session_instability` packet alone:

1. `cpu_a` still reproduces the low anchor-like state.
2. `gpu_a` still reaches the high state.
3. `gpu_b` now falls back toward the low state.
4. the final `cpu_b` row can stall long enough to leave only a zero-byte output
   path under the current `180` second ceiling.

So the official same-family surface still does not preserve one honest
observable, and the break is now visible as a low/high/low sequence followed by
late-session receipt loss.

## Verdict

Verdict: `ABSTAIN`

Why:

- the packet does not preserve full row-by-row custody through `cpu_b`
- the CPU anchor cannot be measured honestly because the closing CPU row is
  absent
- the GPU rows already disagree with each other on the same receipt schema

This is not a same-family `PASS`.
This is not a clean same-family `FAIL` either, because the final anchor did not
complete under custody.

## Next Admissible Move

Do not reopen heterogeneous work from this packet.

The next admissible same-family move is one more locked-identity replay of the
same CPU/GPU/GPU/CPU bracket with:

- the same branch
- the same binary
- the same cwd
- the same assets
- the same row order
- the same observable contract
- a timeout and periodic telemetry policy strong enough to decide whether the
  `cpu_b` break is a true late-session hang or only a `180` second wrapper
  ceiling defect
