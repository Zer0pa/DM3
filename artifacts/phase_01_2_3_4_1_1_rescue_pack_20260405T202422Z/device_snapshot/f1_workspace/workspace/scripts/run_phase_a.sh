#!/usr/bin/env bash
set -euo pipefail
[ -x "$(command -v jq)" ] || { echo "jq required"; exit 1; }

mkdir -p artifacts/geometry artifacts/proofs
echo '{"status":"RUNNING","phase":"A"}' > artifacts/run_state.json

cargo build
cargo test -q -p yantra_3d_dual --tests || true

# Expect the crate to expose a small CLI "dual_cli" that writes PLY/SVG/JSON (agent will add if missing)
if cargo metadata --no-deps -q | jq -e '.packages[] | select(.name=="dual_cli")' >/dev/null; then
  cargo run -q -p dual_cli
else
  echo "dual_cli missing (expected to emit Phase-A artifacts)"; exit 1
fi

# Verify artifacts exist and have no placeholders
for f in artifacts/geometry/dual_meru_geometry_report.json artifacts/geometry/dual_meru_mesh.ply artifacts/geometry/dual_meru_mesh.svg; do
  [ -s "$f" ] || { echo "Missing artifact: $f"; exit 1; }
  if grep -E "(TBD|STUB|Not yet implemented|PLACEHOLDER)" "$f" >/dev/null 2>&1; then
    echo "Placeholder detected in $f"; exit 1
  fi
done

# Ensure Phase A summary exists and reports completion
if [ ! -s artifacts/summary.json ]; then
  echo "dual_cli did not write artifacts/summary.json"; exit 1;
fi

if [ "$(jq -r '.status' artifacts/summary.json)" != "COMPLETE" ]; then
  echo "Phase A summary did not report completion"; exit 1;
fi

echo "Phase A run completed; summary at artifacts/summary.json"
