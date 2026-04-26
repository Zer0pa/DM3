#!/system/bin/sh
set -eu
# No RNG
if grep -R --line-number -E '\brand::|thread_rng|StdRng|ChaCha' crates >/dev/null 2>&1; then
  echo "[POLICY] RNG usage detected — disallowed"; exit 13; fi
# No floats in core crates (allow in io_cli only if needed for timestamps)
if grep -R --line-number -E '\bf32\b|\bf64\b' crates/geometry_core crates/yantra_2d crates/lift_3d crates/dynamics_deq crates/invariants crates/proof_gates >/dev/null 2>&1; then
  echo "[POLICY] Float types detected in core crates — disallowed"; exit 14; fi
echo "[POLICY] PASS"
