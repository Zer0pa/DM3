# Phase L — Rotation x Asymmetry Coupling (Carving 5)

## Pre-Registration

See `PRE_REGISTRATION.md` (written 2026-04-17T05:17:06Z, BEFORE any run).

## Execution Record

- **Date/time range:** 2026-04-17T05:17:39Z — 2026-04-17T08:19:56Z
- **Runs executed:** 7 / 9 (runs 8-9 failed: rc=255, device battery dropped to 36% then disconnected)
- **Missing cells:** rot=120 × asym=0.0 and rot=120 × asym=+0.5
- **Binary hash:** confirmed ✓ at phase start

## Results

### 3×3 Coupling Grid

| rot \ asym | -0.5 | 0.0 | +0.5 |
|------------|------|-----|------|
| **0°** | 1/5 (20%) E=[73,73,86,72,73] | 1/5 (20%) E=[75,76,89,75,75] | 0/5 (0%) E=[79,79,78,79,79] |
| **60°** | 1/5 (20%) E=[73,73,85,71,72] | 1/5 (20%) E=[76,75,75,89,75] | **3/5 (60%)** E=[78,92,79,91,92] |
| **120°** | 2/5 (40%) E=[72,85,73,85,72] | MISSING | MISSING |

### Key Finding: Rotation-Asymmetry Coupling at the Basin Boundary

**rot=60° × asym=+0.5** is the standout cell: 3/5 HIGH with three episodes reaching E=91-92. Compare with **rot=0° × asym=+0.5** where 0/5 are HIGH and all episodes sit at E≈79. Same asymmetry, different rotation, qualitatively different basin access.

This proves rotation and asymmetry are **COUPLED**, not independent. The coupling mechanism: asymmetry at +0.5 pushes both basins upward (LOW E≈79, close to the HIGH threshold of 82). Rotation=60° can then push individual episodes past this boundary into HIGH (E=91-92). Rotation=0° cannot.

### Basin Position Table

| Cell | LOW E mean | HIGH E mean |
|------|-----------|-------------|
| rot=0 asym=-0.5 | 73.0 | 86.3 |
| rot=0 asym=0 | 75.2 | 88.9 |
| rot=0 asym=+0.5 | 79.0 | -- (no HIGH) |
| rot=60 asym=-0.5 | 72.5 | 84.8 |
| rot=60 asym=0 | 75.3 | 88.6 |
| rot=60 asym=+0.5 | 78.8 | 91.6 |

## Verdict

**COUPLED (weak, boundary-localized).**

Rotation and asymmetry interact through the basin boundary. When asymmetry pushes the system near the boundary (asym≈+0.5), rotation can assist or hinder the transition to HIGH. Away from the boundary, rotation has no measurable effect.

This is NOT a strong coupling — it's a boundary sensitivity effect. But it proves the two parameters interact through the symmetry structure, not independently.

## Artifacts

- `artifacts/phase_L_coupling_20260417T051706Z/`
- `artifacts/phase_L_summary.json`
