# Validator Default Rule Ledger

Last refreshed: `2026-04-05`

## Purpose

Freeze the live RM10 validator-default defect at the exact selector and baked-in
pair level for phase `01.2.3.4.1`, without confusing explicit-hash override
with default-path repair.

## Fresh Phase-Local Packet

- Fresh packet:
  `artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/`
- Prior retained packet:
  `artifacts/rm10_validator_probe_20260405T170530Z/`

Both packets agree on the live behavior:

- default validation on the retained historical RM10 parity witness exits `1`
- explicit-hash validation on that same witness exits `0`
- the failure is `verify=false, solve=true`

## Exact Default Path

The active default path is not a dynamic selector tree. It is a fixed compiled
comparison path:

1. the binary loads `artifacts/verify.json` and `artifacts/solve_h2.json` from
   the supplied `--reference-dir`
2. if `--verify-hash` and `--solve-hash` are not passed, it compares those live
   file hashes against compiled canonical constants
3. explicit override bypasses the compiled defaults and succeeds on the retained
   historical witness

The live device help retained in
`artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/identity/binary_help.txt`
shows only:

- `--reference-dir`
- optional `--verify-hash`
- optional `--solve-hash`

That means the live defect is exactly on the compiled default constants or the
logic that falls back to them, not on a hidden selector family discovered so
far.

## Exact Baked-In Pair

The live device binary hash is:

- `e64ec08e4f8dedddea05b00b3c84c830ee3c9d5afb7cbb1acd4ade5c6f51bcae`
  for `/data/local/tmp/genesis_cli`

The fresh packet retains embedded hash strings in
`artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/identity/embedded_hash_strings.txt`.
Those strings still expose:

- `97bd7d121e03e7c35505bd889f85630d6f8d78abbdc6fad1c5654d6743b9ba89`
- `62897b8c26de3af1a78433807c5607fb8c82f061d1457e9c43e2aa5d35fe7780`

The recovery source mirrors that pair in:

- `recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/crates/genesis_cli/src/main.rs`
- `recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/VALIDATION.md`
- `recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/README.md`

## Live Witness Pair Actually On Device

The fresh phase-local packet retains the device-side reference hashes in
`artifacts/phase_01_2_3_4_1_validator_default_20260405T183234Z/identity/reference_hashes.txt`.
The live historical RM10 witness currently staged on the device is:

- `verify.json = e8941414a25c7c8e1aed6b3f5c032c00a69e85ae6964555301ff48dee44009e3`
- `solve_h2.json = 62897b8c26de3af1a78433807c5607fb8c82f061d1457e9c43e2aa5d35fe7780`

So the live mismatch is not a missing reference directory or absent artifact.
The directory exists, the files exist, and the solve hash still matches.
Only the compiled default `verify` side is stale against the surviving witness.

## Surviving Payload Check

The recovery and restart trees were scanned for a surviving `verify.json` with
hash `97bd...`.

Result:

- no surviving `verify.json` payload with hash `97bd...` was found under
  `recovery/` or `restart/`
- multiple documents, ledgers, and receipt files still cite `97bd...`
- the active recovery workspace payloads now hash to `e894...`

That means the stale compiled default pair is stronger than a documentation
drift note. It currently points at a verify canonical that does not survive as a
live payload in the active recovery or restart trees.

## Comparison Matrix

| Surface | `verify.json` | `solve_h2.json` | Default path | Explicit override | What it proves |
| --- | --- | --- | --- | --- | --- |
| live device compiled default pair | `97bd...` in binary strings and source pins | `62897...` in binary strings and source pins | fails on the retained witness | not applicable | the default compare target is stale on at least `verify` |
| retained historical RM10 parity witness on device | `e894...` | `62897...` | `FAIL` | `PASS` | the witness is present and the mismatch is on default handling, not bundle presence |
| active recovery payloads on host | `e894...` | `62897...` | not exercised on device here | not applicable | the active recovery tree no longer carries a live `97bd...` verify payload |

## Exact Verdict

Verdict: `precisely_localized_not_repaired`

Exact failure site:

- the live RM10 default validator falls back to a stale compiled `verify`
  constant (`97bd...`) while the surviving authoritative witness and active
  recovery payloads are `e894...`

Exact non-failure site:

- `solve_h2.json` remains aligned at `62897...`
- the reference directory exists and is readable
- explicit-hash validation succeeds on the same retained witness

## Repaired-Or-Not

- repaired: `no`
- precisely localized: `yes`
- operator-policy route required: `likely yes`

The current device binary is prebuilt. Changing the default rule now requires
one of:

1. patching the source constant and redeploying a rebuilt `genesis_cli`
2. accepting explicit-hash handling as the governed live rule until a rebuilt
   binary is authorized

## Next Admissible Move

Do not narrate explicit-hash validation as repaired default validation.

The next admissible validator move is:

- keep governed RM10 validation under explicit-hash handling for now
- decide whether phase `01.2.3.4.1` is authorized to rebuild and redeploy
  `genesis_cli` with the live `e894...` witness as the default `verify` target

