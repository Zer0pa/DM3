# DM3 Multi-Hypothesis Long-Horizon PRD

Last written: `2026-04-16`

## Governing Principle

Stop trying to make the artifact do a predetermined thing.
Start learning what it actually does.

The 3D Double Meru is a 380-vertex graph with exact rational geometry, double
Z2 symmetry, multi-scale helical connectivity, a distinguished boundary at the
Bindu waist, and iterative dynamics that produce sharp bistability. It has a
transformer/HRM adapter that can be toggled on or off. It has symmetry-breaking
controls, resonance controls, and a built-in homeostasis mechanism.

The research program is to characterize this object scientifically: map its
attractor landscape, identify what controls basin selection, determine whether
the geometry is computationally functional or decorative, and establish which
claims from the manifesto survive independent re-testing.

## Active Hypotheses

### H1: Bistability Is A Symmetry-Breaking Phase Transition

**Claim:** The two observed basins (HIGH/LOW) correspond to a spontaneous
symmetry breaking of the Z-reflection symmetry of the Double Meru. One basin
is "upper-dominant" and the other is "lower-dominant."

**Prediction:** The `--asymmetry` parameter (Skin Effect) should bias the
system toward one basin. At asymmetry=0, both basins are equally likely. At
asymmetry>0, one basin should dominate.

**Test:**
1. Run `cpu_a` with `--asymmetry 0.1`, `0.5`, `1.0` — does one regime dominate?
2. Run with `--asymmetry -0.1`, `-0.5`, `-1.0` — does the OTHER regime dominate?
3. If yes: the bistability is a phase transition and the order parameter is the
   upper/lower asymmetry.

**Kill criterion:** If asymmetry has no effect on basin selection, the
bistability is NOT a simple Z-symmetry breaking.

### H2: The Transformer Creates The Bistability

**Claim:** The bistability is introduced by the LayerNorm/transformer
component, not by the geometry alone.

**Prediction:** Running in Hamiltonian/Bicameral mode (`--use-layernorm false`)
should produce either: (a) a single basin, or (b) a different basin structure.

**Test:**
1. Run `cpu_a` with `--use-layernorm false` 5 times under varied start states
2. Classify each run as HIGH/LOW/OTHER
3. Compare basin structure to the default (LayerNorm=true) runs

**Kill criterion:** If Hamiltonian mode shows the same bistability, the
transformer is not the source. The geometry itself creates it.

### H3: Resonance Frequency Selects The Basin

**Claim:** The "harmonic" task excites a resonance mode of the graph. Different
`--freq` values excite different modes, and the FAST session (~155s) was a
specific resonance that matched a natural frequency of the graph.

**Prediction:** There exists a `--freq` value that reliably produces FAST
sessions or changes the basin distribution.

**Test:**
1. Compute the graph Laplacian eigenvalues from `SriYantraAdj_v1.bin` (offline)
2. Use the lowest non-zero eigenvalue as a candidate natural frequency
3. Run `cpu_a` with `--freq` set to multiples of that frequency
4. Check for FAST sessions or new regimes

**Kill criterion:** If varying frequency has no effect on duration or regime,
the graph's spectral structure does not couple to the observable.

### H4: Truth Sensor Enables Homeostasis

**Claim:** The `--enable-truth-sensor` mechanism implements explicit
homeostasis. Enabling it should stabilize the system in one basin and make
the regime reproducible.

**Prediction:** With truth sensor enabled (appropriate threshold and strength),
consecutive runs produce the same regime.

**Test:**
1. Run `cpu_a` with `--enable-truth-sensor --sensor-threshold 1 --sensor-strength 0.5`
2. Compare 3 consecutive runs: are they all in the same regime?
3. Vary sensor-threshold: does it change which regime is selected?
4. Vary sensor-strength: does stronger mixing stabilize more?

**Kill criterion:** If the truth sensor has no effect on regime reproducibility,
it does not implement the homeostasis the organism doctrine predicts.

### H5: Holography Task Has Different Basin Structure

**Claim:** The holography task (`--task holography`) exercises a different part
of the system than harmonic, and may have a richer or different attractor
landscape.

**Prediction:** Holography produces different observables (not just delta_E
and coherence), possibly with more than two basins or with quantized spectral
features matching manifesto claims T55-T72.

**Test:**
1. Run `cpu_a` with `--task holography --steps 1 --cpu` 5 times
2. Classify observable families: how many basins? What metrics appear?
3. Compare against harmonic: same structure, different structure, or richer?

