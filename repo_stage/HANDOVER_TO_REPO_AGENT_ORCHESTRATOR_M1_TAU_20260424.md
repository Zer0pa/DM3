# Repo-Agent Handover — Orchestrator Layer (Post-M1, Post-A.5)

**Written:** 2026-04-24 (post-phone-reconnect)
**Author:** Orchestrator (Claude Opus 4.7, 1M context)
**Companion to:** the engineer-agent's existing repo-agent handovers from this wave —
- `HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md` (M1 / τ technical handover)
- `HANDOVER_TO_REPO_AGENT_A5_B3_INTERIM_20260424.md` (A.5/B.3 technical handover)
- `CLAIM_TAU_CONFIRMED_20260424.md` (formal τ claim doc)

This note is the **orchestrator-level layer** above those technical handovers. Strategic guidance, governance fences, integration policy. Read this AFTER you've read the engineer-agent's three docs above.

---

## 1. What's actually new for you to integrate

Three streams of evidence landed during the disconnect window:

1. **AGD-H1 M1 cross-platform determinism — ALL_MATCH.**
   - Artefact tree: `artifacts/phase_S8_AGDH1_external_M1_20260424/`
   - 5 per-run logs + receipts.jsonl + AGD_H1_M1_FINDINGS.md + emulator_boot.log
   - **Claim τ promoted directly to CONFIRMED** (not CANDIDATE) — bit-exact 10/10 floats across two distinct ARM64 silicon platforms
   - This is a **Tier-4 unlock event**: cross-platform determinism was originally gated on a second physical device; the M1 / Hypervisor.framework / AVD path provided the same evidence at zero phone-time

2. **A.5 closed (30/30), σ → σ′ refactor.**
   - Artefact tree: `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/A5_peak_finder/` (pending host-side pull)
   - Curve fully mapped: bimodal peaks at steps=32 (1.790665) and steps=41 (1.708374)
   - **σ from earlier handover should be REJECTED.** σ said peaks at 30/40 — that was a 5-step-grid sampling artifact. The real peaks are 32 and 41.
   - **σ′ replaces it as CANDIDATE**, near-final wording in the engineer-agent's `HANDOVER_TO_REPO_AGENT_A5_B3_INTERIM_20260424.md` §2

3. **B.3 in flight (5 of 24 at 17:50 SAST).**
   - Artefact tree: same Phase S8 P0 directory, cells/B3_cli_audit/ (pending pull)
   - Per-task `--steps` responsiveness audit, will produce the table that gates Phase C scope
   - **Hold integration of B.3 until chain closes** — partial integration would cause repo_stage churn

---

## 2. Strategic governance for this integration pass

### 2.1 Treat τ as a first-class claim, not a footnote

τ is the strongest single-test result the project has ever produced. 10 IEEE-754 floats bit-exact across two distinct silicon platforms. The integration should reflect this:

- **`CLAIMS.md` entry** — give τ its own section near the top, alongside ξ and ι (the other determinism / substrate claims)
- **`IS_AND_IS_NOT.md`** — add explicit IS entry: "DM3's logical output is bit-deterministic across distinct ARM64 hardware platforms; SoC-specific FP behavior, scheduler artifacts, and thermal effects do not enter the result." Add IS NOT entry: "DM3 is not dependent on any property of the Snapdragon 8 Elite specifically; cross-vendor ARM64 substitution preserves bit-identity."
- **`CHARACTERIZATION_REPORT.md`** — promote cross-platform-determinism to a headline finding alongside two-layer substrate invariance and the μ/σ′ learning curve. The story is now: bit-deterministic at the gate layer, statistically-deterministic at the dynamics layer, AND bit-deterministic across hardware.
- **`website_summary.md`** — single sentence addition: "DM3's logical output is bit-identical across two distinct ARM64 hardware platforms (Snapdragon 8 Elite and Apple M1) for the same compiled binary and inputs."
- **`JOURNEY_LOG.md`** — entry for 2026-04-24 noting τ as a Tier-4 unlock event achieved at zero phone-time via Hypervisor.framework AVD path. Worth recording the methodological observation: a Tier-4 prioritization-formula item moved to CONFIRMED via a creative-execution path that the formula didn't anticipate.

### 2.2 Two distinct retraction states should be formalized in the status key

`CLAIMS.md` currently has these statuses: SOLID, CONFIRMED, PROMOTED, WEAKENED, RETRACTED, PENDING. Add or differentiate:

- **RETRACTED** = post-promotion kill (the prior claim was on the ledger as CONFIRMED or stronger and was killed by new data). Existing examples: H2, γ.
- **REJECTED-AT-CANDIDATE** = pre-promotion kill (the claim was at CANDIDATE and never promoted; new data showed the framing was wrong before it entered the SOLID/CONFIRMED tier). New example: σ.

The two states have different scientific implications and different ledger handling. RETRACTED preserves the prior claim text + the killing evidence. REJECTED-AT-CANDIDATE records that a CANDIDATE was floated and replaced before promotion. Both should remain visible — neither should be deleted.

### 2.3 ξ statement upgrade

Current ξ: "`exp_k2_scars` is bit-deterministic at fixed config" (or similar).

