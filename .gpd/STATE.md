# Research State

## Project Reference

See: .gpd/PROJECT.md

**Core research question:** What kind of computational object is the 3D Double Meru under surviving evidence, and can that object be reconstructed, falsified, and compared across Mac host and RM10 witness lanes without promoting unrecovered hybrid source into authority?
**Current focus:** Session 4 complete (all 8 phases). The 3D Double Meru is characterized as a bistable relaxation computer (380v × 192 features = 72,960-dim state space) with ONE confirmed order parameter (asymmetry), RNG-dominated basin selection, and one dynamical family across task types. Per-step telemetry and hidden task exploration are Session 5 priorities.

## Current Position

**Current Phase:** Session 6 Gate-Flip Campaign + Invariance Confirmation + Public Repo Staging
**Current Phase Name:** W0, W1, W2, W3, W4 (Session 6 PRD fully delivered)
**Total Phases:** 16 planned (H-W4), 16 completed (H,I,J,K,L,M,N,O,P1b,P2a,P2b,P3,W0,W1,W2,W3,W4)
**Current Plan:** Session 6 complete; public repo staged
**Total Plans in Phase:** 5 (W0 vocab, W1 gate flips, W2 third regime, W3 p(HIGH), W4 staging)
**Status:** Complete (Session 6) — go-live-ready for Monday operator call
**Last Activity:** 2026-04-18
**Last Activity Description:** Session 6 ran four phases (W0, W1, W2, W3) + W4 repo staging across 14h 33m wallclock (2026-04-17T23:08Z → 2026-04-18T13:41Z). Phase W0 doubled the accepted task-name inventory from 5 to 12 (new: exp_i1, exp_i2, exp_h1_h2, exp_k2_scars, exp_k3_truth_sensor, resonance_r3, resonance_v2). Phase W1 identified two reproducible gate flips in exp_r1_r4_campaign: R1 flips FAIL→PASS with --adj RandomAdj_v1.bin (r1.margin 0.0→0.5), and R2 flips FAIL→PASS with --tags RegionTags_v2.bin (claim_level advances CL-0→CL-1). R3 is payload-moving along --steps (r3.k2_uplift 4× at steps=20) but gate stays false. 4 canonical SHA-256 equivalence classes catalogued. Phase W2 characterized asym ≤ -3 regime as W2-CONTINUOUS with emerging mid-cluster at asym ∈ {-3.5, -4}; harmonic Coh compresses monotonically from 0.88 → 0.66 as asym goes 0 → -5. Phase W3 (3 arms × N=100 = 300 harmonic eps) verdict W3-INVARIANT: Arm 0 p(HIGH)=34%, Arm A (+0.2)=42%, Arm B (-0.2)=32%, all CIs overlap. Weak monotone trend kept as Session 7 seed. Phase W4 staged public repo (11 files + 85-artifact SHA-256 manifest). Parallel execution tested and DISCARDED — binary is multi-threaded and saturates Snapdragon cores; 2× parallel yields ~6-10× per-process slowdown. Go-live-ready per PRD §10 minimum-bar criteria.

**Progress:** [██████████] 100%

## Active Hypothesis

**Branch:** hypothesis/rm10-primary-platform-heterogeneous-learning
**Description:** Engineer the Red Magic 10 Pro into the primary DM3 research instrument and treat heterogeneous CPU/GPU/NPU execution as an early first-class learning path.
**Parent:** main

This is a hypothesis branch investigating whether RM10-primary engineering and
early heterogeneous execution produce a stronger learning surface than the
main-line launcher-adjacency-first continuation. Compare results with the
parent branch via `$gpd-compare-branches`.

## Active Calculations

- No active long-running computation at the moment.
- The last governed executions were Mac Genesis `G-01` and `G-02`, Mac October smoke,
  RM10 SoC-runtime `G-01`, and an RM10 raw-workspace Genesis micro run.

## Intermediate Results

