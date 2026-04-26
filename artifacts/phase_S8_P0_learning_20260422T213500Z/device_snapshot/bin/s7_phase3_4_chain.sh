#!/system/bin/sh
# Chains the remaining autonomous cells: S10 (clean) → S11 → S5.

set -u
HARNESS=/data/local/tmp/dm3_harness/bin
LOG=/data/local/tmp/dm3_harness/phase34_chain.log
: > "$LOG"

echo "[$(date -u +%T)] CHAIN START" >> "$LOG"

# Clean out any previous partial S10 data
rm -rf /data/local/tmp/dm3_harness/cells/S10_truth_sensor 2>/dev/null

echo "[$(date -u +%T)] --- S10 truth sensor ---" >> "$LOG"
"$HARNESS/s10_truth_sensor.sh" >> "$LOG" 2>&1

echo "[$(date -u +%T)] --- S11 R3 flip ---" >> "$LOG"
"$HARNESS/s11_r3_flip.sh" >> "$LOG" 2>&1

echo "[$(date -u +%T)] --- S5 basin volume (N=100) ---" >> "$LOG"
N=100 "$HARNESS/s5_basin_volume.sh" >> "$LOG" 2>&1

echo "[$(date -u +%T)] CHAIN_COMPLETE" >> "$LOG"
