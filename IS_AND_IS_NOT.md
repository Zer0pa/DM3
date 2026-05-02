# DM3 — IS / IS NOT Ledger

Last updated: `2026-05-02` (Session 7 closeout + Session 8 Phase A/A5/B3/A6 + Phase G v2 partial chain + reconstruction Tier-2)

This ledger captures scoped positive and negative statements about what
DM3 is and is not, as evidenced by receipted experiments across
Sessions 1–8 (live Phase G v2 chain in flight; backwards reconstruction
lane at static Tier-2).

---

## DM3 IS

### Object

- A precompiled Rust binary, `dm3_runner`, SHA-256
  `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`,
  executable on Red Magic 10 Pro.
- A 380-vertex, C3-symmetric graph constructed via exact-rational 2D
  Sri Yantra plus a 3D toroidal-twist lift.
- A 72,960-dimensional (380 vertices × 192 features) relaxation
  dynamical system.

### Dynamics

- The `harmonic` task is bistable with HIGH basin
  `(E≈88, Coh≈0.77)` and LOW basin `(E≈75, Coh≈0.88)` at default
  parameters.
- The `holography` task is monostable in a RETRY basin `(E≈15, Coh≈0.72
  at asym=0)`.
- Basin selection at default harmonic parameters is IID Bernoulli with
  `p(HIGH) ≈ 0.34`.
- Across the Session 7 dynamics battery, harmonic `p(HIGH)` remains
  statistically stable across six measured arms and 665 total episodes:
  S2H baseline `(N=250)`, S7 cold `(N=100)`, S7 hot `(N=100)`,
  S8 battery `(N=30)`, S8 bypass `(N=70)`, and S5 basin volume
  `(N=23)`. All arm-level Wilson 95% confidence intervals overlap the
  Session 5 baseline `[25.5%, 43.7%]`.

### Capability surface

- The binary exposes a self-evaluating six-gate campaign via
  `--task exp_r1_r4_campaign`.
- At defaults, three gates PASS `(EPSILON_CRIT, R4, WAKE_SLEEP_ALIGN)`
  and three gates FAIL `(R1, R2, R3)`.
- The campaign is deterministic up to `run_sec`.
- The Session 7 smoke receipt fixes a default `--steps 5`
  reproducibility fingerprint at canonical SHA
  `9006df4ec02c8872b2037ce49ba9f2e9f27cfb7b92f62dfea5e7982d6be7d912`.
- `R1` flips when `--adj RandomAdj_v1.bin` is used.
- `R2` flips when `--tags RegionTags_v2.bin` is used, and
  `claim_level` advances `CL-0 → CL-1`.
- The 2×2 cross-control table is closed: `R1` responds to `--adj`,
  `R2` responds to `--tags`, and the axes remain separable at default
  `--steps 1`.
- The combined-axis configuration
  `RandomAdj_v1.bin + RegionTags_v2.bin + --steps 50`
  flips `R1` and `R2` together and raises `r4.transfer_ratio`
  from `1.369` to `2.678`.
- Session 7 final reporting closes a bit-level gate-layer substrate-null
  battery across the tested smoke conditions. The local checkout keeps
  the smoke fingerprint and harness tree visible, and keeps the
  standalone directory-name mismatch explicit in
  `REPO_AGENT_FINDINGS.md`.
- `R3` remains unreachable from the exposed CLI on the SY-default
  surface; requested `--steps > 20` does not raise `operational_steps`
  above `10`.

### Hidden task inventory

Beyond `harmonic` and `holography`, the binary accepts 10 additional
task names:

1. `interference`
2. `holographic_memory`
3. `exp_r1_r4_campaign`
4. `exp_i1`
5. `exp_i2`
6. `exp_h1_h2`
7. `exp_k2_scars`
8. `exp_k3_truth_sensor`
9. `resonance_r3`
10. `resonance_v2`

### Session 7 / Session 8 learning line

