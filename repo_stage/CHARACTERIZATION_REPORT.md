# DM3 Characterization Report (Sessions 1–8 Phase A/A5/B3/A6)

Last updated: `2026-04-25` — Session 7 closeout + Session 8 Phase A/A5/B3/A6

## What the object is

DM3 is a precompiled Rust binary implementing a specific computational
artifact: a 72,960-dimensional state-space dynamical system
`(380 vertices × 192 features)` on a fixed C3-symmetric graph derived
from an exact-rational 2D Sri Yantra construction lifted to 3D via a
toroidal twist. The binary is `dm3_runner`, SHA-256
`daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`.

The graph is fixed. The dynamical process is a relaxation loop cycling
through internal learning rules (`R0 Random`, `R1 Oja`, `R2 Contrastive`)
with an energy-based component and XNOR binary sampling. Different
`--task` values expose different slices of that surface.

## Callable tasks (public surface)

The binary accepts twelve `--task` values:

| Task | Description | Principal output |
|---|---|---|
| `harmonic` | Resonance-training loop on the harmonic landscape | standard JSONL |
| `holography` | Boundary→bulk projection experiment | standard JSONL |
| `interference` | Phase-F style classification probe | stdout |
| `holographic_memory` | GPU-initialized memory-bank experiment | CSV |
| `exp_r1_r4_campaign` | Self-evaluating six-gate campaign | single JSON object |
| `exp_i1` | Minimal Holographic Memory Bank | CSV |
| `exp_i2` | Geometry grammar and auto-correction | CSV |
| `exp_h1_h2` | Two-lesson probe | CSV |
| `exp_k2_scars` | Scar-formation learning task | stdout KPIs |
| `exp_k3_truth_sensor` | Truth-sensor task | stdout KPIs |
| `resonance_r3` | Plasticity / transfer task | stdout |
| `resonance_v2` | Frequency-coherence sweep | stdout / CSV-like text |

No `--seed` flag is exposed. Basin RNG remains source-blocked from the
CLI surface.

## Harmonic task behaviour

At default parameters, `harmonic` is bistable:

| Basin | E | Coh | decision |
|---|---|---|---|
| HIGH | 88–89 | ~0.77 | Commit |
| LOW | 75–76 | ~0.88 | Commit |

Session 5 confirmed that basin selection is IID Bernoulli with
`p(HIGH) ≈ 0.34` at the promoted default surface. Session 6 showed that
basin positions shift smoothly with asymmetry while selection rate does
not show a clean dependence within `|asym| <= 0.2`.

Session 7 closes the dynamics-layer substrate-null line at the tested
granularity. Harmonic `p(HIGH)` stays inside overlapping Wilson
confidence intervals across:

- S2H baseline `(N=250)`
- S7 cold `(N=100)`
- S7 hot `(N=100)`
- S8 battery `(N=30)`
- S8 bypass `(N=70)`
- S5 basin volume `(N=23)`

Total: **665 episodes**. All six arms overlap the Session 5 baseline
`[25.5%, 43.7%]`.

## Holography task behaviour

`holography` is a distinct operating regime, not a second view onto the
harmonic surface. It is monostable in a RETRY basin at approximately
`E≈15, Coh≈0.72` for default asymmetry. Harmonic and holography do not
merge into one E continuum; the gap remains roughly 60 E-units across
the tested shared asymmetry range.

## The `exp_r1_r4_campaign` gate surface

`exp_r1_r4_campaign` is the binary's most interpretable structural
surface. It emits six named gates plus supporting payloads:

- `EPSILON_CRIT`
- `R1`
- `R2`
- `R3`
- `R4`
- `WAKE_SLEEP_ALIGN`

At defaults `(SriYantraAdj_v1 + RegionTags_v1)`:

- PASS: `EPSILON_CRIT`, `R4`, `WAKE_SLEEP_ALIGN`
- FAIL: `R1`, `R2`, `R3`

### What moves the gates

- `R1` is a graph-topology gate. It flips when
  `--adj RandomAdj_v1.bin` is used.
- `R2` is a region-structure gate. It flips when
  `--tags RegionTags_v2.bin` is used, and `claim_level` advances
  `CL-0 → CL-1`.
- `R4` is already PASS at defaults and stays above threshold on all
  promoted surfaces.

### What Session 7 adds

- **Smoke fingerprint.** On the Session 7 smoke surface
  `(--task exp_r1_r4_campaign --steps 5)`, the default campaign emits
  canonical SHA `9006df4ec02c8872...`.
