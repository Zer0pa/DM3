# Test Reference Status

This file tracks the current status of the manifesto's numbered `T01-T236` references.

## Current Situation

The manifesto provides a strong narrative taxonomy, but the recovered repos do not currently preserve those numbers as a clean one-to-one executable registry.

What *is* recovered:

- a real deterministic testing protocol in `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md`
- a real CLI guide in `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/AGENT_GUIDE.md`
- real source-backed October tests in the Rust workspace
- real ledgers, proofs, hashes, and receipts in the recovered repos

What is *not yet* recovered:

- a source-backed table mapping every manifesto `Txx` label to a concrete executable artifact

## Initial Classification

| Manifesto family | Status | Notes |
| ---------------- | ------ | ----- |
| `T01-T18` determinism / fixed-point / stability claims | Partially mapped | likely overlaps with contraction, convergence, and deterministic replay tests, but not yet one-to-one |
| `T19-T28` geometry / topology / holography claims | Partially mapped | likely overlaps with dual-meru geometry, invariants, and phase-7 proof candidates |
| `T29-T48` scaling / hardware / precision claims | Partially mapped | overlaps with deterministic protocol and cross-platform replay doctrine |
| `T49-T58` reproducibility / governance claims | Strongly mapped | directly overlaps with ledgers, hashes, Merkle receipts, and deterministic protocol |
| later labels such as `T79`, `T88`, `T124`, `T131-T133`, `T140-T141`, `T230-T236` | Unmapped | present in manifesto prose, but not yet source-linked in the restart repo |

## Rule For Restart Planning

Until a `Txx` label is source-linked here, it may not be cited as established evidence in plans or validation summaries.
