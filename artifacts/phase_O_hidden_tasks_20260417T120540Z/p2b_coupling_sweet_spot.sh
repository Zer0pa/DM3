#!/system/bin/sh
# P2b: coupling sweet spot. Phase L found rot=60 × asym=+0.5 → 3/5 HIGH.
# Fine sweep around that point, plus rot=0 control, plus rot=120 C3-complement.
# N=5 per cell.

set -u
OUT_DIR=/data/local/tmp/phase_P2b_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
: > "$PROG"

cd /data/local/tmp || exit 2

run_cell() {
  label="$1"; shift
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bat=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "?")
  echo "[$start] start $label bat=$bat" >> "$PROG"
  ./dm3_runner --cpu --mode train --task harmonic --steps 5 -o "$out" "$@" > "$log" 2>&1
  rc=$?
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  echo "[$end] done $label rc=$rc lines=$lines" >> "$PROG"
}

# Fine sweep around rot=60° × asym=+0.5 sweet spot
run_cell "rot60_asym_m05" --rotation 60 --asymmetry=-0.5
run_cell "rot60_asym_040"  --rotation 60 --asymmetry 0.40
run_cell "rot60_asym_045"  --rotation 60 --asymmetry 0.45
run_cell "rot60_asym_050"  --rotation 60 --asymmetry 0.50
run_cell "rot60_asym_055"  --rotation 60 --asymmetry 0.55
run_cell "rot60_asym_060"  --rotation 60 --asymmetry 0.60

# rot=0 controls (should be ~0/5 HIGH per Phase L)
run_cell "rot0_asym_045"   --rotation 0  --asymmetry 0.45
run_cell "rot0_asym_050"   --rotation 0  --asymmetry 0.50
run_cell "rot0_asym_055"   --rotation 0  --asymmetry 0.55

# rot=120 C3-complement control (should be ~0/5 per Phase L)
run_cell "rot120_asym_050" --rotation 120 --asymmetry 0.50

# Additional rotations to probe C3 asymmetry
run_cell "rot30_asym_050"  --rotation 30  --asymmetry 0.50
run_cell "rot90_asym_050"  --rotation 90  --asymmetry 0.50

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
