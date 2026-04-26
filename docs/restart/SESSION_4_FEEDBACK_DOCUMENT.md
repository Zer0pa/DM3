# Feedback Document for Engineering Agent — Session 4 PRD Integration

**From:** Review synthesis, 2026-04-16
**To:** Coding engineer, Session 4 PRD author
**Branch:** `hypothesis/rm10-primary-platform-heterogeneous-learning`
**Status:** Review of Session 3 pack complete. Recommendations for Session 4 scope.

This is the operator's verbatim feedback document after reviewing the Session 3 pack. It
governs the Session 4 PRD. Preserved here as an immutable reference.

---

## Preamble: Objective Hierarchy

The Session 4 PRD must be written with the following strict objective ordering. This is a
discipline, not a preference.

**Primary objective: Discovery.** Learn what this object is. Use the instrument like a
sculptor's scalpel — each experiment carves away one explanation so the true shape becomes
visible. Every experiment must be a falsifier, not a confirmer.

**Secondary objective: Commercial wedge.** Emergent. Not predetermined. Not pursued. Allowed
to surface when the object's capabilities are characterized well enough that a wedge becomes
obvious. If it doesn't emerge, that is a valid outcome of Session 4 — the object may need
Sessions 5 and 6 before any wedge is visible. Do not force it.

If at any point the PRD reads like it is optimizing for a commercial pitch, it has drifted.
Pull it back to discovery.

---

## Part 1: What Session 3 Actually Established

### Solid findings (multiple runs, mechanistic evidence)

- **Geometry is sovereign.** Bistability persists without the transformer. The transformer
  is a bias knob on top of a geometric substrate, not the engine. (Phase C: 18 interleaved runs.)
- **Graph topology is C3-dominant.** 95 of 127 eigenvalue levels are 3-fold degenerate.
  Fiedler vector does not separate cones. BINDU is a 39% equatorial belt, not a waist.
- **Bistability has stable numerical signatures** across all modes: HIGH ≈ (E=89, Coh=0.77),
  LOW ≈ (E=75, Coh=0.89). These two basins are the thing.
- **Basin selection is per-episode, not per-session.** (Phase E steps=10.)
- **Inference mode is a stub.** T1: Contraction, always, regardless of parameters.

### Suggestive findings (small N, needs replication)

- Asymmetry as continuous order parameter (2 episodes per value).
- Rotation=120° preserving bistability where other angles suppress (2 episodes per angle).
- freq=1.0 → 100% HIGH (2 episodes).
- Holography third attractor (3 episodes).
- Truth sensor unidirectional LOW bias (2 episodes per config).

**Session 4 rule: no suggestive finding gets promoted to solid without 5+ episodes of
replication.**

### Unknowns

- What `--freq` actually parameterizes.
- What `--angle` does.
- What `--soak` does under characterization.
- Whether the holography "third basin" is actually monostable, bistable, or multi-stable.
- Whether the graph's C3 symmetry is implemented exactly or approximately.

---

## Part 2: Sculptor's-Scalpel Framing for Session 4

Every experiment must be describable as *"this carving removes the possibility that the
object is X."* Not *"this experiment shows the object does Y."*

### Carvings to attempt

- **Carving 1: Statistical ambiguity.** Redo every Session 3 headline at 5+ episodes.
- **Carving 2: freq=1.0 mystery.** Three sub-carvings (freq sweep; harmonic vs holography;
  cross with rotation).
- **Carving 3: Holography ambiguity.** Is it monostable, narrowly bistable, or
  task-parameterized?
- **Carving 4: Asymmetry phase-transition.** Fine sweep to distinguish sharp critical point
  vs smooth crossover.
- **Carving 5: Rotation × asymmetry coupling.** Are they independent or coupled through
  symmetry?
- **Carving 6: `--angle` characterization.** Cheap; settle or retire.
- **Carving 7: Intra-episode telemetry.** See inside one episode.

### Do not attempt

- Do not reopen H2 (transformer creates bistability — killed).
- Do not try to control RNG seed (source-blocked).
- Do not chase FAST session (~155s anomaly).
- Do not touch NPU / heterogeneous.
- Do not promote inference mode as a live surface.
- Do not cite manifesto T-registry as predictions.

---

## Part 3: Proposed Phase Structure

| Phase | Carving | Est. device time |
|---|---|---|
| H | Statistical replication at N=5 | ~6 hrs |
| I | Frequency deep-characterization | ~3 hrs |
| J | Holography parameter sweep | ~4 hrs |
| K | Asymmetry fine sweep | ~3 hrs |
| L | Rotation × asymmetry coupling | ~2 hrs |
| M | `--angle` characterization | ~1 hr |
| N | Intra-episode telemetry investigation | variable |
| O | Integrated Session 4 characterization | writing |

Total: ~19 hours clean device time, probably 2-3 calendar sessions with breaks.

---

## Part 4: Governance Additions

1. **Minimum N=5 rule.** No finding confirmed without ≥5 episodes.
2. **Pre-registration.** Write expected outcome and kill criterion before running.
3. **Null-result parity.** Killing a hypothesis is as valuable as confirming one.
4. **No commercial framing in phase writeups.** Describe what the object does.
5. **Distinguish binary behavior from mathematical concept.** Say "holography-mode",
   not "holography", until the mathematical identity is established. Same for "resonance",
   "truth sensor", "BINDU".
6. **The sacred-geometry naming is inherited, not load-bearing.** Sri Yantra, Meru, Bindu
   are vocabulary from the source. The 380-vertex graph's properties must be defended on
   graph-theoretic grounds, not on the names its vertices carry.

---

## Part 5: What Commercial Emergence Would Look Like

Document if observed. Do not pursue. Do not design toward.

- Parameter setting producing useful behavior with small spread and sub-second latency on
  commodity hardware, repeatable across 20+ runs.
- Task transformation (X → Y) a small neural net can't cheaply replicate.
- A control regime that reads like a device specification.
- A power/thermal/time signature making RM10 substrate categorically cheaper than a GPU
  for some narrow task.

If any appear, note in a single sentence and move on. If none, Session 4 ends with a
cleaner characterization and an honest note. This is a success, not a failure.

---

## Part 6: The One-Line Brief

Session 4 is not about finding out what this object can *do for us*. It is about finding
out what this object *is*. Every carving removes one wrong answer. When enough wrong
answers are gone, the right one becomes visible — and only then does the commercial
question even make sense to ask.

Build the PRD accordingly.
