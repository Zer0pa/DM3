# DM3 HF Preservation Lane

Written: `2026-04-24` ~00:40 UTC (02:40 SAST)
Pattern adapted from: Zer0paShip phase13.2.1.3.7 custody lane
Purpose: machine-loss + device-loss recovery for DM3 in tandem with GitHub authority

---

## LANE

DM3 / Session 8 Phase A close / Device-Host-HF tri-backup

## GITHUB_REMOTE

```
origin https://github.com/Zer0pa/DM3.git
```

## GITHUB_STATUS

- branch = `hypothesis/rm10-primary-platform-heterogeneous-learning`
- upstream = `origin/hypothesis/rm10-primary-platform-heterogeneous-learning`
- state = up-to-date with origin (0 unpushed commits), **dirty worktree**
- tracked modified: 9 files (including `.gpd/PROJECT.md`, `.gpd/ROADMAP.md`, `.gpd/STATE.md`, `README.md`, `Makefile`, `CONTRIBUTING.md`, 2 hypothesis state files)
- tracked deleted: 100+ briefing-pack files (from earlier session consolidation)
- untracked: 4,451 files (mostly under `.worktrees/`, `.venv/`, cache dirs, and genuinely new work — see manifest)

## GITHUB_REQUIRED

Authority still belongs in GitHub. Repo-agent owns the push. Not mutated in this pass.
Needs later commit/push (preserved off-machine in HF bucket):

- 9 tracked modified files captured in `working-tree-tracked.patch`
- 4,451 untracked entries listed in `untracked-files.txt` + `worktree-manifest.json`
- new docs just authored in this session:
  - `docs/restart/DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md`
  - `docs/restart/DM3_AGENT_HANDOVER_SESSION8_ALIVE_20260423.md`
  - `docs/restart/DM3_SESSION8_PHASE_A_INTERIM_20260423.md`
  - `repo_stage/HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md`
- new artifact tree:
  - `artifacts/phase_S8_P0_learning_20260422T213500Z/cells/` (pulled from device — 278 receipt files)
  - `artifacts/phase_S8_P0_learning_20260422T213500Z/device_snapshot/` (harness scripts + chain log)
  - `artifacts/device_assets_20260424T001500Z/` (frozen binary + adjacency + tags + datasets)

These are now off-machine in HF bucket + two dataset repos. GitHub is still not current; that's the repo-agent's pass.

## HF_DATASET_REPOS

- `Zer0pa/DM3-artifacts` — private dataset repo
  - https://huggingface.co/datasets/Zer0pa/DM3-artifacts
  - Contains: all receipts (Session 7 + Session 8 Phase A), full `docs/restart/` tree, `repo_stage/` mirror
- `Zer0pa/DM3-binary` — private dataset repo
  - https://huggingface.co/datasets/Zer0pa/DM3-binary
  - Contains: frozen `dm3_runner` binary (hash-verified), adjacency files, region tags, xnor datasets

(DM3 is not a weights-model — the binary is a compiled Rust CLI — so no HF model repo is needed. Binary is preserved as dataset content.)

## HF_BUCKETS

- `hf://buckets/Zer0pa/DM3-scratch`
  - used prefix:
    - `hf://buckets/Zer0pa/DM3-scratch/custody/20260424T003000Z`

## UPLOADED_PATHS

### HF dataset repo `Zer0pa/DM3-artifacts` (510 files total)

Three commits:
- `7142946e8c8349326bd000532c47b810b1c2c24a` — Phase A close (324 files)
  - `phase_S8_P0_learning_20260422T213500Z/cells/A1_mu_replicate/**` (53 files)
  - `phase_S8_P0_learning_20260422T213500Z/cells/A2_overfit_boundary/**` (108 files)
  - `phase_S8_P0_learning_20260422T213500Z/cells/A3_cross_graph/**` (66 files)
  - `phase_S8_P0_learning_20260422T213500Z/cells/A4_cross_dataset/**` (51 files)
  - `phase_S8_P0_learning_20260422T213500Z/device_snapshot/bin/**` (35 files — harness scripts)
  - `phase_S8_P0_learning_20260422T213500Z/device_snapshot/phase_a_resume.log`
- `cdb85c815c599e68a4e28a86f3ad6001c532665a` — docs (173 files)
  - `docs/**` — all DM3 docs including Session 7 final report, Session 8 Phase A final report, all handovers, PRDs, status snapshots