- The manifesto now lives inside the restart repo at `docs/reference/GEOMETRY_FIRST_MANIFESTO.md`.
- The recoverable October SNIC substrate compiles and passes its current Rust tests on the Mac host.
- The Genesis lineage contains a real deterministic testing protocol, but not a clean one-to-one `T01–T236` registry.
- Fresh Mac Genesis `G-01` and `G-02` are internally stable at `verify = e894...` and `solve = 62897...`.
- The documented Genesis `verify.json` canonical is stale against the fresh Mac and historical RM10 parity surface.
- Fresh RM10 replay now works over ADB shell from `/data/local/tmp`, but the default device validator still rejects both fresh device bundles.
- The phone carries two old-work surfaces: a governed SoC runtime lane and a later DM3 hybrid prototype residue with mixed signal.
- A fresh `dual_cli` probe re-established the source-backed Double Meru geometry on `2026-04-03`.
- The strongest surviving hybrid-specific story is now boundary-plus-nodewise continuation with scar-memory augmentation.
- Runtime truth is now split explicitly between geometry witness, governed baseline, smoke-only hybrid callability, inspectable residue, and blocked non-stub recovery.
- Phase `01.2.2` fixed the one bounded hybrid target to the bundled RM10 runner plus `SriYantraAdj_v1.bin` and `RegionTags_v2.json`.
- The official bundled `exp_g2_readout` inference attempt collapsed exactly to the smoke canonical `d3e721...`.
- Phase `01.2.3` exhausted and retired the preserved bundled `G2` same-binary surface on the current callable binary as `phase_outcome=PASS` and `route_outcome=FAIL`.
- Witness-floor governance is now frozen around the Mac / historical RM10 parity lane plus an explicit-hash interim rule for fresh RM10 lanes.
- Phase `01.2.3.1` wrote the full RM10-primary internal pack, history indexes, device dossier, runbooks, battery matrices, and a merged 10-document branch briefing pack.
- A fresh RM10 CPU control pass on `2026-04-05` completed under `/data/local/tmp/SoC_runtime/workspace` with `verify.json = f992e9c8...` and `solve_h2.json = a33c5cc4...`.
- The branch now distinguishes two RM10 result families: governed Genesis CPU control on `F1` and bundled-residue harmonic CPU-vs-GPU feasibility on `F2`.
- The bounded `dm3_runner` harmonic compare produced same-schema one-episode CPU and GPU-backed receipts on-device, while NPU and explicit heterogeneous role-partition claims remain `ABSTAIN`.
- Phase `01.2.3.2` refreshed the governed `F1` anchor exactly, proved the live governed bridge is closed on the current `genesis_cli` surface, fenced `F2` as a separate residue line with `unstable_feasibility`, and preserved NPU plus explicit heterogeneous work at `ABSTAIN`.
- The retained `01.2.3.4` validator probe on the historical RM10 parity witness now shows `default_exit=1` and `explicit_exit=0`, which localizes the live device validator gap to a stale compiled default pair rather than bundle corruption.
- The retained `01.2.3.4` `F2` surface probe now shows that the top-level `/data/local/tmp/dm3_runner` root family is callable on its own surface and that `RegionTags_v1.bin` clears the cleanroom startup gate when the other retained assets are present.
- The legacy `/data/local/tmp/dm3/dm3_runner` remains callable as a separate residue control surface, but it cannot substitute for the top-level root family.
- The official same-family `F2` outlier entrypoint now runs on the top-level root family and returns `whole_session_instability` instead of a blocked boundary.
- The first narrow heterogeneous decision is now a retained explicit `ABSTAIN` packet because no preserved same-family observable survives the unstable outlier session honestly.
- The retained `01.2.3.4.1` validator packet now proves the live device default path still compares against a stale compiled `verify` constant `97bd...` while the surviving retained witness and active recovery payloads are `e894...`.
- The retained `01.2.3.4.1` top-level same-family packet now proves the callable root family itself splits between a low default CPU cluster and a high explicit-assets / `RegionTags_v1` cluster, while `/data/local/tmp/PhonemePatterns_v1.bin` is absent from the retained identity packet.
- The retained `01.2.3.4.1` official same-family rerun now sharpens the same-family defect to low `cpu_a`, high `gpu_a`, low `gpu_b`, then a timed-out `cpu_b` that leaves only a zero-byte output path under the current `180` second ceiling.
- The retained `01.2.3.4.1` heterogeneous micro packet is an explicit abstain packet because the fresh same-family rerun did not preserve a governed observable and therefore did not reopen any admissible split boundary.
- Phase `01.2.3.4.1.1.3` established one explicit top-level same-family chamber environment and preserved a two-window CPU-forced versus GPU-backed smoke packet on `/data/local/tmp/dm3_runner`.
- Phase `01.2.3.4.1.1.3` then widened the same-family chamber packet to four windows and observed collapse into signal exits plus missing or zero-byte receipts before any honest chamber-behavior verdict survived.
- Phase `01.2.3.4.1.1.3` corrected an NPU-path probe false positive and retained the NPU route as `ABSTAIN / inventory_only`.
- Phase `01.2.3.4.1.1.3` retained one narrow engineering result, `boundary_sensitivity_without_persistence`, and closed with `continue environment engineering` as the only justified next move.
- Phase `01.2.3.4.1.1.3.1.2` retained a full four-row confirmation packet under the same stronger envelope, but classified it as `whole_session_instability` rather than a reproducible repair.
- Phase `01.2.3.4.1.1.3.1.2.1` retained a bounded `cpu_a,gpu_a,cpu_b` localization packet that started low at row `cpu_a`, which rejected third-row-only and `gpu_b`-required explanations for the live instability.
- Phase `01.2.3.4.1.1.3.1.2.2` ran 7 single-row `cpu_a` anchors under deep-clean cold, shallow-clean, no-clean, and deep-clean short-idle conditions: ruled out file cleanup, idle duration, and thermal state as regime selectors; narrowed the regime to internal RNG seeding interacting with a bistable harmonic training landscape; found the regime is biased by binary page cache warmth (~80% HIGH after recent runs, reliable LOW after extended idle); and wrote a gated retry rule for the full confirmation replay. The FAST session (~155s) from the repaired packet was NOT reproduced in any of 7 anchors.
- Session 3 (`2026-04-16`) executed the DM3 Multi-Hypothesis Long-Horizon PRD: Phase A (offline spectral analysis) classified the graph as C3-dominant (3-fold degeneracy in eigenvalue spectrum, PR=2/3 for all low modes, Fiedler vector does NOT separate the two cones). BINDU region is 39% of graph. Phase C (Hamiltonian mode, 10 runs + 11 interleaved LayerNorm controls) KILLED H2 — the bistability persists without the transformer at 20% HIGH rate (vs 62.5% with transformer). Basin values are identical in both modes. Phase B (7 asymmetry values × 2 episodes) found asymmetry continuously shifts basin positions (asym=-1: E~68; asym=+1: E~95). Phase D (truth sensor, 4 configs × 2 episodes) found unidirectional LOW bias (12.5% HIGH vs baseline ~60%). Phase E discovered holography task has a third attractor (E~14, Coh~0.73, Retry), inference mode is a stub (always returns T1 Contraction canonical receipt regardless of parameters), and basin selection is per-episode not per-session. Phase F (4 rotations + 3 frequencies + gated) found freq=1.0 gives 2/2 HIGH (strongest attractor), and rot=120° (C3 generator) is the only rotation preserving any HIGH occupation.
- Session 4 (`2026-04-16` → `2026-04-17`) ran the Sculptor's Scalpel PRD: Phase H killed 5 of 7 Session-3 suggestive findings at N=5 and promoted 2 (asymmetry, holography third attractor). Phase I characterized --freq as noise-dominated with no resonance peak. Phase J classified holography as same dynamical family as harmonic at lower E scale via asymmetry-response match. Phase K found asymmetry smoothly shifts basin positions but basin selection is noise-dominated in the central range. Phase L found rot=60°×asym=+0.5 gave 3/5 HIGH (suggested C3-asymmetric coupling). Phase M retired --angle as non-functional. Phase N.2 binary strings scan revealed internal architecture (R0/R1/R2 learning rules, 192 features, OntologyInjector) and hidden task candidates.
- Session 5 (`2026-04-17`) executed the hidden-tasks / basin-boundary / E-scale PRD. Phase O + P1b/P1b2 found 3 real hidden tasks (interference, holographic_memory, exp_r1_r4_campaign with 6-gate self-evaluation). Phase P2a (N=100) confirmed basin selection is IID Bernoulli p(HIGH)=0.34; no session lock, no drift. Phase P2b WEAKENED Phase-L C3 claim: at N=10 pooled, rot=60° and rot=120° at asym=+0.5 are indistinguishable (Fisher p=0.65); only rot=0° robustly suppresses HIGH (0/10). Phase P3 showed harmonic stays bistable to asym=±5 with linear E shift (~6 E/asym-unit); holography stays monostable Retry with E=11.3+5.1×asym; harmonic/holography E gap constant ~60 units across asym, so the two regimes never merge. Discovered new edge-regime: harmonic basin Coh signatures compress below 0.82 at asym ≤ -3, making the Session-4 locked classifier invalid in that regime.