- `exp_k2_scars` is the first receipted positive learning line in
  Sessions 3–7. `best_uplift` rises
  `0.010 → 0.075 → 0.273 → 1.324` across
  `--steps 1 → 5 → 10 → 20`, then overfits at `--steps 50`.
- Session 8 Phase A/A5/A6 refines that line: `--steps 20` is a
  shoulder, not the peak. The one-step map across the 28→50 region is a
  trimodal sawtooth with local maxima at `--steps 33`
  (`best_uplift = 1.873756`), `41` (`1.708374`), and `49`
  (`1.819397`), sharp drops at `33→34` and `41→43`, and a final
  `49→50` cliff to `0.000000`.
- At the μ baseline config
  `--steps 20 / SriYantraAdj_v1.bin / RegionTags_v1.bin`,
  `exp_k2_scars` is invariant across `xnor_train`, `xnor_mini`, and
  `xnor_test` in the mirrored Phase A logs.
- Both adjacency topology and region-tag partition affect
  `exp_k2_scars`: the Phase A cross-graph table gives
  `SY+v1 = 1.324074`, `SY+v2 = 0.806000`, `RA+v1 = 1.341583`, and
  `RA+v2 = 0.000000` at `--steps 20`.
- `exp_k3_truth_sensor` does real internal work. Session 7 showed the
  exposed `--sensor-strength` and `--sensor-threshold` flags do not
  parameterize its KPI triple on the tested surface. Session 8 B3 shows
  `--steps` does change baseline and gap values (`75.0%` reduction at
  `steps=1`, `79.4%` at `steps=20`), while selected `sensor_error`
  stays near `22.3`.
- `resonance_r3` does real work inside its task loop, but the exposed
  `--steps` flag does not parameterize the emitted output.
- Session 8 B3 identifies three `--steps`-decorative task surfaces at
  `steps 1` vs `20`: `resonance_r3`, `resonance_v2`, and `exp_i2`.
  This is scoped to those step values and default inputs.

### Phase G v2 chain — closed cells through G.2

- **Path-independent at fixed config.** The Phase G cell `G.6
  path_dependence` reports `4/4 same-config canonical SHAs match across
  path A and B`. DM3 exposes no observable cross-invocation state on
  the tested surface. This closes claim `χ`.
- **σ″ trimodal sawtooth is geometry-independent in shape.** Phase G
  `G.2 trimodal_portability` reports
  `verdict = PASS, summary = "trimodal shape preserved in 3/3 configs"`.
  All three preserved cross-controls (cfg-A `RandomAdj_v1`, cfg-B
  `RegionTags_v2`, cfg-C `xnor_mini`) reproduce the σ″ peaks at
  `s33 / s41 / s49` and the cliff at `s50 = 0.000000`. σ″ promotes to
  CONFIRMED for shape; magnitudes are config-dependent and explicitly
  not promoted as portable.
- **Cliff at `s50` is universal.** All three G.2 configs return
  `p50 = 0.000000` exactly. The cliff is the strongest universal
  feature on the tested surface; its fine structure is `G.7`'s next
  deeper test (in flight at this update).
- **The `s50` zero is a clipped `best_uplift`, not absence of
  per-condition learning dynamics.** The 2026-04-30 08:30 UTC G.7
  in-flight logs show cfg-A complete at `s50` and cfg-B partial at
  `s50`: both return `best_uplift = 0.000000` by max-over-conditions
  clipping while `lesson=3` per-condition uplifts go negative. cfg-A
  reproduces `-0.201691` at `noise=0.100` and `-0.219131` at
  `noise=0.200` across 3/3 receipts; the first completed cfg-B `s50`
  receipt gives `-1.803669` and `-1.860878`. Direction is preserved
  across these two configs; magnitude remains config-bound. This is a
  scope note on the σ″ cliff, not an independent G.7 claim.
- **Cycle past the cliff.** Phase G `G.1 cycle_probe` reports
  `s56 best_uplift = 1.970840` on the σ″ baseline, higher than the σ″
  primary peak `s33 = 1.873756`. The `49 → 50` cliff is therefore not
  a permanent collapse. This is claim `ψ` (CANDIDATE).
