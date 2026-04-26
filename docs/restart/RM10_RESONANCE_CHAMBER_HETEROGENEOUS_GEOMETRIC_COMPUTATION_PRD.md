# RM10 Resonance-Chamber Heterogeneous Geometric Computation PRD

Last refreshed: `2026-04-06`

## Mission

Run the next RM10 branch line as a heterogeneity-first scientific and
engineering attack.

The purpose is not to prove the whole theory.
The purpose is not to narrate heterogeneity as success.
The purpose is not to wait passively for a stable single-lane core if the core
itself may require coupled execution.

The purpose is to determine whether the RM10, treated as a bounded resonance
chamber across CPU, GPU, and possibly NPU, exhibits any nontrivial
geometric-computation behavior that is absent or weaker on the CPU-only
control.

## Executive Instruction

Two corrections define this phase.

### A. Stop treating heterogeneity as downstream by definition

Previous branch work correctly refused to overclaim from unstable same-family
and NPU-inventory surfaces.
That caution does not settle the new question.

This phase tests the opposite possibility directly:

- the stable or interesting regime may require coupled heterogeneous execution
- the handoff or boundary may be where the object actually lives
- a single-lane stability-first doctrine may be hiding the relevant behavior

### B. Translate the training document into experiment, not dogma

The training document describes:

- CPU as scheduler and arbiter
- NPU as projection or priming
- GPU as parallel relaxation
- a resonance-governed advancement policy
- observables such as energy descent, coherence, ECC, Laplacian tension, and
  spectral stability

Those are not accepted facts.
They are a role hypothesis and an observable proposal.

This phase must test which parts cash out on the live RM10 surface and which
parts collapse into metaphor or unavailable infrastructure.

## Product Statement

Build the smallest trustworthy RM10 package that can do all of the following:

- define what "resonance chamber" means operationally on this SoC
- define what "geometric computation" means operationally on this branch
- map the actually callable CPU, GPU, and NPU surfaces on the attached phone
- run a bounded heterogeneity-first battery without waiting for full canonical
  validator success
- compare that battery against a CPU-only control
- determine whether lane coupling changes behavior class, not merely runtime
- determine whether boundaries, windows, and environment are where the signal
  lives
- falsify the story aggressively if the effect is fake

## Current Truth Floor To Inherit

This PRD starts from the retained branch state, not from a blank slate.

- CPU is the only clearly retained live lane
- GPU has been exercised in bounded probes and same-family brackets, but has
  not cleared the authority gate
- the top-level same-family `F2` bracket remains unstable
- NPU remains unproven as a callable DM3 lane
- the capability-discovery reset on the cleaned single-lane contract closed as
  a no-capability result on that contract

Those facts remain visible.
They do not answer whether heterogeneity is part of the required operating
regime.

## Working Model

For this phase, "resonance chamber" means:

- a coupled execution system where CPU, GPU, cache hierarchy, memory traffic,
  packet staging, and possibly accelerator handoffs may shape the time-evolving
  state
- a system whose interesting behavior may appear at windows, boundaries,
  repeated forcing, resumed runs, or lane splits rather than in one isolated
  static output

For this phase, "geometric computation" means:

- inputs, packets, or windows are organized and perturbed as structured state
  on a graph, lattice, field, or boundary/bulk representation
- the outputs are judged by state evolution and observables, not only by final
  hashes

## Non-Goals

Do not spend this phase trying to:

- prove the ontology of DM3
- settle canonical validator doctrine fully
- narrate hardware presence as capability
- claim NPU success from DSP inventory
- claim heterogeneous success from speed or thermal changes alone
- inherit the training document's role map as truth without testing
- call a mixed-lane run meaningful unless it changes or preserves an observable
  in an interpretable way

## Primary Question

Can a bounded heterogeneous RM10 execution surface produce a measurable,
characterizable, and falsifiable geometric-computation response that is not
present on the CPU-only control?

## Subsidiary Questions

1. Does a coupled CPU/GPU or CPU/GPU/NPU path change response class rather than
   just runtime?
2. Are handoffs, windows, boundaries, or resumed state the locus of the effect?
3. Does the system show thresholds, persistence, hysteresis, or attractor-like
   settling under structured forcing?
4. Can the document's proposed observables be approximated honestly on current
   surfaces?
5. Is NPU actually callable, or must the phase reduce honestly to CPU/GPU?
6. Does the effect survive hostile falsification?

## Observable Contract

Each serious battery must define:

- one anchor observable
- one drift observable
- one abstain rule

### Candidate anchor observables

