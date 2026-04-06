# RM10 Resonance-Chamber Heterogeneous PRD

Last refreshed: `2026-04-06`

## Mission

Run a new bounded RM10 programme that treats the phone SoC as a candidate
resonance chamber for geometric computation rather than as a late-stage target
for deterministic replay.

This phase does not assume that heterogeneous compute is optional until a core
stabilizes. It tests the opposite possibility directly:

- heterogeneity may be constitutive, not decorative
- environment may matter, not just commands
- repeated perturbation and relaxation may reveal more than one-shot runs

The job is not to prove the training document true.
The job is to build the smallest honest experimental programme that can test
whether the document's architecture names a real, measurable effect on the
RM10.

## Executive Reframe

The branch has already shown three things:

- CPU control is real on the governed `F1` lane
- GPU-backed residue-family feasibility is real on bounded `F2` surfaces
- NPU remains unresolved as a callable lane

The branch has also been leaning on a sequencing assumption:

1. stabilize the CPU-only core
2. only then test coupled heterogeneous work

This PRD suspends that assumption as a prerequisite.

For this phase:

- CPU-only remains a control and contrast instrument
- heterogeneous coupling becomes an experimental variable to test now
- determinism becomes telemetry unless it directly explains or destroys a
  measured effect
- the authority gate does not move, but the discovery gate moves forward

## Product Statement

Build a minimal RM10 "geometric organism environment" that can:

- keep persistent state across bounded windows
- admit controlled perturbations
- drive callable CPU and GPU stages as one coupled environment
- attach an NPU assist stage immediately if a callable user-space path exists
- emit a small set of honest dynamical observables
- compare CPU-only and heterogeneous-coupled behavior without pretending they
  are already equivalent

## What "Resonance Chamber" Means Here

This phrase must not remain mystical.

Operationally, the chamber is the combination of:

- CPU scheduling and gating
- GPU-parallel update or relaxation work
- optional NPU projection / priming work
- shared memory and cache pressure
- repeated bounded forcing windows
- persistence of intermediate state
- thermal and timing constraints that shape the actual dynamics

The chamber hypothesis says that some response family may depend on the coupled
loop itself, not only on the final output artifact of one lane in isolation.

That means the right early questions are about:

- response class
- persistence
- hysteresis
- boundary sensitivity
- spectral or cluster stability
- recovery after perturbation

not only:

- hash equality
- validator success
- throughput
- heat

## Scientific Reading Of Training Doc #5

The training document proposes a geometry-first machine:

- CPU as scheduler / verifier
- NPU as projection / priming
- GPU as parallel relaxation
- gating by contraction, energy descent, coherence, ECC, and spectral stability

For this project, treat those as:

- candidate roles
- candidate observables
- candidate stop rules

not as proven properties.

The honest question is:

Which parts of that role partition can be instantiated on today's RM10 surfaces
and tested without inventing hidden infrastructure?

## Core Hypotheses

`H1`: A bounded heterogeneous CPU/GPU chamber on RM10 produces a measurable
response family not visible, or less visible, on the CPU-only contrast lane.

`H2`: A minimal persistent environment with repeated perturb-and-relax windows
is necessary to expose any such family.

`H3`: If an NPU path is callable, its honest early role is bounded projection,
priming, or tagging rather than opaque whole-pipeline ownership.

`H4`: Early useful observables are dynamical and qualitative-in-kind before
they are canonical and bitwise-stable.

`H5`: The chamber story may collapse under falsification; that remains a valid
return.

## Non-Goals

Do not use this phase to:

- claim final scientific proof of Double Meru ontology
- claim source parity
- claim repaired validator-default governance
- claim full explicit heterogeneous handoff authority
- treat NPU hardware presence as a lane
- narrate heat or runtime as signal
- silently substitute legacy residue surfaces for current live surfaces

## Admissible Surfaces

Primary surfaces for this phase:

- governed RM10 `F1` CPU lane on `genesis_cli` as control and comparison anchor
- top-level `F2` residue lane on `dm3_runner` where callable CPU/GPU coupled
  work already exists
- any real user-space reachable NPU assist path if one can be named and
  receipted during this phase

Secondary support surfaces:

- Mac host for debugging, code generation, artifact inspection, and contrast
- literature and official hardware sources for framing and run design

## Minimal Observable Contract

Every serious run must name:

- one anchor observable
- one drift observable
- one abstain rule

Candidate observables for this phase:

- delta or descent traces already emitted by current binaries
- coherence-like or cluster fields already exposed by receipts
- packet summary tuples that can be compared across repeated windows
- persistence class over repeated perturbations
- threshold or hysteresis classification under parameter sweeps
- boundary-retention or boundary-perturbation response