- **Cycle-7 mechanism (PARTIAL).** `G.1.5 cycle_disambiguator` reports
  the multiplicity-7 sawtooth fits tighter than multiplicity-6 or -8 on
  the σ″ baseline. Recorded as suggestive; not promoted.
- **σ″ baseline determinism extension.** `G.0.5 determinism_recheck`
  reports `10/10` bit-exact `best_uplift` reproductions at both `s30`
  and `s33`. Folded into the ξ evidence base.

### Reconstruction (static, Tier-2)

The independent `dm3-runner-reconstruction-2026-04-27/` lane closes
seven of eight pre-registered reconstruction hypotheses at static
Tier-2 evidence level. The eighth, R8, requires Tier-3 Android
execution tracing and remains the sovereign open gate. See
`RECONSTRUCTION_TIER2_NOTE.md` for the full evidence table and
`CLAIMS.md` "Reconstruction (static, Tier-2)" for the formal claim
block. The relevant IS statements for this surface are:

- The loaded `SriYantraAdj_v1.bin` fixture graph is exactly
  `P_95 ☐ K_4` at parsed-fixture Tier-2 (380 vertices, 946 edges,
  degree histogram `{4: 8, 5: 372}`).
- The default internal `dm3_runner` skeleton (`build_helix_meru` +
  `build_dual_meru`) is exactly `P_95 ☐ K_3` at static-disassembly
  Tier-2 (285 vertices, 567 edges, degree histogram `{3: 6, 4: 279}`).
- The two surfaces share the path base `P_95 = 2 · (12 · 4) − 1` and
  are related by complete-graph fiber promotion `K_3 → K_4`. The
  loaded fixture's first Betti number is `946 − 380 + 1 = 567`, equal
  to the internal `P_95 ☐ K_3` edge count. This is an exact
  arithmetic identity, not a runtime coupling proof.
- `RegionTags_v2.json` is exactly the degree-4-root BFS shelling of
  the loaded fixture, with `RING_k = min(distance // 5, 8) + 1`. JSON
  mismatch count is zero against the host-side reconstruction.
- The Laplacian spectrum of the loaded fixture is the closed-form
  `λ_k(P_95) + μ(K_4)` with `μ(K_4) ∈ {0, 4, 4, 4}`. Fiedler value
  `0.001093485318147902`, λ_max `7.9989065146818525`.
- The full automorphism group of the loaded fixture graph is
  `Aut(P_95 ☐ K_4) = C_2 × S_4`, of order 48. The previously claimed
  `C_3` symmetry remains a sub-action of the natural `S_4` action on
  the four `K_4` fibers; it is preserved, but it is not the full
  automorphism group.
- Static disassembly identifies a file-loaded L-branch surface in
  `generate_tags_v2` and `run_spectral_analysis`, distinct from the
  internal `Dm3State::initialize / build_dual_meru` default path. No
  static call from the L-branch callees to `Dm3State`,
  `build_dual_meru`, or `flatten_dual_vertices` was found. Whether
  any live task-run actually consumes `RegionTags_v2.bin` (legacy
  TAG2) versus only the JSON / current TAG3 writer path is the open
  R8 question.

### Reproducibility

- `exp_r1_r4_campaign` outputs are deterministic up to `run_sec`, with
  multiple canonical SHA equivalence classes catalogued across Sessions
  6 and 7.
- `exp_k2_scars` promoted KPI outputs are deterministic at fixed
  configurations across the mirrored Session 8 Phase A equivalence
  classes.
- A5/A6 add cross-cell exact matches for `exp_k2_scars` at
  `--steps 30`, `35`, `40`, and `45`.
- τ confirms ARM64 cross-platform determinism for `exp_k2_scars` on the
  tested baseline values: RM10 native Android and Apple M1 Android ARM64
  emulator emit bit-exact `best_uplift` and `max_scar_weight` at
  `--steps {20,30,40,45,50}`.