## Open Questions

- Does the historical bundled `G2` residue belong to a neighboring launcher generation, or would recovering it now require explicit redevelopment?
- Which exact baked-in default target or default-selection rule is still active on the live device validator?
- Can the current RM10 ADB-shell replay surface be promoted from a prebuilt-stub lane to a true source-build parity lane?
- The regime selector is narrowed to internal RNG seeding, but can the seed be controlled without source modification, or should the branch accept bistability as a system property?
- Why was the FAST session (~155s duration) seen in the repaired packet never reproduced in any of 7 anchors at ~200s?
- Can the top-level `/data/local/tmp/dm3_runner` family be stabilized enough to preserve one same-family observable without silently substituting the legacy `/data/local/tmp/dm3/dm3_runner` surface?
- Which exact validator-default repair or operator-policy route should replace the stale compiled device pair on live governed RM10 work?

## Performance Metrics

| Label | Duration | Tasks | Files |
| ----- | -------- | ----- | ----- |
| Mac Genesis `G-02` | local | 5 repeated runs | `artifacts/mac_replay/genesis_g02_20260403/*` |
| RM10 SoC-runtime `G-01` | local | 1 run | `artifacts/rm10_replay/soc_runtime_g01_20260403/*` |
| Bundled RM10 `G2` bounded attempt | local micro-battery | 1 run | `artifacts/phase_01_2_2_non_stub_attempt_20260403/*` |
| Bundled residue harmonic CPU-vs-GPU compare | local bounded feasibility | 2 runs | `artifacts/phase_01_2_3_1_dm3_harmonic_train_compare_20260405/*` |
| Governed `F1` anchor refresh | local serious run | 1 run | `artifacts/phase_01_2_3_2_f1_anchor_20260405/*` |
| Bundled-residue `F2` repeat matrix | local bounded feasibility | 4 runs | `artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/*` |
| NPU or DSP triage | local setup probe | 1 bounded probe | `artifacts/phase_01_2_3_2_npu_triage_20260405/*` |
| RM10 validator-default probe | local engineering readiness | 2 bounded checks | `artifacts/rm10_validator_probe_20260405T170530Z/*` |
| RM10 `F2` root-surface probe | local engineering readiness | 5 bounded scenarios | `artifacts/rm10_f2_surface_probe_20260405T170543Z/*` |
| Official same-family `F2` outlier packet | local engineering readiness | 4-row CPU/GPU/GPU/CPU bracket | `artifacts/rm10_f2_outlier_20260405T171018Z/*` |
| Narrow heterogeneous abstain packet | local engineering readiness | 1 retained abstain decision | `artifacts/phase_01_2_3_4_narrow_heterogeneous_20260405T172724Z/*` |

