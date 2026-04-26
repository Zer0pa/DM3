#!/system/bin/sh
# W2 parallel: harmonic asym ∈ {-5,-4,-3.5,-3,-2.5} × N=10 eps (2× concurrent)
# + holography mirror asym ∈ {-5,-3} × N=5 eps (2× concurrent)
# All sessions pre-registered; each is its own --output file.
# 2× concurrency, 70°C thermal ceiling check before each launch.

set -u
OUT_DIR=/data/local/tmp/phase_W2_third_regime_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
: > "$PROG"

cd /data/local/tmp || exit 2

# Thermal check: pause new launches if zone0 > 70000 (70°C)
thermal_ok() {
  t=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
  if [ -z "$t" ] || [ "$t" = "0" ]; then
    # fallback to zone2
    t=$(cat /sys/class/thermal/thermal_zone2/temp 2>/dev/null || echo 0)
  fi
  if [ "$t" -gt 70000 ]; then
    echo "[$(date -u +%T)] thermal $t mC too hot, waiting..." >> "$PROG"
    return 1
  fi
  return 0
}

# Collision check: any non-agent dm3_runner?
# Our script forks dm3_runner from this shell, so all agent PIDs are descendants.
# Just check nothing was there before.

start_cell() {
  label="$1"; task="$2"; asym="$3"; steps="$4"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "[$start] spawn $label task=$task asym=$asym steps=$steps" >> "$PROG"
  ./dm3_runner --cpu --mode train --task "$task" \
    --asymmetry="$asym" --steps "$steps" -o "$out" > "$log" 2>&1 &
  echo "$!" > "$OUT_DIR/${label}.pid"
}

wait_for_cell() {
  label="$1"
  pidf="$OUT_DIR/${label}.pid"
  [ -f "$pidf" ] || return
  pid=$(cat "$pidf")
  while kill -0 "$pid" 2>/dev/null; do sleep 20; done
  rm -f "$pidf"
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  out="$OUT_DIR/${label}.jsonl"
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  echo "[$end] done $label lines=$lines" >> "$PROG"
}

# Harmonic cells: 5 cells at asym ∈ {-5,-4,-3.5,-3,-2.5} × steps=10 (gets 10 eps per session)
# Steps=10 for harmonic task means 10 episodes.
# Pair (1,2), (3,4), (5) - run 2-at-a-time

HARM_CELLS="H_m5:-5.0 H_m4:-4.0 H_m35:-3.5 H_m3:-3.0 H_m25:-2.5"

# Start first two harmonic
first=""; second=""; rest=""
for c in $HARM_CELLS; do
  if [ -z "$first" ]; then first="$c"
  elif [ -z "$second" ]; then second="$c"
  else rest="$rest $c"
  fi
done

lbl1=$(echo "$first" | cut -d: -f1); a1=$(echo "$first" | cut -d: -f2)
lbl2=$(echo "$second" | cut -d: -f1); a2=$(echo "$second" | cut -d: -f2)

while ! thermal_ok; do sleep 10; done
start_cell "$lbl1" harmonic "$a1" 10
start_cell "$lbl2" harmonic "$a2" 10

for c in $rest; do
  lblN=$(echo "$c" | cut -d: -f1); aN=$(echo "$c" | cut -d: -f2)
  # Wait for one slot to free
  wait_for_cell "$lbl1"
  lbl1="$lbl2"; a1="$a2"
  lbl2="$lblN"; a2="$aN"
  while ! thermal_ok; do sleep 10; done
  start_cell "$lbl2" harmonic "$a2" 10
done

# Wait for both remaining
wait_for_cell "$lbl1"
wait_for_cell "$lbl2"

# Holo mirror: 2 cells at asym ∈ {-5, -3} × steps=5
HOLO_CELLS="HO_m5:-5.0 HO_m3:-3.0"
for c in $HOLO_CELLS; do
  lbl=$(echo "$c" | cut -d: -f1); a=$(echo "$c" | cut -d: -f2)
  while ! thermal_ok; do sleep 10; done
  start_cell "$lbl" holography "$a" 5
done
# Wait for both holo
for c in $HOLO_CELLS; do
  lbl=$(echo "$c" | cut -d: -f1)
  wait_for_cell "$lbl"
done

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