- The `harmonic` task is stochastic in selection but stable in
  distribution at the tested granularity.

---

## DM3 IS NOT

### Computational claims it is NOT

- **Not an AI system.** No external agency, no general intelligence, no
  task-neutral cognition.
- **Not a transformer-created bistability.** H2 was killed; the graph
  geometry is sovereign.
- **Not a tunable resonance computer.** `--freq` remains a null line on
  the tested harmonic surface.
- **Not a C3-asymmetric coupling.** Claim γ remains retracted.
- **Not a deterministic basin selector.** Basin selection is IID at the
  promoted default surface.
- **Not a system with multiple independently confirmed dynamical control
  parameters.** Confirmed exposed axes are narrow: `--asymmetry` for
  basin position, `--adj` for R1, `--tags` for R2, and `--steps` for
  `exp_k2_scars` only.

### Scope claims it is NOT

- **Not a single E-continuum across tasks.** Harmonic and holography are
  distinct regimes.
- **Not a universal basin classifier.** The Session 4 locked classifier
  is valid only on asymmetry within `[−2, +2]`.
- **Not a system whose harmonic basin selection shows a receipted
  coupling to the tested thermal or power-path interventions.**
- **Not a system where requesting `--steps > 20` on the SY-default
  gate surface increases `operational_steps` above 10.**
- **Not a system where `--sensor-strength` or `--sensor-threshold`
  parameterize `exp_k3_truth_sensor`.**
- **Not a system where `--steps` parameterizes `resonance_r3`.**
- **Not a system where `--steps 1` versus `--steps 20` parameterizes
  `resonance_v2` or `exp_i2` on the tested default surface.**
- **Not a system where every callable task responds to `--steps`.**
- **Not a system where parallelizing `dm3_runner` yields throughput
  gain.** That line was tested and discarded.

### Interpretive claims it is NOT

- **Not a cognitive, spiritual, or mystical architecture.** Sri Yantra,
  Bhupura, Lotus, Bindu, Om, Aum, and Meru are source vocabulary, not
  evidence.
- **Not a broad “DM3 learns” claim.** The promoted positive learning
  result is narrow and task-specific to `exp_k2_scars` in the tested
  step window.
- **Not a system where `RandomAdj_v1.bin + RegionTags_v2.bin +
  --steps 20` learns on `exp_k2_scars`.** The mirrored Phase A logs
  show `best_uplift = 0.000000` in all three repeats. This is scoped to
  `--steps 20`, not a ceiling claim for all RA+v2 settings.
- **Not a system whose peak `exp_k2_scars` uplift is at `--steps 20`,
  `30`, or `40` on the mapped baseline surface.** A5/A6 move the
  candidate curve shape to a trimodal sawtooth with local maxima at
  `33`, `41`, and `49`.
- **Not a bimodal `exp_k2_scars` learning curve** on the mapped
  baseline 28→50 surface; old `σ` and `σ′` wordings are
  rejected-before-promoted.
- **Not a system whose σ″ magnitudes are configuration-invariant.**
  Phase G `G.2` shows the trimodal sawtooth shape is preserved across
  all three cross-controls, but cfg-B (`RegionTags_v2`) returns
  substantially weaker peaks (`p33 = 0.995` vs SY baseline
  `p33 = 1.874`) and zeros at `p34` and `p43`. The σ″ shape is
  geometry-independent; the σ″ values are not.
- **Not a system where fixed-config `exp_k2_scars` KPI output is
  stochastic** on the mirrored Phase A equivalence classes.
- **Not a generally tunable CLI capability surface.** Session 7 adds
  narrow sensor-flag decorativeness for `exp_k3_truth_sensor` and
  `--steps` decorativeness for `resonance_r3`; Session 8 B3 narrows that
  by showing `exp_k3_truth_sensor` is `--steps`-responsive in absolute
  values and adds scoped `--steps`-decorative candidates for
  `resonance_v2` and `exp_i2`.
