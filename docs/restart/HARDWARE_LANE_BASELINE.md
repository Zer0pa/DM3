# DM3 Hardware Lane Baseline

## Purpose

This note records the live hardware baseline for the current restart session.
It separates confirmed device facts from assumptions so the restart can plan batteries and pivots without pretending the phone already proves anything.

## Confirmed Device

Connected over ADB at capture time:

- model: `NX789J`
- product / device: `NX789J`
- manufacturer: `nubia`
- Android: `15`
- SDK: `35`
- ABI: `arm64-v8a`
- board platform: `sun`
- SoC manufacturer: `QTI`
- SoC model: `SM8750`
- graphics path indicators: `adreno` for EGL and Vulkan

ADB evidence:

- `adb devices -l` reports `NX789J`
- `getprop` reports `ro.hardware.egl = adreno` and `ro.hardware.vulkan = adreno`
- SurfaceFlinger reports `Adreno (TM) 830` and `OpenGL ES 3.2`

## Confirmed Capacity Signals

- total RAM visible to Linux: about `23.66 GB`
- available RAM during inspection: about `14.63 GB`
- swap total: about `12.58 GB`
- internal data/storage available: about `742 GB`

This means:

- storage is not the immediate bottleneck
- memory is large enough for meaningful micro-batteries and some longer on-device runs
- long runs still need thermal and determinism checks, not just free space

## Confirmed Software Signals

- `com.termux` is installed
- `com.openai.chatgpt` is installed
- developer settings enabled: `1`
- stay-awake while plugged in: `15`

This means the phone can be treated as an active execution target, not just a conceptual lane, and it is already in a usable developer posture for plugged-in long runs.

## Confirmed Compute-Lane Signals

### CPU

Confirmed:

- arm64 cores visible via `/proc/cpuinfo`
- modern instruction features visible, including `bf16`, `i8mm`, `asimd`, and `atomics`

CPU is the safest first phone-side execution lane for deterministic bring-up.

### GPU

Confirmed:

- Adreno graphics path present
- `/dev/kgsl-3d0` present
- Qualcomm GLES / Vulkan stack active

GPU is a real candidate lane for medium and long batteries if deterministic reduction order can be enforced.

### DSP / NPU-adjacent

Confirmed:

- thermal HAL exposes `nsp0` through `nsp6`
- CDSP and ADSP infrastructure present
- visible nodes include `fastrpc-cdsp`, `fastrpc-adsp-secure`, `glink_pkt_*_cdsp`, `remoteproc-cdsp-md`
- visible libraries include `libcdsprpc.so`, `libadsprpc.so`, `vendor.qti.hardware.dsp*`
- visible daemons include `adsprpcd`, `audioadsprpcd`, `cdsprpcd`, `dspservice`

Not yet confirmed:

- a usable DM3-facing user-space NPU path
- a supported Termux-side toolchain that can call the accelerator directly
- deterministic equivalence between any accelerator-assisted path and CPU baseline

So the correct current statement is:

`DSP / NPU-adjacent hardware is present, but a usable DM3 NPU lane is still unproven.`

## Thermal And Power Snapshot

Battery service at capture:

- AC powered: `true`
- battery level: `77%`
- battery temperature: `27.0 C`
- max charging current: `3000000`
- max charging voltage: `5000000`

Thermal service at capture:

- thermal status: `0`
- HAL ready: `true`
- skin temperature around `29.67 C`
- battery hot throttling threshold around `80 C`
- battery severe threshold around `90 C`
- skin hot thresholds begin around `48 C`

Implication:

- the device was in a safe baseline state during inspection
- long batteries should track skin temperature and thermal status, not just CPU and GPU telemetry
- Phase 4 and Phase 5 should include thermal abort / abstain rules

## Lane Interpretation For The Restart

### Safe now

- Mac CPU for source-backed baseline work
- RM10 CPU for phone bring-up and micro-batteries

### Plausible next

- Mac GPU / Metal for accelerated comparison runs
- RM10 GPU for replay once deterministic reduction rules are explicit

### Still speculative

- RM10 NPU-assisted projection or priming
- any claim that the phone's accelerator path is already the authoritative lane

## Immediate Implications For Phase 1

- The project should plan micro-batteries for RM10 CPU first.
- GPU should be treated as a governed acceleration lane, not assumed equivalent.
- NPU should stay in the branch register as a possible pivot, not as an accepted capability.
- Long-run planning must include thermal, checkpoint, and resume identity checks.

## Commands Used

- `adb devices -l`
- `adb shell getprop`
- `adb shell cat /proc/cpuinfo`
- `adb shell grep -E "MemTotal|MemAvailable|SwapTotal" /proc/meminfo`
- `adb shell df -h /data /storage/emulated/0`
- `adb shell dumpsys battery`
- `adb shell dumpsys thermalservice`
- `adb shell dumpsys SurfaceFlinger`
- `adb shell dumpsys package com.termux`
- `adb shell pm list packages`
- `adb shell ls /dev`
- `adb shell ls /vendor/lib64`
- `adb shell ls /vendor/bin`

## Working Rule

For now, the RM10 Pro is a confirmed execution target with strong CPU and GPU evidence, and only a possible NPU-assisted future lane.
Phase planning should treat NPU support as something to test, not something already owned.
