#!/usr/bin/env bash
set -euo pipefail

required=(
  "artifacts/geometry/dual_meru_geometry_report.json"
  "artifacts/deq/dual_meru_deq.json"
  "artifacts/resonance/dual_meru_resonance_cpu.json"
  "artifacts/checksums/432_440.json"
  "artifacts/checksums/mod24_wheel.json"
  "artifacts/summary.json"
  "artifacts/repro_diff.txt"
)

for f in "${required[@]}"; do
  if [ "$f" = "artifacts/repro_diff.txt" ]; then
    if [ ! -f "$f" ]; then
      echo "Missing artifact: $f" >&2
      exit 1
    fi
  else
    if [ ! -s "$f" ]; then
      echo "Missing artifact: $f" >&2
      exit 1
    fi
  fi
  if grep -EIq "(TBD|STUB|Not yet implemented|PLACEHOLDER)" "$f"; then
    echo "Placeholder detected in $f" >&2
    exit 1
  fi
done

if [ ! -f artifacts/repro_diff.txt ]; then
  echo "artifacts/repro_diff.txt missing" >&2
  exit 1
fi
size=$(wc -c < artifacts/repro_diff.txt)
if [ "$size" -ne 0 ]; then
  echo "Repro diff non-zero ($size bytes)" >&2
  exit 1
fi

if ! jq -e '.cpu_only == true' artifacts/summary.json >/dev/null; then
  echo "Summary must be CPU-only" >&2
  exit 1
fi

if ! jq -e '.status == "COMPLETE"' artifacts/summary.json >/dev/null; then
  echo "Summary status must be COMPLETE" >&2
  exit 1
fi

for gate in geometry deq resonance negative_controls prosody; do
  if [ "$(jq -r ".gates.$gate" artifacts/summary.json)" != "pass" ]; then
    echo "Gate $gate failed" >&2
    exit 1
  fi
done

echo "ship_guard: OK"
