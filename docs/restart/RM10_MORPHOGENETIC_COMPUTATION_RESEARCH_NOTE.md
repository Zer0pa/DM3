# RM10 Morphogenetic Computation Research Note

## Purpose

This note ties external research on geometric computation, morphogenesis,
biocomputation, and physical reservoir computing back to the current RM10 DM3
branch.

It is a design note, not a proof note.

## External Source Bridge

| Domain | Source | Usable mechanism | DM3 carry-back |
| ------ | ------ | ---------------- | -------------- |
| geometric deep learning | [Kratsios and Papon 2021](https://arxiv.org/abs/2101.05390) | geometry-compatible models on manifolds have real expressive benefits, but purely local geometric models also have hard limits | if geometry matters, it must remain an explicit hard structure with global transport and boundary behavior |
| reaction-diffusion computation | [Mordvintsev et al. 2021](https://arxiv.org/abs/2107.06862) | pattern-forming dynamical systems can be programmed and can exhibit robust life-like behavior | DM3 can be treated as a programmable dynamical medium, not only as a static inference graph |
| closed-loop morphogenesis | [Grodstein and Levin 2022](https://arxiv.org/abs/2211.01313) | target form is maintained through feedback, computation waves, and error correction | use target-seeking, scan-and-correct, and regeneration-style assays rather than one-shot outputs only |
| basal cognition / bioelectricity | [Levin 2021](https://arxiv.org/abs/2201.10346) | distributed local competencies can scale into larger homeostatic behavior | treat DM3 as a distributed competence stack rather than assume a single central controller |
| morphological computation | [Zahedi and Ay 2013](https://arxiv.org/abs/1301.6975) | morphology and environment can be measured as contributors to behavior | define organism metrics that ask how much the geometry and environment are doing |
| body-led adaptive behavior | [Mertan and Cheney 2024](https://arxiv.org/abs/2407.16613) | useful behavior can arise from body dynamics without a separate heavy controller | do not assume usefulness requires a large learned core first |
| physical reservoir computing | [Nakajima 2020](https://arxiv.org/abs/2005.00992) | nonlinear physical systems with fading memory can compute, especially at the edge | use short-history readout and history-sensitive assays on RM10 |
| self-organized active matter | [Wang and Cichos 2023](https://arxiv.org/abs/2307.15010) | noisy self-organized active systems can compute when historical states are used | retain and compare recent state histories, not just final outputs |

## What Changes In The DM3 Reading

### From Model To Medium

The external work consistently favors reading DM3 as a medium with:

- morphology
- state
- nonlinear dynamics
- feedback
- memory
- boundary readout

That is a better fit than reading it as a conventional software model whose
meaning sits mostly in weights.

### From Inference To Homeostasis

Morphogenesis points toward a target-seeking interpretation:

- runs are not just outputs
- runs are attempts to settle or restore a configuration
- perturbations matter because they test the restore dynamics

For DM3, this means the right future experiments are:

- repeated baseline runs
- lesion / repair runs
- boundary damage runs
- history-direction runs

### From Controller Dominance To Morphological Contribution

Morphological computation gives a concrete question:

How much behavior comes from the geometry plus environment versus the explicit
controller?

For the current branch, that becomes:

- how much does row order matter?
- how much does persistence matter?
- how much does boundary asset state matter?
- how much does the forcing schedule matter?
- how much remains once the explicit controller is simplified?

### From One-Shot Output To Reservoir State

Physical reservoir computing suggests that useful behavior may appear first as:

- fading memory
- nonlinear but repeatable response classes
- short-history readout effects
- hysteresis
- recovery curves

This strongly supports the branch move away from single-shot command rhetoric
and toward repeated-window organism-environment batteries.

## What Carries Back To Geometry And Transformer Placement

The external work does not support turning geometry into decoration.
It supports the opposite:

- keep the geometry as the body plan
- keep the learned adapter thin at the boundary
- let the geometry and dynamics carry as much of the burden as they honestly
  can
- only widen the learned core if the geometry-first route fails clearly

## Practical Consequence

The current confirmation replay should stay the next empirical gate.
But once that gate is stable enough, the experiment family should expand toward:

- homeostasis
- regeneration
- history dependence
- morphological contribution
- boundary-readout fidelity

That is the shortest disciplined path from today's branch truth floor toward an
artifact that can actually be learned, used, and measured as a physical
computational object.
