#!/system/bin/sh
# W3 serial: p(HIGH) parameter dependence.
# Arm A: asym=+0.2, 5 sessions × 20 eps = 100 eps
# Arm B: asym=-0.2, 5 sessions × 20 eps = 100 eps
# Arm 0 (asym=0): uses Session 5 P2a data (N=100)
# Serial execution (parallel hurts on this binary).

set -u
OUT_DIR=/data/local/tmp/phase_W3_p_high_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
: > "$PROG"

cd /data/local/tmp || exit 2

run_session() {
  label="$1"; asym="$2"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ts_s=$(date +%s)
  echo "[$start] start $label asym=$asym" >> "$PROG"
  ./dm3_runner --cpu --mode train --task harmonic \
    --asymmetry="$asym" --steps 20 -o "$out" > "$log" 2>&1
  rc=$?
  ts_e=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  dur=$((ts_e - ts_s))
  echo "[$end] done $label rc=$rc lines=$lines sec=$dur" >> "$PROG"
}

# Arm A: asym=+0.2
for i in 1 2 3 4 5; do
  run_session "arm_plus02_s$i" 0.2
  sleep 20
done

# Arm B: asym=-0.2
for i in 1 2 3 4 5; do
  run_session "arm_minus02_s$i" -0.2
  sleep 20
done

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] W3_COMPLETE" >> "$PROG"