## Accumulated Context

### Decisions

- [Phase —]: Start from scratch in the restart repo and treat the manifesto as a claim inventory, not proof.
- [Phase —]: Keep the recoverable October / Genesis substrate as the only source-backed baseline.
- [Phase —]: Use Mac and RM10 Pro as execution lanes, with receipts and Comet metadata.
- [Phase 01]: Switch restart research mode to explore — Phase 1 needs explicit branching, pivot analysis, and alternative-hypothesis investigation across battery classes and device lanes.
- [Phase 01]: Use `/data/local/tmp` as the canonical ADB-shell execution surface and treat shared storage as ingress only.
- [Phase 01]: Treat fresh phone executability and phone acceptance as separate gates; the current blocker is validator governance, not device reachability.
- [Phase 01.1]: Inserted Phase 01.1 after Phase 01: DM3 Hybrid Archaeology and Recovery (URGENT) — Urgent bounded recovery work is needed to separate real hybrid residue from folklore before broader restart execution decisions are made.
- [Phase 01.1]: Closed Phase 01.1 with a split hybrid verdict: real late DM3 residue, bounded host executability, no governed hybrid parity yet — Phase 01.1 recovered the architecture and proved a bounded receipt-producing host surface, but the work also showed task collapse, missing late-hybrid source/assets, and live RM10 transport loss. The honest next move is a bounded GPU engineering phase, not a rebuild or pass narrative.
- [Phase 01.1]: Closed Phase 01.1: late DM3 hybrid line is real and architecturally legible, but only a smoke-level compiled host lane is runnable now; substantive hybrid recovery needs a bounded rebuild phase. — Current evidence splits governed Genesis from the later hybrid prototype, proves real GPU/microtx/scar/HRM residue, shows inference-mode host smoke receipts surviving, and shows train-mode substantive tasks remaining asset-blocked.
- [Phase 01.2]: Inserted Phase 01.2 after Phase 01: Long-Horizon Recovery Bootstrap and Governance (URGENT) — The long-horizon mandate requires custody, governance, runbooks, lane policy, and bounded engineering control work before formal Phase 02 baseline replay continues.
- [Phase 01.2]: Inserted Phase 01.2 after Phase 01: Long-Horizon Recovery Bootstrap and Governance (URGENT) — The long-horizon mandate requires custody, governance, runbooks, lane policy, and bounded engineering control work before formal Phase 02 baseline replay continues.
- [Phase 01.2]: Closed Phase 01.2: long-horizon custody, governance, runbooks, and fresh RM10 preflight are now frozen into a canonical bootstrap pack. — The long-horizon mandate required a bounded control-phase before broader Phase 02 replay and repair work. The new pack locks evidence custody, gate A/B verdicts, lane policy, pairing boundaries, and blocker-driven next steps without widening hybrid authority.
- [Phase 01.2]: Closed Phase 01.2 with a governed long-horizon bootstrap package — Phase 01.2 established custody, refreshed doctrine and runbooks from current evidence, captured live RM10 launch-proof receipts, wrote Gates A-E, and narrowed the next move to canonical governance plus RM10 source-parity repair before deeper hybrid recovery.
- [Phase 01.2.1]: Reframed Phase 01.2.1 after Phase 01.2: Double Meru Scientific Reconstruction And Hybrid Fidelity — The corrected mandate makes the 3D Double Meru the primary object of inquiry, so hybrid pairing and non-stub recovery now sit underneath a geometry-first reconstruction and fidelity-classification phase rather than defining the phase by themselves.
- [Phase 01.2.1]: Closed Phase 01.2.1 with a governed Double-Meru-first reconstruction package — The phase re-probed the source-backed geometry, classified the late hybrid line by fidelity rather than convenience, split runtime truth from contamination, and narrowed the next move to one bounded non-stub recovery attempt plus witness-lane repair.
- [Phase 01.2.2]: Closed Phase 01.2.2 with a bounded bundled `G2` attempt and witness-floor repair — The phase selected the strongest surviving bundled target, froze the Genesis witness-floor split, proved that the official explicit `exp_g2_readout` attempt still collapses exactly to smoke, and narrowed the blocker to invocation-surface recovery rather than generic pairing doubt.
- [Phase 01.2.3]: Inserted Phase 01.2.3 after Phase 01.2.2: G2 Invocation-Surface Archaeology And Router Recovery — The next honest move is a bounded router / wrapper / mode-surface archaeology phase on the bundled runner, not GPU escalation or rebuild theatre.
- [Phase 01.2.3]: Closed Phase 01.2.3 with exact same-binary retirement of the bundled `G2` family — The phase exhausted the surviving same-binary route surface, froze the result as `phase_outcome=PASS` and `route_outcome=FAIL`, and moved the blocker from route hunting to launcher-adjacency provenance or explicit redevelopment.
- [Phase 01.2.3]: Created hypothesis branch: Engineer the Red Magic 10 Pro into the primary DM3 research instrument and treat heterogeneous CPU/GPU/NPU execution as an early first-class learning path — Investigating an RM10-primary, heterogeneity-early alternative programme on branch hypothesis/rm10-primary-platform-heterogeneous-learning
- [Phase 01.2.3.1]: Inserted Phase 01.2.3.1 after Phase 01.2.3: RM10 Primary-Platform Engineering, History Mining, And Heterogeneous Battery Bootstrap (URGENT) — Urgent branch work is needed to test the RM10-primary and heterogeneity-early hypothesis before rejoining the mainline sequence
- [Phase 01.2.3.1]: Closed Phase 01.2.3.1 with a complete RM10-primary branch bootstrap and first-pass device verdicts — The branch now has its full internal pack, history indexes, RM10 runbooks, a receipted CPU control pass, and explicit GPU/NPU/heterogeneous abstain outcomes plus a merged 10-document science-and-engineering pack.
- [Phase 01.2.3.1]: Supplemented Phase 01.2.3.1 with a bounded bundled-residue CPU-vs-GPU feasibility family — The branch now separates the governed Genesis CPU control family from a lower-ceiling `dm3_runner` harmonic compare, records GPU-backed callability without promoting it into primary-lane authority, and keeps NPU plus explicit heterogeneous role partition at abstain.
- [Phase 01.2.3.2]: Inserted Phase 01.2.3.2 after Phase 01.2.3.1: RM10 Family-Bridge, Accelerator Qualification, And Heterogeneous Handoff Decision — The next honest move after the branch bootstrap was to decide whether the residue accelerator family actually bridged to the governed Genesis family or remained separate.
- [Phase 01.2.3.2]: Closed Phase 01.2.3.2 with explicit bridge closure and residue-family separation — The branch refreshed the governed `F1` anchor, proved the current live governed surface exposes no accelerator-bearing entrypoint, classified the residue `F2` accelerator line as callable but unstable, preserved NPU and explicit heterogeneous work at abstain, and shifted the next move toward real science batteries on `F1`.
- [Phase 01.2.3.3]: Inserted Phase 01.2.3.3 after Phase 01.2.3.2: RM10 Validator-Default Localization, F2 Root-Surface Repair, And Heterogeneous Brief Readiness — The next honest move after bridge closure was to localize stale validator-default behavior and repair the top-level `F2` root family before any official outlier packet or heterogeneous-compute brief.
- [Phase 01.2.3.3]: Closed Phase 01.2.3.3 with truthful readiness evidence and a blocked-safe official `F2` boundary — The phase localized the live default-validator failure to stale device-side default handling, localized the top-level `F2` root family to a missing ambient asset plus a post-resonance stall envelope, preserved the official `F2` outlier entrypoint as a governed `BLOCKED` packet, and returned a no-readiness verdict for an official heterogeneous-compute brief.
- [Phase 01.2.3.4]: Inserted Phase 01.2.3.4 after Phase 01.2.3.3: RM10 Validator Rule Repair, F2 Root Handoff, And Narrow Heterogeneous Probe — The next honest move is to repair or exactly pin down the live validator rule and the top-level `F2` root family, then only if those gates open run the official same-family `F2` handoff and one narrow heterogeneous split.
- [Phase 01.2.3.4.1]: Inserted Phase 01.2.3.4.1 after Phase 01.2.3.4: RM10 Validator-Default Rule, Same-Family F2 Instability, And Observable-Gated Replay (URGENT) — Urgent work discovered mid-project requiring immediate attention
- [Phase 01.2.3.4.1.1]: Inserted Phase 01.2.3.4.1.1 after Phase 01.2.3.4.1: RM10 Capability Discovery Reset, Drift Purge, And Property-First Battery (URGENT) — Urgent reset work is needed to purge drift, demote determinism to telemetry, and run capability-discovery batteries on the cleaned RM10 surface before any further validator-centered story.
- [Phase 01.2.3.4.1.1]: Planned Phase 01.2.3.4.1.1 as a six-battery capability-discovery reset — The branch now has an execution-ready rescue-pack, drift-purge, smoke-lattice, property-mapping, same-family handoff, lane-contrast, and falsifier plan stack that keeps authority claims fenced while discovery work proceeds.
- [Phase 01.2.3.4.1.1.1]: Inserted Phase 01.2.3.4.1.1.1 after Phase 01.2.3.4.1.1: RM10 Resonance-Chamber Heterogeneous Bring-Up And Geometric Computation (URGENT) — Urgent work discovered mid-project requiring immediate attention
- [Phase 01.2.3.4.1.1.2]: Inserted Phase 01.2.3.4.1.1.2 after Phase 01.2.3.4.1.1: RM10 Resonance-Chamber Heterogeneous Bring-Up And Geometric Organism Environment (URGENT) — User directed a new heterogeneity-first, resonance-oriented RM10 phase built from Training Doc #5 and requiring fresh research, PRD, planning, and execution.
- [Phase 01.2.3.4.1.1.3]: Inserted Phase 01.2.3.4.1.1.3 after Phase 01.2.3.4.1.1: RM10 Resonance-Chamber Heterogeneous Bootstrap And Geometric Computation Battery (URGENT) — Urgent work discovered mid-project requiring immediate attention
- [Phase 01.2.3.4.1.1.4]: Inserted Phase 01.2.3.4.1.1.4 after Phase 01.2.3.4.1.1: RM10 Resonance-Chamber Heterogeneous Bootstrap And Geometric Computation Probe (URGENT) — Urgent work discovered mid-project requiring immediate attention
- [Phase 01.2.3.4.1.1.3.1]: Closed Phase 01.2.3.4.1.1.3.1 with a retained full four-row same-family replay and repaired cpu_b closeout — The stronger replay envelope produced four real receipts on the top-level same-family surface, collapsing the old hard closing-row failure as the active live truth floor while leaving the repair mechanism unresolved.
- [Phase 01.2.3.4.1.1.3.1.1]: Closed Phase 01.2.3.4.1.1.3.1.1 with a physical-organism doctrine for DM3 branch work — The branch now has one converged artifact reading: geometry as body plan, dynamics as homeostatic medium, transformer-like machinery as boundary adapter by default, and the immediate same-family confirmation replay as the unchanged live empirical gate.
- [Phase 01.2.3.4.1.1.3.1.2]: Closed Phase 01.2.3.4.1.1.3.1.2 with a failed confirmation replay and a blocked homeostasis gate — The full same-family packet completed under the stronger envelope, but the repaired packet did not reproduce and instead split into whole-session instability.
- [Phase 01.2.3.4.1.1.3.1.2.1]: Closed Phase 01.2.3.4.1.1.3.1.2.1 with bounded regime localization — The bounded `cpu_a,gpu_a,cpu_b` packet entered the low regime from row 1, so the live blocker is now the entrance condition before the packet starts rather than a third-row-only trigger.
- [Phase 01.2.3.4.1.1.3.1.2.2]: Closed Phase 01.2.3.4.1.1.3.1.2.2 with entrance-condition narrowing — Ran 7 cpu_a anchors under controlled pre-run states, ruled out file cleanup, idle duration, and thermal state as regime selectors, narrowed to internal RNG seeding with page cache warmth bias, wrote gated retry rule for the full confirmation replay, and classified the phase as `entrance_condition_narrowed`.

