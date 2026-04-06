# RM10 NPU Projection Probe Ledger

Last refreshed: `2026-04-06`

## Purpose

Freeze the bounded Plan 04 NPU assist verdict without letting inventory or a
tooling false positive inflate into an assist-lane claim.

## Bounded Role

Bounded assist role tested:

- user-space callable projection / priming / tagging probe

Missing-path criterion:

- no accelerator-specific executable candidate can be named and probed from
  user space under receipts

## Corrected Probe Packet

Retained packet:

- [phase_01_2_3_4_1_1_3_npu_probe_20260406T004820Z](/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_1_3_npu_probe_20260406T004820Z)

Superseded packet:

- `phase_01_2_3_4_1_1_3_npu_probe_20260406T004711Z`

Why superseded:

- the first pass used an over-broad matcher that treated `input` and `uinput`
  as `npu` hits
- the matcher was tightened and the probe was rerun

## Corrected Results

- verdict: `inventory_only`
- executable candidates: `0`
- bounded help probes: `0`
- library candidates:
  - `/vendor/lib64/libadsprpc.so`
  - `/vendor/lib64/libcdsprpc.so`
- matching service:
  - `vendor.qti.hardware.dsp.IDspService/default`

Visible process evidence remains accelerator-adjacent only:

- `adsprpcd`
- `cdsprpcd`
- `dspservice`
- CDSP / ADSP glink worker processes

## Interpretation

The device still exposes DSP / accelerator-adjacent infrastructure, but the
branch still does not have:

- an accelerator-specific user-space executable
- a bounded help-probe target
- receiptable assist-stage inputs and outputs

So the honest plan verdict is:

- `ABSTAIN`

not `PASS`, `FAIL`, or `BLOCKED`.

## Exact Ceiling

What this packet does prove:

- accelerator-adjacent libraries and services are present
- the device has a visible DSP service boundary

What it does not prove:

- a DM3-facing NPU lane
- a callable assist-stage path
- any CPU to NPU handoff artifact

## Verdict

Verdict: `ABSTAIN / inventory_only`

Reason:

- bounded callable path search found no accelerator-specific executable
- the earlier apparent positive was a matcher bug and has been explicitly
  superseded