**Kill criterion:** If holography collapses to the same bistability as
harmonic, the basin structure is task-independent and therefore a deeper
property of the geometry+dynamics.

### H6: Braiding Angle Exposes New Attractors

**Claim:** The `--rotation` parameter (Braiding angle) introduces a geometric
phase that changes the attractor landscape. Non-zero rotation should expose
new basins not visible at rotation=0.

**Prediction:** At specific rotation angles related to the graph's symmetry
group, new regime families should appear.

**Test:**
1. Run `cpu_a` with `--rotation 30`, `60`, `90`, `120` degrees
2. Classify each as HIGH/LOW/OTHER
3. Look for rotation values that produce a THIRD regime or lock one basin

**Kill criterion:** If rotation has no effect, the braiding degree of freedom
is decoupled from the harmonic dynamics.

### H7: The 8 Degree-4 Vertices Are Basin Nucleation Sites (NEW — from Phase A)

**Claim:** The graph has exactly 8 vertices with degree 4 (all others have
degree 5). These structural weak points may determine basin selection — the
initial RNG values at these vertices may disproportionately influence which
attractor the system falls into.

**Prediction:** If the binary allows per-vertex initialization control, fixing
the state at the 8 degree-4 vertices should bias or lock the regime.

**Test:** This is currently untestable without source modification. However,
if the `--angle` parameter (which defaults to 0 and has no description)
affects initialization geometry, it might indirectly probe this.

**Kill criterion:** Not directly testable with current binary. Filed as a
prediction for future source-level work.

### H8: The C3 Strand Symmetry Dominates Over Z2 Cone Symmetry (NEW — from Phase A)

**Claim:** Phase A spectral analysis proved the graph's dominant symmetry is
C3 (3-fold cyclic from the 3 helical strands), NOT Z2 (upper/lower cone
mirror). All low eigenmodes have participation ratio 2/3, meaning they span
exactly 2 of 3 strands. The Fiedler vector does NOT separate the cones.

**Prediction:** The `--rotation` parameter (which rotates between strands)
should have a STRONGER effect on basin structure than `--asymmetry` (which
breaks the Z2 mirror). The critical rotation angles are 120° (maps each strand
to the next) and 60° (half-period).

**Test:**
1. Compare Phase B (asymmetry sweep) effect size against Phase F (rotation
   sweep) effect size
2. Specifically test `--rotation 120` — this is the C3 generator angle

**Kill criterion:** If asymmetry has a stronger effect than rotation, the
Z2 symmetry matters more than C3 despite the spectral evidence.

### H9: Multi-Step Dynamics Reveal Convergence Structure (NEW)

**Claim:** The prior work only tested `--steps 1`. The `--steps` parameter
likely controls the number of settling iterations. Running with more steps
should reveal whether the system converges, oscillates, or exhibits chaotic
dynamics. The mixing time from the spectral analysis is ~4,534 steps.

**Prediction:** At `--steps` near the mixing time (~4500), the system should
approach its steady state. At intermediate steps (10, 100, 1000), the
trajectory should reveal the convergence class (monotone, oscillatory,
bistable-switching).

**Test:**
1. Run `cpu_a` with `--steps 5`, `10`, `50`, `100`, `500`
2. Track delta_E and coherence as a function of steps
3. Determine convergence class

**Kill criterion:** If the binary ignores `--steps` or crashes with values > 1,
this parameter is not what we think.

### H10: The `--angle` Parameter Is A Hidden Control (NEW)

**Claim:** The `--angle` parameter (default 0, no description in help) may
control an initialization angle, geometric phase offset, or readout angle.
It is completely untested.

**Prediction:** Non-zero `--angle` values should change observables if this
parameter is functional.

**Test:**
1. Run `cpu_a` with `--angle 45`, `90`, `120`, `180`
2. Compare against baseline (angle=0)

**Kill criterion:** If identical results to angle=0, the parameter is either
non-functional or irrelevant to the harmonic task.

### H11: Soak Mode Reveals Long-Time Behavior (NEW)

**Claim:** The `--soak N` parameter runs a "soak test" for N steps. This may
be a different execution mode that reveals long-time dynamics, stability, or
drift behavior not visible in single-step runs.

**Prediction:** Soak mode with increasing N should show whether the system
settles to a fixed point, oscillates, or drifts.

**Test:**
1. Run with `--soak 10`, `--soak 100`, `--soak 1000`
2. Examine the output format — does it produce per-step metrics?