### Active Approximations

None yet.

**Convention Lock:**

- Metric signature: not applicable
- Fourier convention: not applicable
- Natural units: dimensionless computational units unless protocol says otherwise
- Gauge choice: not set
- Regularization scheme: not applicable
- Renormalization scheme: not applicable
- Coordinate system: graph / lattice coordinates with explicit boundary and bulk labeling
- Spin basis: not applicable
- State normalization: not set
- Coupling convention: restart-specific and source-backed only
- Index positioning: graph / node indices only unless explicitly derived later
- Time ordering: discrete iteration index
- Commutation convention: not applicable
- Levi-Civita sign: not applicable
- Generator normalization: not applicable
- Covariant derivative sign: not applicable
- Gamma matrix convention: not applicable
- Creation/annihilation order: not applicable

### Propagated Uncertainties

None yet.

### Pending Todos

- Follow the gated retry rule from `RM10_ENTRANCE_CONDITION_RETRY_RULE.md` to attempt the full four-row confirmation replay: warm-up throwaway, classification anchor, proceed only if HIGH regime.
- Keep chamber science and homeostasis blocked until the entrance condition is localized and a full same-family confirmation replay reproduces honestly.
- Keep NPU assist at `ABSTAIN / inventory_only` until a callable device entrypoint exists with retained receipts.
- Keep explicit heterogeneous role partition at `ABSTAIN` until one preserved same-family observable survives widening honestly.
- Repair or operator-policy-route the stale compiled validator-default pair on the live `genesis_cli` surface so governed `F1` work can rejoin cleanly.

