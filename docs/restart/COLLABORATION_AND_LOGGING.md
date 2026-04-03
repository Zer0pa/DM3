# Collaboration And Logging

## Repo Operating Model

- This repo is the canonical restart workspace for DM3 collaborators and machines.
- Local recovery clones and raw forensic artifacts stay outside this repo unless they are deliberately curated in.
- Every serious run should emit both local receipts and Comet metadata.
- Branch names and Comet tags should make it obvious what hypothesis is being tested.

## Multi-Machine Rules

1. Use environment variables or `~/.comet.config` for Comet credentials.
2. Never commit API keys or local-machine secrets.
3. Tag runs with:
   - branch name
   - machine class
   - run purpose
   - acceptance lane
4. Keep manifests small and machine-readable.

## Comet Defaults

- Workspace: `zer0pa`
- Project: `dm3`
- Preferred local env file: `.env`
- Preferred offline directory: `.cometml-runs/`

## Suggested Run Tags

- `restart`
- `baseline`
- `geometry-only`
- `deq`
- `hybrid`
- `mac-host`
- `soc-device`
- `acceptance`
- `smoke`

## Logging Workflow

1. Define a manifest JSON for the run.
2. Start or resume the Comet experiment through `tools/comet_manifest_logger.py`.
3. Write the returned experiment key into the run directory or receipt bundle.
4. Store final local artifacts and refer back to the Comet experiment key.

## Online And Offline

- Use online mode when the machine has stable connectivity and the run is not secret-constrained.
- Use offline mode for device-side or unstable-network runs, then upload later.

## Why The Repo Uses A Neutral Logging Shim

The restart code may be Rust-heavy, Python-heavy, or mixed. A small manifest-driven Comet logger lets all of those runtimes log to the same project without forcing the core experiment code into one language too early.
