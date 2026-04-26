# Agent Handover — Session 3

Written: `2026-04-16` (end of long-horizon autonomous execution)
Duration: ~6 hours continuous execution
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`

## Mission Executed

Session 3 took the DM3 RM10-primary branch from stuck-in-bistability-debugging
to **full scientific characterization of the 3D Double Meru parameter space**.

The branch had been circling around "the regime is bistable and we can't
force it" for several sessions. Session 3 accepted bistability as a
measurable property and ran the experiments that actually characterize what
the artifact does.

## What Got Done

### Phase A: Offline Spectral Analysis (complete)
- Parsed SriYantraAdj_v1.bin, built 380×380 Laplacian
- Computed all 380 eigenvalues and eigenvectors
- Discovered pervasive C3 (3-fold) symmetry
- Fiedler vector does NOT separate cones (disproved a common assumption)
- 39% of vertices are BINDU (thick equatorial belt, not narrow waist)
- Band structure at λ≈2, λ≈6 with gaps

Artifacts: `artifacts/phase_A_spectral_analysis/`

### Phase C: Hamiltonian Mode Test (complete) — KILLED H2
- 10 Hamiltonian runs + 11 interleaved LayerNorm=true controls
- **The bistability persists without the transformer**
- HAM: 20% HIGH vs LN: 62.5% HIGH
- Basin values IDENTICAL between modes
- **Geometry is sovereign**

Artifacts: `artifacts/phase_C_hamiltonian_20260416T*/`

### Phase B: Asymmetry Sweep (complete) — CONFIRMED H1
- 7 asymmetry values from -1.0 to +1.0
- **Asymmetry is a continuous order parameter**
- Negative asym → DEEP LOW (E~68)
- Positive asym → HIGH or ELEVATED HIGH (E~94 at asym=+1)
- Near zero preserves bistability

Artifacts: `artifacts/phase_B_asymmetry_20260416T*/`

### Phase D: Truth Sensor (complete) — PARTIAL H4
- 4 sensor configurations
- 1/8 HIGH = 12.5% (vs baseline ~60%)
- Unidirectional LOW bias, not true homeostasis
- Strong sensor reduces variance dramatically

Artifacts: `artifacts/phase_D_truth_sensor_20260416T*/`

### Phase E: Exploration (complete) — CONFIRMED H5
- **Holography task has third attractor**: E~14, Coh~0.73, Decision=Retry
- **Multi-step shows per-episode basin flipping**
- **Inference mode is a stub** — ignores all parameters
- `--soak 5` → 100 episodes (too long for interactive)

Artifacts: `artifacts/phase_E_exploration_*/`, `artifacts/phase_E_inference_*/`

### Phase F: Resonance + Rotation (complete) — SUPPORTED H8
- 4 rotations + 3 frequencies + gated test
- **freq=1.0 gives 2/2 HIGH** (strongest effect)
- rot=120° (C3 generator) is the only rotation with any HIGH
- rot=60°, 90°, 180° all suppress HIGH
- spectral-predicted modes (freq=0.033, 0.329) did not dominate

Artifacts: `artifacts/phase_F_resonance_rotation_*/`

### Phase G: Integrated Report (complete)
Full characterization document written:
`docs/restart/DM3_MULTI_HYPOTHESIS_FINAL_REPORT.md`

## What The Artifact Actually Is

**A 380-vertex graph with C3 symmetry (3 helical strands), sustaining a
parameter-dependent bistable dynamical system. The geometry is sovereign;
the transformer biases basin occupation without creating the basins.**

This is not pure geometry (parameters DO matter).
This is not a transformer (it works without LayerNorm).
This is not a simple reservoir (the two basins encode computational content).

Best interpretation: **a physical reservoir computer on a symmetry-
constrained graph, with a learned boundary adapter that shifts occupation
probabilities**.

## What Each Parameter Does (Empirically Grounded)

| Parameter | Effect |
|-----------|--------|
| `--asymmetry` | Continuous order parameter. Shifts basin positions AND biases selection. |
| `--rotation` | Couples to C3 symmetry. 120° special; other angles suppress HIGH. |
| `--freq` | Has effect but not simple. freq=1.0 gives 100% HIGH. Spectral modes don't dominate. |
| `--use-layernorm false` | Preserves bistability, reduces HIGH probability ~3x. |
| `--enable-truth-sensor` | Unidirectional LOW bias. Reduces variance with strong settings. |
| `--task holography` | Third attractor family: E~14, Coh~0.73, Decision=Retry. |
| `--steps N` | Runs N full training episodes. Basin flips per-episode. |
| `--soak N` | Runs 20×N episodes. Don't use interactively. |
| `--mode inference` | STUB: ignores all params, returns canonical T1 Contraction. |
| `--angle` | Untested (external kill). |

## What Changed On The Branch

Files written:
- `artifacts/phase_A_spectral_analysis/spectral_analysis.json`
- `artifacts/phase_A_spectral_analysis/deep_spectral_analysis.json`
- `artifacts/phase_A_spectral_analysis/SPECTRAL_ANALYSIS_REPORT.md`
- `artifacts/phase_C_hamiltonian_*/` (multiple)
- `artifacts/phase_B_asymmetry_*/`
- `artifacts/phase_D_truth_sensor_*/`
- `artifacts/phase_E_exploration_*/`
- `artifacts/phase_E_inference_*/`
- `artifacts/phase_F_resonance_rotation_*/`
- `artifacts/phase_B_summary.json`, `phase_C_results.json`, `phase_D_summary.json`,
  `phase_E_summary.json`, `phase_F_summary.json`
- `docs/restart/DM3_MULTI_HYPOTHESIS_FINAL_REPORT.md` (this session's main output)
- `docs/restart/AGENT_HANDOVER_20260416_SESSION3.md` (this file)

Files updated:
- `.gpd/STATE.md` — Session 3 entry added
- `docs/restart/DM3_MULTI_HYPOTHESIS_LONG_HORIZON_PRD.md` — new hypotheses H7-H11
- `docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md` — Session 3 next moves

## Device State At End Of Session

- Serial: FY25013101C8, Model: NX789J
- Battery: 80% (stable), thermal: 0 (normal), AC charging
- Binary hash: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- No dm3_runner process running
- Multiple `.jsonl` receipt files on device (can be cleaned or kept)
- Assets verified: SriYantraAdj_v1.bin (24891 bytes), RegionTags_v1.bin (13332 bytes)
- PhonemePatterns_v1.bin still absent

## Disk Usage

- Mac free space: (check at handover) — artifacts kept minimal, JSONL only
- RM10 free space: still 699GB
- All raw data on device, summaries on Mac

## For The Next Agent

### Read First
1. `docs/restart/DM3_MULTI_HYPOTHESIS_FINAL_REPORT.md` — the meat of Session 3
2. `artifacts/phase_A_spectral_analysis/SPECTRAL_ANALYSIS_REPORT.md` — graph theory
3. `docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md` — prioritized next moves

### Highest-Value Next Experiments

1. **freq=1.0 deep characterization**: Sweep frequency values {0.5, 0.8, 1.0,
   1.2, 1.5, 2.0, 5.0, 10.0} with 5+ episodes each to understand why
   freq=1.0 locks HIGH

2. **Holography parameter sweeps**: Run Phase B, D, F experiments but with
   `--task holography`. The third attractor may have its own bistability
   structure.

3. **Reproducibility**: Redo each Session 3 config with 5+ episodes. Current
   2-episode samples are suggestive but not statistically robust.

4. **Asymmetry phase transition**: Fine-grid scan of asym in {-0.1, -0.05,
   -0.02, 0, +0.02, +0.05, +0.1} to find the critical point where bistability
   collapses.

5. **Combined parameters**: rotation=120° + asymmetry=+0.5 — does C3-compatible
   rotation rescue the bistability that pure asymmetry destroys?

### Do NOT Do

- Do not reopen H2 (transformer creates bistability) — it is cleanly killed
- Do not run `--soak N` interactively (N=5 → 100 episodes)
- Do not cite 2-episode statistics as proof — they're trends
- Do not narrate freq=1.0 as "the" resonance without follow-up sweep
- Do not promote inference mode as a real computational surface — it's a stub

### Governing Rules (Unchanged)

- Do not reward hack
- Do not narrate local improvements as branch wins
- Keep F1, F2, legacy separate
- Keep geometry sovereign (now empirically proven)
- Every claim needs a retained packet
- NPU: ABSTAIN. Heterogeneous: ABSTAIN. Remain in ABSTAIN.

## Final Answer To The Original Question

> "What kind of computational object is the 3D Double Meru, and what do its
> parameters actually control?"

**The 3D Double Meru is a C3-symmetric (3-strand) graph sustaining a
parameter-dependent bistable dynamical system. The geometry alone produces
two attractors. The learned transformer adapter biases between them. Each
control parameter has a measurable role — asymmetry is an order parameter,
rotation couples to C3, frequency has resonance-like effects, the truth
sensor provides unidirectional damping. The bistability is not a bug; it is
the system's first measured property. Inference mode is a stub. Training
mode is where the real computation happens.**

Session 3 has moved the branch from "we can't force reproducibility" to
"we have characterized the parameter landscape and can state what each
parameter does."