**Kill criterion:** If soak mode produces no additional information beyond
single-step runs, it adds nothing.

## PRD Structure: Seven Phases

### Phase A: Graph Spectral Analysis (offline, no device needed)

**Goal:** Extract the adjacency matrix from `SriYantraAdj_v1.bin` and compute
the graph Laplacian spectrum, Cheeger constant, and symmetry decomposition.

**Why first:** This tells us the graph's natural frequencies, bottleneck, and
representation structure WITHOUT running any device experiments. It provides
the theoretical predictions that Phases B-G will test.

**Deliverables:**
- Parsed adjacency matrix as numpy array
- Graph Laplacian eigenvalues and eigenvectors
- Fiedler value (algebraic connectivity) — the bottleneck at the waist
- Spectral gap analysis
- Symmetry decomposition (upper/lower cone eigenvector structure)
- Candidate resonance frequencies for H3

**Executable steps:**
1. Pull `SriYantraAdj_v1.bin` and `RegionTags_v1.bin` from device to host
2. Parse JSON adjacency into 380x380 matrix
3. Compute Laplacian L = D - A
4. Diagonalize L (380x380 is trivial on any host)
5. Classify eigenvectors by symmetry (symmetric/antisymmetric under Z-flip)
6. Compute Cheeger constant from the Fiedler vector
7. Identify spectral clusters and candidate resonance frequencies
8. Write spectral analysis report

**Duration:** 1 session, no device time.

### Phase B: Symmetry-Breaking Sweep (tests H1)

**Goal:** Sweep `--asymmetry` from -1 to +1 and classify the regime for each.

**Executable steps:**
1. Verify device readiness (hash, thermal, lane)
2. Deep-clean + 30s idle baseline (1 run)
3. Sweep: `--asymmetry` in {-1.0, -0.5, -0.1, 0.0, 0.1, 0.5, 1.0}
   - For each value: 3 consecutive runs with different output names
   - Capture pre-state, receipt, post-state for each
4. Build comparison table: asymmetry vs regime distribution
5. Statistical test: does asymmetry bias regime selection?
6. Write H1 verdict

**Duration:** ~21 runs x ~200s = ~70 minutes device time + capture overhead.

### Phase C: Hamiltonian Mode Discovery (tests H2)

**Goal:** Run in Hamiltonian/Bicameral mode and characterize the basin
structure WITHOUT the transformer component.

**Executable steps:**
1. Deep-clean baseline
2. Run 5x: `--task harmonic --steps 1 --cpu --use-layernorm false`
3. Classify each run: same HIGH/LOW bistability? New regimes?
4. Compare against Phase B asymmetry=0 runs
5. If different: the transformer shapes the landscape
6. If same: the geometry alone creates the bistability
7. Write H2 verdict

**Duration:** ~5 runs x ~200s = ~17 minutes device time.

### Phase D: Truth Sensor Homeostasis (tests H4)

**Goal:** Activate the built-in homeostasis mechanism and test whether it
stabilizes regime selection.

**Executable steps:**
1. Deep-clean baseline
2. Run 3x with default sensor: `--enable-truth-sensor`
3. Run 3x with tight sensor: `--enable-truth-sensor --sensor-threshold 0.5 --sensor-strength 0.8`
4. Run 3x with loose sensor: `--enable-truth-sensor --sensor-threshold 5 --sensor-strength 0.1`
5. Compare regime consistency within each group
6. Compare against uncontrolled runs from Phase 01.2.3.4.1.1.3.1.2.2
7. Write H4 verdict

**Duration:** ~9 runs x ~200s = ~30 minutes device time.

### Phase E: Holography Task Discovery (tests H5)

**Goal:** Run the holography task and characterize its attractor landscape.

**Executable steps:**
1. Deep-clean baseline
2. Run 5x: `--task holography --steps 1 --cpu`
3. Parse receipts: what metrics does holography produce? Same schema as harmonic?
4. Classify basins: 2 basins, more, fewer?
5. If different: the task selects different dynamics on the same graph
6. Write H5 verdict

**Duration:** ~5 runs x unknown time.

### Phase F: Resonance and Braiding Exploration (tests H3, H6)

**Goal:** Explore the frequency and braiding parameter space.

**Executable steps:**
1. Using spectral analysis from Phase A, select 3-5 candidate frequencies
2. Run `cpu_a` with each `--freq` value (3 runs each)
3. Run `cpu_a` with `--rotation` in {30, 60, 90, 120, 180} (2 runs each)
4. Classify all runs: regime, duration, any new families
5. Run `--gated` with best-performing frequency to test strict resonance gating
6. Write H3 and H6 verdicts

