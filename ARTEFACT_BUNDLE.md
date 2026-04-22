# DM3 Artefact Bundle Register

This file is the human-readable root entry point for the Artefact Bundle
Register under License Sections 3 and 19.3(a).

## Canonical Register

- File-level SHA-256 register: [ARTEFACT_BUNDLE_REGISTER.tsv](ARTEFACT_BUNDLE_REGISTER.tsv)
- Source surface mirrored into that register:
  `repo_stage/MANIFEST.tsv`
- The register intentionally excludes a self-hash row for
  `ARTEFACT_BUNDLE_REGISTER.tsv` to avoid recursive hash drift.

## Current Bundle Scope

The current bundle register covers the published DM3 repository surface at this
endpoint, including:

- the compiled DM3 binary and receipted artifact trees mirrored in `artifacts/`
- the promoted scientific ledgers and product packet
- the root public compliance surface (`README.md`, `LICENSE`, `CLAIMS.md`,
  `IS_AND_IS_NOT.md`, `RETRACTIONS.md`, `CONTACT.md`, `TRADEMARK.md`)
- supporting manifests and validation outputs used by the root README

Counterparties should rely on `ARTEFACT_BUNDLE_REGISTER.tsv` for the current
per-file SHA-256 and path inventory.
