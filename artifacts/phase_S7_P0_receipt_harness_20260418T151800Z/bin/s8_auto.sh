#!/system/bin/sh
# S8 AUTO — battery vs bypass; operator-friendly, zero sentinel dependency.
# Transitions triggered by battery_status changes, no ADB required.
#
# Flow:
#  1. WAIT: waits for battery_status=Discharging (operator unplugs cable)
#  2. BATTERY arm: runs harmonic --steps 5 until cap<=40 OR N=20.
#  3. WAIT: waits for charger to be reconnected (status != Discharging).
#     Preferred: charge_type=Bypass (Charge Separation enabled).
#     If charge_type=Bypass → proceed to BYPASS arm.
#     If charge_type != Bypass → wait another 60s for operator to toggle bypass,
#       then proceed anyway (documented as "bypass-not-detected" in progress.txt).
#  4. BYPASS arm: N=20 runs harmonic --steps 5.
#  5. Summary + S8_COMPLETE marker.

set -u
N="${N:-20}"
CELL=S8_battery
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT trap" >> $PROG' EXIT

wait_status() {
  want="$1"
  echo "[$(date -u +%T)] waiting for battery_status=$want" >> "$PROG"
  while true; do
    s=$(cat /sys/class/power_supply/battery/status 2>/dev/null)
    if [ "$s" = "$want" ]; then
      echo "[$(date -u +%T)] battery_status=$s matched" >> "$PROG"
      return
    fi
    sleep 15
  done
}

wait_not_status() {
  nope="$1"
  echo "[$(date -u +%T)] waiting for battery_status != $nope" >> "$PROG"
  while true; do
    s=$(cat /sys/class/power_supply/battery/status 2>/dev/null)
    if [ "$s" != "$nope" ]; then
      echo "[$(date -u +%T)] battery_status=$s matched (not $nope)" >> "$PROG"
      return
    fi
    sleep 15
  done
}

run_arm() {
  arm="$1"; stop_at_cap="$2"
  echo "[$(date -u +%T)] ARM START $arm stop_at_cap=$stop_at_cap" >> "$PROG"
  kat=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
  [ "$kat" != "OK" ] && { echo "KAT FAIL ($kat) arm=$arm; abort" >> "$PROG"; return 4; }
  i=1
  while [ $i -le $N ]; do
    if [ "$stop_at_cap" -gt 0 ]; then
      c=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)
      if [ "$c" -le "$stop_at_cap" ]; then
        echo "[$(date -u +%T)] arm=$arm capacity=$c <= $stop_at_cap; halting at run=$i" >> "$PROG"
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

echo "[$(date -u +%T)] S8 AUTO start N_per_arm=$N" > "$PROG"
echo "[$(date -u +%T)] Flow: waits for unplug → BATTERY arm → waits for replug → BYPASS arm → summary" >> "$PROG"
echo "[$(date -u +%T)] OPERATOR: unplug charger now to start BATTERY arm" >> "$PROG"

# Wait for unplug (status=Discharging)
wait_status Discharging

# BATTERY arm
run_arm BATTERY 40

# Wait for replug (status != Discharging)
echo "[$(date -u +%T)] OPERATOR: plug charger back in + enable Charge Separation for BYPASS arm" >> "$PROG"
wait_not_status Discharging

# Give 60s settle window, then check charge_type
sleep 60
ctype=$(cat /sys/class/power_supply/battery/charge_type 2>/dev/null)
echo "[$(date -u +%T)] charge_type=$ctype after settle" >> "$PROG"
if [ "$ctype" != "Bypass" ]; then
  echo "[$(date -u +%T)] WARN: charge_type=$ctype (not 'Bypass'); Bypass arm will run anyway but scientifically this is 'plugged-in regular charge' not strict bypass" >> "$PROG"
fi

# BYPASS arm
run_arm BYPASS 0

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S8_COMPLETE" >> "$PROG"
