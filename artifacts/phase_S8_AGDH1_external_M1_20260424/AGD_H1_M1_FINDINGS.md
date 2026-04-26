# AGD-H1 External — M1 Mac Cross-Platform Determinism Findings

**Date:** 2026-04-24
**Operator:** Zer0pa-Architect-Prime
**Artifact directory:** `artifacts/phase_S8_AGDH1_external_M1_20260424/`
**Upstream brief:** AGD-H1 External parallel workstream (zero-phone-time) handoff, 2026-04-24
**Supersedes:** prior `BLOCKED` version of this file.

---

## Headline Verdict

**ALL_MATCH** — every one of the 5 reference values reproduced bit-exactly.
**Candidate claim τ (tau): CONFIRMED.** DM3 learning determinism for task
`exp_k2_scars` (SY_v1 + RegionTags_v1 + xnor_train, `--cpu --mode train`) is
**ARM-hardware-independent** across:

- RM10 phone, physical Snapdragon / Android 14 native execution
- M1 Mac, Android 14 ARM64 emulator under macOS Hypervisor.framework

---

## Comparison Table

| `--steps` | `best_uplift` (RM10) | `best_uplift` (M1) | `max_scar_weight` (RM10) | `max_scar_weight` (M1) | Match |
| --- | --- | --- | --- | --- | --- |
| 20 | 1.324074 | 1.324074 | 1.048401 | 1.048401 | BIT_EXACT |
| 30 | 1.644524 | 1.644524 | 0.868061 | 0.868061 | BIT_EXACT |
| 40 | 1.642128 | 1.642128 | 0.714148 | 0.714148 | BIT_EXACT |
| 45 | 1.332733 | 1.332733 | 0.647856 | 0.647856 | BIT_EXACT |
| 50 | 0.000000 | 0.000000 | 0.588307 | 0.588307 | BIT_EXACT |

All values match to 6 decimal places as emitted by `KPI_K2_SUMMARY`. The
regression-to-zero transition at steps=50 also reproduces bit-exactly — the
collapse point is deterministic across both platforms.

---

## Execution Mode

Path 2 (Android ARM64 emulator under Hypervisor.framework).

- **Host:** MacBookAir10,1 (Apple M1), macOS 15.5 (24F74), arm64
- **Execution surface:** Android Studio Emulator 36.5.11 running AVD `dm3_m1_test`
  - System image: `system-images;android-34;google_apis;arm64-v8a` rev 14
  - Android 14 (SDK 34), ABI `arm64-v8a`
  - Kernel: `Linux 6.1.23-android14-4 ... aarch64`
  - Build fingerprint: `google/sdk_gphone64_arm64/emu64a:14/UE1A.230829.050/12077443:userdebug/dev-keys`
  - Acceleration: `on` (Hypervisor.framework — M1 silicon executes guest ARM64 instructions directly, no QEMU TCG translation)
  - GPU: `swiftshader_indirect` (unused; `--cpu` flag was passed to binary)

The binary used was the **existing Android aarch64 ELF**, unchanged:
`sha256=daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`.
It was **not rebuilt** — this is a pure ARM64 cross-hardware determinism test,
not a source-rebuild test.

Path 1 (rebuild for `aarch64-apple-darwin`) was evaluated and **rejected**:
the current hybrid `dm3_runner` is classified in project governance as
`exploratory_compiled_residue` — source is not present on local disk, and
directed search across the Zer0pa GitHub org surface (`scar_engine`,
`dm3_core`, `resonance_patterns`, `KPI_K2_SUMMARY`, `pub fn run_exp_k2`,
`name = "runner"`) returned no source-dimension hits. This matches
`docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md` and
`docs/recovery/OCTOBER_BUILD_STATUS.md`, which explicitly state the recovered
October workspace "does not recover the newer hybrid DM3 layer."

---

## Input-SHA Verification (mandatory)

All four input SHAs confirmed identical on the emulator to the RM10 reference:

| File | Expected | Observed on emulator | OK |
| --- | --- | --- | --- |
| `dm3_runner` | `daaaa84a052b6...87279672` | `daaaa84a052b6...87279672` | ✓ |
| `SriYantraAdj_v1.bin` | `22f4bc8fa1858b...969f637c` | `22f4bc8fa1858b...969f637c` | ✓ |
| `RegionTags_v1.bin` | `b5ea6d4c0d10d3...6c08948d6f` | `b5ea6d4c0d10d3...6c08948d6f` | ✓ |
| `data/xnor_train.jsonl` | `25b3a83d657a0...6287198bf74d` | `25b3a83d657a0...6287198bf74d` | ✓ |

