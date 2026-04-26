#!/bin/bash
# Phase H executor — 14 runs × 5 episodes = ~4 hrs device time
# Runs sequentially, pulls receipts after each, appends to log.txt

set -u
DEVICE=FY25013101C8
PHASE_DIR=/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_H_statistical_replication_20260416T143544Z
LOG=${PHASE_DIR}/log.txt
PROGRESS=${PHASE_DIR}/progress.txt

# Each entry: "LABEL|EXTRA_FLAGS"
RUNS=(
  "H.1_ham|--use-layernorm false"
  "H.2_ln|--use-layernorm true"
  "H.3_asym_neg1|--asymmetry=-1.0"
  "H.4_asym_neg01|--asymmetry=-0.1"
  "H.5_asym_01|--asymmetry=0.1"
  "H.6_asym_10|--asymmetry=1.0"
  "H.7_rot120|--rotation 120"
  "H.8_rot60|--rotation 60"
  "H.9_rot0|--rotation 0"
  "H.10_freq10|--freq 1.0"
  "H.11_freq0033|--freq 0.033"
  "H.12_holography|--task holography"
  "H.13_truth_default|--enable-truth-sensor"
  "H.14_truth_strong|--enable-truth-sensor --sensor-threshold 0.1 --sensor-strength 0.9"
)

echo "=== PHASE H: STATISTICAL REPLICATION (N=5) ===" > ${LOG}
echo "Started: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> ${LOG}
echo "Device: ${DEVICE}" >> ${LOG}
echo "" >> ${LOG}
echo "starting" > ${PROGRESS}

i=0
for entry in "${RUNS[@]}"; do
  i=$((i+1))
  LABEL="${entry%%|*}"
  FLAGS="${entry##*|}"
  OUT_DEV="/data/local/tmp/${LABEL}.jsonl"

  # Default task=harmonic, override if flags contain --task
  if [[ "$FLAGS" == *"--task"* ]]; then
    CMD="rm -f ${OUT_DEV} && cd /data/local/tmp && ./dm3_runner -o ${OUT_DEV} --mode train --steps 5 --cpu ${FLAGS}"
  else
    CMD="rm -f ${OUT_DEV} && cd /data/local/tmp && ./dm3_runner -o ${OUT_DEV} --mode train --task harmonic --steps 5 --cpu ${FLAGS}"
  fi

  START=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "[$i/14] ${LABEL} starting at ${START}" >> ${PROGRESS}
  echo "" >> ${LOG}
  echo "=== [$i/14] ${LABEL} | flags: ${FLAGS} ===" >> ${LOG}
  echo "start: ${START}" >> ${LOG}
  echo "cmd: ${CMD}" >> ${LOG}

  # Execute on device
  adb -s ${DEVICE} shell "${CMD}" >> ${LOG} 2>&1
  RC=$?

  END=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "end: ${END} rc=${RC}" >> ${LOG}

  # Pull receipt
  adb -s ${DEVICE} pull ${OUT_DEV} ${PHASE_DIR}/${LABEL}.jsonl >> ${LOG} 2>&1
  PULL_RC=$?
  echo "pull_rc: ${PULL_RC}" >> ${LOG}

  # Per-run battery + thermal sample
  SAMPLE=$(adb -s ${DEVICE} shell 'echo -n "batt="; cat /sys/class/power_supply/battery/capacity; echo -n " therm="; cat /sys/class/thermal/thermal_zone0/temp' 2>/dev/null | tr -d '\r\n')
  echo "device: ${SAMPLE}" >> ${LOG}
  echo "[$i/14] ${LABEL} done at ${END} rc=${RC} pull_rc=${PULL_RC} ${SAMPLE}" >> ${PROGRESS}
done

echo "" >> ${LOG}
echo "=== PHASE H COMPLETE ===" >> ${LOG}
echo "Finished: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> ${LOG}
echo "done" >> ${PROGRESS}
