# Binary Telemetry Request for Session 5

Written: `2026-04-17` by Session 4 agent

## Problem

The `dm3_runner` binary emits one receipt per episode with 6 fields: `{asymmetry, coherence, decision, delta_E, duration_ms, episode}`. There is no per-step telemetry available. This makes intra-episode dynamics completely opaque.

## What We Need

### Minimum

1. **Per-step energy and coherence emission** — every N steps (configurable), emit intermediate `delta_E` and `coherence` values. This would reveal whether convergence is monotone, oscillatory, or hopping between basins mid-episode.

### Preferred

2. **Learning rule phase indicator** — emit which rule (R0-Random, R1-Oja, R2-Contrastive) is active at each emitted step. This would reveal the learning cycle structure.
3. **Per-step state hash** — a lightweight hash of the full 380×192 state vector at each emitted step. This would enable convergence tracking and fixed-point detection.

### Nice-to-have

4. **Per-step adjacency influence metric** — some measure of how much the graph topology (adjacency, sector/ring structure) is driving the update vs the learning rule.
5. **Separate receipt schema for telemetry mode** — a `--telemetry-interval N` flag that emits extended JSONL with per-step fields without changing the standard receipt format.

## Why

Session 4 characterized the basins (HIGH/LOW) and their parameter dependence. But we cannot distinguish between:
- Basin selection happening at initialization (step 0) and remaining fixed
- Basin selection happening mid-episode via a dynamical transition
- Basin selection being a gradual convergence process

All three are consistent with the per-episode receipt data. Only per-step telemetry can resolve this.

## Format Suggestion

```json
{"step": 100, "delta_E": 82.3, "coherence": 0.81, "rule": "R1", "state_hash": "a3f2..."}
```

Emitted to a separate file (`--telemetry-output <path>`) to keep the standard receipt format unchanged.

## Context

- Binary: `/data/local/tmp/dm3_runner` (9.6MB, Rust, wgpu GPU compute)
- Feature dim: 192
- State space: 380 × 192 = 72,960 floats
- Typical episode: ~195 seconds
- Internal learning rules: R0 Random, R1 Oja, R2 Contrastive
- State update: `state_out = state_in + dt * (output - state_in)`
