# DM3 — IS / IS NOT Ledger

Last updated: `2026-04-21` (Session 7 interim, mirrored state)

This ledger captures scoped positive and negative statements about what
DM3 is and is not, as evidenced by receipted experiments across
Sessions 1–7 interim.

---

## DM3 IS

### Object

- A precompiled Rust binary, `dm3_runner`, SHA-256
  `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`,
  executable on Red Magic 10 Pro (Android, Snapdragon 8 Elite, Adreno
  GPU, ~9.5 MB).
- A 380-vertex, C3-symmetric graph constructed via exact-rational 2D
  Sri Yantra + 3D toroidal-twist lift. Construction milestone dated
  2025-10-10.
- A 72,960-dimensional (380 vertices × 192 features) bistable
  relaxation dynamical system.

### Dynamics

- The primary callable tasks `harmonic` and `holography` exercise a
  resonance-training loop that relaxes a 72,960-dim state vector toward
  fixed-point attractors under `x_{t+1} = x_t + dt · (f(x_t) − x_t)`.
- The `harmonic` task exhibits **bistability** with HIGH basin (E≈88,
  Coh≈0.77) and LOW basin (E≈75, Coh≈0.88) at default parameters.
- The `holography` task exhibits **monostability** in a RETRY basin
  (E≈15, Coh≈0.72 at asym=0).
- Asymmetry smoothly deforms basin positions. Validated in E-space over
  asym ∈ [−5, +5]; Coh signatures are asym-invariant only on asym ∈
  [−2, +2].
- Basin selection at default parameters is **IID Bernoulli** with
  p(HIGH) ≈ 0.34 (Session 5 P2a N=100; independence confirmed,
  transitions within 3pp of marginal, run-length distributions match
  geometric).
- Across the mirrored Session 7 substrate battery,
  `harmonic --steps 5` remains statistically stable on the tested
  thermal and power-path interventions: S2H 35.6% [29.9%, 41.7%] at
  N=250, COLD 36.0% [27.3%, 45.8%] at N=100, HOT 33.0% [24.6%, 42.7%]
  at N=100, BATTERY 36.7% [21.9%, 54.5%] at N=30, BYPASS 28.6%
  [19.3%, 40.1%] at N=70. All overlap the Session 5 baseline.

### Capability surface

- The binary exposes a self-evaluating 6-gate experiment via
  `--task exp_r1_r4_campaign`. Gates: EPSILON_CRIT, R1, R2, R3, R4,
  WAKE_SLEEP_ALIGN.
- At defaults (SriYantra adjacency, RegionTags_v1, asym=0), 3 gates
  PASS (EPSILON_CRIT, R4, WAKE_SLEEP_ALIGN) and 3 FAIL (R1, R2, R3).
- The campaign is deterministic: byte-identical output across replicates
  except `run_sec` (verified in Session 6 W1).
- **R1 flips FAIL→PASS when `--adj RandomAdj_v1.bin`** is used
  (Session 6 W1 Tier C). `r1.margin` 0.0 → 0.5, crosses 0.01 threshold.
- **R2 flips FAIL→PASS when `--tags RegionTags_v2.bin`** is used.
  `claim_level` advances CL-0 → CL-1.
- **R3 is payload-moving** along the `--steps` axis: `r3.k2_uplift`
  4× increase from steps=1 to steps=20, though the R3 gate remains
  FAIL in every tested config.
- The Session 7 smoke receipt fixes a default `--steps 5` reproducibility
  fingerprint at canonical SHA `9006df4ec02c8872...`.
- Mirrored partial Session 7 S11 receipts show that requested
  `--steps 20 / 50 / 100` on the SY-default surface all saturate
  `operational_steps` at 10, keep `R3 == false`, and keep
  `r3.k2_uplift == 0.02921423316001892`.
- A mirrored partial combined-axis S11 receipt
  (`RandomAdj_v1.bin + RegionTags_v2.bin + --steps 50`) flips
  **R1 and R2 together**, advances `claim_level` to `CL-1`, and raises
  `r4.transfer_ratio` to `2.67826509475708`.

### Hidden task inventory

Beyond `harmonic` / `holography`, the binary accepts 10 task names,
all confirmed callable in Sessions 5 + 6:

1. `interference` (Phase F classification; deterministic, does not learn at defaults)
2. `holographic_memory` (GPU-initialized memory experiment; CSV logged; no learning at defaults)
3. `exp_r1_r4_campaign` (self-evaluating 6-gate campaign)
4. `exp_i1` (Minimal Holographic Memory Bank)
5. `exp_i2` (Geometry Grammar & Auto-Correction; Bhupura → Ring 9 vs Lotus → Ring 8)
6. `exp_h1_h2` (Two-Lesson Probe: Bhupura vs Lotus)
7. `exp_k2_scars` (Scar Formation Grid Search; explicit multi-lesson learning)
8. `exp_k3_truth_sensor` (Truth Sensor Stability Test; this task IS sensor-sensitive)
9. `resonance_r3` (Plasticity & Transfer: Om → Aum → Om)
10. `resonance_v2` (frequency sweep with zero drive nodes by default)

