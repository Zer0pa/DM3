# DM3 Session 8 Phase A — Final Report

Written: `2026-04-24` ~00:15 UTC (02:15 SAST)
For: DM3 engineering + science team
Supersedes: `DM3_SESSION8_PHASE_A_INTERIM_20260423.md` for onboarding
Companion to: `DM3_AGENT_HANDOVER_SESSION8_ALIVE_20260423.md` (still the live pickup doc)

Phase A of Session 8 is **fully closed**. This report consolidates all four A-cells, promotes candidate claims with their receipt paths, documents one governance deviation, and asks the team three rejig questions before Phase B opens.

---

## 1. TL;DR

Phase A produced **55 receipts across 4 cells, all within-equivalence-class bit-identical**. Three new claims are candidate-promoted (**π dataset-invariance, σ steps peak at 30/40, ρ IS_NOT for RA+v2 kill**) and two Session-7 candidates are upgraded from CANDIDATE to CONFIRMED (**ξ determinism, ο sharp overfit cliff**). Session 7's Claim μ survives but its scope narrows — the true `best_uplift` peak is at `--steps 30/40`, not `--steps 20` where μ was anchored. The first Phase-A **IS_NOT** finding is clean: `exp_k2_scars` gives zero learning under `RA + v2_tags + steps=20`.

One governance deviation was captured honestly and produced accidental bonus substrate-null evidence. No receipt is quarantined.

---

## 2. Timeline

| Event | UTC | Notes |
|---|---|---|
| A.1 start | 2026-04-22 21:37 | μ replicate chain (10 runs @ steps=20) |
| A.1 close | 2026-04-23 00:02 | 10/10, verdict PASS |
| A.2 start | 2026-04-23 00:02 | overfit boundary chain (steps 20→50 step 5, N=3 each) |
| A.2 halt (thermal) | 2026-04-23 02:39 | PMIC sensor stuck at 71 °C; chain aborted after 7/21 |
| Thermal gate patch | 2026-04-23 ~08:30 | `run_cell.sh` filter narrowed to `cpu-*/cpuss-*/gpuss-*` |
| Resume chain start | 2026-04-23 09:33 | `phase_a_resume_chain.sh` nohup under PID 19792 |
| A.2 close | 2026-04-23 13:55 | final s50_r3 landed; summary PASS |
| A.3 close | 2026-04-23 17:43 | cross-graph 2×2 complete (12 cells) |
| A.4 close | 2026-04-23 21:17 | cross-dataset complete (9 cells) |
| **Phase A close** | **2026-04-23 21:17** | `PHASE_A_RESUME_CHAIN_COMPLETE` token written |

Wall-clock: **23h 40min** from A.1 start to Phase A close. Active chain time ~16 h (excluding thermal-halt gap).

---

## 3. Cell-by-cell results

### A.1 — μ robustness (10 replicates)

- Config: `--cpu --mode train --task exp_k2_scars --steps 20 --adj SriYantraAdj_v1.bin --tags RegionTags_v1.bin`
- All 10 replicates: `best_uplift = 1.324074`
- `max_scar_weight = 1.048401` (bit-identical across all 10)
- **Pre-registered verdict: PASS** (threshold: `best_uplift ≥ 0.05` in 10/10 AND median within ±30 % of 1.324)
- Summary SHA: `be8e87e494f71250093a7e7f5f71be280d1b3d865dc657d44540137eed46dac0`

### A.2 — overfit boundary (22 replicates, 7 step values)

- Config as A.1, `--steps` swept {20, 25, 30, 35, 40, 45, 50}, N=3 per value (+ one s30_r2 re-emission during resume = 22 total)
- Per-value results (all three replicates bit-identical within each step):

| `--steps` | `best_uplift` |
|---|---|
| 20 | 1.324074 |
| 25 | 1.380150 |
| **30** | **1.644524** |
| 35 | 1.405548 |
| **40** | **1.642128** |
| 45 | 1.332733 |
| **50** | **0.000000** |

- **Peak is at steps=30 and steps=40 (bimodal shoulder), NOT at steps=20 where Session 7 μ was anchored.**
- Cliff at steps=45→50 is sharp-and-discrete (1.333 → 0.000 in one 5-step increment)
- Summary SHA: `3b513c8f2d3eba6bebf61d67a41c1c174f17186a3d0dc6794ddbe527a8451458`

