#!/system/bin/sh
# P2a: intra-session basin correlation. 5 sessions of --steps 20 at default params.
# Between sessions: 30s idle. Survives disconnect under nohup.

set -u
OUT_DIR=/data/local/tmp/phase_P2a_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
: > "$PROG"

cd /data/local/tmp || exit 2

i=1
while [ $i -le 5 ]; do
  out="$OUT_DIR/session_${i}.jsonl"
  log="$OUT_DIR/session_${i}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bat=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "?")
  echo "[$start] session=$i start battery=$bat" >> "$PROG"
  ./dm3_runner --cpu --mode train --task harmonic --steps 20 -o "$out" > "$log" 2>&1
  rc=$?
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  bat2=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "?")
  echo "[$end] session=$i done rc=$rc lines=$lines battery=$bat2" >> "$PROG"
  i=$((i+1))
  if [ $i -le 5 ]; then
    sleep 30
  fi
done
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