- **R3 weakening.** The old Session 6 reading that R3 “payload-moves
  along `--steps`” is weakened. Session 7 A-cells at requested
  `--steps 20 / 50 / 100` show that the SY-default surface saturates at
  `operational_steps == 10`; above that, the payload no longer advances
  and `R3` remains false.
- **Compound flip.** `RandomAdj_v1.bin + RegionTags_v2.bin + --steps 50`
  flips `R1` and `R2` together, advances `claim_level`, and raises
  `r4.transfer_ratio` from `1.369` to `2.678`.
- **Cross-control closure.** The 2×2 table `{SY, RA} × {v1, v2}` is
  now closed at default `--steps 1`: `R1` is pure `--adj`, `R2` is pure
  `--tags`, and `RA+v2` is deterministic across 3 replicates.

### Gate-layer substrate-null note

The Session 7 final report closes a bit-level gate-layer substrate-null
battery across the tested smoke conditions. The local checkout preserves
the smoke fingerprint, the harness tree, and the final report, while
also keeping an explicit repo seam visible: the handover names
standalone `S2_pinned / S4_airplane / S6_core` directories that are not
exposed verbatim in this checkout. See `REPO_AGENT_FINDINGS.md`.

## Session 7 / 8 learning and CLI-decorative task lines

### `exp_k2_scars`

This is the first receipted positive learning line in Sessions 3–7.
Session 7 T2 shows:

| `--steps` | `best_uplift` | Outcome |
|---|---|---|
| 1 | 0.010 | below threshold |
| 5 | 0.075 | learns |
| 10 | 0.273 | learns |
| 20 | 1.324 | LEARNS-STRONG |
| 50 | 0.000 | overfit |

The promoted statement is narrow: `exp_k2_scars` learns strongly on the
tested step budget, then overfits at high step count. This is not a
blanket “DM3 learns” claim.

Session 8 Phase A deepens that line with mirrored local receipts:

| Cell | Local per-run logs | Result |
|---|---:|---|
| A.1 μ robustness | 10 | `--steps 20` repeats at `best_uplift = 1.324074` |
| A.2 overfit boundary | 21 | coarse 5-step bracket; later superseded by A5/A6 |
| A.3 cross-graph | 12 | both adjacency and tags affect learning; RA+v2 gives zero |
| A.4 cross-dataset | 9 | xnor train/mini/test all return `1.324074` |

A.2 values:

| `--steps` | `best_uplift` |
|---|---:|
| 20 | 1.324074 |
| 25 | 1.380150 |
| 30 | 1.644524 |
| 35 | 1.405548 |
| 40 | 1.642128 |
| 45 | 1.332733 |
| 50 | 0.000000 |

The follow-on A5/A6 sweeps replace the coarse 30/40 reading. The
baseline `exp_k2_scars` curve across the 28→50 region is a candidate
trimodal sawtooth:

| Region | Steps | Shape |
|---|---|---|
| Cycle 1 | 28→33 | monotone rise to global peak `1.873756` at `s33` |
| Drop 1 | 33→34 | `1.873756 → 1.370651` |
| Cycle 2 | 34→41 | monotone rise to local max `1.708374` at `s41` |
| Drop 2 | 41→43 | `1.708374 → 1.160828` |
| Cycle 3 | 43→49 | monotone rise to local max `1.819397` at `s49` |
| Cliff | 49→50 | `1.819397 → 0.000000` |

Promoted Session 8 claims are fixed-config KPI determinism (`ξ`), the
sharp overfit cliff localized to `49→50` (`ο`), and ARM64
cross-platform determinism (`τ`). Candidate Session 8 claims are scoped
dataset invariance (`π`), RA+v2+steps=20 zero learning (`ρ`), trimodal
sawtooth curve shape (`σ″`), and three scoped `--steps`-decorative
task surfaces (`φ`). Earlier `σ` and `σ′` curve wordings were
rejected-before-promoted.

### `exp_k3_truth_sensor`

The task does real internal work, but the Session 7 tested
sensor-strength / sensor-threshold flags are decorative. Across nine
configurations spanning
`--sensor-strength ∈ {0.0, 0.1, 0.25, 0.5, 0.75, 1.0}` and
`--sensor-threshold ∈ {0.01, 0.1, 1.0, 10.0}`, the KPI triple remains
fixed at:

- baseline = `108.16`
- sensor = `22.29`
- gap = `85.87`
- ratio = `79.4%`

