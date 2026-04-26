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

Session 8 Phase A is mirrored at this endpoint with A.1/A.2/A.3/A.4
receipt trees plus the device harness snapshot. The A5/B3/A6 final
chain is also mirrored with `A5_peak_finder/`, `B3_cli_audit/`,
`A6a_peak_fill/`, and `A6b_post_peak/`, and the external M1 τ packet is
mirrored under `artifacts/phase_S8_AGDH1_external_M1_20260424/`. The
current scientific truth floor promotes the receipt-backed `ξ`, `ο`,
and `τ` lines and records `π`, `ρ`, `σ″`, and `φ` as candidates. The
Phase A total-run count seam, rejected-before-promoted `σ`/`σ′`
history, and κ B3 nuance are documented in
`repo_stage/REPO_AGENT_FINDINGS.md`.

Counterparties should rely on `ARTEFACT_BUNDLE_REGISTER.tsv` for the current
per-file SHA-256 and path inventory.
