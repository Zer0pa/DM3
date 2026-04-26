# Agent Handover — Session 4 End

Written: `2026-04-17`
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Execution host: Mac (RM10 Pro via ADB, device reconnected after gap-fill)

## For the Session 5 Agent

Session 4 ran all 8 planned phases (H-O) to completion, including gap-fill runs after device reconnect. The characterization is materially sharper than Session 3. Here's what you need to know.

## Device Status

**The RM10 Pro was reconnected** after battery drain during the main session. Gap-fill runs (Phase L cells, Phase M angle sweep, Phase N.1 schema probes) completed successfully. Device is available for Session 5 work. Verify with `adb devices` and binary hash before starting.

## What Session 4 Established (Solid, N≥5)

1. **Geometry is sovereign (strengthened).** HAM and LN both give 20% HIGH at N=5. The transformer has NO measurable effect on basin selection. Not even a 3x bias.

2. **Asymmetry is the ONLY confirmed order parameter.** It smoothly shifts basin E values: LOW from 69 (asym=-1) to 77 (asym=+0.3); HIGH from 87 to 91. Slope ~6 E/asym-unit in both basins.

3. **Basin SELECTION is RNG-dominated.** Within asym ∈ [-0.3, +0.3], HIGH rate bounces 0-60% with no systematic trend. No sharp critical point. External parameters don't deterministically control selection.

4. **Holography is the same dynamical family as harmonic.** Not a separate object. Same asymmetry response, different energy scale (E≈15 vs E≈75-89). The --task flag sets the operating point.

5. **freq has no resonance structure.** 10-point sweep shows noise-dominated selection. freq=1.0 is a DIP (20%), not a peak. Basin VALUES are freq-independent.

6. **Rotation has weak boundary-localized coupling with asymmetry.** rot=60° at asym=+0.5 can push episodes across the HIGH boundary. Away from this boundary, rotation has no effect.

## What Session 4 Killed

- freq=1.0 → 100% HIGH (was N=2 noise)
- rot=120° preserves bistability (was N=2 noise)
- Truth sensor suppresses HIGH (was N=2 noise)
- Transformer 3x HIGH bias (was N=2 noise)

## What Was Completed in Gap-Fill

- **Phase M (--angle)**: 7 values × 3 eps = 21 episodes. Verdict: NON-FUNCTIONAL, retired from parameter space. No systematic trend (9/21 = 43% HIGH).
- **Phase L gaps**: rot=120 × asym={0, +0.5} completed. rot=120 at asym=+0.5 gave 1/5 HIGH vs rot=60's 3/5 — coupling is NOT C3-symmetric.
- **Phase N.1**: autobrake, dataset-size, calibration probes all produced standard 6-field receipts. Per-step telemetry confirmed blocked.

All Session 4 gaps are now filled.

## Internal Architecture (from Phase N.2 binary scan)

- Feature dim: 192. State space: 380 × 192 = 72,960 floats.
- Learning rules: R0 Random, R1 Oja, R2 Contrastive.
- State update: `x_{t+1} = x_t + dt·(f(x_t) - x_t)` (relaxation dynamic).
- Graph organized into sectors and rings via OntologyInjector.
- EBM calibration + XNOR sampling.
- Hidden tasks: interference, holographic_memory, K1 pattern ontology, G2 boundary readout, exp_r1_r4_campaign.
- Holography = boundary-to-bulk mapping.
- Per-step telemetry: NOT available. Source request at `docs/restart/BINARY_TELEMETRY_REQUEST.md`.

## Session 5 Priorities

1. **Probe hidden tasks** (`--task interference`, etc.). Are they accessible?
3. **Per-step telemetry** (if source modified). See request doc.
4. **Basin boundary exploration** — the central remaining mystery. Can targeted initial conditions probe the separatrix?
5. **E-scale relationship between tasks** — is there a continuous path from holography (E≈15) to harmonic (E≈75)?

## Binary Facts

- Path: `/data/local/tmp/dm3_runner`
- Hash: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- Size: 9,554,600 bytes
- Typical episode: ~195s (steady state), ~60s (cache-warm)
- Receipt schema: `{asymmetry, coherence, decision, delta_E, duration_ms, episode}`

## Hard Don'ts (unchanged from Session 4)

- Do NOT reopen H2
- Do NOT try to control RNG seed (source-blocked)
- Do NOT chase the FAST session (~155s)
- Do NOT touch NPU or heterogeneous
- Do NOT promote inference mode as live
- Do NOT cite T01-T236 as operational predictions

## Artifact Locations

All under `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/`:
- `phase_H_statistical_replication_20260416T143544Z/` (70 eps)
- `phase_I_frequency_20260416T161725Z/` (75 eps)
- `phase_J_holography_20260416T203947Z/` (45 eps)
- `phase_K_asymmetry_fine_20260417T013126Z/` (65 eps)
- `phase_L_coupling_20260417T051706Z/` (45 eps, 9/9 cells complete)
- `phase_N_telemetry_20260417T095000Z/` (binary scan + schema probes)
- `phase_M_summary.json` (21 eps, --angle retired)
- `phase_*_summary.json` for each completed phase
- `classify_basins.py` and `phase_runner.sh` — reusable tools