### Blockers/Concerns

- The manifesto numbering `T01–T236` is not yet a source-backed executable registry.
- The newer hybrid DM3 source remains missing.
- The current phone `genesis_cli` default validator still rejects the historical Mac-parity witness under default handling.
- The fresh phone lanes currently depend on prebuilt device binaries and a cargo stub.
- The top-level same-family `/data/local/tmp/dm3_runner` regime is bistable (HIGH ~57%, LOW ~43%) and driven by internal RNG seeding biased by page cache warmth. A gated warm-up + classification retry protocol exists but does not guarantee deterministic regime control.
- The legacy `/data/local/tmp/dm3/dm3_runner` is callable, but it is a separate surface and cannot be silently substituted for the top-level root family.
- No callable NPU assist path exists yet beyond inventory-only residue.
- No stable preserved same-family observable exists yet for a heterogeneous role-partition claim.

## Session Continuity

**Last session:** 2026-04-18T13:41:46Z (W3 complete; W4 staged)
**Stopped at:** Session 6 delivered all four PRD priorities W0/W1/W2/W3 plus W4 public-repo staging. Two gate flips identified: R1 via --adj RandomAdj_v1.bin, R2 via --tags RegionTags_v2.bin (+ claim_level CL-0→CL-1). R3 payload-moving via --steps but gate unchanged. p(HIGH) invariant at |asym|≤0.2 (N=300). Task inventory doubled to 12. asym≤-3 regime characterized as continuous with emerging mid-cluster. Parallelization tested and discarded. Public repo staged in repo_stage/ with 85-artifact SHA-256 manifest. Monday go-live decision handed to operator.
**Resume file:** docs/restart/DM3_SESSION6_FINAL_REPORT.md
**Session 7 handover:** docs/restart/NEXT_BOUNDED_ENGINEERING_MOVE.md
**Key artifacts:** artifacts/phase_W0_vocabulary_20260417T230843Z/, artifacts/phase_W1_gate_flip_20260418T000305Z/, artifacts/phase_W2_third_regime_20260418T031800Z/, artifacts/phase_W3_p_high_20260418T053010Z/, repo_stage/
