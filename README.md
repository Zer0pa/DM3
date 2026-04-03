# DM3 2026 Restart

This repository is the canonical restart workspace for DM3 re-engineering.

It does not vendor the legacy codebases. Those remain in the broader local workspace for recovery and comparison:

- `/Users/Zer0pa/DM3/recovery/zer0pamk1-DM-3-Oct`
- `/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025`
- `/Users/Zer0pa/DM3/target/debug/dm3_runner`

Current purpose:

1. Freeze the factual recovery boundary.
2. Separate proven carry-forward components from source-missing components.
3. Rebase the science, physics, and acceptance gates before rebuilding.
4. Keep experiment metadata portable across collaborators and machines.

Start with:

- `.gpd/PROJECT.md`
- `.gpd/STATE.md`
- `.gpd/ROADMAP.md`
- `docs/recovery/RECOVERY_MATRIX.md`
- `docs/recovery/OCTOBER_BUILD_STATUS.md`
- `docs/recovery/RESET_BASIS.md`
- `docs/recovery/TEST_REFERENCE_STATUS.md`
- `docs/restart/TRAINING_DOC_HYPOTHESES.md`
- `docs/restart/LEGACY_BATTERY_ENTRYPOINTS.md`
- `docs/restart/GPD_OPERATING_MAP.md`
- `docs/restart/HYPOTHESIS_BRANCH_REGISTER.md`
- `docs/restart/HARDWARE_LANE_BASELINE.md`
- `docs/restart/COLLABORATION_AND_LOGGING.md`
- `docs/restart/FRESH_CLONE.md`

The restart is now also a GPD project. The current scientific reset begins in:

- `.gpd/PROJECT.md`
- `.gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md`

Phase 1 is deliberately a falsification and claim-mapping phase. The manifesto is treated as a claim inventory, not as proof.

## Collaboration Baseline

- Use this repo as the canonical restart workspace.
- Keep secrets out of the repo. Use environment variables or `~/.comet.config`.
- Log serious runs to Comet under workspace `zer0pa` and project `dm3` unless we deliberately change the tracking topology later.
- Preserve branch, machine class, and acceptance-lane tags on every serious run.

## Comet Quickstart

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Either:
comet login

# Or:
set -a
source .env
set +a

python3 tools/comet_manifest_logger.py \
  --manifest examples/comet/run_manifest.example.json \
  --offline
```

Offline mode is included because some device-side runs may not have stable connectivity during execution.

## Fresh Clone

```bash
git clone https://github.com/Zer0pa/DM3-2026-Restart.git
cd DM3-2026-Restart

./tools/bootstrap_recovery.sh
./tools/check_legacy_october.sh
```

If both commands complete successfully, the collaborator has the same recoverable baseline we do.

To join the scientific reset instead of only verifying recovery, read:

```bash
sed -n '1,220p' .gpd/PROJECT.md
sed -n '1,220p' .gpd/STATE.md
sed -n '1,220p' .gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md
```
