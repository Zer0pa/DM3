# Repo-agent handover — AGD-H1 External on M1 MacBook Air

**Date:** 2026-04-24
**From:** Session 8 external-parallel agent (AGD-H1 M1 lane)
**Scope:** land AGD-H1 External (M1 MacBook Air pass) into the public `Zer0pa/DM3` and `Zer0pa/DM3-artifacts` surfaces
**Supersedes:** prior `BLOCKED` version of this handover.

---

## TL;DR

AGD-H1 External on M1 Mac ran to completion and returned **ALL_MATCH /
τ CONFIRMED**. The repo-agent should:

1. Move the five new docs into the public `Zer0pa/DM3` repo where applicable.
2. Update ledger-level claim files to reflect τ as confirmed.
3. Confirm the HF mirror is complete for all artifacts listed below.
4. Remove any "BLOCKED" or "SOURCE_NOT_ACCESSIBLE" wording for AGD-H1 M1 from
   the narrative docs.

---

## New artifacts on disk (local)

Under `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/`:

**Primary findings directory** —
`artifacts/phase_S8_AGDH1_external_M1_20260424/`:

| File | Purpose |
| --- | --- |
| `AGD_H1_M1_FINDINGS.md` | headline verdict + comparison table + governance |
| `receipts.jsonl` | 5 JSONL receipts (one per step value) with full provenance |
| `m1_s20.log` | stdout log for `--steps 20` run |
| `m1_s30.log` | stdout log for `--steps 30` run |
| `m1_s40.log` | stdout log for `--steps 40` run |
| `m1_s45.log` | stdout log for `--steps 45` run |
| `m1_s50.log` | stdout log for `--steps 50` run |
| `emulator_boot.log` | AVD boot-time log for provenance |

**Companion docs:**

- `docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md` — science team note
- `repo_stage/HANDOVER_TO_REPO_AGENT_AGDH1_M1_20260424.md` — this file

---

## Public-repo integration steps

### 1. Files to carry into the public `Zer0pa/DM3` repo

Copy (not move) the following into `Zer0pa/DM3` at the same relative paths:

- `docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/AGD_H1_M1_FINDINGS.md`
- `artifacts/phase_S8_AGDH1_external_M1_20260424/receipts.jsonl`

The raw stdout logs are bulky-ish (~1.5 KB each) and **should** go into the
public repo too since they are small and carry the `KPI_K2_SUMMARY` line
that is the primary evidence.

### 2. Update these ledger files

- `CLAIMS.md` — elevate τ from *candidate* to *confirmed*, scoped to
  `--cpu --task exp_k2_scars` with `SY_v1 + RegionTags_v1 + xnor_train`
  inputs. Cite the 5-row comparison table and the four verified input SHAs.
- `IS_AND_IS_NOT.md` — add a positive statement under the `exp_k2_scars`
  section: "DM3 learning determinism is ARM-hardware-independent on CPU mode
  for this task, confirmed across RM10 Snapdragon and Apple M1 (Android 14
  emulator under Hypervisor.framework)."
- `ARTEFACT_BUNDLE_REGISTER.tsv` — add new rows for each of the 8 artifacts
  above, with their sha256 and file size (see receipts for per-log hashes).
- `RETRACTIONS.md` — not applicable; this is a new confirmation, not a
  retraction.

### 3. HF preservation

Upload everything in
`artifacts/phase_S8_AGDH1_external_M1_20260424/` plus the science-team note
to `Zer0pa/DM3-artifacts` dataset repo, preserving path structure.
Suggested command:

```bash
hf upload --repo-type dataset Zer0pa/DM3-artifacts \
  artifacts/phase_S8_AGDH1_external_M1_20260424 \
  artifacts/phase_S8_AGDH1_external_M1_20260424
hf upload --repo-type dataset Zer0pa/DM3-artifacts \
  docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md \
  docs/restart/DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md
```

This handover file itself (`repo_stage/...`) is **not** for HF — it is an
internal staging note.

### 4. Remove stale "BLOCKED" narrative

The prior `BLOCKED — SOURCE_NOT_ACCESSIBLE` versions of
`AGD_H1_M1_FINDINGS.md` and `DM3_AGDH1_M1_SCIENCE_TEAM_NOTE_20260424.md`
have been overwritten in place. Grep any remaining narrative docs for
"BLOCKED" + "AGDH1" + "M1" and rewrite or delete; the M1 lane is no longer
blocked.

---

## Provenance and governance

- **Binary used:** existing Android aarch64 ELF
  `sha256=daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`.
  Not rebuilt. Classified `exploratory_compiled_residue` under
  `docs/restart/PREBUILT_VS_SOURCE_BUILT_MATRIX.md`.
- **Execution surface:** Android Studio Emulator 36.5.11,
  `system-images;android-34;google_apis;arm64-v8a` rev 14, AVD `dm3_m1_test`
  (Pixel 6 profile), Hypervisor.framework acceleration.
- **Host:** MacBookAir10,1, Apple M1, macOS 15.5 (24F74), arm64.
- **Input SHAs verified** pre-run on emulator, 4/4 matching reference.
- **Phone (`FY25013101C8`)** was present on USB the whole time and was
  **not touched**; every `adb` command used `-s emulator-5554`.

---

## Recommended commit plan for the repo-agent

Single PR, branch suggestion `feat/agd-h1-m1-external-all-match`:

- Title: `AGD-H1 External (M1 Mac): τ confirmed, 5/5 bit-exact`
- Body: cite the comparison table verbatim, link to `AGD_H1_M1_FINDINGS.md`,
  summarize ledger edits.
- Files touched: the 8 new artifacts, the science-team note, and the 3 ledger
  updates (`CLAIMS.md`, `IS_AND_IS_NOT.md`, `ARTEFACT_BUNDLE_REGISTER.tsv`).

No source code change. No tool-belt change. Documentation + evidence only.

---

## Open items for operator (not for repo-agent)

1. Decide whether to also run N=3 repeats on each step (engineering belt-and-braces; not scientifically necessary for a pure function of inputs).
2. Decide whether to stand up an x86_64 Mac (Intel) lane for ARM-vs-x86 determinism — blocked on source-recovery; no tooling work will unblock it.
3. Ratify τ promotion in whatever governance layer supersedes `CLAIMS.md`.
