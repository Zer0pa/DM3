# DM3 Hypothesis and Battery Register

## Purpose

This is the current branch and battery register for the DM3 restart.
It is a planning and falsification aid.
It does not mean every branch should be created immediately.

Use this register to decide:

- what counts as a real hypothesis branch
- what counts as a battery class or parameter sweep
- which inputs, outputs, and pivots matter
- what honest failure would look like

## Branch Creation Rule

Create a hypothesis branch only when the alternative changes the scientific or architectural interpretation of DM3.

Do not create separate branches for:

- seeds
- thresholds
- window sizes
- run duration
- hardware lane by itself

Those are run classes under a hypothesis unless they imply a different explanation.

## Candidate Hypotheses

| ID | Hypothesis | Core claim | Inputs to vary | Decisive outputs | Honest failure signal | Likely pivot |
| -- | ---------- | ---------- | -------------- | ---------------- | --------------------- | ------------ |
| H-01 | Exact Geometry Artifact | The main irreplaceable asset is the mathematically exact DM3 geometry itself | geometric validation method, coordinate definitions, exactness tests | exactness proof or independent validation dossier | exactness cannot be defined sharply enough to validate | reduce to geometry-inspired design rather than exact canonical artifact |
| H-02 | Field Computation Manifold | Deterministic relaxation on the DM3 substrate yields distinctive computation beyond a pretty geometry | lattice rules, contraction tests, holography tests, energy witnesses | stable fixed-point receipts, contraction evidence, replay parity | no distinctive computation survives source-backed replay | downgrade to constrained state-space or memory substrate |
| H-03 | Structure-First Scientific Memory | DM3 is best as a deterministic memory, indexing, or retrieval substrate for structured technical knowledge | corpus ordering, retrieval tasks, proof/equation anchoring, boundary readouts | retrieval fidelity, recall stability, equation/proof object preservation | it behaves no better than simpler graph/index baselines | reduce to exact-geometry IP plus curriculum method |
| H-04 | Boundary Transformer Hybrid | Transformer machinery belongs only at the boundary as encoder, readout, gloss, or adapter | boundary encoder type, readout head, adapter width, gloss strategy | improved interfacing without degrading geometry metrics | transformer quickly becomes the real hidden-state substrate | freeze transformer to a thinner adapter role or remove it |
| H-05 | Center Model Hybrid | A stronger learned model at the center is required while the geometry remains the outer contract | center module choice, center/geometry coupling, bridge rules | better performance with preserved geometry authority metrics | center model dominates and makes geometry ornamental | split into ordinary hybrid architecture and stop calling it DM3-first |
| H-06 | Nodewise Transformer Hybrid | Transformer logic at many or all nodes is required for useful behavior | nodewise attention pattern, sparsity, weight sharing, topology placement | measurable gains under the same authority battery | geometry no longer explains behavior and nodewise model becomes the real engine | retreat to boundary or center hybrid only |
| H-07 | Training Regime Pivot | Useful DM3 behavior requires something beyond pure relaxation-first feeding | relaxation-only vs hybrid optimization, scar editing, curriculum strictness | improved acceptance without losing deterministic authority tests | only standard optimization works and relaxation-first adds no value | separate training method from geometry claim |
| H-08 | Device-Lane Hypothesis | The RM10 Pro device lane is a first-class execution environment, not just deployment | CPU, GPU, NPU role partition; deterministic reduction order; staging windows | reproducible device receipts, replay parity, thermal-safe long runs | phone lane is unstable, inaccessible, or materially divergent | keep Mac as authority lane and treat phone as optional deployment target |

## Battery Classes

### Micro-batteries

Purpose:

- fast falsification
- fast regression checks
- lane bring-up
- per-pivot sanity tests

Typical duration:

- seconds to minutes

Examples:

- projection of one input batch to geometry coordinates
- one-wave relax / settle / measure cycle
- determinism under same seed
- receipt emission and checkpoint / resume identity
- boundary reconstruction and coherence spot checks
- small proof/object tether checks

