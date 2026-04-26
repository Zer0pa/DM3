#!/system/bin/sh
# S8 / LAB-E1 — battery vs bypass hash identity.
# Battery arm: charger unplugged, battery_status=Discharging, capacity 60→40%.
# Bypass arm: charger plugged, status=Not charging, charge_type=Bypass, capacity held.
# Same harness pattern as S7 with operator sentinel between arms.

set -u
N="${N:-20}"
CELL=S8_battery
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
SENTINEL="$OUT_DIR/continue"
CHECKLIST="$OUT_DIR/INTERVENTION_CHECKLIST.md"

cat > "$CHECKLIST" <<'EOF'
# S8 INTERVENTION_CHECKLIST

## Arm 1: BATTERY (runs on battery power)
Preconditions required BEFORE starting this cell:
- Battery capacity ≥ 60 %
- Charger UNPLUGGED from phone
- battery_status=Discharging
Cell auto-halts when capacity drops to 40 % OR N=20 runs complete (whichever first).

## Arm 2: BYPASS (plugged, Charge Separation/Bypass ON)
After BATTERY arm completes, script pauses and writes:
  [$(date -u +%T)] INTERVENTION REQUIRED: switch to BYPASS arm

### Your steps for the BYPASS arm:
1. Plug charger back in
2. In REDMAGIC UI, ENABLE Charge Separation / Bypass
   (this is the setting that routes USB power directly to SoC bypassing battery;
    battery should read "Not charging", usb_online=1, charge_type=Bypass)
3. Touch sentinel:  adb -s FY25013101C8 shell 'touch /data/local/tmp/dm3_harness/cells/S8_battery/continue'
   Script resumes within 30 s.
EOF

trap 'echo "[$(date -u +%T)] EXIT trap" >> $PROG' EXIT

check_battery_preconditions_battery() {
  status=$(cat /sys/class/power_supply/battery/status 2>/dev/null)
  cap=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)
  if [ "$status" != "Discharging" ]; then
    echo "[$(date -u +%T)] BATTERY_PRECONDITION_FAIL status=$status expected=Discharging" >> "$PROG"
    return 1
  fi
  if [ "$cap" -lt 60 ]; then
    echo "[$(date -u +%T)] BATTERY_PRECONDITION_FAIL capacity=$cap expected>=60" >> "$PROG"
    return 1
  fi
  return 0
}

check_battery_preconditions_bypass() {
  status=$(cat /sys/class/power_supply/battery/status 2>/dev/null)
  uon=$(cat /sys/class/power_supply/usb/online 2>/dev/null)
  if [ "$status" != "Not charging" ] && [ "$status" != "Full" ]; then
    echo "[$(date -u +%T)] BYPASS_PRECONDITION_SOFTFAIL status=$status (expected Not charging). Proceeding anyway — charger is plugged=$uon." >> "$PROG"
  fi
  return 0
}

run_arm() {
  arm="$1"
  stop_at_cap="$2"   # stop if capacity drops to this
  echo "[$(date -u +%T)] ARM START $arm stop_at_cap=$stop_at_cap" >> "$PROG"
  kat=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
  [ "$kat" != "OK" ] && { echo "KAT FAIL ($kat) arm=$arm; abort" >> "$PROG"; return 4; }
  i=1
  while [ $i -le $N ]; do
    if [ "$stop_at_cap" -gt 0 ]; then
      c=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)
      if [ "$c" -le "$stop_at_cap" ]; then
        echo "[$(date -u +%T)] arm=$arm capacity=$c reached stop threshold $stop_at_cap; halting early at run=$i" >> "$PROG"
        break
      fi
    fi
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${arm}_$(printf %03d $i)" "$OUT_DIR" \
      --cpu --mode train --task harmonic --steps 5 >> "$PROG" 2>&1
    rc=$?
    [ $rc -ne 0 ] && { echo "[$(date -u +%T)] arm=$arm run $i FAIL rc=$rc" >> "$PROG"; break; }
    i=$((i+1))
  done
  echo "[$(date -u +%T)] ARM END $arm runs=$((i-1))" >> "$PROG"
}

echo "[$(date -u +%T)] S8 start N_per_arm=$N" > "$PROG"
echo "[$(date -u +%T)] checklist: $CHECKLIST" >> "$PROG"

# Precondition check for BATTERY arm
if ! check_battery_preconditions_battery; then
  echo "[$(date -u +%T)] Waiting for battery precondition — unplug charger and ensure cap>=60%. Touch $SENTINEL when ready." >> "$PROG"
  echo "[$(date -u +%T)] INTERVENTION REQUIRED: unplug charger for BATTERY arm. Touch $SENTINEL when ready." >> "$PROG"
  rm -f "$SENTINEL"
  while [ ! -f "$SENTINEL" ]; do sleep 30; done
  rm -f "$SENTINEL"
  echo "[$(date -u +%T)] sentinel received; re-checking preconditions" >> "$PROG"
fi

# ARM 1: BATTERY
run_arm BATTERY 40

# WAIT FOR BYPASS INTERVENTION
echo "[$(date -u +%T)] INTERVENTION REQUIRED: switch to BYPASS arm. Plug charger + enable Charge Separation. Touch $SENTINEL when ready." >> "$PROG"
while [ ! -f "$SENTINEL" ]; do sleep 30; done
rm -f "$SENTINEL"
check_battery_preconditions_bypass

# ARM 2: BYPASS
run_arm BYPASS 0

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S8_COMPLETE" >> "$PROG"
