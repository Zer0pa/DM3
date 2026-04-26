# NPU Abstain Justification Note

Last refreshed: `2026-04-05`

## Current Verdict

- `npu_triage_verdict=ABSTAIN`
- `surface_class=inventory_only`

## What The Branch Really Has

The branch has real NPU or DSP-adjacent inventory:

- `fastrpc*`, `glink*cdsp*`, and `remoteproc*` device surfaces
- `libQnnHtp*`, `libQnnSystem.so`, `libadsprpc.so`, and `libcdsprpc.so`
- `adsprpcd`, `audioadsprpcd`, `cdsprpcd`, `dspservice`, and `sscrpcd`

That is evidence of infrastructure, not evidence of a callable branch-grade
assist lane.

## What The Branch Does Not Have

The current evidence does not show:

- a user-space callable assist command
- a named bounded assist role tied to a DM3 observable family
- receiptable inputs and outputs for an assist stage
- a CPU-governed comparison surface that can audit the assist result
- a preserved artifact chain for an NPU-assisted substage

## Why The Honest Verdict Is `ABSTAIN`

`ABSTAIN` is the correct result because the branch has not reached a real
callable assist test. The evidence is stronger than "nothing exists," so `FAIL`
would overstate the case. The evidence is weaker than "a bounded assist path is
callable and auditable," so `PASS` would be inflated.

Inventory without callable, receiptable execution stays below both `PASS` and
`FAIL`.

## What Would Be Required To Reopen The Question

Any future NPU or DSP revisit must present all of the following before the
verdict can move:

- one exact user-space command or API invocation that is callable now
- one named bounded assist role, such as preprocessing or tagging, declared in
  advance
- mirrored inputs and outputs preserved under repo artifact custody
- a CPU-governed comparison note showing that the final observable remains
  auditable
- exact identity, telemetry, and receipt capture for the assist run

Without those items, the verdict remains `ABSTAIN`.

## Explicit Non-Promotions

None of the following justifies an NPU claim beyond `ABSTAIN`:

- vendor libraries on disk
- visible RPC daemons
- thermal or service telemetry
- an opaque vendor stack with no bounded DM3 role
- rhetoric that treats inventory as bridge progress for `F1`

## Boundary Consequence

NPU work remains outside the live branch programme until a receiptable callable
assist path exists. Current evidence does not genuinely support more.
