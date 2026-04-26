# DM3 Journey Log

One paragraph per research session. What moved, what died, what emerged.
Journey is the destination.

---

## Session 1 (manifesto era, pre-restart)

The manifesto claimed a `T01–T236` registry of deterministic
theorems-on-construction for the 3D Double Meru. On restart the
manifesto was treated as a claim inventory, not proof. The 2D → 3D
Sri Yantra construction was affirmed from source-backed geometry, but
the `T01–T236` numbering was demoted to vocabulary until receipted
executability could be re-established.

## Session 2 (custody & governance)

Long-horizon research custody was established: Mac and Red Magic 10 Pro
as execution lanes, ADB as the canonical device transport, `/data/local/tmp`
as the canonical on-device execution surface. Gates A-E were written.
Fresh device executability was proven, but the live `genesis_cli` default
validator still rejected the historical Mac-parity witness — localizing
the blocker to stale validator defaults rather than bundle corruption.

## Session 3 (multi-hypothesis long-horizon)

Seven hypotheses tested against the bundled `dm3_runner` binary. H2
(the transformer creates the bistability) was **killed**: bistability
persists at 20% HIGH rate even in Hamiltonian / LayerNorm-off mode.
Asymmetry was identified as an order parameter. The holography task was
discovered as a distinct operating point (E≈15). Per-episode stochastic
basin selection was observed. Multiple suggestive findings (freq=1.0 →
100% HIGH; rot=120° preserves bistability; truth sensor suppresses HIGH)
carried N=2 evidence and were flagged for replication.

## Session 4 (Sculptor's Scalpel, N=5)

Seven "carvings" at N=5 each. Session 3's suggestive findings were
revisited: 5 of 7 were KILLED at N=5 (freq resonance peak, rot=120
preserves bistability, truth sensor, transformer 3× bias, sharp
asymmetry critical point). 2 were PROMOTED (asymmetry as order
parameter, holography third attractor). The transformer was re-killed
with strengthened evidence. A binary strings scan revealed internal
architecture (R0 Random / R1 Oja / R2 Contrastive learning rules; 192
features; sector/ring OntologyInjector) and a list of hidden task
identifiers not exposed through the canonical help flag.

## Session 5 (hidden tasks + basin independence + E-scale)

Three hidden tasks became callable through `--task`: `interference`,
`holographic_memory`, `exp_r1_r4_campaign`. The last of these was the
surprise — a self-evaluating 6-gate capability surface. At defaults
3 gates PASS and 3 FAIL. Basin selection in `harmonic` was N=100 pooled
and confirmed as IID Bernoulli with p(HIGH) ≈ 0.34. Claim γ (Session 4's
"rot=60° uniquely opens the boundary; C3-asymmetric coupling") was
**weakened to RETRACTION at N=10 pooled**; rot=60° and rot=120° are
statistically indistinguishable. Harmonic and holography were shown to
be **distinct dynamical regimes** sharing an asymmetry axis but not
merging; the E gap persists ~60 units across asym ∈ [−5, +5]. A new
edge was found: basin Coh signatures compress at asym ≤ −3, breaking
the Session 4 locked classifier.

## Session 6 (this session — gate flips, full vocabulary, resilience)

Task-name inventory doubled: from 5 to **12 accepted task names**,
including `exp_i1`, `exp_i2`, `exp_h1_h2`, `exp_k2_scars`,
`exp_k3_truth_sensor`, `resonance_r3`, `resonance_v2` — all callable.
Four canonical SHA-256 equivalence classes were catalogued for
`exp_r1_r4_campaign` output. Two gate flips were discovered and
documented: **R1 flips FAIL→PASS with `--adj RandomAdj_v1.bin`**
(`r1.margin` 0.0 → 0.5), and **R2 flips FAIL→PASS with
`--tags RegionTags_v2.bin`** (`claim_level` advances CL-0 → CL-1).
R3 payload-moves 4× along the `--steps` axis but the gate itself
doesn't flip in the tested surface. **Parallelization was attempted
and discarded** — the binary is multi-threaded and saturates the
Snapdragon cores; 2× concurrent processes yielded ~6–10× per-process
slowdown. The asym ≤ −3 third regime question: Coh compression is
smooth and monotone; an emerging mid-cluster at asym ∈ {−3.5, −4}
is suggestive but not robust at N=7-10 per cell. Phase W3 (p(HIGH)
parameter dependence) is the final running experiment. W4 (public
repo staging) is in progress. Resilience step: the on-device W3 script
survives ADB disconnect; a w3_resume.sh script is staged on device that
skips already-complete sessions if a restart is needed.

Operational learning: the single biggest operational discovery was
**that parallelization does not help on this binary** — contrary to
default operator intuition. This is important for future sessions:
serial N=5 is faster than "parallel N=5 / 2".