Typical outputs:

- metrics trace
- receipt bundle
- pass / fail / abstain verdict

### Medium batteries

Purpose:

- local hypothesis testing
- interface validation
- curriculum transitions

Typical duration:

- tens of minutes to a few hours

Examples:

- geometry -> math curriculum slice
- Sanskrit / phoneme bridge slice
- minimal formal English tether
- small code / proof / equation corpus slice
- GPU lane deterministic reduction checks
- NPU projection feasibility checks if accessible

Typical outputs:

- comparison ledger
- drift notes
- battery-specific summaries

### Long batteries

Purpose:

- saturation behavior
- thermal behavior
- multi-wave curriculum behavior
- honest cross-platform falsification

Typical duration:

- hours to overnight or longer

Examples:

- canonical streaming flood in staged windows
- multi-shell curriculum progression
- mixed modality ingestion under the same authority rules
- cross-platform Mac vs RM10 replay
- long-running CPU/GPU lane parity
- phone thermal / resume / checkpoint safety

Typical outputs:

- long-run ledger
- device health notes
- acceptance or falsification verdict

## Execution Lanes

| Lane | Role now | What to test | What not to assume |
| ---- | -------- | ------------ | ------------------ |
| Mac CPU | current safest source-backed lane | build, deterministic baseline, debug, small and medium batteries | not necessarily final authority for all later DM3 claims |
| Mac GPU / Metal | optional acceleration lane | deterministic parity with CPU, faster medium batteries | not proof that mobile SoC behavior matches |
| RM10 CPU | likely easiest phone baseline | bring-up, deterministic replay, micro-batteries | not enough alone to prove SoC-native advantage |
| RM10 GPU | likely main acceleration lane if deterministic reduction is achievable | replay parity, longer batteries, thermal behavior | not guaranteed to match CPU without careful reduction rules |
| RM10 NPU | optional projection or priming lane if toolchain permits | mapping/projection, lightweight assist roles | not assume direct support until proven in tooling |

## Input / Output / Pivot Matrix

| Area | Inputs | Outputs | Pivot triggers |
| ---- | ------ | ------- | -------------- |
| Geometry exactness | coordinate construction, symmetry constraints, validation references | exactness dossier, validation note, rejection note | exactness claim not formally defensible |
| Field dynamics | update rules, contraction checks, energy witnesses, holography checks | receipts, energy traces, coherence/ECC ledgers | witnesses fail, contraction not robust, replay not unique |
| Corpus and curriculum | ordering, scope, geometry/math/proof/phoneme/text/code slices | curriculum battery ledgers, regression notes | early language collapses geometry-first behavior |
| Hybrid architecture | boundary adapters, center model, nodewise transformer variants | branch comparison tables, authority-metric deltas | hybrid wins only by erasing geometry-first identity |
| Device execution | CPU/GPU/NPU lane configs, window sizes, checkpoint rules | lane-specific ledgers, drift reports, thermal notes | device lane cannot replay authority battery honestly |

## Suggested Initial Branch Order

Do not create all branches at once.
The likely order is:

1. Mainline Phase 1 and Phase 2
2. H-02 versus H-03 once source-backed baseline is clearer
3. H-04 versus H-05 only if hybrid continuation becomes justified
4. H-06 only if there is a real reason to test transformer-per-node as a distinct scientific story
5. H-08 when device-lane evidence becomes strong enough to compare as an architectural thesis rather than just an execution lane

## PRD Precursor Fields

The eventual long-running PRD should be built from this register.
It will need, at minimum:

- hypothesis ID
- invariant that must remain true
- allowed inputs
- decisive outputs
- authority metric
- run classes
- device lanes
- kill criteria
- allowed pivots
- comparison target or baseline

## Working Rule

The point of this register is to let DM3 fail honestly.
If a branch collapses, we keep the surviving artifact, memory, or product wedge instead of pretending the original strongest claim still held.
