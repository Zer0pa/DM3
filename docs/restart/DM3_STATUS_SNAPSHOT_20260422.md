# DM3 Status Snapshot — 2026-04-22

**Branch:** `hypothesis/rm10-primary-platform-heterogeneous-learning`
**Last session:** Session 7 (PRD v2), closed 2026-04-22
**Binary:** `dm3_runner`, SHA-256 `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
**Device:** Red Magic 10 Pro (FY25013101C8), plugged in, idle

---

## 1. Where we are

**Session 7 PRD v2 is closed.** S9 is the sole documented gap (freq-locked, root required). All other Phase 0-6 cells executed, with some (S5, S8 Battery, S8 Bypass) truncated by thermal aborts but still statistically meaningful.

The DM3 project has accumulated **7 research sessions** of receipted evidence. Session 7 added 6 new promoted claims (θ, ι, κ, λ, μ, ν) and weakened one prior claim (δ.3). One claim is retracted and remains visible (γ, retracted Session 5). Two early-session claims remain killed (H2, flipping rates at N=2).

---

## 2. Completed sessions

| Session | Theme | Key outcome |
|---------|-------|-------------|
| 1 | Manifesto era | T01-T236 registry demoted to vocabulary; Sri Yantra geometry affirmed |
| 2 | Custody & governance | Mac + RM10 execution lanes; ADB canonical transport; Gates A-E |
| 3 | Multi-hypothesis | H2 killed (transformer doesn't create bistability); asymmetry order parameter; holography third operating point |
| 4 | Sculptor's Scalpel (N=5) | 5 of 7 session-3 suggestives killed; 2 promoted |
| 5 | Hidden tasks + IID | 3 hidden tasks confirmed callable; basin selection IID Bernoulli p≈0.34 at N=100; Claim γ retracted |
| 6 | Gate flips + full vocabulary | 12 task names accepted; 4 canonical SHA equivalence classes; R1 flips via `--adj`, R2 flips via `--tags`; parallelization confirmed counterproductive |
| **7** | **Substrate null at both layers + compound flip + first positive learning** | **6 new claims; first receipted LEARNS (exp_k2_scars); closed 2×2 cross-control; bit-level + statistical substrate-null battery** |

---

## 3. Claims ledger (current state)

### Promoted / SOLID (evidence across ≥2 sessions)
- **α** — Sri Yantra exact-rational 2D→3D construction
- **β** — Bistable relaxation on C3-symmetric graph; p(HIGH) IID Bernoulli at ~0.34

### Promoted / CONFIRMED (Session 6)
- **δ** — exp_r1_r4_campaign 6-gate capability surface callable, byte-deterministic
- **δ.1** — R1 flips with `--adj RandomAdj_v1.bin`
- **δ.2** — R2 flips with `--tags RegionTags_v2.bin` (+ claim_level CL-0→CL-1)
- **ε** — Harmonic basin Coh signatures compress at asym ≤ −3
- **η** — 12 callable `--task` values (vocabulary claim)
- **ζ** — p(HIGH) parameter-INVARIANT at |asym| ≤ 0.2

### Promoted / CONFIRMED (Session 7)
- **θ** — Compound RA+v2+steps=50 → R1+R2+CL-1, `r4.transfer_ratio` doubles
- **ι** — Dynamics-layer substrate null: p(HIGH) overlapping CIs across 6 arms × 665 episodes
- **κ** — exp_k3_truth_sensor CLI flags decorative; fixed 79.4% error reduction
- **λ** — R1/R2 cross-control axes cleanly separable (R1 pure --adj; R2 pure --tags)
- **μ** — **exp_k2_scars LEARNS-STRONG** at steps=20 (first receipted positive learning); overfits at steps=50
- **ν** — resonance_r3 ignores `--steps` flag

### Weakened / updated
- **δ.3** — R3 was "payload-moving along --steps"; Session 7 found `operational_steps` caps at 10. Revised: R3 structurally unreachable from current CLI surface.

### Retracted (remains visible)
- **γ** — Rotation × asymmetry C3-asymmetric coupling (retracted Session 5 P2b at N=10)

### Killed (removed narrative, kept provenance)
- H2 (transformer-creates-bistability, Session 3)
- freq=1.0 → 100% HIGH (Session 3, N=2 noise; Session 4 N=5 killed)
- rot=120° preserves bistability (Session 3 N=2; Session 4 killed)
- Truth sensor suppresses HIGH on harmonic (Session 4 killed; task-specific effect retained under Claim κ)
- Transformer 3× HIGH bias (Session 4 killed)
- Sharp asymmetry critical point (Session 4 killed)

---

## 4. DM3 IS / IS NOT — current snapshot

### DM3 IS (accumulated, evidenced)
- A precompiled Rust binary (`dm3_runner`) on Red Magic 10 Pro
- A 380-vertex C3-symmetric graph via exact-rational Sri Yantra + toroidal-twist lift
- A 72,960-dimensional bistable relaxation dynamical system
- Bistable in the harmonic regime (HIGH E≈88, Coh≈0.77 / LOW E≈75, Coh≈0.88 at default asym)
- Monostable in the holography regime (Retry, E≈15 at default asym)
- Selecting basins per episode as IID Bernoulli with p(HIGH) ≈ 0.34 at default
- Exposing 12 accepted `--task` values (10 confirmed clean in T1 cartography; resonance_v2 has a task-side issue)
- Exposing a 6-gate self-evaluating campaign (`exp_r1_r4_campaign`) with 4 canonical SHA equivalence classes catalogued
- A system where R1 flips cleanly with `--adj RandomAdj_v1.bin` and R2 flips cleanly with `--tags RegionTags_v2.bin`
- A system where compound RA+v2+steps=50 produces R1+R2+CL-1 + doubled r4.transfer_ratio
- **A system where `exp_k2_scars` learns strongly (uplift 0.01 → 1.32 across steps 1→20) and overfits by steps=50**
- Substrate-null: the harmonic p(HIGH) distribution and the exp_r1_r4_campaign gate surface are invariant to tested thermal/power-path/core-topology/airplane/core-pinning manipulations

### DM3 IS NOT
- Not an AI system
- Not a transformer-created bistability (H2 killed)
- Not a tunable resonance computer (`--freq` remains null on harmonic)
- Not a C3-asymmetric coupling (Claim γ retracted)
- Not a deterministic basin selector (IID confirmed at N=100 + re-confirmed across substrate)
- Not a system where harmonic and holography share one E continuum (Session 5 P3 killed that)
- Not a system with a universal basin classifier (Session 4 classifier valid only asym ∈ [−2, +2])
- Not a system where `--sensor-strength`/`--sensor-threshold` parameterize exp_k3_truth_sensor
- Not a system where `--steps` parameterizes resonance_r3
- Not a system where requesting `--steps > 20` on SY-default gate surface extends operational budget
- Not a system where basin selection couples to the tested thermal or power-path envelope
- Not a system where parallelizing dm3_runner processes produces throughput gain
- Not a commercial product. Live research artifact.

---

## 5. What's deferred / what's open

### Session 8+ candidates, ranked by the PRD prioritization formula
1. **S9 freq-locked governor sweep** — blocked by root requirement; needs
   device-side root or a signed userspace governor probe
2. **Intermediate adjacency files** between SY and Random to identify the
   property boundary that moves `r1.margin` 0.0 → 0.5
3. **Tier-2 thermal/basin sensitivity (M1-M4)** at higher N than S7 allowed
4. **AGD-C1 Mode A scaffold validation** — the PRD's highest-commercial-
   value single line, but requires embedding + retrieval + ontology pipeline
   (not a single-cell probe)
5. **Cross-platform determinism** if a second RM10 device is acquired
6. **exp_k2_scars deeper characterization** — given Claim μ is the first
   positive learning result, mapping its step-budget curve at N≥3 per
   step value is high-value
7. **R3 structural probe** — the `operational_steps` cap is at 10; what
   hard-coded or internal route controls it? Binary strings analysis may
   reveal the constant
8. **RegimeC (ChaosControl) entrypoint hunt** — binary strings reference
   it but no CLI unlocks; may need specific adj/tag combination

### Known gaps to document on the repo front door
- S5 truncated at N=23 (thermal-aborted); N=100 target deferred
- S9 deferred entirely (root)
- Tier-2/3/4 from PRD v2 §3 untouched this session (multi-session backlog)
- resonance_v2 task appears to have a self-test bug (T1 cartography)

---

## 6. Open scientific questions (for operator / downstream)

1. **What is Claim μ's step-budget curve shape?** T2 observed monotone
   increase from steps 1→20 then overfit at 50. Is this a bell curve
   with peak at 20-30? A sigmoid? A piecewise-linear threshold?
   N≥3 per step × finer grid would resolve.

2. **What property of RandomAdj_v1.bin sets `r1.margin = 0.5`?**
   SriYantra gives exactly 0.0. Clean-random gives 0.5. Where's the
   topological boundary? Permuted SY? Sparse random? Scale-free?

3. **Can any of the "CLI decorative" tasks (κ, ν) be made CLI-responsive
   by supplying a calibration file?** The `--calibration <path>` flag
   exists but has never been tested with a non-empty input.

4. **Does the compound flip (Claim λ) have higher-order interactions?**
   Three-axis: --adj × --tags × --steps. The r4.transfer_ratio
   multiplicative pattern suggests yes but was observed only at two
   --steps values.

5. **Is the per-episode basin RNG seeded from `/dev/urandom`, clock,
   or state?** Session 5 seed-determinism test was deferred. If seeded
   from device entropy, two back-to-back identical sessions should
   produce different basin sequences; if from clock/state, identical.

---

## 7. Governance posture

All non-negotiables from AGENTS.md maintained across Sessions 1-7:
- Receipts SHA-indexed
- Null results reported with same care as confirmations
- Pre-registered kill criteria applied honestly (Claim κ fails LEARNS at 79.4% without rounding up)
- Retractions visible (Claim γ)
- Weakenings visible (δ.3)
- No reward hacking
- No commercial framing in any artifact inside `repo_stage/`
- Sacred-geometry vocabulary treated as source, not evidence
- Binary hash gate enforced (`daaaa84a…`) at every cell start
- KAT canary integrated across every Session 7 battery

---

## 8. Artifact map

```
restart-hypothesis-rm10-primary-platform/
├── AGENTS.md                            # governance
├── docs/restart/
│   ├── DM3_SESSION[3-7]_FINAL_REPORT.md # per-session writeup
│   ├── DM3_SESSION7_PRD_v2.md           # current PRD
│   ├── DM3_STATUS_SNAPSHOT_20260422.md  # THIS file
│   └── NEXT_BOUNDED_ENGINEERING_MOVE.md
├── artifacts/
│   ├── phase_H/I/J/K/L/M/N/O/_*/        # Sessions 3-4
│   ├── phase_P2a/P2b/P3_*/              # Session 5
│   ├── phase_W0/W1/W2/W3_*/             # Session 6
│   └── phase_S7_P0_receipt_harness_20260418T151800Z/  # Session 7
│       ├── bin/                         # harness scripts
│       ├── S1_smoke/S2_pinned/S4_airplane/S6_core/
│       ├── S7_thermal_final/S8_final/S2H_final/S5_final/
│       ├── S10_final/S11_final/
│       └── T1_cartography/T2_scars_scaling/T3_plasticity/T11_cross_control/
├── repo_stage/                          # PUBLIC front door (repo-agent's domain)
│   ├── README.md
│   ├── CLAIMS.md
│   ├── IS_AND_IS_NOT.md
│   ├── CHARACTERIZATION_REPORT.md
│   ├── JOURNEY_LOG.md
│   ├── LIVE_PROJECT.md
│   ├── website_summary.md
│   ├── REPO_AGENT_FINDINGS.md
│   ├── HANDOVER_TO_REPO_AGENT_20260422.md  # THIS session's handover to repo-agent
│   ├── CITATION.cff
│   ├── MANIFEST.tsv
│   └── SESSION6_REVIEW_PACK.md
└── .gpd/STATE.md
```

---

## 9. On-device state (current)

- Phone plugged in, battery Charging, capacity 85%
- `dm3_runner` idle (no active cells)
- Harness staged at `/data/local/tmp/dm3_harness/` with full script suite
- All Session 7 cell directories preserved for future reference
- Binary hash verified: `daaaa84a…`

---

**End of status snapshot.** Written 2026-04-22. Next entry should be dated
at start of Session 8 or at the first point where Session 7 claims are
promoted/retracted.
