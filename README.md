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

- `docs/recovery/RECOVERY_MATRIX.md`
- `docs/recovery/RESET_BASIS.md`
- `docs/recovery/SCOPING_DRAFT.md`
- `docs/restart/COLLABORATION_AND_LOGGING.md`

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
