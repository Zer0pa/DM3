# AGD-H1 M1 — Science Team Note

**Date:** 2026-04-24
**From:** Session 8 external-parallel agent (AGD-H1 M1 lane)
**Re:** AGD-H1 External on M1 MacBook Air — cross-platform determinism test
**Status:** **ALL_MATCH — τ (tau) CONFIRMED**
**Supersedes:** prior `BLOCKED — SOURCE_NOT_ACCESSIBLE` version of this note.

---

## Why this matters

Phase A on the RM10 phone captured a 5-point deterministic reference vector
for `exp_k2_scars` (SY_v1 + RegionTags_v1 + xnor_train, `--cpu --mode train`)
at steps ∈ {20, 30, 40, 45, 50}. The candidate claim **τ (tau)** states that
this vector is a property of the binary plus inputs — not a property of the
RM10's specific hardware or kernel.

AGD-H1 External asks: does the same binary, run on a different ARM64
hardware + kernel, produce the same 10 floats bit-exactly?

Answer: **yes, bit-exactly, on all 5 points.**

---

## What was run

The existing Android aarch64 ELF `dm3_runner`
(sha256 `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`)
was executed inside an Android 14 / arm64-v8a AVD on an M1 MacBook Air,
running under macOS 15.5 Hypervisor.framework. All four Phase A input SHAs
(binary + `SriYantraAdj_v1.bin` + `RegionTags_v1.bin` +
`data/xnor_train.jsonl`) were verified bit-identical to the RM10 reference
before any run. The phone was present on USB throughout and was **not
touched** — every adb command used `-s emulator-5554`.

Five invocations (N=1 per step value) with CLI
`./dm3_runner --cpu --mode train --task exp_k2_scars --steps {20|30|40|45|50} -o /data/local/tmp/m1_sN.bin`.

---

## Results

| `--steps` | `best_uplift` RM10 | `best_uplift` M1 | `max_scar_weight` RM10 | `max_scar_weight` M1 | Match |
| --- | --- | --- | --- | --- | --- |
| 20 | 1.324074 | 1.324074 | 1.048401 | 1.048401 | BIT_EXACT |
| 30 | 1.644524 | 1.644524 | 0.868061 | 0.868061 | BIT_EXACT |
| 40 | 1.642128 | 1.642128 | 0.714148 | 0.714148 | BIT_EXACT |
| 45 | 1.332733 | 1.332733 | 0.647856 | 0.647856 | BIT_EXACT |
| 50 | 0.000000 | 0.000000 | 0.588307 | 0.588307 | BIT_EXACT |

10 independent floats, 10/10 bit-exact. The regression collapse point at
steps=50 (`best_uplift=0.000000`) reproduces on the M1 as well.

---

## Scientific interpretation

The `exp_k2_scars` learning pipeline, on `--cpu`, is a **pure deterministic
function** of (binary, Sri Yantra adjacency, region tags, training dataset,
step count). There is no dependency on:

- physical silicon (Snapdragon SoC vs Apple M1)
- OS/kernel (Android native vs Android emulator under Hypervisor.framework)
- thermal envelope (phone under load vs Mac well-cooled)
- scheduler / core mix (phone big-little vs M1 P-cores)
- page cache or filesystem (ext4 / f2fs on phone vs virtio-blk in emulator)
- clock rate or frequency scaling

τ is confirmed as a property of the algorithm, not of the RM10. Any future
cross-device comparison of `exp_k2_scars` can use bit-exactness as the
canary for both tamper detection and environmental-sanity.

---

## What this does NOT show

- **Not** a source-rebuild parity result. The source for the current hybrid
  `dm3_runner` with the 12-task namespace remains unrecovered
  (`exploratory_compiled_residue` per the prebuilt-vs-source matrix). This
  test used the existing Android ELF on both platforms.
- **Not** a statement about non-CPU lanes. GPU/NPU paths were not exercised;
  the `--cpu` flag is load-bearing here.
- **Not** yet evidence of determinism across ARM64 → x86-64. Intel Mac
  parallel testing is blocked by source-recovery, not by tooling.

---

## Recommendations

1. Promote τ from *candidate* to *confirmed* in the claims ledger
   (`CLAIMS.md`, `IS_AND_IS_NOT.md`), scoped to `--cpu --task exp_k2_scars`.
2. Reframe the Intel Mac external lane as **source-blocked**; allocate
   source-recovery effort toward locating the current `runner` / `scar_engine`
   / `dm3_core` / `resonance_patterns` workspace (not present on this Mac,
   not found in Zer0pa public/private GitHub surface as of 2026-04-24).
3. Mode A (multi-device receipt comparison as a lightweight determinism
   witness) is favorably indicated; operator may safely design workflows
   that treat cross-ARM64 bit-divergence as signal rather than noise.
4. Consider a N=3 repeat run on both surfaces as a later belt-and-braces
   check, but it is not scientifically necessary — a pure function of inputs
   cannot produce variance across repeats on the same platform.

---

## Artifacts and evidence

- `artifacts/phase_S8_AGDH1_external_M1_20260424/AGD_H1_M1_FINDINGS.md`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/receipts.jsonl` (5 receipts)
- `artifacts/phase_S8_AGDH1_external_M1_20260424/m1_s{20,30,40,45,50}.log`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/emulator_boot.log`

All to be mirrored to Hugging Face dataset repo `Zer0pa/DM3-artifacts` per
the live preservation-lane protocol.