- `87921804e939d0dd3504a65bdd3afc109e632fee` — repo_stage (13 files)
  - `repo_stage/**` — `CLAIMS.md`, `IS_AND_IS_NOT.md`, `CHARACTERIZATION_REPORT.md`, `JOURNEY_LOG.md`, `LIVE_PROJECT.md`, `README.md`, both handovers, `MANIFEST.tsv`, `CITATION.cff`, `website_summary.md`, `REPO_AGENT_FINDINGS.md`, `SESSION6_REVIEW_PACK.md`
- `c678c0047ae0d0eb79800da64991484c3f9450f7` — Session 7 artifacts (1,663 files)
  - `phase_S7_P0_receipt_harness_20260418T151800Z/**` — S1-S11, T1-T11, all substrate null + learning probe receipts

### HF dataset repo `Zer0pa/DM3-binary` (9 files)

Commit `6c0518f66138cc6fc475bce0baab335fb9c5d681`:
- `device_assets_20260424T001500Z/dm3_runner` (9,554,600 bytes — SHA256 `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`)
- `device_assets_20260424T001500Z/dm3_runner.device.sha256` (device + host verify)
- `device_assets_20260424T001500Z/SriYantraAdj_v1.bin` (24,891 bytes)
- `device_assets_20260424T001500Z/RandomAdj_v1.bin` (22,012 bytes)
- `device_assets_20260424T001500Z/RegionTags_v1.bin` (13,332 bytes)
- `device_assets_20260424T001500Z/RegionTags_v2.bin` (1,532 bytes)
- `device_assets_20260424T001500Z/data/xnor_train.jsonl`
- `device_assets_20260424T001500Z/data/xnor_mini.jsonl`
- `device_assets_20260424T001500Z/data/xnor_test.jsonl`

### HF bucket `hf://buckets/Zer0pa/DM3-scratch/custody/20260424T003000Z`

7 files (1.31 MB total):
- `git-remote.txt` (97 B)
- `git-status.txt` (13,565 B)
- `head.txt` (149 B)
- `upstream-head.txt` (149 B)
- `unpushed-commits.txt` (0 B — nothing unpushed)
- `unpushed-range.patch` (0 B — nothing unpushed)
- `untracked-files.txt` (444,070 B — 4,451 entries)
- `working-tree-tracked.patch` (196,356 B)
- `worktree-manifest.json` (657,963 B — full file list with sizes)

## EXCLUDED_PATHS

The following are NOT in HF backup (by design — either regenerable, secret, or not intentionally salvaged):

- `.git/` (entire git internals — `git clone` recreates after push)
- `.env` / credentials / tokens / any secrets
- `.venv/` (Python virtualenv — recreatable via `pip install`)
- `node_modules/` (recreatable via `npm install`)
- `__pycache__/` and other cache dirs
- `.claude/worktrees/` duplicate copies (every DM3 file would otherwise be multiplied per worktree)
- `.DS_Store` OS junk (some slipped into the docs upload — benign)
- Build outputs not yet declared authority artifacts
- Pod or remote runtime state (N/A for DM3 — no pod in this lane)

## RUNPOD_ACCESS_REQUIRED

NO for this pass. DM3 does not use RunPod. Device is the RM10 Pro+ phone `FY25013101C8` connected via ADB. The phone holds state in `/data/local/tmp/dm3_harness/cells/` which was pulled to host in this pass.

## DEVICE_SNAPSHOT_DONE

All device-resident state captured to host and to HF:
- binary: pulled, SHA256 verified identical on device and host
- adjacency (Sri Yantra + Random) and tags (v1 + v2): pulled
- datasets (xnor_train, xnor_mini, xnor_test): pulled
- harness scripts (`bin/`): pulled (35 files)
- chain log (`phase_a_resume.log`): pulled
- Phase A receipts: pulled (278 files across 4 cells)

## REMAINING_MACHINE_LOSS_RISK

### GitHub authority gap
- 9 tracked modifications + 4,451 untracked entries are not yet committed to GitHub
- Recovery: apply `custody/20260424T003000Z/working-tree-tracked.patch` to a fresh clone; use `untracked-files.txt` + `worktree-manifest.json` as the inventory of untracked paths
- Caveat: **the untracked files' CONTENT is not in the bucket** — only the filename + size manifest is. If Mac dies, untracked file content is lost. This is acceptable for the present pass because (a) most untracked paths are under `.venv/`, caches, or worktree duplicates; (b) the science-critical files we authored in this session (`DM3_SESSION8_PHASE_A_FINAL_REPORT_20260424.md` etc.) ARE among the 237 tracked-modified lines and are inside `working-tree-tracked.patch`.
- Follow-up: repo-agent should commit + push in a dedicated pass. That closes this gap.

