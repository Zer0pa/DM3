# RM10 NPU Triage Dossier

## Verdict

- `npu_triage_verdict=ABSTAIN`
- `surface_class=inventory_only`

## What Exists

The phase retained real accelerator-adjacent inventory:

- `/dev` surfaces: `fastrpc-adsp-secure`, `fastrpc-cdsp`, `fastrpc-cdsp-secure`, `glink_pkt_ctrl_cdsp`, `glink_pkt_data_cdsp`, `remoteproc-adsp-md`, `remoteproc-cdsp-md`
- libraries: `libQnnHtp.so`, `libQnnHtpNetRunExtensions.so`, `libQnnHtpPrepare.so`, `libQnnHtpProfilingReader.so`, `libQnnHtpV79.so`, `libQnnSystem.so`, `libadsprpc.so`, `libcdsprpc.so`
- daemons and services: `adsprpcd`, `audioadsprpcd`, `cdsprpcd`, `dspservice`, `sscrpcd`

## What Does Not Exist

The bounded command probe found no callable path for:

- `qnn-net-run`
- `qnn-context-binary-generator`
- `qnn-profile-viewer`
- `qnn-op-package-generator`
- `fastrpc_shell`

The bounded path search also found no searchable device-local CLI on:

- `/system/bin`
- `/system_ext/bin`
- `/vendor/bin`
- `/vendor/bin/hw`
- `/product/bin`
- `/odm/bin`
- `/data/local/tmp`

## Why The Verdict Is `ABSTAIN`

This phase found inventory and vendor infrastructure, but no branch-grade
user-space assist command with:

- a named bounded role
- receiptable inputs
- receiptable outputs
- a CPU-governed comparison surface

That keeps the branch below `PASS` and below `FAIL`. The honest result is
inventory-only `ABSTAIN`.

## Thermal And Battery Envelope

- battery level: `80%` before and after
- battery temperature: `33.0 C` before and after
- thermal status: `0` before and after

## Conclusion

The RM10 still shows real NPU or DSP-adjacent infrastructure. The branch still
cannot name a callable NPU assist path honestly. No NPU promotion is justified.