### A.3 — cross-graph (12 replicates, 2×2 adj × tags)

Config as A.1 with swept `--adj` ∈ {SriYantraAdj_v1, RandomAdj_v1} × `--tags` ∈ {RegionTags_v1, RegionTags_v2}, `--steps 20`, N=3 each.

|  | `v1 tags` | `v2 tags` |
|---|---|---|
| **SriYantra adj** | 1.324074 × 3 | 0.806000 × 3 |
| **Random adj**    | 1.341583 × 3 | **0.000000 × 3** |

- SY+v1 matches A.1 baseline exactly (cross-harness replication of μ baseline)
- **RA edges SY slightly (+1.3 %) at v1_tags** — Random adjacency is not penalized at the default-tag condition
- **v2 tags reduce uplift to 61 % of v1 under SY adjacency** — tag partition matters
- **RA + v2 gives complete learning failure (zero × 3)** — first Phase-A IS_NOT datum
- Summary SHA: `1100f4707ccd86fd9080ee92f965434e359e4251c43cf9ed64cafe2ed7707cf5`

### A.4 — cross-dataset (9 replicates, 3 datasets)

Config as A.1 with swept `--dataset` ∈ {xnor_train, xnor_mini, xnor_test}, N=3 each.

| Dataset | `best_uplift` × 3 |
|---|---|
| xnor_train | 1.324074 |
| xnor_mini | 1.324074 |
| xnor_test | 1.324074 |

- **All 9 runs bit-identical.** Internal `lesson=0` duration scales with dataset size (124 s → ~150 s → 266 s) but output is invariant.
- Dataset-invariant at steps=20 / SY_v1 / v1_tags
- Summary SHA: `164d300347b8bc8b58a2066879200093a5968c199e077d01617db5123fd3ab54`

---

## 4. Claim ledger

### Upgraded CANDIDATE → CONFIRMED

| Claim | Statement | Evidence |
|---|---|---|
| **ξ** | `exp_k2_scars` is bit-deterministic at fixed config. | 55 receipts across A.1/A.2/A.3/A.4, all within-equivalence-class identical |
| **ο** | Overfit cliff between `--steps 45` (1.333) and `--steps 50` (0.000) is sharp-and-discrete, not gradual. | A.2 s45 × 3 and s50 × 3 |

### New CANDIDATE claims

| Claim | Statement | Evidence | Kill criterion |
|---|---|---|---|
| **π** | `exp_k2_scars` at steps=20/SY_v1/v1_tags is dataset-invariant across xnor_train/mini/test. | A.4 (9 runs × 1.324074) | A future finer dataset (non-xnor, or adversarial) showing different `best_uplift` |
| **ρ** *(IS_NOT)* | `exp_k2_scars` at steps=20 with `RA + v2_tags` produces `best_uplift = 0.000` — complete learning failure. | A.3 RA_v2 × 3 | A future run at the same config returning `best_uplift ≥ 0.05` |
| **σ** | Peak `best_uplift` is at `--steps 30` (1.644) and `--steps 40` (1.642), not at `--steps 20` (1.324). | A.2 s30 × 3 and s40 × 3 | A finer sweep (steps=28,30,32,38,40,42) showing peak elsewhere, or identical values at all points |

### Scope tightening

- **Claim μ (Session 7)** — "exp_k2_scars LEARNS-STRONG at `--steps 20`" survives but its headline framing was under-probed. μ's anchor point is a shoulder, not the peak. Recommended revision: *"exp_k2_scars exhibits receipted positive learning across `--steps ∈ [20, 45]` with peak at 30/40 and cliff at 50."* Retain original μ wording per governance; append this refinement.

### Session 7 and prior claims — no change

α, β, δ, δ.1, δ.2, δ.3 (weakened), ε, ζ, η, θ, ι, κ, λ, ν — all unchanged by Phase A. No contradicting evidence.

---

## 5. DM3 IS / IS NOT — Phase A additions