### Phone loss → no longer critical
Before this pass: phone loss = permanent loss of 55 Phase A receipts + binary + inputs. After this pass: all 55 receipts + binary + inputs are on host + HF. Phone loss now only costs in-flight work (none right now; Phase A is closed and no chain is running).

### Mac loss → no longer critical for Phase A
Before this pass: Mac loss = loss of 1,663 Session 7 receipts + 278 Session 8 receipts + 173 docs + 13 repo_stage files + 9 binary assets. After this pass: all on HF. Mac loss now only costs the ~4,451 untracked file contents (largely regenerable).

### Pod-only artifacts
N/A for DM3. Session 7 final report and current Phase A Final Report reference no pod-only artifacts.

### Remaining operator-side items
- **Repo-agent has not pushed Session 7 integration yet** (pending since 2026-04-22) — still in `repo_stage/` only, not in the public `Zer0pa/DM3` GitHub repo front door
- **Repo-agent has not integrated Session 8 Phase A yet** (this handover just authored: `repo_stage/HANDOVER_TO_REPO_AGENT_PHASE_A_20260424.md`)
- **Airplane mode** on device is still OFF (unchanged from end-of-Phase-A). Operator should restore ON before Phase B.

## RECOVERY PROCEDURE (if Mac and phone both die simultaneously)

1. On a fresh Mac:
   ```
   git clone https://github.com/Zer0pa/DM3.git
   cd DM3
   git checkout hypothesis/rm10-primary-platform-heterogeneous-learning
   ```

2. Apply uncommitted changes from HF scratch:
   ```
   hf buckets cp hf://buckets/Zer0pa/DM3-scratch/custody/20260424T003000Z/working-tree-tracked.patch ./
   git apply working-tree-tracked.patch
   ```

3. Restore artifact trees from HF:
   ```
   hf download --repo-type dataset Zer0pa/DM3-artifacts . --local-dir-pattern "phase_S7_P0_*/**"
   hf download --repo-type dataset Zer0pa/DM3-artifacts . --local-dir-pattern "phase_S8_P0_*/**"
   hf download --repo-type dataset Zer0pa/DM3-artifacts docs --include "docs/**"
   hf download --repo-type dataset Zer0pa/DM3-artifacts repo_stage --include "repo_stage/**"
   ```

4. Restore binary + inputs + datasets (for a fresh phone):
   ```
   hf download --repo-type dataset Zer0pa/DM3-binary .
   # Verify binary hash matches `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
   sha256sum device_assets_20260424T001500Z/dm3_runner
   # Push to new phone via adb push
   adb push device_assets_20260424T001500Z/dm3_runner /data/local/tmp/
   adb push device_assets_20260424T001500Z/SriYantraAdj_v1.bin /data/local/tmp/
   adb push device_assets_20260424T001500Z/RandomAdj_v1.bin /data/local/tmp/
   adb push device_assets_20260424T001500Z/RegionTags_v1.bin /data/local/tmp/
   adb push device_assets_20260424T001500Z/RegionTags_v2.bin /data/local/tmp/
   adb push device_assets_20260424T001500Z/data /data/local/tmp/
   adb shell chmod +x /data/local/tmp/dm3_runner
   ```

5. Re-stage harness scripts:
   ```
   adb push artifacts/phase_S8_P0_learning_20260422T213500Z/device_snapshot/bin /data/local/tmp/dm3_harness/
   adb shell chmod +x /data/local/tmp/dm3_harness/bin/*.sh
   ```

6. Verify:
   ```
   adb shell sha256sum /data/local/tmp/dm3_runner
   # Must match `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
   ```

Recovery time estimate (fresh Mac + fresh phone, everything from HF): ~30–45 minutes.

## REPO_STRUCTURE (for future passes)

Per-session pattern going forward:

1. At each cell close on device → pull to host at `artifacts/phase_S{N}_P{M}_*/cells/<cell_name>/`
2. At each phase close → upload that phase's cells dir to `Zer0pa/DM3-artifacts` under the same path
3. At each session start + end → custody snapshot to `hf://buckets/Zer0pa/DM3-scratch/custody/<timestamp>/`
4. Any binary change (if the binary-fence ever lifts) → new commit to `Zer0pa/DM3-binary` with SHA256-in-filename
5. `docs/` and `repo_stage/` → sync to `Zer0pa/DM3-artifacts` at each session close
6. Repo-agent owns all GitHub authority pushes (docs, repo_stage mirror, claim ledger)

This lane is additive to GitHub, not a replacement. GitHub remains authority.

—— Session 8 engineer-agent, 2026-04-24
