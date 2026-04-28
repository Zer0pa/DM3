# DM3 — Backwards Reconstruction (Static, Tier-2)

Last updated: `2026-04-28`. Workstream root:
`dm3-runner-reconstruction-2026-04-27/`.

This note records the static-Tier-2 state of an independent backwards
reconstruction of `dm3_runner` from the Android aarch64 ELF, the loaded
fixtures, and the host-recomputable invariants. It is anchored in
`CLAIMS.md` "Reconstruction (static, Tier-2)" and
`IS_AND_IS_NOT.md` "Reconstruction (static, Tier-2)".

The note does NOT claim complete reconstruction. R8 (Android execution
trace) remains the sovereign open gate.

---

## Evidence-tier discipline

```text
Tier 1: spectral or scalar observable match only
Tier 2: graph isomorphism / static-disassembly identity / host-recomputable invariants
Tier 3: Android binary-execution trace (argv, openat, output-write)
```

R1–R7 are Tier-2. R8 is Tier-3 and remains open. The note does not
treat Tier-1 spectral matches as identity evidence.

---

## Binary anchor

```text
path = device_artifacts/dm3_runner
sha256 = daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672
type = Android AArch64 PIE, dynamically linked, not stripped
interpreter = /system/bin/linker64
```

Hash matches the live RM10 binary at `/data/local/tmp/dm3_runner` under
`pidof dm3_runner` discipline.

---

## Loaded fixture identity (R1, R3, R7)

```text
SriYantraAdj_v1.bin = P_95 ☐ K_4
vertices = 95 · 4 = 380
edges = (94 · 4) + (95 · C(4,2)) = 946
degree histogram = {4: 8, 5: 372}
```

Coordinate form: vertices `(p, f)` with `p ∈ [0, 94]` and `f ∈ [0, 3]`.
Edges along the path `(p, f) — (p ± 1, f)` and within each station's
`K_4` clique `(p, f) — (p, f')` for `f ≠ f'`.

Closed-form Laplacian spectrum:

```text
λ_{k,j}(P_95 ☐ K_4) = (2 − 2 cos(π k / 95)) + μ_j(K_4)
k = 0..94 ; μ(K_4) ∈ {0, 4, 4, 4}
Fiedler = 0.001093485318147902
λ_max  = 7.9989065146818525
zero count = 1
```

Catalogue invariants:

```text
Aut(P_95 ☐ K_4) = C_2 × S_4
|Aut| = 48
diameter = 95
radius = 48
center vertex count = 4
clique number = 4
chromatic number = 4
independence number = 95
triangles from K_4 slices = 380
induced ladder squares = 564
cycle rank β_1 = 567
```

The previously promoted `C_3` symmetry is preserved as a sub-action of
`S_4` on the four `K_4` fibers. The full automorphism group is
strictly larger than `C_3`.

---

## RegionTags shelling formula (R2)

```text
roots = path-end fibers = 8 vertices of degree 4
distance(v) = BFS distance from v to nearest root
ring(v) = RING_{min(distance(v) // 5, 8) + 1}
type(v) = BOUNDARY if RING_1
        = BINDU    if RING_9
        = BULK     otherwise
sector(v) = zero-based root order reached by BFS
```

Counts:

```text
RING_1..RING_8 = 40 each
RING_9 = 60
BOUNDARY = 40
BULK = 280
BINDU = 60 (central band p ∈ [40, 54], 15 stations × 4 fibers)
```

JSON mismatch count of host-side reconstruction vs `RegionTags_v2.json`:
zero. The legacy `RegionTags_v2.bin` is TAG2/version 2; the current
binary writer string is TAG3/version 3. Whether any live task consumes
the legacy TAG2 binary is an open R8 question.

---

## Internal generated surface (R4)

```text
dm3_runner default skeleton = P_95 ☐ K_3
segments_per_turn = 12
turns = 4
levels = 48
path length = 2 · 48 − 1 = 95
vertices = 95 · 3 = 285
edges = (94 · 3) + (95 · C(3,2)) = 567
degree histogram = {3: 6, 4: 279}
```

