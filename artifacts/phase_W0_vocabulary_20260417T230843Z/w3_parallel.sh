#!/system/bin/sh
# W3 parallel: p(HIGH) parameter dependence.
# 2 new arms (asym=+0.2, asym=-0.2), each 5 sessions × 20 eps = 100 eps.
# Arm 0 (asym=0) already has N=100 from Session 5 P2a.
# Parallelize across sessions: 3 concurrent sessions total.

set -u
OUT_DIR=/data/local/tmp/phase_W3_p_high_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
: > "$PROG"

cd /data/local/tmp || exit 2

thermal_ok() {
  t=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
  [ -z "$t" ] || [ "$t" = "0" ] && t=$(cat /sys/class/thermal/thermal_zone2/temp 2>/dev/null || echo 0)
  [ "$t" -gt 70000 ] && return 1
  return 0
}

start_session() {
  arm="$1"; n="$2"; asym="$3"
  label="${arm}_s${n}"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "[$start] spawn $label asym=$asym" >> "$PROG"
  ./dm3_runner --cpu --mode train --task harmonic \
    --asymmetry="$asym" --steps 20 -o "$out" > "$log" 2>&1 &
  echo "$!" > "$OUT_DIR/${label}.pid"
}

wait_session() {
  label="$1"
  pidf="$OUT_DIR/${label}.pid"
  [ -f "$pidf" ] || return
  pid=$(cat "$pidf")
  while kill -0 "$pid" 2>/dev/null; do sleep 30; done
  rm -f "$pidf"
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  out="$OUT_DIR/${label}.jsonl"
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  echo "[$end] done $label lines=$lines" >> "$PROG"
}

# Build session list: arm_plus02_s1..s5, arm_minus02_s1..s5 (10 sessions total)
SESSIONS="plus02:0.2:1 plus02:0.2:2 plus02:0.2:3 plus02:0.2:4 plus02:0.2:5 minus02:-0.2:1 minus02:-0.2:2 minus02:-0.2:3 minus02:-0.2:4 minus02:-0.2:5"

# 3-slot pipeline
SLOT1=""; SLOT2=""; SLOT3=""
for s in $SESSIONS; do
  arm=$(echo "$s" | cut -d: -f1)
  asym=$(echo "$s" | cut -d: -f2)
  n=$(echo "$s" | cut -d: -f3)
  label="arm_${arm}_s${n}"

  # Find free slot or wait
  while true; do
    if [ -z "$SLOT1" ] || ! [ -f "$OUT_DIR/${SLOT1}.pid" ]; then
      while ! thermal_ok; do sleep 30; done
      start_session "arm_${arm}" "$n" "$asym"
      SLOT1="$label"
      break
    elif [ -z "$SLOT2" ] || ! [ -f "$OUT_DIR/${SLOT2}.pid" ]; then
      while ! thermal_ok; do sleep 30; done
      start_session "arm_${arm}" "$n" "$asym"
      SLOT2="$label"
      break
    elif [ -z "$SLOT3" ] || ! [ -f "$OUT_DIR/${SLOT3}.pid" ]; then
      while ! thermal_ok; do sleep 30; done
      start_session "arm_${arm}" "$n" "$asym"
      SLOT3="$label"
      break
    else
      sleep 30
      # Cleanup finished pids
      for sl in "$SLOT1" "$SLOT2" "$SLOT3"; do
        if [ -n "$sl" ] && [ -f "$OUT_DIR/${sl}.pid" ]; then
          pid=$(cat "$OUT_DIR/${sl}.pid")
          if ! kill -0 "$pid" 2>/dev/null; then
            wait_session "$sl"
          fi
        fi
      done
    fi
  done
done

# Wait for all remaining
for sl in "$SLOT1" "$SLOT2" "$SLOT3"; do
  [ -n "$sl" ] && wait_session "$sl"
done

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
