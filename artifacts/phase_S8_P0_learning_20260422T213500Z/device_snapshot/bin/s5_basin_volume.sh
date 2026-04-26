#!/system/bin/sh
# S5 / LAB-I1 — basin volume map (trimmed to N=100 for budget).
# Harmonic --steps 5 × N=100 runs, pinned, 100% dynamics-layer measurement.
# Extends S2H with more statistical power for baseline p(HIGH) calibration.

set -u
N="${N:-100}"
CELL=S5_basin_volume
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT

echo "[$(date -u +%T)] S5 start N=$N (basin volume via harmonic --steps 5)" > "$PROG"
kat=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
[ "$kat" != "OK" ] && { echo "KAT FAIL; abort" >> "$PROG"; exit 4; }

i=1
while [ $i -le $N ]; do
  # Thermal check before each run; pause 60s if hot
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  if [ "$worst" -gt 65000 ]; then
    echo "[$(date -u +%T)] thermal $worst mdeg > 65C, cooling 120s..." >> "$PROG"
    sleep 120
  fi
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "$(printf %03d $i)" "$OUT_DIR" \
    --cpu --mode train --task harmonic --steps 5 >> "$PROG" 2>&1
  rc=$?
  [ $rc -ne 0 ] && { echo "[$(date -u +%T)] run $i FAIL rc=$rc; halting" >> "$PROG"; break; }
  i=$((i+1))
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S5_COMPLETE" >> "$PROG"
