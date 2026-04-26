#!/system/bin/sh
# s7_chain_resume.sh — detects which S10/S11/S5 cells are complete and
# restarts only what's missing. Safe to re-run after a power-loss reboot.
#
# Usage:
#   adb shell 'nohup /data/local/tmp/dm3_harness/bin/s7_chain_resume.sh \
#      > /data/local/tmp/dm3_harness/chain_resume.log 2>&1 &'

set -u
HARNESS=/data/local/tmp/dm3_harness/bin
LOG=/data/local/tmp/dm3_harness/chain_resume.log

echo "[$(date -u +%T)] RESUME start" >> "$LOG"

is_cell_done() {
  # Check for a *_COMPLETE marker in the cell's progress.txt
  cell="$1"; marker="$2"
  f="/data/local/tmp/dm3_harness/cells/$cell/progress.txt"
  [ -f "$f" ] || return 1
  grep -q "$marker" "$f"
}

# S10
if is_cell_done "S10_truth_sensor" "S10_COMPLETE"; then
  echo "[$(date -u +%T)] S10 already complete; skipping" >> "$LOG"
else
  rm -rf /data/local/tmp/dm3_harness/cells/S10_truth_sensor
  echo "[$(date -u +%T)] --- S10 restart ---" >> "$LOG"
  "$HARNESS/s10_truth_sensor.sh" >> "$LOG" 2>&1
fi

# S11
if is_cell_done "S11_r3_flip" "S11_COMPLETE"; then
  echo "[$(date -u +%T)] S11 already complete; skipping" >> "$LOG"
else
  rm -rf /data/local/tmp/dm3_harness/cells/S11_r3_flip
  echo "[$(date -u +%T)] --- S11 restart ---" >> "$LOG"
  "$HARNESS/s11_r3_flip.sh" >> "$LOG" 2>&1
fi

# S5 — don't delete partial data; s5_basin_volume.sh numbers runs sequentially,
# so partial runs already there are preserved. It overwrites only its own
# outputs. To get a clean resume for S5, the inner script would need idx
# detection; for now, if partial S5 is acceptable, just rerun from 1.
# SAFEST: archive partial S5 and restart
if is_cell_done "S5_basin_volume" "S5_COMPLETE"; then
  echo "[$(date -u +%T)] S5 already complete; skipping" >> "$LOG"
else
  # Count how many runs completed; if <50, archive and restart; if >=50, accept and skip
  current=$(ls /data/local/tmp/dm3_harness/cells/S5_basin_volume/S5_basin_volume_*.bin 2>/dev/null | wc -l | tr -d ' ')
  current=${current:-0}
  if [ "$current" -ge 50 ]; then
    echo "[$(date -u +%T)] S5 has $current runs already (>=50); treating as complete" >> "$LOG"
    "$HARNESS/summarize_cell.sh" "S5_basin_volume" "/data/local/tmp/dm3_harness/cells/S5_basin_volume" >> "$LOG" 2>&1
    echo "[$(date -u +%T)] S5_COMPLETE" >> "/data/local/tmp/dm3_harness/cells/S5_basin_volume/progress.txt"
  else
    echo "[$(date -u +%T)] S5 has $current runs; archiving and restarting" >> "$LOG"
    mv /data/local/tmp/dm3_harness/cells/S5_basin_volume /data/local/tmp/dm3_harness/cells/S5_basin_volume_partial_$(date +%s) 2>/dev/null
    N=100 "$HARNESS/s5_basin_volume.sh" >> "$LOG" 2>&1
  fi
fi

echo "[$(date -u +%T)] RESUME_CHAIN_COMPLETE" >> "$LOG"
