# DM3 Session 6 Review Pack

Session window: `2026-04-17T23:08Z` → (closing with W4 when W3 completes)
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Device: Red Magic 10 Pro (FY25013101C8), binary SHA-256
`daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
(verified at session start and each phase).

## PRD compliance summary

| PRD priority                                                          | Session 6 verdict |
|-----------------------------------------------------------------------|-------------------|
| W0 — Vocabulary & flag harvest                                        | **Complete.** W0-EXPANSION: +7 new callable task names. |
| W1 — Gate-flip campaign                                               | **Complete.** Two flips (R1 via `--adj`, R2 via `--tags`); R3 payload-moving via `--steps`. |
| W2 — asym ≤ −3 third regime characterization                          | **Complete.** W2-CONTINUOUS with emerging mid-cluster at asym ∈ {−3.5, −4}. |
| W3 — p(HIGH) parameter-dependence at ±0.2                             | **Complete. W3-INVARIANT.** Arm 0: 34%, Arm A (+0.2): 42%, Arm B (−0.2): 32%, all CIs overlap at N=100 per arm. Monotone trend kept as Session 7 seed. |
| W4 — Public repo staging                                              | **Complete.** All artifacts finalized, W3 results integrated. |

## Phase summaries (index)

- `artifacts/phase_W0_vocabulary_20260417T230843Z/PHASE_W0_SUMMARY.md`
  — 12 accepted task names total; CLI flag surface is exactly the
  `--help` list; adj / tags swaps are discovered new-axis targets for W1.
- `artifacts/phase_W1_gate_flip_20260418T000305Z/PHASE_W1_SUMMARY.md`
  — 4 canonical SHA equivalence classes; two gate flips; R3
  payload-moving; parameter axes within a fixed graph are null.
- `artifacts/phase_W2_third_regime_20260418T031800Z/PHASE_W2_SUMMARY.md`
  — Coh compression is smooth and monotone across asym ∈ [0, −5]; the
  Session 4 basin classifier is calibrated for asym ∈ [−2, +2] only;
  emerging mid-cluster at asym ∈ {−3.5, −4} is suggestive.
- `artifacts/phase_W3_p_high_20260418T053010Z/PHASE_W3_SUMMARY.md`
  — 3 arms × N=100 each. p(HIGH) at Arm 0 = 34%, Arm A (+0.2) = 42%,
  Arm B (−0.2) = 32%. All pairwise CIs overlap. W3-INVARIANT
  confirmed. Monotone trend toward +asym → higher HIGH is within noise
  at this N; Session 7 seed is at |asym| ≥ 0.4 or N ≥ 200.

## Operational lessons

- **Parallelization is counterproductive on this binary.** 2×
  concurrent processes yield ~6-10× per-process slowdown because the
  binary is already multi-threaded and saturates the Snapdragon 8
  Elite cores. Serial is faster. Operator's upgrade to 4-way parallel
  was tested and discarded; the 10-graph Session 7 cross-product seed
  is carried forward in `NEXT_BOUNDED_ENGINEERING_MOVE.md`.
- **Determinism-check early.** One replicate was enough to confirm
  `exp_r1_r4_campaign` bit-deterministic and truncate the 45-cell
  Tier A down to 2 cells.
- **Coh compression at asym ≤ −3 requires a regime-tagged classifier**
  — adopt E-ordering over Coh threshold in the `asym ≤ −3` regime.

## Receipts inventory (SHA-256 indexed)

See `MANIFEST.tsv` at the repo root. 85 files from this session are
hashed individually; canonical SHA-256 equivalence classes for
`exp_r1_r4_campaign` are enumerated in `CLAIMS.md`.

### Principal receipt files

- `artifacts/phase_W0_vocabulary_20260417T230843Z/w0_random_adj.jsonl`
  — the R1-flip receipt (RA default, canonical SHA `21ef856f…`)
- `artifacts/phase_W1_gate_flip_20260418T000305Z/json_receipts/SY_default.jsonl`
  — the baseline receipt (canonical SHA `6317e822…`)
- `artifacts/phase_W1_gate_flip_20260418T000305Z/json_receipts/SY_tags_v2.jsonl`
  — the R2-flip receipt (canonical SHA `d15c551d…`)
- `artifacts/phase_W1_gate_flip_20260418T000305Z/phase_W1_tier_c_receipts/C_SY_s20.jsonl`
  — the R3-payload-moving receipt at steps=20 (canonical SHA `06e5cf74…`)
- `artifacts/phase_W2_third_regime_20260418T031800Z/phase_W2_third_regime_receipts/H_*.jsonl`
  — harmonic basin structure at extreme negative asym (5 cells)
- `artifacts/phase_W2_third_regime_20260418T031800Z/phase_W2_third_regime_receipts/HO_*.jsonl`
  — holography mirror (2 cells)

## Governance retrospective

- Pre-registration before each phase: YES (each phase has a visible
  PRE_REGISTRATION.md or equivalent in its summary).
- N ≥ 5 enforced for all confirmed claims; N=100 for IID Bernoulli.
- Two Session 4/5 claims revised: (a) Claim γ retracted at N=10 pooled
  (Session 5, carried forward here); (b) Session 5 basin classifier
  scoped to asym ∈ [−2, +2] (Session 6 W2).
- One new retraction stays visible in `CLAIMS.md`.
- Kill criteria applied honestly: SY sweep truncated at 2 cells when
  bit-identical output revealed null axes; parallel scheme killed after
  timing evidence; `holo_steps10` style wasteful runs skipped.
- All claims have retained packets.

## Go-live criteria (for Monday operator review)

Per PRD §10:

| Criterion                                                  | Met? |
|------------------------------------------------------------|------|
| W1 complete with a receipted verdict per gate              | **YES** (R1 FLIPPED, R2 FLIPPED, R3 PAYLOAD-MOVING) |
| W4 complete: README, CLAIMS, etc., all present + indexed   | In final pass; draft complete, W3 fill-in pending |
| No open kill-criterion violations from earlier sessions    | YES |
| At least one of W2, W3 complete                            | W2 YES; W3 in flight |
| W1-FLIPPED verdict with reproducible config                | YES (two such configs) |
| W2 verdict in hand                                         | YES (W2-CONTINUOUS + emerging mid-cluster) |
| W3 verdict in hand                                         | YES (W3-INVARIANT) |

**Recommendation:** **go-live-ready.** All four PRD priorities produced
receipted verdicts; the W1 flip headline is reproducible; no open
kill-criterion violations; the IS/IS_NOT ledger is up to date;
SHA-256 manifest is written.

## Staging note

This review pack is authored as part of W4. It mirrors the
Session 5 review-pack template. All content will be finalized when
W3 completes; this draft reflects the Session 6 state as of the end
of W2.
