# Fresh Clone

This is the minimum path for a new machine or collaborator.

## Requirements

- `git`
- Rust toolchain with `cargo`
- Python 3 for the Comet logging shim

## Clone The Restart Repo

```bash
git clone https://github.com/Zer0pa/DM3-2026-Restart.git
cd DM3-2026-Restart
```

## Fetch Recoverable Legacy Sources

```bash
./tools/bootstrap_recovery.sh
```

Default layout after bootstrap:

- `../recovery/zer0pamk1-DM-3-Oct`
- `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025`

Override the default recovery root if needed:

```bash
DM3_RECOVERY_ROOT=/path/to/recovery ./tools/bootstrap_recovery.sh
```

## Validate The Recoverable Baseline

```bash
./tools/check_legacy_october.sh
```

That script runs:

- `cargo check --workspace`
- `cargo test --workspace -- --nocapture`

against the October SNIC workspace.

## Optional Comet Setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Set your `COMET_API_KEY` in `.env`, or run `comet login`.

Offline smoke test:

```bash
COMET_OFFLINE_DIRECTORY=.cometml-runs \
  .venv/bin/python tools/comet_manifest_logger.py \
  --manifest examples/comet/run_manifest.example.json \
  --offline
```

## Ready State

A collaborator is ready to start when:

1. the restart repo is cloned
2. `./tools/bootstrap_recovery.sh` succeeds
3. `./tools/check_legacy_october.sh` succeeds
4. Comet setup is either configured or intentionally deferred
5. they have read `.gpd/PROJECT.md`, `.gpd/STATE.md`, and `.gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md`

## Current GPD Entry Point

This repo now includes a fresh GPD project bootstrap for the DM3 restart.

Read in this order:

1. `.gpd/PROJECT.md`
2. `.gpd/STATE.md`
3. `.gpd/ROADMAP.md`
4. `.gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md`
5. `docs/recovery/TEST_REFERENCE_STATUS.md`

The immediate task is not hybrid rebuilding. It is mapping the manifesto's numbered claims to source-backed evidence or explicit gaps, then selecting the narrow battery that must later replay on both Mac host and RM10 Pro.