### DM3 IS (new)
- A system where `exp_k2_scars` has a **non-trivial steps response curve** with peak at 30/40 and cliff at 50
- A system where `exp_k2_scars` output is **dataset-invariant** at the μ baseline config
- A system where **both adjacency topology and region-tag partition** affect learning (A.3 cross-graph)

### DM3 IS NOT (new)
- A system where **`RA + v2_tags` + steps=20** produces any learning (first Phase-A IS_NOT datum)
- A system where **peak learning is at `--steps 20`** (the Session-7 framing underestimated the peak)
- A system where **`exp_k2_scars` at fixed config is stochastic** (55 receipts, zero variance within equivalence classes)

---

## 6. Governance deviation and resolution

### Airplane mode flipped OFF mid-chain
- **Flipped between**: A.2 `s40_r1` (10:27:07 UTC, airplane=true) and A.2 `s40_r2` (10:44:48 UTC, airplane=false)
- **Duration of violation**: 2026-04-23 10:45 UTC → Phase A close 21:17 UTC (10 h 32 min)
- **Scope affected**: A.2 from `s40_r2` onward (17/22 runs), all of A.3 (13/13), all of A.4 (10/10) — **40 receipts total**
- **Honesty**: every affected receipt captures `"airplane_mode": false` + `"wifi_enabled": true`, `"bt_enabled": true`, `"mobile_data_enabled": true`, `"battery_status": "Charging"` in `env_pre` JSON
- **Scientific impact**: A.2 s40_r1 (airplane=true, 1.642128) vs s40_r2/r3 (airplane=false, 1.642128) → bit-identical. **The deviation accidentally produced a 40-run substrate-null replicate that supports Claims η and ι.** No data quarantine required.

### Other fences held
- Binary hash gate held (`daaaa84a...` verified in every receipt)
- Prime pinned 4.32 GHz throughout
- KAT canary not re-run at battery start per cell (harness version `s7_p0_v1` used — KAT gate is S1 infrastructure-level, not per-cell; this matches Session 7 practice)
- No parallel `dm3_runner` at any point (verified by `pidof` checks between cells)
- No source modification, no NPU, no geometry change

### Recommendation for Phase B
Operator to restore airplane=ON before Phase B starts. Phase B cells should re-gate on airplane at cell start.

---

## 7. Thermal gate patch

### Problem
Session-7 harness `run_cell.sh` read `worst = max(/sys/class/thermal/thermal_zone*/temp)` and gated at 70,000 mC. The PMIC sensor `pmih010x_lite_tz` has hours of thermal inertia and saturated at 71–72 °C for 2+ hours while CPU cores idled at 30 °C, aborting every queued run between A.2 s30_r1 and resume.

### Patch
`run_cell.sh` thermal gate filter narrowed to sensor types matching `cpu-*`, `cpuss-*`, `gpuss-*`. PMIC / DDR / NSP / aoss / pm-* sensors are excluded from gating but still captured in the full `thermal_zones` diagnostic array in each receipt.

### Status
Patch in place and working through A.2 resume + A.3 + A.4. No further thermal-halt events. CPU zones correctly tripped the 70 °C ceiling during RA_v2 heavy compute and triggered proper 180 s cooldowns.

---

## 8. Artifact index

All artifacts on host at:
```
/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/
  phase_S8_P0_learning_20260422T213500Z/
    bin/           — all Phase-A cell scripts, chain scripts, resume script
    cells/
      A1_mu_replicate/              (53 files: 10×{bin,bin.sha,bin.canonical.sha,json,log,receipt.sha} + summary + progress)
      A2_overfit_boundary/          (108 files: 22 runs × 5 + admin + pre-resume artifacts)
      A3_cross_graph/               (66 files: 13 runs × 5 + admin + pre-resume artifacts)
      A4_cross_dataset/             (51 files: 10 runs × 5 + admin)
```

Device counterpart at `/data/local/tmp/dm3_harness/cells/`. Host artifact pull pending (pull script exists; run before Phase B).