## Session 7 (closeout — substrate null, cross-control, first positive learning)

Session 7 rebuilt the receipt harness from scratch, added a NIST-KAT
trust chain, and fixed a `duration_ns` overflow in the harness. PRD v2
closed with six promoted claims and one visible weakening. The first
new front-door result is the project's first receipted positive learning
line: `exp_k2_scars` LEARNS-STRONG at `--steps 20`, then overfits at
`--steps 50`. The second is a dynamics-layer substrate null across six
arms and 665 total harmonic episodes: S2H baseline, S7 cold, S7 hot,
S8 battery, S8 bypass, and S5 basin volume all overlap the Session 5
baseline envelope. The third is gate-surface sharpening: the smoke
surface is fingerprinted at canonical SHA `9006df4ec02c8872...`, the
2×2 R1/R2 cross-control is closed, the combined `RA+v2+steps=50`
receipt flips R1 and R2 together with higher transfer ratio, and the
old "R3 payload moves with steps" line is weakened because
`operational_steps` saturates at 10.

## Session 8 Phase A (K2 curve, scoped zero, receipt-backed promotion)

Session 8 reopened under a pure-scientific-learning frame rather than a
commercial one. Phase A closed after 23h 40min wall-clock. The local
mirror now contains 52 per-run receipt/log pairs across A.1 robustness,
A.2 overfit boundary, A.3 cross-graph, and A.4 cross-dataset; the final
report and summary files use 55 total-run accounting, so the count seam
is explicit. `exp_k2_scars` is deterministic on promoted KPI values
within fixed configs, the steps curve peaks at 30/40 rather than 20, the
45 -> 50 overfit cliff is sharp, the
`xnor_train/mini/test` datasets are invariant at the μ baseline, and
`RA+v2+steps=20` gives the first Phase-A zero-learning datum. It also
records two governance facts: airplane mode was OFF for 40 reported
receipts, and the thermal gate was patched to CPU/GPU-only sensors after
a PMIC-lag halt. The initial repo integration promoted `ξ` and `ο`,
recorded `π`, `ρ`, and coarse `σ` as candidates, and kept the
count/accounting seam visible; the next A5/B3/A6 entry supersedes the
coarse `σ` wording before promotion.

## Session 8 A5/B3/A6 (finer K2 map, task audit, tau promotion)

The follow-on A5/B3/A6 chain closed 57 additional local per-run
receipts over 24h15m. A5/A6 killed the earlier active curve wording
before it could harden into a public claim: the coarse 30/40 `σ` draft
and the interim bimodal `σ′` draft are both rejected-before-promoted.
The replacement candidate `σ″` is a trimodal sawtooth on the scoped
baseline `exp_k2_scars` surface, with local maxima at `s33=1.873756`,
`s41=1.708374`, and `s49=1.819397`, sharp drops after s33 and s41,
and the final `s49 -> s50` collapse to zero. B3 audited all twelve
tasks at `--steps 1` versus `20`: nine respond, while `resonance_r3`,
`resonance_v2`, and `exp_i2` are scoped decorative candidates. The
audit also refined κ without hiding the seam: K3 sensor strength /
threshold invariance survives, but `--steps` changes baseline and gap
values, with reduction around 75.0% at steps=1 and 79.4% at steps=20.
The independent τ lane is promoted: RM10 native Android and Apple M1
Android ARM64 emulator match all 10 tested `exp_k2_scars` KPI floats.

---

## What carries forward during Session 8

- `S9` freq-locked remains the sole documented PRD gap and still needs
  root or an equivalent governor-control route.
- `exp_k2_scars` remains the most valuable positive line to characterize
  more deeply; after A5/A6 the active shape candidate is `σ″` trimodal
  sawtooth, not the old 30/40 or bimodal wording.
- The immediate repo-side residue is the original Phase A 55 total-run
  accounting versus 52 local per-run receipt/log pairs, plus candidate
  scoping for `σ″` and `φ`, not missing local A5/B3/A6 receipts.
- The `exp_r1_r4_campaign` gate surface remains the primary structural
  diagnostic object on the binary.
- The next high-value scientific edge is still the adjacency boundary
  that moves `r1.margin` from `0.0` to `0.5`.
- Three regimes (`RegimeA`, `RegimeB`, `RegimeCChaosControl`) are still
  named in the binary, but `RegimeC` has no exposed entrypoint.
- Intra-episode telemetry for dynamical tasks is still blocked at the
  binary level (see `BINARY_TELEMETRY_REQUEST.md`).
- The repo front door now carries Session 7 closeout plus Session 8
  Phase A/A5/B3/A6 and τ, while keeping the gate-layer directory-name
  mismatch, the Phase A count seam, and the κ B3 nuance visible instead
  of narrating past them.

Kill criteria and scope fences remain non-negotiable. See AGENTS.md.
