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
- a recoverable source tree for the later hybrid DM3 runner
- a finished Dual-Meru battery with full receipts and non-placeholder Merkle outputs

## Source-Backed Anchor Surfaces

The restart now has a stricter anchor order:

1. `genesis_cli` deterministic batteries and ledgers in `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/`
2. October SNIC proof-harness scripts and receipts in `../recovery/zer0pamk1-DM-3-Oct/snic/`
3. October Dual-Meru bring-up notes and partial scripts, which remain weaker than the two proof-harness layers above

See `../restart/LEGACY_BATTERY_ENTRYPOINTS.md` for the concrete command inventory.

## Current Classification

| Manifesto family or label | Status | Strongest locators now | Notes |
| ------------------------- | ------ | --------------------- | ----- |
| `T01-T18` determinism / fixed-point / stability claims | Collapsed and partially mapped | `../recovery/zer0pamk1-DM-3-Oct/snic/docs/BUILD_REPORT.md`, `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md` | strong evidence survives for contraction, monotone energy notes, deterministic replay, and governed hashes, but not as a preserved one-label-per-test registry |
| `T19-T28` geometry / topology claims | Partially mapped | `../recovery/zer0pamk1-DM-3-Oct/snic/scripts/REPRODUCE.sh`, `../recovery/zer0pamk1-DM-3-Oct/snic/scripts/VERIFY.sh`, `../recovery/zer0pamk1-DM-3-Oct/snic/receipts/PROOFS.md` | geometry, lift, and GC invariant surfaces survive; holography and richer mode-lock claims do not yet have clean source-backed replay surfaces |
| `T29-T48` scaling / hardware / precision claims | Partially mapped | `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md`, `../restart/HARDWARE_LANE_BASELINE.md` | cross-platform replay doctrine survives; GPU/NPU and stronger mixed-device claims do not |
| `T49-T58` reproducibility / governance claims | Strongly mapped | `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md`, `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/AGENT_GUIDE.md`, `../recovery/zer0pamk1-DM-3-Oct/snic/ORGANISM-HASH-README.md` | ledgers, canonical hashes, Merkle receipts, validation, and audit-report generation are real and source-backed |
| `T79` extra energy-descent stress claim | Collapsed into `T01-T18` family | `../recovery/zer0pamk1-DM-3-Oct/snic/docs/BUILD_REPORT.md` | there is surviving energy-descent evidence, but not a preserved standalone `T79` artifact |
| `T88` scaling / capacity claim | Unmapped | none yet | no preserved source-backed capacity or trace-count stress surface has been found |
| `T124` tighter-tolerance stability claim | Unmapped | none yet | the manifesto claim exists, but the exact 10x-tolerance replay surface was not recovered |
| `T131-T133` holographic masking / ECC claims | Unmapped | none yet | no preserved boundary-mask or ECC receipt surface has been recovered |
| `T140-T141` noise-floor / adversarial-threshold claims | Unmapped | none yet | no preserved source-backed acceptance battery for these thresholds has been recovered |
| `T230-T233` gauge / cyclic claims | Unmapped | none yet | no source-backed implementation of gauge receipts or cyclic attractor receipts has been recovered |
| `T234-T236` heterogeneous execution / equivalence claims | Partially mapped but weak | `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md`, `../recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/AGENT_GUIDE.md` | exact-hash cross-platform replay survives; unified-memory and non-bitwise-equivalence receipt claims do not |

## Important Distinction

The October repo does preserve a real proof harness and a real Dual-Meru intent surface.
It does **not** preserve a completed Dual-Meru receipt-governed battery that would let the restart claim the full late-manifesto story as source-backed.

## Rule For Restart Planning

Until a `Txx` label is source-linked here, it may not be cited as established evidence in plans or validation summaries.
