# DM3 Fresh-Eyes Investigation: The 3D Double Meru As Scientific Object

Last written: `2026-04-16`

## What I Actually See

### The Geometry

The 3D Double Meru is a 380-vertex graph constructed as:

1. A 2D Sri Yantra graph (9 interlocking triangles) lifted into 3D via three
   helical strands at radii [1, 2, 3] with pitch 1/2 and exact rational
   arithmetic
2. Mirrored at Z=0 (the Bindu equator) to create two cones
3. Upper cone ("RIGHT_MERU") and lower cone ("LEFT_MERU") sharing a waist
4. Vertices classified by: meru side, ring level, boundary/interior

This is not a metaphorical structure. It is a concrete finite graph with exact
coordinates, verified by 5 geometry gates (A1-A5): symmetry, concurrency,
monotonicity, curvature/torsion constancy, and ruled-surface waist connectivity.

The graph has inherent properties that matter for computation:
- **Double Z2 symmetry**: mirror at Z=0
- **Three-strand hierarchy**: creates multi-scale connectivity
- **Distinguished boundary**: waist vertices connect to BOTH cones
- **Ring structure**: concentric organization like a target
- **Exact arithmetic**: all coordinates are rational, not floating-point

### The Dynamics

The `dm3_runner` binary executes a settling/training process on this graph.
The CLI reveals the system has at least:

- **Two task families**: `holography` and `harmonic`
- **Two normalization modes**: LayerNorm on (transformer mode) and off
  (Hamiltonian/Bicameral mode)
- **Symmetry breaking controls**: `--asymmetry` (Skin Effect), `--rotation`
  (Braiding)
- **Resonance controls**: `--freq` (drive frequency), `--gated` (strict
  resonance gating per Doc #5)
- **Homeostasis controls**: `--enable-truth-sensor` with threshold, strength,
  and cooldown

Almost all of this parameter space is UNEXPLORED. The branch has only tested:
`--task harmonic --steps 1 --cpu --use-layernorm true --asymmetry 0 --rotation 0`

### The Signal

The entrance-condition battery (Phase 01.2.3.4.1.1.3.1.2.2) found:

- **Sharp bistability**: two basins with zero intermediate values across 7 runs
- **HIGH regime**: delta_E ~88-89, coherence ~0.77
- **LOW regime**: delta_E ~74-76, coherence ~0.877-0.892
- **Anti-correlation**: higher energy ↔ lower coherence (and vice versa)
- **Session-level duration signature**: the only FAST session (~155s) appeared
  in one packet and was never reproduced; all others are SLOW (~200s)

### The Transformer/HRM Component

The binary includes:
- LayerNorm toggle (on by default, off = "Hamiltonian/Bicameral mode")
- A "Truth Sensor" (active maintenance) that monitors and corrects

This means the system is not pure geometry + dynamics. It has a learned
boundary adapter (the transformer/HRM component) that can be switched between
two operating modes. The relationship between the geometry and the learned
component is the central architectural question.

## What This Looks Like Through Different Lenses

### Dynamical Systems

A 380-node graph with iterative dynamics, two sharp basins, anti-correlated
energy/coherence, and a distinguished boundary is a **bistable dynamical system
on a graph**. The bifurcation parameter is the initial condition (RNG seed).

The anti-correlation E↑/Coh↓ vs E↓/Coh↑ is consistent with a **symmetry-
breaking phase transition**: one state is more ordered (high coherence, lower
energy) and one is more disordered (lower coherence, higher energy). This maps
onto solid/liquid-like phases in statistical mechanics.

### Information Theory

The dynamics preserves 1 bit of information (which basin) from a high-
dimensional initial condition. This is a form of **attractor coding**: the
system functions as a 1-bit classifier of its initial state. The Shannon
capacity of this channel is bounded by the number of distinguishable attractors.

If there are only 2 basins, the system encodes 1 bit. But the manifesto claims
236 tests passed. If the system can be driven into a richer attractor landscape
(via different tasks, frequencies, asymmetries), the encoding capacity could be
much larger.

### Morphogenesis / Biocomputation

A graph with: fixed body plan (geometry), homeostatic dynamics (settling +
truth sensor), boundary tissue (transformer adapter), and bistable fate
decisions (two basins) — this is formally analogous to a **morphogenetic
field** in the sense of Levin's bioelectric patterns.

The two regimes are like two **cell fates**: different stable configurations
that the same tissue can adopt depending on initial conditions. The geometry
constrains which fates are possible. The dynamics implements the selection.
The truth sensor implements repair/homeostasis.

### Geometric Computation / Reservoir Computing

A fixed graph with nonlinear dynamics, input through initial conditions, and
readout through final state metrics — this is literally the definition of a
**physical reservoir computer** (Nakajima 2020). The graph topology determines
the computational capacity.

Key reservoir properties to characterize:
- **Echo State Property**: does the effect of the initial condition fade or
  persist? (Currently it persists as basin selection — 1 bit)
- **Separation Property**: can different inputs be distinguished in the readout?
- **Approximation Property**: can the reservoir approximate continuous functions?

### Geometric Unity / Physics-Based Computation

The Double Meru's exact rational geometry, combined with contractive dynamics
and energy monotonicity, resembles a **lattice gauge theory** where the graph
is the spacetime lattice and the dynamics is the field equation. The Euler
characteristic computation per cone is a topological invariant — the geometry
carries topological information that constrains the dynamics.

The `--rotation` (Braiding) and `--asymmetry` (Skin Effect) parameters map
directly onto **gauge transformations** and **symmetry-breaking terms** in
physics. The Braiding angle is literally a holonomy parameter.

## What Has Been Missed

1. **The binary has a Hamiltonian/Bicameral mode** (`--use-layernorm false`)
   that has never been tested. This is the mode where the transformer adapter
   is removed and the geometry+dynamics run alone. If the bistability persists
   in this mode, it is a property of the geometry, not the transformer. If it
   disappears, the transformer is creating it.

2. **The symmetry-breaking parameter** (`--asymmetry`) has never been varied
   from 0. Setting asymmetry > 0 should bias the system toward one basin. If
   it does, this proves the bistability is a symmetry-breaking phenomenon.

3. **The drive frequency** (`--freq`) has never been specified. Different
   frequencies should excite different resonance modes. The FAST session might
   correspond to a specific resonance.

4. **The truth sensor** (`--enable-truth-sensor`) has never been activated.
   This is a built-in homeostasis mechanism. Activating it might stabilize one
   basin and solve the reproducibility problem.

5. **The holography task** has been set aside in favor of harmonic. But the
   manifesto's strongest claims (T55-T72) are about holographic encoding. The
   holography task may have different basin structure.

6. **The graph spectral properties** have never been analyzed. The Laplacian
   eigenvalues of a 380-node graph are easily computable and would reveal the
   resonance frequencies, mixing time, and bottleneck (Cheeger constant) at
   the waist.

7. **No experiment has probed the upper/lower cone asymmetry directly.** The
   `--asymmetry` and `--rotation` parameters exist precisely for this. Nobody
   has measured whether the two regimes map onto upper-cone-dominant vs
   lower-cone-dominant states.
