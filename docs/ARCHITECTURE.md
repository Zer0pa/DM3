# DM3 Architecture

## Product Shape

DM3 is a structural diagnostic on a fixed graph, not a general-purpose codec.
The canonical README spine still applies, but the `Architecture` and
`Encoding` fields act as product identity tags for this instrument-shaped
surface.

## Repo Layout

- `README.md` is the parser-safe front door.
- `repo_stage/` holds the promoted DM3 claim packet currently feeding the root
  surface.
- `proofs/manifests/` holds root authority summaries.
- `validation/results/` holds structural checks on the repo surface.
- `docs/restart/` and `artifacts/` remain the live engineering lane.
- `.gpd/` remains internal state and planning machinery.

## Non-Collision Rule

Root repo organization work can update the front door, legal/docs scaffolding,
and root manifests. It must not rewrite live session artifacts, `.gpd` state,
or raw engineering receipts just to make the surface look cleaner.