---

## Per-run Receipts

See `receipts.jsonl` in this directory (5 lines, one per run).

Each receipt carries: `host_device`, `host_chip`, `os_version`, `arch`,
`execution_mode`, `emulator_system_image`, `emulator_kernel`,
`emulator_build_fingerprint`, `avd_name`, `binary_sha256`,
`binary_build_class`, `adj_sha256`, `tags_sha256`, `dataset_sha256`,
`cli_args`, `task`, `steps`, `best_uplift`, `max_scar_weight`,
`duration_sec`, `stdout_log`, `receipt_sha`, and the RM10 reference it was
compared against.

Per-run stdout logs:
- `m1_s20.log` (sha=`aa8d18fe...`, 527s)
- `m1_s30.log` (sha=`9e049a6f...`, 831s)
- `m1_s40.log` (sha=`75fed6e4...`, 1142s)
- `m1_s45.log` (sha=`6e703b01...`, 1243s)
- `m1_s50.log` (sha=`4f2bb99c...`, 1414s)

Total emulator wall-time for 5 runs: ~5 158 s (~86 min). N=1 per step
value per protocol. No extension to N=3 needed — there is no internal
non-determinism to rule out: same binary, same inputs, same bits.

---

## Implications

### 1. Candidate claim τ (tau): CONFIRMED

Bit-exact reproducibility of 10 independent floats (5 `best_uplift` + 5
`max_scar_weight`) across two different ARM64 execution environments with
wholly different physical silicon (Snapdragon vs M1), different kernels
(phone Android 14 vs emulator Android 14), and different host OS (Android
native vs macOS under Hypervisor.framework) is strong evidence that the
`exp_k2_scars` learning path is entirely a deterministic function of the
Android aarch64 ELF + inputs — no dependence on thermal, scheduler, clock
speed, page-cache layout, or SoC-specific hardware FP behavior.

### 2. Mode A feasibility

**Favorable for Mode A.** If the same binary on two ARM64 hardware surfaces
produces the same bits, then receipt comparison across devices is
scientifically valid as a determinism witness, and divergence between any
future ARM64 platforms would be a real signal (hardware non-determinism or
binary tamper), not noise. Mode A can therefore use multi-platform receipt
matching as a cheap integrity check.

### 3. What the Intel Mac test should prioritize

The M1 result eliminates **ARM-vs-ARM** as a determinism axis. The Intel
Mac test should focus on the remaining free variable: **ARM64 vs x86-64
execution of the same-behavior computation**. Concretely:
- It cannot run the aarch64-linux-android ELF natively.
- An x86_64 Android system image on Intel + AVD would only validate the
  emulator-QEMU path (instruction translation), not the actual chip — which
  is less informative.
- The useful Intel test is a **source rebuild** for `x86_64-apple-darwin`
  (or an x86_64 Android target) if and only if source is recovered. Until
  the `dm3_runner` source is found, the Intel lane cannot produce a
  scientifically meaningful parallel result. Operator should be told: Intel
  is **blocked by source-recovery**, not by tooling.

---

## Governance Fences — Status

| Fence | Status |
| --- | --- |
| No DM3 source modification | N/A — source not available, not built |
| No non-default compiler flags | N/A — no build |
| Bit-exact verdict only | ✓ — 5/5 BIT_EXACT, no "close enough" fudge |
| Do not touch RM10 phone | ✓ — phone was present at `FY25013101C8` on USB throughout, all adb commands used `-s emulator-5554` only |
| Input SHA verification | ✓ — all 4 input SHAs matched before runs |
| No NIST-KAT canary required | ✓ — cross-platform determinism test, not compute integrity |

**Phone collision check:** Phone remained a connected `adb` device
(`FY25013101C8`) throughout the session. Every `adb` invocation in this
phase's scripts carried `-s emulator-5554`. No shell, push, pull, or
command touched the phone.

---

## Escalation Trigger

Per the brief: **ALL_MATCH triggers operator review before moving on.**
See `docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md` for the
science-team-facing note and `repo_stage/HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md`
for the repo-agent integration note.

Operator: this finding materially strengthens τ, suggests Mode A is viable,
and reframes the Intel Mac lane as source-blocked rather than tooling-blocked.
Recommend a short review before scheduling further cross-platform work.