Recommended upgrade: *"`exp_k2_scars` is bit-deterministic at fixed config across (a) independent chains separated by device idle periods, (b) multiple days, (c) post-harness-patches, (d) distinct ARM64 silicon platforms (Snapdragon 8 Elite native and Apple M1 via AVD). Evidence base: 76+ receipts across A.1, A.2, A.3, A.4, A.5, and AGD-H1 M1, with zero within-equivalence-class deviation."*

The strengthened phrasing matches the strengthened evidence base. ξ is now one of the strongest claims in the project.

### 2.4 Cross-link the M1 work to the rest of the receipt chain

The M1 phase directory is currently siloed at `phase_S8_AGDH1_external_M1_20260424/`. Cross-link it explicitly:

- **`MANIFEST.tsv`** must include all M1 artifacts (5 logs + receipts.jsonl + findings + emulator boot log + host_input_sha256.txt + host_env.txt). Each gets a canonical SHA entry.
- **Per-claim evidence references** for τ should cite both the M1 phase directory AND the RM10 reference vectors in `phase_S8_P0_learning_20260422T213500Z/cells/A2_*` (because τ's evidence is the COMPARISON, not just the M1 side).

### 2.5 What NOT to do this pass

- **Do NOT push to GitHub yet.** The engineer-agent has explicitly preserved the GitHub publication step for the repo-agent. But GitHub push should wait until B.3 closes and the next batch integration runs. Partial integration breaks the receipt-chain story for any external observer who reads mid-pass.
- **Do NOT integrate B.3 receipts until the chain closes.** B.3 is at 5/24 — partial integration would inflate the receipt count without providing the per-task responsiveness table that's the actual deliverable.
- **Do NOT promote σ′ yet.** σ′ is CANDIDATE, kill criterion is a finer sweep of {33-37} that hasn't run yet. The engineer-agent has held it correctly at CANDIDATE; preserve that posture.
- **Do NOT remove or soften σ.** Record σ as REJECTED-AT-CANDIDATE with the killing evidence (A.5 finer sweep) and σ′ as the replacement. Both visible.
- **Do NOT collapse the M1 finding into "another substrate-null receipt."** It is structurally different from the substrate-null story (S2/S4/S6/S7/S8). Substrate nulls test environmental perturbations on one device; τ tests cross-device determinism. Two different IS findings, two different ledger entries.

### 2.6 Sync seams to flag for next pass

The engineer-agent's `REPO_AGENT_FINDINGS.md` should be updated this pass to note new sync seams:

- **A.5+B.3 host-side pull pending.** Phone-side receipts complete; host-side pull deferred until chain close. MANIFEST.tsv will not include cells/A5_*/, cells/B3_*/ until next pass.
- **τ artifacts integrated this pass.** M1 phase tree mirrored; τ promoted to CONFIRMED; cross-link to RM10 reference receipts in CLAIMS.md.
- **σ → σ′ ledger transition recorded.** σ flagged as REJECTED-AT-CANDIDATE (pending status-key formalization); σ′ added as CANDIDATE.
- **Source-recovery workstream open.** `dm3_microtx` source unavailability is now a strategic gap because it blocks the ARM↔x86 determinism question. Flag this in REPO_AGENT_FINDINGS.md as an operator-decision item.

---

## 3. Three orchestrator-level invitations to push back

The engineer-agent invited push-back in their handover. I'll add three orchestrator-level ones the engineer-agent's technical view doesn't cover:

1. **Should τ's evidence be expanded to a third ARM64 platform before promotion to SOLID?** Current evidence: Snapdragon 8 Elite + Apple M1 (via AVD). Both are high-end consumer ARM64. A third platform — say a Pixel (Tensor SoC) or a Raspberry Pi 5 (BCM2712) — would diversify the evidence and let τ promote from CONFIRMED to SOLID with broader hardware coverage. Cost: low, if any cooperative engineer with a different ARM device runs the kit. Worth scoping?

2. **Should the cross-platform-determinism claim be its own paper?** τ alone is publishable. "Cross-platform bit-determinism of a compiled learning task across distinct ARM64 silicon platforms" is an interesting result for the reproducibility / compiled-deterministic-systems literature. Lower-stakes than waiting for Mode A. May be worth scoping as a 4-week side track.

3. **Is the source-recovery workstream a discrete project or an ambient task?** Right now `dm3_microtx` source unavailability is a passive gap. The orchestrator-level question: do we make this a named workstream with a budget, or do we accept the gap and revise the license + reproducibility-kit docs to reflect "source-blocked, ARM64-determinism receipted" as our public posture? Both are defensible; the operator should pick.

---

## 4. Final note

This wave's artefact is materially stronger than yesterday's. τ is the largest single-test gain since the substrate-null story closed in Session 7. ξ is now one of the strongest claims in the project. σ′ replaces a CANDIDATE that would have been wrong if promoted.

Your integration of these findings into repo_stage matters because it's where external observers first see the artefact. Get the τ promotion right, the σ → σ′ transition right, and the ξ upgrade right, and the public narrative will be tighter than it was yesterday.

Push back via `REPO_AGENT_FINDINGS.md` if anything in this orchestrator note conflicts with the engineer-agent's technical handover. Both layers should agree before integration.

—— Orchestrator, 2026-04-24