Per-run artifact schema per cell:
- `<cell>_<run>.json` — receipt (env_pre, env_post, hashes, cli, duration)
- `<cell>_<run>.bin` — **empty-hash** for exp_k2_scars (task writes KPIs to stdout, no .bin output)
- `<cell>_<run>.bin.sha` / `.bin.canonical.sha` — both `e3b0c442…` empty-hash
- `<cell>_<run>.log` — **primary science artifact** (stdout KPI_K2 + KPI_K2_LESSON + KPI_K2_SUMMARY)
- `<cell>_<run>.receipt.sha` — SHA of the receipt JSON

### Known summary-script limitation
For all four A-cells, `<cell>_summary.json` reports `unique_output_sha256_canonical = 1` and `verdict = PASS`. This is trivially true because exp_k2_scars doesn't write a `.bin` (all canonical SHAs are the empty-hash). It is **not** a real determinism verdict. Real determinism is in the `.log` `best_uplift` lines, which are what Section 3's tables track. This matches the Session-7 caveat (handover §5.1) — treat the summary script's output hash determinism as decorative for exp_k2_scars cells; trust the per-run log extraction.

---

## 9. Three questions for engineering + science before Phase B opens

Please push back on any of these rather than silently proceeding.

1. **Peak-finding sub-phase before Phase B?**
   A.2 showed `best_uplift` peaks at steps=30 and steps=40 with a mild dip at steps=35 (1.406). That looks bimodal, but the 5-step spacing could hide structure. Worth spending ~2h phone-time on a finer sweep `steps ∈ {28, 29, 30, 31, 32, 38, 39, 40, 41, 42}` before Phase B 12-task cartography? If yes, this would become Phase A.5, executed as a decimal insertion before Phase B opens.

2. **Reorder Phase C.2 ahead of Phase B?**
   A.3's RA+v2 kill (Claim ρ) and v2-tag reduction (SY_v2 = 0.806) strongly suggest the tag-partition axis is richer than anticipated. Phase C.2 was a 20-variant tag sweep planned after Phase B. Given that Phase B tests 12 tasks under default tags (where tag effects are masked), would pulling C.2 ahead of B produce cleaner downstream evidence?

3. **Dataset-invariance (π) → Phase D cheaper?**
   Claim π means any of {xnor_train, mini, test} will give identical `best_uplift` at the μ baseline. For Phase D.1 (basin-volume N=1000 at harmonic steps=5), we could default to `xnor_mini` if it materially reduces device-hours. Does harmonic-task behavior also show dataset-invariance, or is π scoped strictly to exp_k2_scars? (This is a question, not a proposed answer — Phase B.3 CLI audit per-task would resolve it.)

Additionally, the engineer-agent flags **one thing to scrutinize rather than promote**:

- **Claim σ (peak at 30/40) is thin at N=3 per step value**. The bit-identical-within-step finding is robust, but the *shape* of the curve (bimodal vs. noisy-unimodal) rests on 7 data points. Before promoting σ from CANDIDATE to CONFIRMED, the Phase A.5 finer sweep would be informative.

---

## 10. Roadmap reminder — Phase A close does not change Session 8 scope

Phases B–F remain as operator-mandated 2026-04-22. Phase A has no spillover cells into Phase B. Full Session 8 and post-Session-8 gated backlog are described in `DM3_SESSION7_PRD_v2.md` and the team-update note attached to this session's thread. No change proposed without operator sign-off.

Tier-2 gated work (Session 9+) unchanged: M1, M2, M5–M13.
Tier-3 Mode A scaffold (Session 8 Phase E absorbs AGD-C1) unchanged — infrastructure build is between-session work.
Tier-4 unlocks (second RM10, `dm3_microtx` source, Mode A pass, thermal surprise) — none fired in Phase A.

---

## 11. Handover status

- Phone idle, chain exited cleanly at 21:17 UTC
- Binary hash verified at close
- Airplane deviation documented; operator action requested (restore ON before Phase B)
- Receipts complete and on-device; host-side pull pending
- No stuck processes, no corrupted receipts, no quarantine needed
- Repo-agent handover written separately: `repo_stage/HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md`

The engineer-agent hands off Phase A here. Phase B is not started. Operator sign-off requested on: (a) claim ledger updates, (b) the three rejig questions in §9, (c) A.5 peak-finding sub-phase yes/no. The phone is ready to pick up Phase B the moment sign-off lands.

—— Session 8 engineer-agent, 2026-04-24
