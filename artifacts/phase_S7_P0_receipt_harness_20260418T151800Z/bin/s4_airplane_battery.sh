#!/system/bin/sh
# S4 / LAB-F1 — airplane vs full-radios hash identity.
# Two arms × N runs. Arm RF-QUIET: airplane on. Arm RF-LOUD: airplane off + wifi on.
# PRD §5.S4. PASS = 1 unique canonical SHA across 2N.
# No root needed — uses `settings put global airplane_mode_on`.

set -u
N="${N:-5}"   # per-arm; 5 × 2 = 10 runs total
CELL=S4_airplane
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

# Record initial airplane state to restore on exit
INIT_AIRPLANE=$(settings get global airplane_mode_on 2>/dev/null | tr -d '\r\n ')
trap "echo '[$(date -u +%T)] EXIT trap; restoring airplane_mode_on=$INIT_AIRPLANE' >> $PROG; settings put global airplane_mode_on $INIT_AIRPLANE 2>/dev/null" EXIT

echo "[$(date -u +%T)] S4 start N_per_arm=$N init_airplane=$INIT_AIRPLANE" > "$PROG"

run_arm() {
  arm="$1"
  ap="$2"
  settings put global airplane_mode_on $ap 2>/dev/null
  sleep 10  # let radios settle
  ap_now=$(settings get global airplane_mode_on 2>/dev/null | tr -d '\r\n ')
  echo "[$(date -u +%T)] arm=$arm airplane_mode=$ap_now" >> "$PROG"

  kat_pre=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
  [ "$kat_pre" != "OK" ] && { echo "KAT pre-run FAIL ($kat_pre); arm=$arm aborted" >> "$PROG"; return 4; }

  i=1
  while [ $i -le $N ]; do
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${arm}_$(printf %03d $i)" "$OUT_DIR" \
      --cpu --mode train --task exp_r1_r4_campaign --steps 1 >> "$PROG" 2>&1
    rc=$?
    if [ $rc -ne 0 ]; then
      echo "[$(date -u +%T)] arm=$arm run $i FAILED rc=$rc" >> "$PROG"
      break
    fi
    i=$((i+1))
  done
}

# Arm 1: RF-QUIET (airplane on)
run_arm QUIET 1

# Arm 2: RF-LOUD (airplane off)
run_arm LOUD 0

# Restore
settings put global airplane_mode_on $INIT_AIRPLANE 2>/dev/null

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S4_COMPLETE" >> "$PROG"
