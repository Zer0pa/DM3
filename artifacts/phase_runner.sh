#!/bin/bash
# Generic phase runner for Session 4.
# Usage:
#   phase_runner.sh <phase_dir> <config_file>
# config_file lines: LABEL|STEPS|FLAGS
#   - LABEL: short label for output files (e.g. "I.a.freq_0_1")
#   - STEPS: number of episodes per invocation
#   - FLAGS: extra flags appended after default set
# Default base flags: --mode train --task harmonic --cpu
#   (if FLAGS contains --task, that base --task harmonic is replaced)
set -u

DEVICE=FY25013101C8
PHASE_DIR="$1"
CONFIG="$2"

LOG=${PHASE_DIR}/log.txt
PROGRESS=${PHASE_DIR}/progress.txt

# Count non-comment/non-empty lines
TOTAL=$(grep -cvE '^\s*(#|$)' "$CONFIG")
echo "=== PHASE RUNNER: $(basename ${PHASE_DIR}) (${TOTAL} runs) ===" >> ${LOG}
echo "Started: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> ${LOG}
echo "Config: ${CONFIG}" >> ${LOG}
echo "starting" > ${PROGRESS}

i=0
while IFS='|' read -r LABEL STEPS FLAGS; do
  # Skip comments/empty
  [[ -z "$LABEL" || "$LABEL" =~ ^[[:space:]]*# ]] && continue

  i=$((i+1))
  LABEL=$(echo "$LABEL" | xargs)
  STEPS=$(echo "$STEPS" | xargs)
  FLAGS=$(echo "$FLAGS" | xargs)

  OUT_DEV="/data/local/tmp/${LABEL}.jsonl"

  if [[ "$FLAGS" == *"--task"* ]]; then
    CMD="rm -f ${OUT_DEV} && cd /data/local/tmp && ./dm3_runner -o ${OUT_DEV} --mode train --steps ${STEPS} --cpu ${FLAGS}"
  else
    CMD="rm -f ${OUT_DEV} && cd /data/local/tmp && ./dm3_runner -o ${OUT_DEV} --mode train --task harmonic --steps ${STEPS} --cpu ${FLAGS}"
  fi

  START=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "[$i/${TOTAL}] ${LABEL} starting at ${START}" >> ${PROGRESS}
  echo "" >> ${LOG}
  echo "=== [$i/${TOTAL}] ${LABEL} | steps: ${STEPS} | flags: ${FLAGS} ===" >> ${LOG}
  echo "start: ${START}" >> ${LOG}
  echo "cmd: ${CMD}" >> ${LOG}

  adb -s ${DEVICE} shell "${CMD}" </dev/null >> ${LOG} 2>&1
  RC=$?

  END=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "end: ${END} rc=${RC}" >> ${LOG}

  adb -s ${DEVICE} pull ${OUT_DEV} ${PHASE_DIR}/${LABEL}.jsonl </dev/null >> ${LOG} 2>&1
  PULL_RC=$?
  echo "pull_rc: ${PULL_RC}" >> ${LOG}

  SAMPLE=$(adb -s ${DEVICE} shell </dev/null 'echo -n "batt="; cat /sys/class/power_supply/battery/capacity; echo -n " therm="; cat /sys/class/thermal/thermal_zone0/temp' 2>/dev/null | tr -d '\r\n')
  echo "device: ${SAMPLE}" >> ${LOG}
  echo "[$i/${TOTAL}] ${LABEL} done at ${END} rc=${RC} pull_rc=${PULL_RC} ${SAMPLE}" >> ${PROGRESS}
done < "$CONFIG"

echo "" >> ${LOG}
echo "=== PHASE RUNNER COMPLETE ===" >> ${LOG}
echo "Finished: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> ${LOG}
echo "done" >> ${PROGRESS}
