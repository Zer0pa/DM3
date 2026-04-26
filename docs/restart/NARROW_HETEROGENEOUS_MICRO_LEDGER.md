# Narrow Heterogeneous Micro Ledger

Last refreshed: `2026-04-05`

## Purpose

Freeze the narrow heterogeneous verdict for phase `01.2.3.4.1` without forcing
execution after a same-family `ABSTAIN`.

## Upstream Gate

The heterogeneous gate did not reopen in this phase.

Upstream evidence:

- observable contract:
  `docs/restart/OBSERVABLE_CONTRACT_NOTE.md`
- official same-family rerun ledger:
  `docs/restart/F2_OFFICIAL_OUTLIER_RERUN_LEDGER.md`
- official same-family rerun packet:
  `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/`

That rerun returned an honest same-family verdict of `ABSTAIN` because:

- `gpu_a` and `gpu_b` already disagreed on the fresh receipt schema
- the final `cpu_b` row timed out
- the packet ended with a zero-byte device output path instead of a receipted
  closing CPU anchor

## Split-Boundary Note

No heterogeneous split boundary is admissible yet.

The phase therefore retains an explicit abstain packet instead of running:

- no CPU authority path with GPU-bounded substage
- no NPU-assisted projection or priming step
- no opaque multi-accelerator execution

## Preserved-Observable Comparison Note

No heterogeneous comparison is honest until the same-family surface first
preserves the observable contract on its own boundary.

The missing prerequisite is not merely “more runtime.” It is a same-family
packet that:

- closes the CPU bracket under custody
- keeps the GPU rows mutually consistent
- shows where drift enters if drift appears

The fresh official rerun did not meet those conditions.

## Drift-Localization Note

The live drift truth remains upstream and same-family-local:

- low `cpu_a`
- high `gpu_a`
- low `gpu_b`
- missing `cpu_b` receipt after timeout

That means drift still enters before any honest heterogeneous split can even be
named.

## Final Verdict

Verdict: `ABSTAIN`

The fresh abstain packet is:

- `artifacts/phase_01_2_3_4_1_heterogeneous_micro_20260405T184748Z/`

No heterogeneous execution was run in this packet. That is the correct result.

## Next Admissible Move

Keep heterogeneous compute fenced.

The next admissible move is to close the same-family late-session `cpu_b`
boundary on the top-level `F2` surface first, under the same observable
contract and without changing the family.
