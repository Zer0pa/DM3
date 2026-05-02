# DM3 Characterization Report (Sessions 1–8 Phase A/A5/B3/A6, Phase G v2 partial)

Last updated: `2026-05-02` — Session 7 closeout + Session 8 Phase A/A5/B3/A6 + live Phase G v2 partial chain + reconstruction Tier-2

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

## Phase G v2 chain (G.2 closed; later cells unpromoted; updated 2026-05-02 18:38 UTC)

The Phase G v2 chain launched 2026-04-25 18:25:54 UTC under
`docs/restart/DM3_PHASE_G_AUGMENTED_PRD_v2_REORDERED_20260425.md`.
The chain re-orders cells upside-first and preserves all v1
augmentations and gate disciplines (KAT canary, hash gate, thermal
gate, pinned cpu7, airplane mode).

Closed cells with promoted ledger entries:

| Cell | Verdict | Promoted | Findings |
|---|---|---|---|
| `G.0` | PASS | bookkeeping | pre-launch gates clean |
| `G.0.5` | PASS | folded into `ξ` | σ″ baseline determinism extension: 10/10 bit-exact `best_uplift` at `s30 = 1.644524` and `s33 = 1.873756` |
| `G.6` | PASS | `χ` | path-independence: 4/4 same-config canonical SHAs match across path A and path B |
| `G.1` | PASS | `ψ` (CANDIDATE) | cycle-extension: `s56 = 1.970840` exceeds σ″ peak #1 at `s33 = 1.873756`; `49 → 50` cliff is not a permanent collapse |
| `G.1.5` | PARTIAL | mechanism candidate | multiplicity-7 sawtooth fits tighter than multiplicity-6 or -8; suggestive cycle-7 mechanism for σ″, not promoted |
| `G.2` | **PASS** | `σ″` → CONFIRMED for shape | trimodal sawtooth shape preserved across 3/3 cross-controls (cfg-A `RandomAdj_v1`, cfg-B `RegionTags_v2`, cfg-C `xnor_mini`); cliff at `s50 = 0.000000` exact in all three; magnitudes config-dependent (cfg-B substantially weaker), explicitly not portable |

`G.2` per-config metrics from
`artifacts/phase_S8_PG_followup_20260429T130215Z/cells/G2_trimodal_portability/outcome.json`:

```
cfg-A  RandomAdj_v1   p33=1.919380  p34=1.408173  p41=1.784622  p43=1.217201  p49=1.897110  p50=0.000000  shape_ok=1
cfg-B  RegionTags_v2  p33=0.995499  p34=0.000000  p41=0.477169  p43=0.000000  p49=0.543240  p50=0.000000  shape_ok=1
cfg-C  xnor_mini      p33=1.873756  p34=1.370651  p41=1.708374  p43=1.160828  p49=1.819397  p50=0.000000  shape_ok=1
```

The `s50 = 0.000000` cliff is reported as `best_uplift`, the maximum
over `(lesson, noise)` conditions. The 2026-04-30 08:30 UTC G.7
in-flight logs sharpen the interpretation: completed cfg-A `s50`
receipts show deterministic negative uplift, and the first completed
cfg-B `s50` receipt shows the same negative direction with larger
config-bound magnitude.

| Config | G.7 `s50` status | Baseline scale | `lesson=3 noise=0.100` | `lesson=3 noise=0.200` |
|---|---|---:|---:|---:|
| cfg-A `RandomAdj_v1` | complete, 3/3 receipts | `~118.78` | `-0.201691` | `-0.219131` |
| cfg-B `RegionTags_v2` | partial, `cb_s50_r1` complete and `cb_s50_r2` in flight | `~39.85` | `-1.803669` | `-1.860878` |
| cfg-C `xnor_mini` | pending | n/a | n/a | n/a |

Both observed configs still clip to `best_uplift = 0.000000`. Direction
is preserved across cfg-A and the first completed cfg-B `s50` receipt;
magnitude is not portable. This remains a σ″ cliff scope-note, not a
G.7 outcome promotion.

The latest GitHub-resident `G.7 cliff-class characterization` pull is
still the 2026-04-30 partial snapshot: 22 immutable receipts, cfg-A
complete at 15/15, cfg-B partial at 7/15, cfg-C pending at 0/15, and no
G.7 `outcome.json`. The 2026-05-02 audit note reports that G.7 later
closed on-device and G.3 entered flight, but those statuses remain
non-promotional in this report. G.7 verdicts, G.3 classes, G.4, G.5,
and G.5+ outcomes wait for the chain-close handover and host-side
receipt pull.