- **Not a folder for commercial framing.** `repo_stage/` remains the
  scientific and receipted language lane.

### Reconstruction-side IS_NOT (static, Tier-2)

- **Not a complete reconstruction.** R1–R7 are static Tier-2 evidence:
  parsed fixtures, host-recomputed invariants, and static-disassembly
  call-graph identity. R8 (Android argv / file-open / output trace
  under live execution) remains `OPEN_TIER3_BLOCKED`. Until R8 closes,
  the reconstruction is not authority-complete.
- **Not "the binary's runtime graph is `P_95 ☐ K_4`."** The parsed
  loaded fixture is `P_95 ☐ K_4`. Whether the live task actually
  consumes that fixture, generates an isomorphic graph, or combines
  fixture loading with runtime mutation is the R8 question. Static
  evidence favours independent file-load for the L-branch
  tag/spectral callees, but Tier-3 trace is still required.
- **Not a "Sri Yantra mystical geometry" claim at graph level.** The
  graph is the Cartesian product of a 95-vertex path and a 4-clique.
  The geometric/Sri-Yantra vocabulary is source-history, preserved at
  the construction layer (claim α) and not re-promoted at the
  reconstruction layer.
- **Not "transformer-static and graph-static both reconstructed."**
  The 192-wide `MicroTransformer` surface is identified statically as
  a separate component but is not the subject of the R1–R7 graph
  reconstruction. Its interaction with the relaxation dynamics is not
  reconstructed at this surface.
- **Not "TAG2 is a live consumed file."** The legacy `RegionTags_v2.bin`
  is TAG2/version 2; the current binary writer string is TAG3/version
  3. Whether any live task consumes the legacy TAG2 file is the open
  R8 question; static evidence says only that the current writer is
  TAG3.

---

## Session 7 closeout notes

- The Session 7 closeout claim set is now
  `θ, ι, κ, λ, μ, ν`, with `δ.3` visibly weakened.
- The strongest public headline is the combination of:
  first receipted positive learning (`μ`),
  dynamics-layer substrate null (`ι`),
  and closed 2×2 gate cross-control (`λ`).
- The gate-layer substrate-null closeout is carried with an explicit
  repo seam: the engineer handover names standalone
  `S2_pinned / S4_airplane / S6_core` directories that are not exposed
  verbatim in this checkout. That mismatch stays visible in
  `REPO_AGENT_FINDINGS.md`.

## Session 8 Phase A / A5-B3-A6 close note

- Phase A is closed under a pure-scientific-learning frame in
  `docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md`.
- The local mirror includes the A.1/A.2/A.3/A.4 receipt trees and
  `device_snapshot/bin/run_cell.sh`.
- The follow-on final report
  `docs/restart/DM3_SESSION8_PHASE_A5_B3_A6_FINAL_REPORT_20260425.md`
  closes 57 additional A5/B3/A6 local per-run receipts.
- The promoted Phase A/A5/B3/A6 lines are `ξ` fixed-config determinism,
  `ο` sharp overfit cliff localized to `49→50`, and `τ` ARM64
  cross-platform determinism. Candidate lines are `π` scoped dataset
  invariance, `ρ` RA+v2+steps=20 zero learning, `σ″` trimodal sawtooth
  curve shape, and `φ` three scoped `--steps`-decorative tasks.
- Old `σ` and `σ′` curve-shape wordings are rejected-before-promoted
  and remain visible as process wins, not active claims.
- Count seam: the final report and summaries use 55 total-run
  accounting, while the local mirror has 52 per-run receipt/log pairs.
  The promoted numeric statements use the 52 local per-run logs and the
  matching summary hashes; the later A5/B3/A6 chain adds 57 directly
  mirrored per-run receipts. See `REPO_AGENT_FINDINGS.md`.
- The final report documents an airplane-mode deviation: 40 reported
  Phase A receipts were captured with airplane mode OFF. No receipt is
  quarantined, and the deviation remains visible.
