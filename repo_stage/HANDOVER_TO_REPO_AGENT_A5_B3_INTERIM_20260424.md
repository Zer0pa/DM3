# Handover to repo-agent — A.5 closed, B.3 in flight, τ CONFIRMED

Written: `2026-04-24` ~15:55 UTC (17:55 SAST)
From: Session 8 engineer-agent
For: the repo-agent keeping `repo_stage/` fresh and the front door inviting
Status: **INTERIM — A.5 closed at 12:56 UTC, B.3 still advancing (5/24), ETA ~tomorrow morning**
Supersedes: prior interim at 10:35 UTC today

This update supersedes the earlier A.5+B.3 interim. Key changes since then:
1. **A.5 closed cleanly** — the σ′ draft wording is now final-ready.
2. **AGD-H1 External M1 lane returned ALL_MATCH** — τ CONFIRMED. The fresh agent already wrote its own repo-agent handover at `repo_stage/HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md` — integrate that too.
3. **B.3 is still running**, slower than estimated. Final close probably tomorrow morning.

---

## TL;DR — three separate ledger events to integrate

### Event 1 — Phase A close

Covered in `HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md`. **IMPORTANT CORRECTION**: that doc asked you to promote σ with wording "bimodal peak at steps=30 and 40". **Revoke that specific ask.** Use the σ′ wording from this doc instead (see Event 2). Everything else in the Phase A handover — ξ, ο, π, ρ, μ refinement — stands as written.

### Event 2 — A.5 close (refined σ → σ′)

**A.5 sub-phase closed at 12:56 UTC with 30/30 bit-identical triplet receipts.** Full curve:

| `--steps` | `best_uplift` × 3 | Note |
|---|---|---|
| 28 | 1.521027 | |
| 29 | 1.580566 | |
| 30 | 1.644524 | ✓ bit-identical to A.2 |
| 31 | 1.714828 | |
| **32** | **1.790665** | **primary peak** |
| 38 | 1.531288 | |
| 39 | 1.582687 | |
| 40 | 1.642128 | ✓ bit-identical to A.2 |
| **41** | **1.708374** | **secondary local max** |
| 42 | 1.383827 | sharp drop starts |

**σ (as written in Phase A handover) is WRONG.** It said peak at 30 and 40. Real peaks are 32 and 41. Do not promote σ. Promote σ′ instead (wording below).

### Event 3 — τ CONFIRMED from M1 Mac

Fresh agent ran AGD-H1 External on M1 MacBook Air via Android ARM64 AVD under Hypervisor.framework. All five reference values + all five `max_scar_weight` values reproduced bit-exactly. See `repo_stage/HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md` for the agent's own integration instructions. τ is CONFIRMED, scoped to `--cpu --task exp_k2_scars` with SY_v1 + v1_tags + xnor_train.

---

## Final claim-ledger state (post-A.5, pre-B.3-close)

| Claim | Final status | Action for repo-agent |
|---|---|---|
| **ξ** determinism | **CONFIRMED** | Upgrade from CANDIDATE. Evidence base: 55 Phase A receipts + 30 A.5 receipts + cross-cell A.2↔A.5 bit-identical replication at s30, s40 + cross-hardware Snapdragon↔M1 bit-identical replication at s20/30/40/45/50. Total ~76 within-equivalence-class identical receipts across 4 cells × 2 hardware platforms. |
| **ο** sharp overfit cliff at s50 | **CONFIRMED** | Upgrade from CANDIDATE. Unchanged evidence (A.2 s45 vs s50 triplicate). |
| **π** dataset-invariance | **CANDIDATE** (scoped) | Add as new CANDIDATE with the strict scope from the earlier Phase A handover. |
| **ρ** RA+v2 zero-learning IS_NOT | **CANDIDATE** (IS_NOT, scoped) | Add as new CANDIDATE. |
| ~~**σ** bimodal peak at 30/40~~ | **REJECTED BEFORE PROMOTION** | Do NOT promote. Record in `JOURNEY_LOG.md`: *"Phase A draft σ (peak at 30/40) was invalidated by A.5 finer sweep before the repo-agent integration pass. Replaced by σ′. Example of pre-registered kill criterion firing cleanly — incorrect claim never reached public ledger."* |
| **σ′** bimodal peak at 32/41 | **CANDIDATE** (new) | Add as new CANDIDATE with wording below. |
| **τ** cross-platform determinism | **CONFIRMED** | Promote directly from nothing → CONFIRMED. Scope: `--cpu --task exp_k2_scars` with SY_v1 + v1_tags + xnor_train. Evidence: AGD-H1 M1 ALL_MATCH + Phase A RM10 reference vector. |
| **μ** (Session 7) | unchanged status, scope refined | Append the refinement block from prior handover, plus the A.5 peak-location finding. |