Reconstructed via `phase_01_binary_re/scripts/reconstruct_internal_dual_meru.py`.
Static call chain:

```text
main → Dm3CapsuleConfig::default       at 0x1f2b84
default → HelixMeruParams::default     at 0x53e870
main → Dm3State::initialize            at 0x1f2b94
initialize → build_helix_meru          at 0x53eafc
initialize → build_dual_meru           at 0x53eb0c
```

---

## Product-family relation (R5)

```text
internal generated  = P_95 ☐ K_3
loaded fixture      = P_95 ☐ K_4
shared base         = P_95
fiber promotion     = K_3 → K_4
```

Exact arithmetic identity, host-recomputable:

```text
β_1(loaded fixture) = E − V + 1 = 946 − 380 + 1 = 567
                    = E(P_95 ☐ K_3)                   = 567
```

This is a graph-theoretic relation. It is not yet a runtime coupling
proof.

---

## Runtime surface flow (R6, dynamic-open)

Static disassembly separates three runtime surfaces. The L-branch
file-loaded surface is reached via:

```text
generate_tags_v2:
  main → 0x19e440
  open adjacency path at 0x19e498
  serde_json parse at 0x19e4c8
  degree-4 roots and BFS at 0x19e53c..0x19e90c
  ring/type classification at 0x19ed9c..0x19efac

run_spectral_analysis:
  main → 0x19667c
  open adjacency path at 0x1966f8
  serde_json parse at 0x196728
  dense adjacency / Laplacian / nalgebra SymmetricEigen
```

No static call from these L-branch callees to `Dm3State`,
`build_dual_meru`, or `flatten_dual_vertices` was found. R6 is
PASS_STATIC_TIER2_DYNAMIC_OPEN: the static control flow strongly
favours independent file-loaded operation for tag and spectral tasks,
but Tier-3 trace is required to close the dynamic side.

---

## Open gate (R8)

```text
H8 / R8 = OPEN_TIER3_BLOCKED
```

Required when the RM10 device is clear (Phase G chain closed or
operator-cleared):

```text
1. adb -s FY25013101C8 shell pidof dm3_runner   # must return empty
2. capture argv for the target task
3. capture openat events for SriYantraAdj_v1.bin and RegionTags_v2.bin / .json
4. capture output write paths and compare produced tags / spectra against fixtures
5. check whether any Dm3State / build_dual_meru path feeds the L-branch target run
```

Until R8 closes, no claim of complete reconstruction is promoted on
this surface.

---

## Regression gate

```text
script: dm3-runner-reconstruction-2026-04-27/artifacts/phase_03_catalogue_identity/scripts/run_static_authority_checks.py
fails on drift in:
  - fixture P_95 ☐ K_4
  - RegionTags formula
  - closed-form spectrum
  - internal P_95 ☐ K_3
  - product-family relation
  - automorphism order 48
  - diameter 95 / radius 48
  - Betti number 567
  - cycle primitives (380 triangles, 564 induced squares)
```

A future change to the binary that breaks any of these would either
fail this gate or require a documented retraction event in
`RETRACTIONS.md`.

---

## Cross-reference

- `CLAIMS.md` "Reconstruction (static, Tier-2)" — the formal R1..R8 block.
- `IS_AND_IS_NOT.md` "Reconstruction (static, Tier-2)" — IS/IS-NOT.
- `dm3-runner-reconstruction-2026-04-27/artifacts/phase_01_binary_re/PHASE2_GEOMETRY_RECONCILIATION_REPORT.md`
- `.../PRODUCT_FAMILY_RELATION_REPORT.md`
- `.../RUNTIME_SURFACE_FLOW_REPORT.md`
- `.../phase_03_catalogue_identity/GRAPH_IDENTITY_CARD.md`
- `.../phase_05_falsification_harness/H1_H8_STATIC_PREFLIGHT.md`
- `.../PERSISTENT_MEMORY_PACK_2026-04-28/00_README.md`