- Engineering-side admissible finding: the old all-sensor thermal gate
  on RM10 is not a trustworthy execution guard because the PMIC sensor
  can stay hot long after CPU zones cool. The mirrored harness snapshot
  now contains the CPU/GPU-only patched `run_cell.sh` and the pre-patch
  backup.

## Phase G v2 chain note (G.2 closed; later cells unpromoted; updated 2026-05-02 18:38 UTC)

- Phase G v2 launched 2026-04-25 18:25:54 UTC. Master log on device
  at `/data/local/tmp/dm3_harness/phase_g_chain.log`. PRD at
  `docs/restart/DM3_PHASE_G_AUGMENTED_PRD_v2_REORDERED_20260425.md`.
- Closed cells with promoted ledger entries:
  - `G.0` PASS (pre-launch gates)
  - `G.0.5` PASS (folded into `ξ`; 10/10 bit-exact at `s30/s33`)
  - `G.6` PASS (claim `χ`, path-independence)
  - `G.1` PASS (claim `ψ`, `s56 = 1.970840` cycle past cliff,
    CANDIDATE)
  - `G.1.5` PARTIAL (multiplicity-7 mechanism candidate, not
    promoted)
  - `G.2` PASS (σ″ trimodal sawtooth shape geometry-independent
    across cfg-A / cfg-B / cfg-C cross-controls; promotes σ″ to
    CONFIRMED for shape; magnitudes config-dependent, not portable)
- The latest GitHub-resident G.7 pull remains the 2026-04-30 partial
  snapshot: 22 immutable in-flight G.7 receipts, cfg-A complete at
  15/15, cfg-B partial at 7/15, cfg-C pending at 0/15, and no
  `outcome.json`.
- The 2026-05-02 audit note reports that G.7 later closed on-device and
  G.3 is in flight. Those statuses are evidence handles only here: no
  G.7 verdict, G.3 class assignment, G.4, G.5, or G.5+ outcome is
  promoted without the chain-close handover and host-side receipt pull.
- Closed-cell evidence for `G.0.5`, `G.1`, and `G.1.5` remains mirrored
  under `artifacts/phase_S8_PG_followup_20260429T023308Z/`. The
  13:01 UTC partial pull under
  `artifacts/phase_S8_PG_followup_20260429T130215Z/` supersedes G.2 and
  G.6 evidence paths. The 08:30 UTC partial pull under
  `artifacts/phase_S8_PG_followup_20260430T082723Z/` is the latest G.7
  GitHub-resident snapshot. The May 2 audit note is mirrored at
  `docs/restart/REPO_AGENT_NOTE_PHASE_G_G7_CLOSE_AND_G3_IN_FLIGHT_20260502T1838.md`.
  The next ledger update for Phase G lands when the chain closes and
  the remaining cell receipts are pulled to host.

## Reconstruction (static, Tier-2) note (2026-04-28)

- Independent backwards-reconstruction lane:
  `dm3-runner-reconstruction-2026-04-27/`.
- Eight pre-registered reconstruction hypotheses `R1..R8` at
  `phase_05_falsification_harness/H1_H8_STATIC_PREFLIGHT.md`.
- R1–R7: PASS_STATIC_TIER2 (or PASS_STATIC_TIER2_DYNAMIC_OPEN for R6).
- R8: `OPEN_TIER3_BLOCKED`. Tier-3 closure requires Android
  argv/`openat`/write trace under live `dm3_runner` execution and is
  parked until the live Phase G v2 chain closes.
- See `RECONSTRUCTION_TIER2_NOTE.md` for the full identity card,
  closed-form spectrum, RegionTags shelling formula, and runtime
  surface flow.
- Until R8 closes, no claim of complete reconstruction is promoted on
  this surface.

---

## How this ledger is maintained

Each session appends or revises lines with an explicit justification and
receipted basis. Removals require a written retraction or weakening that
remains visible in `CLAIMS.md`.
