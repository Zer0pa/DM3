# Phase N — Intra-Episode Telemetry (Carving 7)

## Pre-Registration

Phase N aims to see inside a single episode. Is convergence monotone, oscillatory, or hopping?

## Execution Record

- **N.1 (schema scan):** BLOCKED — device disconnected during Phase L. Not executed.
- **N.2 (binary strings scan):** COMPLETED on Mac.
- **N.3 (source request):** Written below.

## N.2 Results — Binary Strings Analysis

The `dm3_runner` binary (9,554,600 bytes, SHA256 `daaaa8...`) was pulled to Mac and analyzed with `strings`. Key findings:

### Internal Learning Rules

Three learning rules are embedded:
- **R0: Random** — random initialization phase
- **R1: Oja** — Oja's learning rule (Hebbian principal component learning)
- **R2: Contrastive** — contrastive learning

The resonance training likely cycles through R0→R1→R2 phases, or uses them in alternation. This explains the "resonance" training name — it may refer to iterative cycling of learning rules until convergence.

### Internal State Dimensions

- **Feature dimension: 192** (found in error string: `"not divisible by feature_dim 192"`)
- **Total state: 380 vertices × 192 features = 72,960 floats per episode**
- State update equation visible in GPU shader: `state_out = state_in + dt * (output - state_in)` — a discrete-time relaxation dynamic toward the output of a nonlinear function.

### Hidden Task Types

Besides `harmonic` and `holography`, the binary contains:
- **`InterferenceTask`** — an interference computation task
- **`holographic_memory`** — `run_holographic_memory` function
- **`exp_i0_classifier`** — inference classifier with `ResonanceMetrics` struct
- **`exp_r1_r4_campaign`** — R1-R4 campaign experiment with `eval_stats` and `eval_stats_mean`
- **`K1: Pattern Ontology Capacity Experiment`** — pattern capacity testing
- **`G2 Boundary Readout Experiment (Mode: )`** — parameterized boundary readout

### Graph Structure Internals

- **`OntologyInjector`** — organizes graph into sectors and rings
- **`get_nodes_for_sector`**, **`get_all_sectors_in_ring`** — sector/ring accessors
- The graph is organized as sectors within rings, not just vertices with tags.

### Other Findings

- **`EbmCalibration`** struct — Energy-Based Model calibration
- **`XnorSampler`** — XNOR-based binary sampling
- **`Corrections Triggered:`** — internal correction mechanism
- **`Holography (Boundary->Bulk)`** — confirms holography implements boundary-to-bulk mapping
- **`Stats: Match_E=, Mismatch_E=, Sep=`** — internal energy statistics
- **`Saved radii to`** — can save geometric radii data
- **`L1 Step`**, **`L2 Step`** — layered processing steps
- Hidden flags: only `--help` visible in strings. All CLI flags defined via clap (Rust CLI framework) and not stored as literal strings.
- GPU compute via wgpu with fused transformer kernel (Q, K, V computation in shared memory)

### No Per-Step Telemetry

No strings matching `trace`, `checkpoint`, `log`, `debug`, `step`, `emit`, `dump`, `profile`, `metric`, `telem` were found that indicate user-accessible per-step telemetry emission. The internal telemetry (ResonanceMetrics, Stats, L1/L2 Step) is consumed internally and only the final per-episode receipt is emitted.

## N.3 — Source-Level Request

**Per-step telemetry emission is blocked at the binary level.** The binary computes per-step state updates internally but only emits per-episode summary receipts. To see inside a single episode, the source code needs modification.

Requested for Session 5:
1. Emit per-step `delta_E` and `coherence` values (at minimum every N steps for configurable N)
2. Emit the learning rule phase (R0/R1/R2) active at each step
3. Optionally emit per-step state hash for convergence tracking

Without this, intra-episode dynamics remain opaque. The binary treats each episode as an atomic unit producing a single receipt.

## Verdict

**PARTIAL — N.2 completed with significant internal structure findings. N.1 blocked (device offline). Per-step telemetry CONFIRMED blocked at binary level.**

The N.2 binary scan is the most valuable part of Phase N. It reveals the internal architecture: a 380×192 state space evolving under relaxation dynamics with three learning rules (Oja + contrastive + random init), organized via sector/ring graph structure. The "resonance training" is likely the alternation of these rules until the state relaxes to one of the two basins.

The hidden task types (interference, holographic_memory, K1 pattern ontology, G2 boundary readout) are potential Session 5 investigation targets.

## Artifacts

- `artifacts/phase_N_telemetry_20260417T095000Z/` (this writeup)
- Binary strings analysis performed on `/tmp/dm3_runner_binary`
