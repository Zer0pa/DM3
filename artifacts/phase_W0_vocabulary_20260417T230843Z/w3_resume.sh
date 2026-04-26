#!/system/bin/sh
# W3 resume: checks which sessions have complete 20-ep JSONL and only runs missing ones.
# Use if device rebooted mid-W3 and the original script died.
# Re-run: adb -s <serial> shell 'nohup /data/local/tmp/w3_resume.sh > /data/local/tmp/phase_W3_resume.log 2>&1 &'

set -u
OUT_DIR=/data/local/tmp/phase_W3_p_high_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

cd /data/local/tmp || exit 2

ALL_SESSIONS="arm_plus02_s1:0.2 arm_plus02_s2:0.2 arm_plus02_s3:0.2 arm_plus02_s4:0.2 arm_plus02_s5:0.2 arm_minus02_s1:-0.2 arm_minus02_s2:-0.2 arm_minus02_s3:-0.2 arm_minus02_s4:-0.2 arm_minus02_s5:-0.2"

is_complete() {
  f="$OUT_DIR/$1.jsonl"
  [ -f "$f" ] || return 1
  n=$(wc -l < "$f" 2>/dev/null | tr -d ' ')
  [ "${n:-0}" -ge 20 ]
}

run_session() {
  label="$1"; asym="$2"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ts_s=$(date +%s)
  echo "[$start] (resume) start $label asym=$asym" >> "$PROG"
  ./dm3_runner --cpu --mode train --task harmonic \
    --asymmetry="$asym" --steps 20 -o "$out" > "$log" 2>&1
  rc=$?
  ts_e=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  dur=$((ts_e - ts_s))
  echo "[$end] (resume) done $label rc=$rc lines=$lines sec=$dur" >> "$PROG"
}

for s in $ALL_SESSIONS; do
  label=$(echo "$s" | cut -d: -f1)
  asym=$(echo "$s" | cut -d: -f2)
  if is_complete "$label"; then
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] (resume) skip $label — already has 20 eps" >> "$PROG"
    continue
  fi
  run_session "$label" "$asym"
  sleep 10
done

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] W3_COMPLETE" >> "$PROG"