### Reproducibility & determinism

- All `exp_r1_r4_campaign` outputs are byte-deterministic up to
  `run_sec`. Canonical SHA-256 (with `run_sec` zeroed) equivalence
  classes identified this session: `6317e82281cee0b0` (SY default family),
  `21ef856f094dff82` (RA default family), `d15c551d4e537545` (SY+tags_v2),
  `06e5cf74d608fe4a` (SY+steps=20).
- On the Session 7 smoke harness at `--steps 5`, the default family is
  fingerprinted by canonical SHA
  `9006df4ec02c8872b2037ce49ba9f2e9f27cfb7b92f62dfea5e7982d6be7d912`.
- Basin selection in `harmonic` task is stochastic per episode but
  statistically independent across episodes within a session.

---

## DM3 IS NOT

### Computational claims it is NOT

- **Not an AI system.** No external agency, no goal, no task-neutral
  intelligence. It is a dynamical system with boolean gates.
- **Not a transformer doing the work.** The transformer component
  exists in the binary (WGSL kernel, Q/K/V in shared memory) but
  disabling it via `--use-layernorm=false` (Hamiltonian / Bicameral
  mode) does not alter basin selection rates at N=5. H2 was killed in
  Session 3 and strengthened in Session 4.
- **Not a tunable resonance computer.** The `--freq` parameter has no
  confirmed resonance structure (Session 4 Phase I).
- **Not a device with multiple independent control parameters.** Only
  `--asymmetry`, `--adj`, and `--tags` have confirmed effects on some
  surface. `--rotation`, `--freq`, `--angle`, `--enable-truth-sensor`,
  `--use-layernorm`, `--dataset` are null or boundary-limited.
- **Not a C3-asymmetric dynamical coupling.** Claim γ from Session 4
  (rot=60° uniquely couples with asymmetry at the basin boundary) was
  RETRACTED in Session 5 at N=10 pooled; rot=60° and rot=120° give
  statistically indistinguishable HIGH rates.
- **Not a deterministic basin selector.** Independence confirmed at
  N=100 (Session 5 P2a) at default asymmetry.
- **Not a system whose mirrored harmonic basin distribution shows a
  receipted coupling to the tested thermal or power-path interventions.**
  The mirrored Session 7 cold / hot / battery / bypass arms all overlap
  the Session 5 baseline CI.

### Scope claims it is NOT

- **Not a shared E continuum across tasks.** Harmonic (bistable) and
  holography (monostable) are distinct dynamical regimes with a ~60
  E-unit gap that persists across asym ∈ [−5, +5]. They do not merge
  (Session 5 P3 + Session 6 W2).
- **Not a system whose basin classifier is universal.** The Session 4
  locked classifier (LOW Coh > 0.82 / HIGH Coh < 0.82) is valid only
  for asym ∈ [−2, +2]. At asym ≤ −3, both harmonic basin Coh
  signatures compress below 0.82 (Session 5 P3, confirmed and extended
  in Session 6 W2).
- **Not a system whose gate surface responds to dynamical parameters.**
  `exp_r1_r4_campaign` at N=10+ configs is invariant to
  `--asymmetry`, `--rotation`, `--dataset`. Gate-flipping axes are
  graph-topology axes (`--adj`, `--tags`).
- **Not a system where requesting `--steps > 20` on the mirrored
  SY-default Session 7 S11 surface increases `operational_steps` above
  10.** The requested step count changes metadata but not the internal
  operational cap in the mirrored partial receipts.

### Interpretive claims it is NOT

- **Not a cognitive architecture.** Inherited vocabulary (Bhupura,
  Lotus, Bindu, Sri Yantra, Om, Aum, Meru) is source / naming
  provenance, not evidence.
- **Not a spiritual or consciousness artifact.** The binary computes
  numeric gates; the geometric inspiration is source history.
- **Commercial framing does not belong in this folder.** This staged
  packet is scientific / receipted language only.
- **Not a publishable-result machine.** DM3 is a live research artifact.
  Claims carry pre-registered kill criteria. Retractions are features.

---

## W3 verdict landed

- **Claim ζ (p(HIGH) is parameter-INVARIANT at |asym| ≤ 0.2):** CONFIRMED.
  Arm 0: 34%, Arm A (+0.2): 42%, Arm B (−0.2): 32%. All three CIs
  overlap. A weak monotone trend is visible but inside statistical noise
  at N=100 per arm; kept as a Session 7 seed.

## Session 7 interim additions

- **Claim θ (harmonic dynamics-layer substrate null):** CONFIRMED on the
  mirrored local battery of 550 harmonic episodes.
- **Claim ι (gate-layer substrate null across the full 40-invocation
  battery):** still pending sync because the full gate-cell mirror is
  not present in this checkout.
- **Claim κ (compound R1+R2 flip):** mirrored as a partial S11 receipt;
  final combined-axis cell still pending.

---

## How this ledger is maintained

Each session appends new lines or modifies existing lines with an
explicit justification and dated receipt. Removals require a written
retraction (e.g., Claim γ) that remains visible in CLAIMS.md.