The Phase G v2 chain is autonomous on the RM10 device. Watcher
infrastructure (`master_death_watcher.sh`, `post_chain_g4_launcher.sh`)
ensures resume on disconnect. Closed-cell receipts for `G.0.5`, `G.1`,
and `G.1.5` are mirrored under
`artifacts/phase_S8_PG_followup_20260429T023308Z/`; the later partial
pull under `artifacts/phase_S8_PG_followup_20260429T130215Z/`
supersedes G.2/G.6 evidence paths. The latest G.7 snapshot is mirrored
under `artifacts/phase_S8_PG_followup_20260430T082723Z/`; the May 2
audit note is mirrored at
`docs/restart/REPO_AGENT_NOTE_PHASE_G_G7_CLOSE_AND_G3_IN_FLIGHT_20260502T1838.md`.
Remaining Phase G promotion still happens at chain close, not
mid-flight.

## Reconstruction (static, Tier-2)

An independent backwards-reconstruction lane parses the Android
aarch64 ELF (`dm3_runner`, SHA-256 `daaaa84a...`) along with the
loaded fixtures and the static-disassembly call graph. It registers
eight pre-registered hypotheses `R1..R8`. Status:

| ID | Hypothesis | Status |
|---|---|---|
| R1 | Loaded `SriYantraAdj_v1.bin` is exactly `P_95 ☐ K_4` | PASS_STATIC_TIER2 |
| R2 | `RegionTags_v2.json` is degree-4-root BFS shelling | PASS_STATIC_TIER2 |
| R3 | Spectrum is closed-form `λ_k(P_95) + μ(K_4)` | PASS_STATIC_TIER2 |
| R4 | Internal default skeleton is exactly `P_95 ☐ K_3` | PASS_STATIC_TIER2 |
| R5 | Loaded and internal share `P_95` product family | PASS_STATIC_TIER2 |
| R6 | L-branch flow is file-loaded under `generate_tags_v2` and `run_spectral_analysis` | PASS_STATIC_TIER2_DYNAMIC_OPEN |
| R7 | Catalogue invariants match `P_95 ☐ K_4` (`Aut = C_2 × S_4`, diameter 95, radius 48) | PASS_STATIC_TIER2 |
| R8 | Android execution trace identifies the runtime fixture path | OPEN_TIER3_BLOCKED |

The arithmetic identity `β_1(loaded fixture) = E(internal skeleton) =
567` is exact and host-recomputable. The previously promoted `C_3`
symmetry is preserved as a sub-action of the natural `S_4` action on
the four `K_4` fibers.

R8 is the sovereign open gate. Until R8 closes via Android argv,
`openat`, and output-write tracing under live `dm3_runner`, no claim
of complete reconstruction is promoted on this surface. See
[`RECONSTRUCTION_TIER2_NOTE.md`](RECONSTRUCTION_TIER2_NOTE.md) for the
full evidence card and
[`CLAIMS.md`](CLAIMS.md) "Reconstruction (static, Tier-2)" for the
formal claim block.

## Clean operating statement

The cleanest integrated description after Session 8 Phase A and the
Phase G v2 partial chain is:

- DM3 is deterministic in gate-surface output up to `run_sec`.
- DM3 is stochastic in harmonic basin selection but stable in
  distribution at the tested granularity.
- DM3 is path-independent at fixed config (claim `χ`).
- Graph / region structure dominate the interpretable gate surface.
- The first promoted positive learning line remains narrow and
  task-specific to `exp_k2_scars`; Session 8 confirms fixed-config KPI
  determinism, ARM64 cross-platform determinism, and the trimodal
  sawtooth shape on the scoped baseline surface; Phase G `G.2`
  promotes the σ″ shape to CONFIRMED across 3/3 cross-controls (graph,
  tags, dataset) with magnitudes recorded as config-dependent and
  explicitly not portable; `G.1` adds a CANDIDATE cycle past the
  `49 → 50` cliff; the cliff fine structure is the subject of `G.7`,
  in flight.
- CLI-decorative controls are narrow and task/flag-specific, not a
  broad statement about the whole binary.
- The static-Tier-2 reconstruction identifies the loaded fixture as
  `P_95 ☐ K_4` and the internal default skeleton as `P_95 ☐ K_3`,
  related by complete-graph fiber promotion `K_3 → K_4` over the
  shared base `P_95`. Tier-3 runtime identity is open.