The `.bin` payloads are empty by design; the scientific content is in
the `.log` files.

Session 8 B3 refines this rather than broadening it: `--steps` changes
absolute K3 values. At `steps=1`, `baseline_error = 89.255325`,
`sensor_error = 22.317333`, and reduction is about `75.0%`; at
`steps=20`, `baseline_error = 108.164818`,
`sensor_error = 22.292860`, and reduction is about `79.4%`. The stable
B3 component is selected `sensor_error` near `22.3`, not a universal
`--steps`-invariant KPI triple.

### `resonance_r3`

This task also joins the “CLI decorative on the tested surface” family.
Across `--steps ∈ {1, 5, 10, 20}`, it emits identical output:

- `Om_dE 1.2745 → 1.2741`
- `delta = -0.0004`
- task self-verdict: `"PLASTICITY CONFIRMED"`

The exposed `--steps` flag does not parameterize the output on the
tested surface.

### B3 12-task `--steps` audit

B3 tested all twelve callable tasks at `--steps 1` and `--steps 20`.
Nine tasks were responsive. Three tasks were decorative on primary
output at those settings: `resonance_r3`, `resonance_v2`, and
`exp_i2`. `exp_k3_truth_sensor` is partial: absolute values change, but
selected `sensor_error` remains near `22.3`.

The B3 summary JSON reports `verdict=FAIL` because its generic
deterministic-cell script sees heterogeneous canonical outputs across
different tasks. That is a script limitation, not a scientific failure.

## Remaining narrow technical seams

- Harmonic summary JSON verdicts are generic deterministic-cell verdicts
  and should not be read as the scientific authority surface.
- B3 summary JSON verdict is generic for a heterogeneous task audit and
  should not be read as the scientific authority surface.
- The gate-layer directory-name mismatch in the Session 7 handover
  remains visible in the repo findings doc instead of being hidden.
- The original Phase A 55-vs-52 accounting seam remains visible, even
  though A5/B3/A6 add 57 directly mirrored per-run receipts.
- The K3 handover language proposed ratio invariance, but local B3 logs
  show `75.0%` at `steps=1` and `79.4%` at `steps=20`; public wording
  preserves that nuance.

## Session 8 Phase A / A5-B3-A6 close

The Session 8 Phase A final report closes the first Phase A block under
a scientific-learning frame. The local mirror contains 52 per-run
receipt/log pairs across four cells: A.1 `μ` robustness, A.2 overfit
boundary, A.3 cross-graph, and A.4 cross-dataset. The final report and
summary files use 55 total-run accounting; that count seam is tracked
in `REPO_AGENT_FINDINGS.md`.

Phase A lines:

- `ξ`: fixed-config determinism on `exp_k2_scars`
- `ο`: a sharp overfit boundary localized to `--steps 49` and `50`
- `π`: scoped dataset invariance at the `μ` baseline config
- `ρ`: `RandomAdj_v1.bin + RegionTags_v2.bin + --steps 20` gives zero
  learning
- `σ″`: the baseline steps-response curve is trimodal sawtooth, not
  coarse 30/40 and not bimodal
- `φ`: `resonance_r3`, `resonance_v2`, and `exp_i2` are
  `--steps`-decorative at `steps 1` vs `20`
- `τ`: RM10 native Android and Apple M1 Android ARM64 emulator emit
  bit-exact `exp_k2_scars` KPIs for the tested baseline values

The final report also records two governance / execution facts that
must stay visible: airplane mode flipped OFF for 40 reported receipts,
and the old all-sensor thermal gate was replaced by a CPU/GPU-only
thermal rule after PMIC lag caused an A.2 halt. The mirrored
`device_snapshot/bin/` contains both the patched `run_cell.sh` and the
pre-patch backup.

## Clean operating statement

The cleanest integrated description after Session 8 Phase A is:

- DM3 is deterministic in gate-surface output up to `run_sec`.
- DM3 is stochastic in harmonic basin selection but stable in
  distribution at the tested granularity.
- Graph / region structure dominate the interpretable gate surface.
- The first promoted positive learning line remains narrow and
  task-specific to `exp_k2_scars`; Session 8 confirms fixed-config KPI
  determinism, ARM64 cross-platform determinism, and a trimodal
  sawtooth candidate curve on the scoped baseline surface.
- CLI-decorative controls are narrow and task/flag-specific, not a
  broad statement about the whole binary.
