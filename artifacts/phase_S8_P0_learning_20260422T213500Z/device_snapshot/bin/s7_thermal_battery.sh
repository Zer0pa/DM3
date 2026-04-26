#!/system/bin/sh
# S7 / LAB-D1 — cold vs hot hash identity (dynamics layer, harmonic --steps 5).
# Operator intervention between arms; ALWAYS keeps running arms autonomously.
# Pre-registered PASS:
#   observed p(HIGH) 95% Wilson CI in EACH arm overlaps Session 5 baseline
#   AND overlaps the OTHER arm's CI.
# Pre-registered FAIL: any arm's CI disjoint from baseline OR from the other arm.
# Thermal auto-abort: any zone ≥70000 mdeg C → SIGKILL runner + halt.

set -u
N="${N:-20}"
CELL=S7_thermal
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
SENTINEL="$OUT_DIR/continue"
CHECKLIST="$OUT_DIR/INTERVENTION_CHECKLIST.md"
TCEIL=70000

# Intervention checklist for operator
cat > "$CHECKLIST" <<EOF
# S7 INTERVENTION_CHECKLIST

## Arm 1: COLD (autonomous, no intervention needed)
Preconditions:
- Fan on (REDMAGIC UI set to level 5 or higher)
- Airplane mode ON (optional; airplane state recorded per-run regardless)
- Skin/CPU thermal zones ≤ 45 °C

Observed at launch: thermal zones all < 40 °C, fan verified on by operator.

## BETWEEN ARMS — INTERVENTION REQUIRED
When COLD arm completes, the script pauses and writes:
  [$(date -u +%T)] INTERVENTION REQUIRED: switch to HOT arm

### Your steps for the HOT arm:
1. Turn fan **off** via REDMAGIC UI (or leave fan on but set to level 0/minimum)
2. Plug charger in (wall wart preferred); verify status=Charging
3. In REDMAGIC UI, **DISABLE** Charge Separation / Bypass
   (battery should charge normally so it warms under load)
4. Optional: place device on a thermal blanket or warm surface
5. When ready, touch this file:  $SENTINEL
   via:  adb -s FY25013101C8 shell 'touch $SENTINEL'
   The script will resume within 30 s.

**The script auto-aborts any run where any thermal zone ≥ 70 °C.**
If you see "THERMAL_OVER_CEILING" in progress.txt, cool the device and restart.
EOF

trap 'echo "[$(date -u +%T)] EXIT trap" >> $PROG' EXIT

thermal_ok() {
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  if [ "$worst" -gt "$TCEIL" ]; then
    echo "[$(date -u +%T)] THERMAL_OVER_CEILING worst_mc=$worst" >> "$PROG"
    return 1
  fi
  return 0
}

run_arm() {
  arm="$1"
  echo "[$(date -u +%T)] ARM START $arm" >> "$PROG"
  kat=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
  [ "$kat" != "OK" ] && { echo "KAT FAIL ($kat) arm=$arm; abort" >> "$PROG"; return 4; }
  i=1
  while [ $i -le $N ]; do
    if ! thermal_ok; then
      echo "[$(date -u +%T)] halting arm=$arm at run=$i on thermal ceiling" >> "$PROG"
      break
    fi
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${arm}_$(printf %03d $i)" "$OUT_DIR" \
      --cpu --mode train --task harmonic --steps 5 >> "$PROG" 2>&1
    rc=$?
    [ $rc -ne 0 ] && { echo "[$(date -u +%T)] arm=$arm run $i FAIL rc=$rc" >> "$PROG"; break; }
    i=$((i+1))
  done
  echo "[$(date -u +%T)] ARM END $arm" >> "$PROG"
}

echo "[$(date -u +%T)] S7 start N_per_arm=$N" > "$PROG"
echo "[$(date -u +%T)] checklist: $CHECKLIST" >> "$PROG"

# ARM 1: COLD (auto)
run_arm COLD

# WAIT FOR OPERATOR
rm -f "$SENTINEL"
echo "[$(date -u +%T)] INTERVENTION REQUIRED: switch to HOT arm. Touch $SENTINEL when ready." >> "$PROG"
while [ ! -f "$SENTINEL" ]; do
  sleep 30
done
echo "[$(date -u +%T)] sentinel received; proceeding to HOT arm" >> "$PROG"

# ARM 2: HOT
run_arm HOT

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S7_COMPLETE" >> "$PROG"
