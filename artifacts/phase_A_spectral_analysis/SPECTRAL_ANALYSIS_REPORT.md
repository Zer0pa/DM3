# Phase A: Graph Spectral Analysis Report

Written: `2026-04-16`

## Executive Summary

The 380-vertex Double Meru graph has been fully diagonalized. The dominant
structural feature is **3-fold cyclic symmetry** from the three helical strands,
NOT the Z2 mirror symmetry between upper and lower cones. This fundamentally
reframes the bistability question.

## Graph Properties

| Property | Value |
| -------- | ----- |
| Vertices | 380 |
| Edges | 946 |
| Connected components | 1 |
| Bipartite | NO (has odd cycles) |
| Min/Max degree | 4 / 5 |
| Mean degree | 4.98 |
| Degree-4 vertices | 8 (structural weak points) |
| Ring levels | 1 (all RING_0) |
| BINDU fraction | 147/380 = 38.7% |
| BOUNDARY fraction | 285/380 = 75.0% |
| INTERIOR vertices | 0 |

## Vertex Classification

| Tag Group | Count |
| --------- | ----- |
| RIGHT_MERU, non-BINDU | 136 |
| LEFT_MERU, non-BINDU | 131 |
| BINDU | 147 |
| Of which BINDU + RIGHT_MERU | 28 |
| Of which BINDU + LEFT_MERU | 24 |
| Of which AXIS + BINDU + BULK | 95 |

**Key finding:** The BINDU region is NOT a narrow waist. It is 39% of the
entire graph — a thick equatorial belt. There are NO interior vertices; the
entire graph is boundary or axis+bulk.

## Laplacian Spectrum

### Key Spectral Values

| Quantity | Value |
| -------- | ----- |
| Fiedler value (λ₁) | 0.00109349 |
| Spectral gap | 0.00109349 |
| Normalized spectral gap | 0.00022055 |
| Mixing time estimate | ~4,534 steps |
| Cheeger lower bound | 0.000547 |
| Cheeger upper bound | 0.1046 |
| λ_max | 7.999 |

### Band Structure

The spectrum has three bands with prominent gaps at λ ≈ 2 and λ ≈ 6:

| Band | Range | Eigenvalue count |
| ---- | ----- | ---------------- |
| Lower | [0, 1.9] | 46 |
| Middle | [2.0, 5.95] | 188 |
| Upper | [6.0, 8.0] | 141 |

### Pervasive 3-Fold Degeneracy

**95 out of 127 distinct eigenvalue levels have multiplicity exactly 3.**

This is the signature of the graph's C3 (3-fold cyclic) symmetry from the
three helical strands. The eigenvalue at λ = 4.0 has multiplicity 3 and is
the center of the spectrum.

### Participation Ratio

ALL of the lowest 9 non-trivial eigenmodes have participation ratio = 0.6667,
meaning each mode is delocalized over exactly 2/3 of the graph — consistent
with modes that involve pairs of the 3 strands.

## The Fiedler Vector Does NOT Separate The Cones

The Fiedler vector (lowest non-trivial eigenvector) splits:
- 192 vertices positive, 188 vertices negative, 4 near-zero
- RIGHT_MERU: 69 positive / 67 negative (nearly 50/50)
- LEFT_MERU: 66 positive / 65 negative (nearly 50/50)
- BINDU: 74 positive / 73 negative (nearly 50/50)

**Every tag group has mean Fiedler value ≈ 0.** The natural partition of the
graph does NOT correspond to upper vs lower cone. The bottleneck is elsewhere
— likely along the helical strand structure.

## Graph Topology

### Block Structure

The graph consists of 8 blocks of ~48 vertices, arranged along the helix:
- Blocks 0-2 (indices 0-143): mixed RIGHT_MERU + LEFT_MERU + BINDU
- Block 3 (indices 144-191): pure AXIS + BINDU (equatorial belt)
- Blocks 4-7 (indices 192-379): mixed RIGHT_MERU + LEFT_MERU + BINDU

### Connectivity Pattern

Within each block, vertices connect to:
- ±1 (chain neighbors within the block) — 372 edges
- ±48 (next block at same strand position) — 144 edges
- ±96 (two blocks away) — 96 edges
- ±144 (three blocks away) — 48 edges

This creates a **tube-like** topology: a thick cylinder with 3 longitudinal
pathways connected at each level.

### Inter-Component Edges

| Connection Type | Count |
| --------------- | ----- |
| Within RIGHT (non-BINDU) | 95 |
| Within LEFT (non-BINDU) | 108 |
| Within BINDU | 164 |
| RIGHT ↔ BINDU | 196 |
| LEFT ↔ BINDU | 175 |
| RIGHT ↔ LEFT (direct) | 118 |

**There are 118 direct RIGHT↔LEFT edges**, meaning the cones are directly
connected, not just through the waist.

## Candidate Resonance Frequencies

From ω_k = √(λ_k), f_k = ω_k/(2π):

| Mode | λ | ω | f |
| ---- | -- | -- | -- |
| 1 | 0.00109 | 0.03307 | 0.00526 |
| 2 | 0.00437 | 0.06613 | 0.01052 |
| 3 | 0.00983 | 0.09917 | 0.01578 |
| 5 | 0.02728 | 0.16516 | 0.02629 |
| 10 | 0.10837 | 0.32919 | 0.05239 |

The frequencies are very low. If the binary's `--freq` parameter expects
values in these ranges, natural resonance effects should appear.

## Implications for the Six Hypotheses

### H1 (Symmetry Breaking via --asymmetry)

**Weakened.** The Fiedler analysis shows the graph's natural partition is NOT
the upper/lower cone divide. The Z2 mirror symmetry exists but is not the
dominant structural feature. Asymmetry may still have an effect, but the
prediction that it should bias between the two basins is less certain because
the basins may not correspond to cone dominance.

### H2 (Transformer Creates Bistability)

**Unchanged.** The spectral analysis doesn't address the dynamics directly.
Still the highest-value experiment.

### H3 (Resonance Frequency)

**Sharpened.** We now have exact candidate frequencies. The lowest modes are
f ≈ 0.005, 0.011, 0.016, 0.021. If the `--freq` parameter is in these units,
mode 1 should produce the strongest resonance effect.

### H6 (Braiding/Rotation)

**Strengthened.** The dominant symmetry is C3 (3-fold), not Z2. The `--rotation`
parameter (braiding angle) should couple directly to the 3-fold strand structure.
Prediction: **120° rotation should be a special angle** (it maps each strand
to the next). Other candidates: 60°, 180° (half-period and anti-period).

### New Hypothesis H7 (see PRD augmentation)

The 8 degree-4 vertices are structural weak points. They may serve as
nucleation sites for basin selection — the dynamics near these vertices may
determine which attractor the system falls into.

## What This Analysis Cannot Tell Us

1. How the binary maps the adjacency to its internal dynamics
2. What the `--freq` parameter's units are
3. Whether the binary respects the graph's symmetry or breaks it
4. What the actual dynamical equations are
5. Whether the transformer adds new coupling beyond the graph adjacency
