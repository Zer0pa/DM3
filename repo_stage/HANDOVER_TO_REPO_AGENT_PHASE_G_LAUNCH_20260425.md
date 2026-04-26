# Handover to repo-agent — Phase G launched

Written: `2026-04-25` ~18:35 UTC (20:35 SAST)
From: Session 8 engineer-agent
For: the repo-agent
Status: **NOT FOR INTEGRATION YET** — chain is live, results pending

This is a launch-time placeholder. No claim updates yet. The chain is running autonomously; final findings + claim ledger updates will land in a Phase G close handover at chain end (~2026-04-26 to 2026-04-27).

---

## What's live

Phase G chain launched 2026-04-25 18:25:54 UTC.
- **Authoritative PRD**: orchestrator's Phase G brief 2026-04-25
- **Augmented PRD**: [`docs/restart/DM3_PHASE_G_AUGMENTED_PRD_20260425.md`](../docs/restart/DM3_PHASE_G_AUGMENTED_PRD_20260425.md) — engineer-additions G.0.5, G.1.5, G.5+
- **Chain script**: `phase_g_chain.sh` on device, nohup PID 11731
- **Cells to land**: G.0, G.0.5, G.6 (+G.6 reverse if KILL), G.1, G.1.5, G.2, G.5 (cond.), G.5+, G.7 (cond.), G.3, G.4 (overflow)

---

## What you should NOT do yet

- Do not promote any new claims from this chain — wait for the Phase G close handover with verdicts + outcome.json files
- Do not update README/website — chain is mid-flight
- Do not change `CLAIMS.md` — current state already reflects A.5+B.3+A.6 close per `HANDOVER_TO_REPO_AGENT_A5_B3_A6_FINAL_20260425.md`

The current outstanding-from-prior-handovers integration list (still valid):
- Reject σ and σ′ before promotion (per A.5+B.3+A.6 handover)
- Promote σ″, φ, π, ρ as CANDIDATE
- Refine κ wording
- Promote τ, ξ, ο to CONFIRMED
- Add the IS / IS_NOT items from the A.5+B.3+A.6 handover

That work is independent of Phase G and ready for your pass at any time.

---

## Phase G outcomes you'll be asked to integrate later

When the chain closes, expect:
- A Phase G final report (engineer-authored, science-team-facing)
- A Phase G repo-agent handover (this doc's successor)
- New claims ν.1 / θ.1 / etc. depending on G.6, G.1, G.2, G.7, G.3, G.5, G.5+, G.4 outcomes
- New IS / IS_NOT entries for whichever questions get settled
- Possibly retraction or weakening events on existing claims if KILL outcomes fire

Don't pre-allocate claim glyphs. Let the data dictate.

---

## Three things the chain might surface that warrant pre-flagging

1. **G.6 KILL** would be the project's largest finding — DM3 has cross-invocation state. Auto-triggers reverse-confirm. If reverse-confirm reproduces, this is a session-pivoting result. Engineer-agent will flag explicitly and request operator review before any public framing.

2. **G.2 KILL** would fragment σ″ into per-config variants and reframe how we discuss the trimodal-sawtooth structure. Less revolutionary than G.6 KILL, but ledger-impacting.

3. **G.3 finding any LEARNS-STRONG task other than `exp_k2_scars`** would extend μ to a multi-task family. Possible but not predicted.

For all three, the chain produces decisive PASS/KILL outcomes; no human heuristic needed mid-flight.

---

## HF preservation status

- All four cell scripts pushed to device, chain script staged
- HF dataset repo `Zer0pa/DM3-artifacts` ready for the new `phase_S8_PG_followup_*/cells/` tree at chain close
- Custody snapshot at chain close will go to `hf://buckets/Zer0pa/DM3-scratch/custody/<close-timestamp>/`

---

## Final note

Chain is autonomous. Operator can disconnect phone any time. Resume script ready if anything dies overnight. Next handover lands at chain close with the actual integrable findings.

Thanks for keeping the door fresh.

—— Session 8 engineer-agent, 2026-04-25
