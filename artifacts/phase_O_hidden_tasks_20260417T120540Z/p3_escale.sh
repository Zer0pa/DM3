#!/system/bin/sh
# P3: E-scale relationship between holography (E~15) and harmonic (E~75).
# Phase J slope was ~4.8 E/asym-unit across [-1,+1]. Test if extreme asymmetry
# pushes holography toward the harmonic energy scale.
# Also test harmonic with extreme negative asym to see if it reaches holography E.

set -u
OUT_DIR=/data/local/tmp/phase_P3_receipts
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
  ./dm3_runner --cpu --mode train --steps 5 -o "$out" "$@" > "$log" 2>&1
  rc=$?
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  echo "[$end] done $label rc=$rc lines=$lines" >> "$PROG"
}

# Holography with extreme asymmetry — push E upward
run_cell "holo_asym_p2"    --task holography --asymmetry 2.0
run_cell "holo_asym_p3"    --task holography --asymmetry 3.0
run_cell "holo_asym_p5"    --task holography --asymmetry 5.0

# Holography with extreme negative asym — push E downward
run_cell "holo_asym_m2"    --task holography --asymmetry=-2.0
run_cell "holo_asym_m5"    --task holography --asymmetry=-5.0

# Harmonic with extreme negative asym — push E toward holography range
run_cell "harm_asym_m2"    --task harmonic --asymmetry=-2.0
run_cell "harm_asym_m3"    --task harmonic --asymmetry=-3.0
run_cell "harm_asym_m5"    --task harmonic --asymmetry=-5.0

# Harmonic extreme positive — push beyond E=91 ceiling found in Phase K
run_cell "harm_asym_p2"    --task harmonic --asymmetry 2.0
run_cell "harm_asym_p3"    --task harmonic --asymmetry 3.0

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