- response class
- energy-like descent proxy
- coherence or ECC field if honestly exposed
- packet summary field
- pre/post handoff summary delta
- lane-differential behavior on a common input family

### Candidate drift observables

- response-class flip
- loss of monotonicity
- coherence collapse
- handoff corruption
- thermal co-occurrence without behavioral persistence
- variance blowout under the same battery

### Secondary telemetry

- validator result
- hashes
- runtime
- power and thermal state
- process snapshots

These are secondary unless they directly explain the effect.

## Workstreams

### Workstream A: Training-Document Translation

Objective:

- convert the training document into a branch-local experimental contract

Required outputs:

- `RESONANCE_CHAMBER_INTERPRETATION_NOTE.md`
- `GEOMETRIC_COMPUTATION_OBSERVABLES_NOTE.md`
- `TRAINING_DOC_ROLE_MAP.md`

Required questions:

1. Which claims are directly testable now?
2. Which claims are role hypotheses?
3. Which claims are metaphor?
4. Which observables can be surfaced on current binaries?

### Workstream B: Live Lane Reality Check

Objective:

- map what is actually callable now on RM10

Required outputs:

- `RM10_RESONANCE_LANE_REALITY_NOTE.md`
- `RM10_CALLABLE_SURFACE_TABLE.md`

Required classifications:

- `callable_control`
- `callable_candidate`
- `inventory_only`
- `opaque`
- `blocked`

### Workstream C: Heterogeneity-First Micro-Battery

Objective:

- run the smallest honest coupled-lane battery against CPU-only control

Minimum structure:

- one CPU-only control
- one CPU/GPU candidate path if callable
- one CPU/GPU/NPU candidate path only if NPU is truly callable
- identical input family and logging discipline across rows

Required outputs:

- `RM10_RESONANCE_MICRO_BATTERY_LEDGER.md`
- exact command transcript
- per-row observable summary
- control-vs-candidate comparison note

### Workstream D: Boundary And Environment Battery

Objective:

- test whether the signal lives in packet windows, resumed state, cache-local
  forcing, or bounded environment structure

Examples:

- short versus resumed windows
- different packet shapes
- different boundary conditions
- persistent versus cold-start state
- staged versus monolithic forcing

Required outputs:

- `RM10_BOUNDARY_AND_ENVIRONMENT_LEDGER.md`
- boundary sensitivity table
- environment sensitivity note

### Workstream E: NPU Reality Check

Objective:

- attack the NPU question directly rather than carrying it as mythology

Rules:

- if there is no callable user-space path, say so and stop
- if a path exists, bound it tightly and compare against CPU or CPU/GPU control

Required outputs:

- `RM10_NPU_CALLABILITY_AND_ROLE_LEDGER.md`
- explicit verdict: `PASS`, `FAIL`, or `ABSTAIN`

### Workstream F: Adversarial Falsification

Objective:

- prove the apparent effect is fake if it is fake

Attack lines:

- stale-path illusion
- logging illusion
- thermal confound
- timing artifact
- reused output contamination
- hidden fallback
- lane illusion
- boundary illusion

Required outputs:

- `RM10_RESONANCE_FALSIFIER_VERDICT.md`

## Acceptance Rules

### Pass

The phase passes only if:

- a coupled-lane candidate path is actually callable
- at least one observable distinguishes control from candidate behavior in a
  repeatable way
- the effect survives bounded falsification
- the claim is stated no larger than the evidence class

### Abstain

Abstain if:

- the lane is too opaque
- the signal is too small
- the observable is too weak
- the effect cannot be separated from thermal or timing noise
- the NPU remains inventory-only

### Fail

Fail if:

- no callable heterogeneous candidate path exists
- no observable difference survives control comparison
- the story collapses under simple falsification

## Logging And Telemetry Discipline

Every serious run must preserve:

- run ID
- battery ID
- lane or split
- exact command
- cwd
- output path
- battery and thermal snapshots
- observable summary
- handoff or boundary notes where applicable

## Deliverables

Return with:

1. the PRD itself
2. the training-document translation notes
3. the live lane reality note
4. the heterogeneity-first battery ledger
5. the boundary/environment ledger
6. the NPU ledger or abstain note
7. the falsifier verdict
8. a final recommendation with only three sections:
   - what is real
   - what collapsed
   - what one next move is justified

## Final Instruction

Do not wait for permission from an inherited doctrine that assumed
heterogeneity had to come later.

Run the bounded heterogeneous hypothesis directly.
Measure it honestly.
Attack it hard.

If the resonance-chamber story survives, tighten it.
If it collapses, say so plainly.