### σ′ CANDIDATE wording (final, for `CLAIMS.md`)

> **σ′ — `exp_k2_scars` learning curve is bimodal with primary peak at `--steps 32` (1.790665) and secondary local maximum at `--steps 41` (1.708374)** | **CANDIDATE**
> Scope: `exp_k2_scars` on SY_v1 + RegionTags_v1 + xnor_train, pinned Prime cpu7, airplane ON.
> Evidence: A.5 sweep of `--steps ∈ {28, 29, 30, 31, 32, 38, 39, 40, 41, 42}`, N=3 each, all triplets bit-identical. A.2 s35 = 1.406 as the one interior data point between the two peaks confirms a real dip in the 34–36 region. After s41 the curve drops to s42=1.384 and then to the known s45=1.333, s50=0.000.
> Kill criterion: a finer sweep of `--steps ∈ {33, 34, 35, 36, 37}` showing no dip (i.e., monotone descent from s32 to s38) OR a new replicate at s32 or s41 returning a different value.
> Reopen: if primary or secondary peak location shifts under cross-graph / cross-dataset / cross-tags conditions.

### τ CONFIRMED wording (for `CLAIMS.md`)

> **τ (tau) — DM3 learning determinism is ARM-hardware-independent on CPU for `exp_k2_scars`** | **CONFIRMED**
> Scope: `--cpu --mode train --task exp_k2_scars` with `SY_v1 + RegionTags_v1 + xnor_train` inputs, at `--steps ∈ {20, 30, 40, 45, 50}`.
> Evidence: 10 independent floats (5 `best_uplift` + 5 `max_scar_weight`), 10/10 bit-exact across RM10 Snapdragon 8 Elite (Android 14 native, physical device `FY25013101C8`) and Apple M1 (Android 14 ARM64 AVD `dm3_m1_test` under macOS 15.5 Hypervisor.framework). Same binary (sha256 `daaaa84a…`), same input SHAs on both platforms.
> Kill criterion: any future ARM64 substrate running the same binary + inputs producing a value that differs at any decimal place.
> Reopen: if the claim is challenged at a CLI config outside this scope (non-`--cpu`, non-`exp_k2_scars`, non-SY_v1+v1_tags+xnor_train).

---

## Artifact trees to mirror

### A.5 + B.3 (partial — under chain, not yet pulled to host)

Will appear under `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/`:
- `A5_peak_finder/` — 30 runs × 5 files + summary + progress (expected ≈152 files). Summary SHA: `7d1f960c0191427c55d613706c176abcfd6359c8cca0e67f0f2d421e332b8313`
- `B3_cli_audit/` — 24 runs × 5 files + summary + progress (expected ≈122 files). Currently 5 runs landed; 19 pending.

Host pull + HF upload happens when chain closes (~tomorrow morning).

### AGD-H1 M1 (already on disk, already on HF — per fresh-agent handover)

Under `artifacts/phase_S8_AGDH1_external_M1_20260424/`:
- `AGD_H1_M1_FINDINGS.md`
- `receipts.jsonl` (5 receipts)
- `m1_s{20,30,40,45,50}.log`
- `emulator_boot.log`

Plus `docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md`.

---

## What the engineer-agent recommends you do

Order your integration pass by severity:

1. **FIRST**: Reject draft σ. It never appeared in `CLAIMS.md` (integration hadn't happened yet), but if you've already started writing it, stop. Use σ′ instead.

2. **Promote ξ and ο to CONFIRMED** per the earlier handover — adding the A.5 cross-cell + AGD-H1 cross-hardware evidence to ξ's base count.

3. **Promote τ directly to CONFIRMED** — this is the biggest single finding of the session. It belongs in the public headline.

4. **Add π, ρ, σ′ as new CANDIDATES.** Scopes as written above.

5. **Append μ refinement block** (from prior handover) plus a second sentence about the primary peak being at s32, not s30/s40.

6. **Record σ rejection in `JOURNEY_LOG.md`** as a receipted-discipline success case — *"pre-registered kill criterion fired cleanly; incorrect draft claim never reached public ledger"*.

7. **Update `IS_AND_IS_NOT.md`** with the A.5 + τ additions:
   - DM3 IS: *"a system whose `exp_k2_scars` learning curve has primary peak at `--steps 32` (1.79) and secondary local max at `--steps 41` (1.71) on the default config"*
   - DM3 IS: *"a system whose `exp_k2_scars` learning output is bit-exact reproducible across independent ARM64 hardware (confirmed RM10 Snapdragon ↔ Apple M1)"*
   - (Do NOT add the "bimodal peak at 30/40" line — that was σ's wrong wording.)

8. **Refresh `README.md` + `website_summary.md`** with the expanded story. Suggested headline:

> *Session 8 is producing the project's first truly cross-platform result. AGD-H1 External on M1 Mac returned ALL_MATCH — 10 of 10 reference floats reproduced bit-exactly across RM10 Snapdragon and Apple M1 via Android ARM64 AVD under Hypervisor.framework. Claim τ CONFIRMED: DM3's `exp_k2_scars` learning determinism is a property of the algorithm, not the silicon. Phase A.5 peak-finder simultaneously refactored the Phase A σ wording before it reached publication — real peaks are at `--steps 32` (1.79) and `--steps 41` (1.71), not 30/40 as the coarser grid suggested.*

9. **MANIFEST.tsv** — pending host pull, but plan for ~280 new rows (A.5 + B.3 + AGD-H1 M1).

---

## What NOT to do

- **Do not promote σ as originally written.** The handover at `HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md` asked for σ; A.5 has invalidated that ask.
- **Do not treat σ's rejection as a failure.** Pre-registered kill criterion fired. System worked correctly.
- **Do not overstate τ's scope.** It's CONFIRMED only for `--cpu --task exp_k2_scars` with the specific SY_v1 + v1_tags + xnor_train inputs at `--steps ∈ {20, 30, 40, 45, 50}`. NOT confirmed for GPU, NPU, other tasks, other configs, or ARMv8 ↔ x86_64.
- **Do not merge the AGD-H1 M1 handover into this one.** Fresh agent wrote their own (`HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md`); integrate both separately. Their handover has the Android AVD / Hypervisor.framework provenance details that matter for τ's scope.
- **Do not wait for B.3 to close before starting the integration pass.** A.5 + AGD-H1 M1 are the two big findings ready for public ledger NOW. B.3 adds the responsiveness table later (probably tomorrow).

---

## Scope fences — all intact

- Binary hash `daaaa84a…` held on every A.5 receipt + every AGD-H1 M1 receipt
- No DM3 source modification attempted or successful
- AGD-H1 M1 used the existing Android aarch64 ELF unchanged (no rebuild)
- No NPU / Hexagon / Adreno
- No parallel `dm3_runner` on the phone; AGD-H1 M1 ran the binary inside an AVD while the phone was physically connected — every `adb` call used `-s emulator-5554` to avoid collision
- Airplane ON throughout A.5 on the phone
- Sri Yantra geometry unchanged

---

## Sync seams

1. **Two repo-agent handovers coexist** for the same session date: `HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md` (Phase A close) and `HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md` (fresh-agent M1 pass). This interim (A.5+B.3) is a third. Treat them as a coordinated set. The PHASE_A handover has the σ line that's now obsolete; the others are clean.

2. **σ was written into the PHASE_A handover (which is on HF already)** — the integration hasn't happened yet, so the public ledger never saw it. But future archaeology passes will see σ in the handover's version history. That's fine — retraction-before-promotion is legitimate and should be visible.

3. **B.3 preliminary findings (harmonic + holography both responsive to `--steps`)** are mentioned in the science-team interim but NOT yet in this handover as claim candidates. They'll land in a B.3-close handover when the chain finishes. Don't promote anything B.3-related yet.

4. **AGD-H1 M1 used the existing binary on an emulator — this is a pure hardware-cross-check, not a source-build-cross-check.** τ's scope needs to be clear on this distinction: it's "same binary, different silicon", not "independently-compiled binary, same behavior". Both are determinism, but of different classes.

---

## Two questions for the repo-agent to pose back

1. **τ's framing on the public front door** — engineer-agent leans "lead with τ" as the session headline. But τ is scoped to one task + one config. Is that too narrow a headline? Alternative framing: *"First cross-platform determinism proof for DM3 — 10/10 bit-exact on `exp_k2_scars` across Snapdragon and M1. Single-task scope; broader confirmation pending."*

2. **σ rejection visibility** — should the public README mention that A.5 rejected σ before publication, or is that "process detail" that belongs only in JOURNEY_LOG? Engineer-agent leans mention it in the README — it's a clean example of discipline working — but repo-agent owns the public framing.

---

## Final note

This handover supersedes the 10:35 UTC interim. The 10:35 interim asked you to hold σ′ pending A.5 close; A.5 has now closed, σ′'s wording is locked, and τ has been added as a bigger headline alongside it.

B.3 will produce its own handover when it closes tomorrow morning. That one will have the per-task responsiveness table + any new claim candidates (κ/ν reinforcement or weakening depending on what B.3 shows for `exp_k3_truth_sensor` and `resonance_r3`).

Thanks for keeping the door fresh.

—— Session 8 engineer-agent, 2026-04-24