## Environment Doctrine

This phase does not treat the organism as a naked invocation.

The environment includes:

- workspace root
- output root
- retained intermediate state
- reseeded or persisted inputs
- thermal state
- perturbation schedule
- run cadence

The phase must therefore build one minimal environment scaffold instead of only
throwing isolated commands at the phone.

## Workstream A: Chamber Surface Map

Purpose:

- localize the exact runnable CPU, GPU, and candidate NPU surfaces
- state what can be reused from existing runbooks and helpers
- avoid losing time to dead wrappers or duplicated binaries

Required outputs:

- `RM10_RESONANCE_SURFACE_MAP.md`
- `RM10_CALLABLE_LANE_MATRIX.md`
- one exact live command table

## Workstream B: Geometric Organism Environment

Purpose:

- create the minimal persistent environment in which bounded perturbation and
  relaxation windows can be run honestly

Required components:

- one live workspace root
- one live output root
- state persistence policy
- perturbation-window schedule
- capture helper or runner wrapper for repeated windows

Required outputs:

- `RM10_GEOMETRIC_ENVIRONMENT_SPEC.md`
- environment helper scripts or configs
- one clean-room bring-up packet

## Workstream C: CPU/GPU Resonance Micro-Battery

Purpose:

- compare CPU-only versus heterogeneous CPU/GPU-coupled behavior on one
  callable family now

Questions:

1. Does coupling change response class or only runtime?
2. Does repeated forcing expose persistence, hysteresis, or threshold behavior?
3. Does the coupled loop degrade or sharpen the chosen observable?

Required outputs:

- `RM10_CPU_GPU_RESONANCE_LEDGER.md`
- parameter table
- repeated-window receipts
- explicit verdict: `NO_EFFECT`, `WEAK_EFFECT`, `STRUCTURED_EFFECT`, or
  `UNRESOLVED`

## Workstream D: NPU Projection / Priming Probe

Purpose:

- attempt immediate NPU opening without waiting for a stable core, but only as
  a bounded assist role

Allowed roles:

- projection
- priming
- tagging
- preprocessing

If no callable path exists, classify the missing path sharply and continue.

Required outputs:

- `RM10_NPU_PROJECTION_PROBE_LEDGER.md`
- explicit role statement or explicit missing-path statement
- verdict: `PASS`, `FAIL`, `ABSTAIN`, or `BLOCKED`

## Workstream E: Persistence, Boundary, And Hysteresis

Purpose:

- test whether the environment exhibits memory or boundary-mediated behavior
  under repeated perturbations

Probe classes:

- short repeated windows
- perturb / relax / perturb cycles
- boundary-input variation
- packet-shape or state-initialization variation

Required outputs:

- `RM10_PERSISTENCE_AND_BOUNDARY_LEDGER.md`
- one property map or explicit null result

## Workstream F: Adversarial Falsification

Purpose:

- try to kill the chamber story quickly

Attack lines:

- stale-path illusion
- wrapper illusion
- output-directory contamination
- logging illusion
- thermal confound
- residue substitution
- hidden fallback
- pure speedup mistaken for behavior

Required outputs:

- `RM10_RESONANCE_FALSIFIER_VERDICT.md`

## Logging Discipline

Every serious run must record:

- run ID
- battery ID
- lane or lane split
- exact command
- cwd
- output root
- before / after battery state
- before / after thermal state
- observable summary

Optional but desirable:

- periodic load samples
- process snapshots
- hash or validator telemetry
- Comet or offline manifest key

## Acceptance Gates

This PRD is complete when:

1. one real CPU/GPU chamber battery has been executed on RM10 with preserved
   receipts
2. the phase can say whether heterogeneity changed behavior or only runtime on
   the chosen family
3. the phase can say whether any persistence, hysteresis, or boundary effect
   survived falsification
4. the NPU path is either opened honestly as a bounded assist role or reduced
   to an exact missing-path statement
5. the final package chooses one recommendation:
   - continue chamber science
   - continue environment engineering
   - escalate NPU assist work
   - terminate the chamber story as empty

## Deliverables

Return with:

- the PRD
- phase research pack
- environment spec
- callable lane matrix
- CPU/GPU resonance ledger
- NPU probe ledger
- persistence / boundary ledger
- falsifier verdict
- final bounded verdict note

## Final Instruction

Proceed as if heterogeneity might be part of the mechanism.
Do not assume it is.
Build the environment.
Run the chamber.
Measure the response.
Kill the story if the response is fake.
