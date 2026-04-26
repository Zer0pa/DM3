# Narrow Heterogeneous Abstain Packet

The fresh official same-family rerun at
`artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/` did not return a
same-family `PASS`.

It reproduced a low/high/low split across `cpu_a`, `gpu_a`, and `gpu_b`, then
timed out on `cpu_b` and left a zero-byte output path instead of a closing CPU
receipt.

That means no preserved same-family observable survives honestly enough to
justify even one narrow heterogeneous split. This packet freezes the correct
verdict: `heterogeneous_handoff_verdict=ABSTAIN`.
