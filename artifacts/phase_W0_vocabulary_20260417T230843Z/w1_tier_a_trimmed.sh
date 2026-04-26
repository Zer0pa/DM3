#!/system/bin/sh
# W1 Tier A (trimmed): focus on steps=1 for full 15-cell asym×rot grid.
# Determinism: 3 SY replicates at default.
# steps=5 expansion: only at asym=0 rot=0 (baseline) to establish operational_steps scaling.
# Budget target: ~90 minutes.

set -u
OUT_DIR=/data/local/tmp/phase_W1_tier_a_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
RES="$OUT_DIR/results.tsv"
: > "$PROG"
printf "label\tadj\tasym\trot\tsteps\tstart\tend\trc\tbytes\tsec\n" > "$RES"

cd /data/local/tmp || exit 2

run_cell() {
  label="$1"; adj="$2"; asym="$3"; rot="$4"; steps="$5"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ts_s=$(date +%s)
  echo "[$start] start $label (adj=$adj asym=$asym rot=$rot steps=$steps)" >> "$PROG"
  ./dm3_runner --cpu --mode train --task exp_r1_r4_campaign \
    --adj "$adj" --asymmetry "$asym" --rotation "$rot" --steps "$steps" \
    -o "$out" > "$log" 2>&1
  rc=$?
  ts_e=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bytes=$(wc -c < "$out" 2>/dev/null || echo 0)
  dur=$((ts_e - ts_s))
  echo "[$end] done $label rc=$rc bytes=$bytes sec=$dur" >> "$PROG"
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$label" "$adj" "$asym" "$rot" "$steps" "$start" "$end" "$rc" "$bytes" "$dur" >> "$RES"
}

# Determinism: 3 SY replicates at defaults (for bit-identical check)
run_cell "det_SY_default_r1" SriYantraAdj_v1.bin 0.0 0 1
run_cell "det_SY_default_r2" SriYantraAdj_v1.bin 0.0 0 1
run_cell "det_SY_default_r3" SriYantraAdj_v1.bin 0.0 0 1

# Tier A: 15 cells at steps=1, asym×rot grid
for asym in "-1.0" "-0.5" "0.0" "0.5" "1.0"; do
  for rot in 0 60 120; do
    asym_tag=$(echo "$asym" | sed 's/-/n/; s/\./_/')
    label="A_asym${asym_tag}_rot${rot}_s1"
    run_cell "$label" SriYantraAdj_v1.bin "$asym" "$rot" 1
  done
done

# steps=5 anchors: 3 cells with varied asym to see scaling of operational_steps
run_cell "A_asym0_rot0_s5"  SriYantraAdj_v1.bin 0.0 0 5
run_cell "A_asymn1_rot0_s5" SriYantraAdj_v1.bin -1.0 0 5
run_cell "A_asym1_rot60_s5" SriYantraAdj_v1.bin 1.0 60 5

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
