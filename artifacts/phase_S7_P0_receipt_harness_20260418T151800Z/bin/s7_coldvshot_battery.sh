#!/system/bin/sh
# S7 / LAB-D1 — cold vs hot hash identity (statistical via S2H-STAT method).
# Two arms × N runs, with operator-intervention checkpoints between arms.
# Thermal auto-abort watchdog active throughout.
# PRD §5.S7 + operator clarification (physical-manipulation mode).

set -u
N="${N:-20}"
CELL=S7_coldvshot
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
COLD_SENT=/data/local/tmp/dm3_harness/continue_s7_cold
HOT_SENT=/data/local/tmp/dm3_harness/continue_s7_hot
CEIL=70000

rm -f "$COLD_SENT" "$HOT_SENT"
trap 'echo "[$(date -u +%T)] EXIT trap" >> $PROG' EXIT

echo "[$(date -u +%T)] S7 start N_per_arm=$N; waiting for COLD sentinel" > "$PROG"
echo "INTERVENTION REQUIRED: set fan level 5, charger plugged, wait for thermal ≤45°C, then:"
echo "  adb shell 'touch $COLD_SENT'"

# Wait for COLD sentinel (poll every 30s)
while [ ! -f "$COLD_SENT" ]; do sleep 30; done
echo "[$(date -u +%T)] COLD sentinel received; verifying thermal" >> "$PROG"

# Verify thermal ≤ 45°C (soft — log warning if higher but proceed)
worst=0
for z in /sys/class/thermal/thermal_zone*; do
  t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
  [ "$t" -gt "$worst" ] && worst=$t
done
echo "[$(date -u +%T)] COLD arm start worst_zone_mc=$worst" >> "$PROG"
[ "$worst" -gt 45000 ] && echo "[$(date -u +%T)] WARN COLD arm thermal already >45000 mC; proceeding anyway" >> "$PROG"

kat_pre=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
echo "kat_pre_cold=$kat_pre" >> "$PROG"
[ "$kat_pre" != "OK" ] && { echo "KAT fail, abort"; exit 4; }

# Start thermal watchdog in background
(
  while true; do
    worst=0
    for z in /sys/class/thermal/thermal_zone*; do
      t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
      [ "$t" -gt "$worst" ] && worst=$t
    done
    if [ "$worst" -gt "$CEIL" ]; then
      echo "[$(date -u +%T)] THERMAL ABORT worst=$worst" >> "$PROG"
      kill -15 $(pidof dm3_runner) 2>/dev/null
      exit 2
    fi
    sleep 1
  done
) &
WD_PID=$!

run_arm() {
  arm="$1"
  i=1
  while [ $i -le $N ]; do
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${arm}_$(printf %03d $i)" "$OUT_DIR" \
      --cpu --mode train --task harmonic --steps 5 >> "$PROG" 2>&1
    rc=$?
    if [ $rc -ne 0 ]; then
      echo "[$(date -u +%T)] arm=$arm run $i rc=$rc halting" >> "$PROG"
      break
    fi
    i=$((i+1))
  done
}

run_arm COLD
echo "[$(date -u +%T)] S7_ARM1_COLD_COMPLETE" >> "$PROG"
kill $WD_PID 2>/dev/null

# 15-min cooldown
echo "[$(date -u +%T)] 15-min inter-arm pause" >> "$PROG"
sleep 900

echo "INTERVENTION REQUIRED: set fan OFF, bypass disabled, then:"
echo "  adb shell 'touch $HOT_SENT'"
while [ ! -f "$HOT_SENT" ]; do sleep 30; done
echo "[$(date -u +%T)] HOT sentinel received; starting HOT arm" >> "$PROG"

kat_pre=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
echo "kat_pre_hot=$kat_pre" >> "$PROG"
[ "$kat_pre" != "OK" ] && { echo "KAT fail, abort"; exit 4; }

# Restart watchdog
(
  while true; do
    worst=0
    for z in /sys/class/thermal/thermal_zone*; do
      t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
      [ "$t" -gt "$worst" ] && worst=$t
    done
    if [ "$worst" -gt "$CEIL" ]; then
      echo "[$(date -u +%T)] THERMAL ABORT worst=$worst" >> "$PROG"
      kill -15 $(pidof dm3_runner) 2>/dev/null
      exit 2
    fi
    sleep 1
  done
) &
WD_PID=$!

run_arm HOT
echo "[$(date -u +%T)] S7_ARM2_HOT_COMPLETE" >> "$PROG"
kill $WD_PID 2>/dev/null

kat_post=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
echo "kat_post=$kat_post" >> "$PROG"

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S7_BATTERY_COMPLETE" >> "$PROG"
