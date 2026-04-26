#!/system/bin/sh
# phase5_chain — T11 → T1 → T2 → T3 sequentially.
# Closes Phase 5 (Tier-1 cont) + the deferred Phase 4 T1 baseline.

set -u
HARNESS=/data/local/tmp/dm3_harness/bin
LOG=/data/local/tmp/dm3_harness/phase5_chain.log
: > "$LOG"

echo "[$(date -u +%T)] PHASE5 CHAIN START" >> "$LOG"

# T11 cross-control (quick)
if [ ! -f /data/local/tmp/dm3_harness/cells/T11_cross_control/progress.txt ] \
   || ! grep -q T11_COMPLETE /data/local/tmp/dm3_harness/cells/T11_cross_control/progress.txt; then
  echo "[$(date -u +%T)] --- T11 cross-control ---" >> "$LOG"
  "$HARNESS/t11_cross_control.sh" >> "$LOG" 2>&1
else
  echo "[$(date -u +%T)] T11 already complete; skipping" >> "$LOG"
fi

# T1 12-task cartography
if [ ! -f /data/local/tmp/dm3_harness/cells/T1_cartography/progress.txt ] \
   || ! grep -q T1_COMPLETE /data/local/tmp/dm3_harness/cells/T1_cartography/progress.txt; then
  echo "[$(date -u +%T)] --- T1 cartography ---" >> "$LOG"
  "$HARNESS/t1_12task_cartography.sh" >> "$LOG" 2>&1
else
  echo "[$(date -u +%T)] T1 already complete; skipping" >> "$LOG"
fi

# T2 scars scaling
if [ ! -f /data/local/tmp/dm3_harness/cells/T2_scars_scaling/progress.txt ] \
   || ! grep -q T2_COMPLETE /data/local/tmp/dm3_harness/cells/T2_scars_scaling/progress.txt; then
  echo "[$(date -u +%T)] --- T2 scars scaling ---" >> "$LOG"
  "$HARNESS/t2_scars_scaling.sh" >> "$LOG" 2>&1
else
  echo "[$(date -u +%T)] T2 already complete; skipping" >> "$LOG"
fi

# T3 plasticity scaling
if [ ! -f /data/local/tmp/dm3_harness/cells/T3_plasticity/progress.txt ] \
   || ! grep -q T3_COMPLETE /data/local/tmp/dm3_harness/cells/T3_plasticity/progress.txt; then
  echo "[$(date -u +%T)] --- T3 plasticity scaling ---" >> "$LOG"
  "$HARNESS/t3_plasticity_scaling.sh" >> "$LOG" 2>&1
else
  echo "[$(date -u +%T)] T3 already complete; skipping" >> "$LOG"
fi

echo "[$(date -u +%T)] PHASE5_CHAIN_COMPLETE" >> "$LOG"