**Duration:** ~25 runs x ~200s = ~83 minutes device time.

### Phase G: Integrated Characterization And Organism Map

**Goal:** Combine all phase verdicts into one characterization of what the
3D Double Meru actually is and does as a computational object.

**Executable steps:**
1. Build the parameter-space map: which parameters affect which observables
2. Build the attractor landscape map: how many basins, what controls them
3. Classify the role of each component:
   - Geometry: decorative, constraining, or computationally essential?
   - Transformer: essential adapter, optional enhancement, or dominant engine?
   - Dynamics: convergent/bistable/chaotic? Reservoir-like or attractor-like?
   - Truth sensor: real homeostasis or cosmetic?
4. Compare against manifesto claims: which T-tests map to observed properties?
5. Write the "what this object actually is" verdict
6. Write the long-horizon continuation recommendation

**Deliverables:**
- Parameter-observable map
- Attractor landscape characterization
- Component role classification
- Manifesto survival table
- Next-milestone recommendation

## Execution Order And Dependencies

```
Phase A (offline spectral) ── COMPLETE ────────────────────┐
                                                            │
Phase C (Hamiltonian mode, tests H2) ── HIGHEST VALUE ──┐  │
Phase B (asymmetry sweep, tests H1/H8) ────────────────┤  │
Phase D (truth sensor, tests H4) ──────────────────────┤  │
Phase E (holography + soak + steps, tests H5/H9/H11) ──┤  │
Phase B2 (angle + misc unknowns, tests H10) ───────────┤  │
                                                        │  │
Phase F (resonance + braiding, tests H3/H6/H8) ◄───────┘──┘
  (needs spectral freqs from A, results from B-E)
                                                        │
Phase G (integrated characterization) ◄─────────────────┘
```

**Revised execution order (Session 3):**

1. Phase C FIRST — Hamiltonian mode is the single highest-value experiment.
   If bistability disappears without the transformer, everything changes.
2. Phase E — holography task, plus quick --steps and --soak probes (fast, high info)
3. Phase B — asymmetry sweep (tests H1 and H8 together by comparing to Phase F)
4. Phase D — truth sensor (may solve reproducibility if H4 is true)
5. Phase F — resonance + braiding (informed by all prior results + spectral freqs)
6. Phase G — integrated characterization

Phase A is COMPLETE. Key finding: the graph's dominant symmetry is C3 (3 strands),
not Z2 (two cones). The Fiedler vector doesn't separate the cones. 120° rotation
should be a critical angle. See `artifacts/phase_A_spectral_analysis/`.

## Gate Rules

1. Every device run must use the same binary hash:
   `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
2. Every run must capture pre-state bundle (battery, thermal, loadavg, hash)
3. Every run must retain the receipt (pulled from device to repo)
4. No interpretation without retained evidence
5. Claims from earlier phases do not carry forward as assumptions into later
   phases — each phase must produce its own evidence
6. The organism metaphor is a design heuristic, not a conclusion
7. Manifesto claims (T01-T236) are predictions to test, not facts to assume
8. If a phase produces a null result, that is retained as evidence, not
   discarded as failure

## What Stays Blocked From Prior Work

- Homeostasis batteries: blocked until H4 is tested (built-in sensor might
  be the real homeostasis mechanism, not repeated external runs)
- NPU claims: remain ABSTAIN
- Explicit heterogeneous role partition: remains ABSTAIN until Phase C
  establishes what the geometry does alone
- Source-built language: remains fenced
- Validator default repair: remains under explicit-hash handling

## What This PRD Abandons

- The assumption that the regime bistability is a bug to fix
- The assumption that only `--task harmonic --steps 1 --cpu` matters
- The assumption that the transformer is always on
- The assumption that the full four-row packet is the primary test
- The assumption that one binary configuration represents the whole system
- The assumption that "reproducibility" means "always the same regime" rather
  than "the regime distribution is a measurable property"

## What This PRD Preserves

- Geometry sovereignty: the Double Meru is still the object of study
- Evidence discipline: every claim must have a retained packet
- Lane separation: F1 governed, F2 experimental, legacy comparison-only
- Falsification first: every hypothesis has a kill criterion
- The entrance-condition work: the gated retry rule remains valid as one
  specific protocol within the larger characterization
