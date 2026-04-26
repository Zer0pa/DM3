#!/system/bin/sh
# W1 Tier A: coarse sweep of exp_r1_r4_campaign.
# Grid: asymmetry {-1, -0.5, 0, +0.5, +1} × rotation {0, 60, 120} × steps {1, 5, 10}
# = 45 invocations.
# Also: 3 determinism replicates at 3 configurations (9 extra runs first).
# Plus: W0-discovered adj swap: run determinism at RandomAdj defaults (3 runs).

set -u
OUT_DIR=/data/local/tmp/phase_W1_tier_a_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
RES="$OUT_DIR/results.tsv"
: > "$PROG"
printf "label\tadj\tasym\trot\tsteps\tstart\tend\trc\tbytes\trun_sec\n" > "$RES"

cd /data/local/tmp || exit 2

run_cell() {
  label="$1"; adj="$2"; asym="$3"; rot="$4"; steps="$5"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ts_start=$(date +%s)
  echo "[$start] start $label (adj=$adj asym=$asym rot=$rot steps=$steps)" >> "$PROG"
  ./dm3_runner --cpu --mode train --task exp_r1_r4_campaign \
    --adj "$adj" --asymmetry "$asym" --rotation "$rot" --steps "$steps" \
    -o "$out" > "$log" 2>&1
  rc=$?
  ts_end=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bytes=$(wc -c < "$out" 2>/dev/null || echo 0)
  dur=$((ts_end - ts_start))
  echo "[$end] done $label rc=$rc bytes=$bytes sec=$dur" >> "$PROG"
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$label" "$adj" "$asym" "$rot" "$steps" "$start" "$end" "$rc" "$bytes" "$dur" >> "$RES"
}

# Determinism block: 3 configs × 3 replicates at SriYantra
# Config A: default
run_cell "det_SY_A_r1" SriYantraAdj_v1.bin 0.0 0 1
run_cell "det_SY_A_r2" SriYantraAdj_v1.bin 0.0 0 1
run_cell "det_SY_A_r3" SriYantraAdj_v1.bin 0.0 0 1
# Config B: asym negative rot nonzero
run_cell "det_SY_B_r1" SriYantraAdj_v1.bin -0.5 60 1
run_cell "det_SY_B_r2" SriYantraAdj_v1.bin -0.5 60 1
# Config C: asym positive rot C3 complement
run_cell "det_SY_C_r1" SriYantraAdj_v1.bin 0.5 120 1
run_cell "det_SY_C_r2" SriYantraAdj_v1.bin 0.5 120 1

# Determinism at RandomAdj defaults (2 replicates because RA is ~1340s each)
run_cell "det_RA_A_r1" RandomAdj_v1.bin 0.0 0 1
run_cell "det_RA_A_r2" RandomAdj_v1.bin 0.0 0 1

# Tier A full sweep at SriYantra (asymmetry × rotation × steps)
# asymmetry ∈ {-1, -0.5, 0, +0.5, +1}; rotation ∈ {0, 60, 120}; steps ∈ {1, 5, 10}
for asym in "-1.0" "-0.5" "0.0" "0.5" "1.0"; do
  for rot in 0 60 120; do
    for steps in 1 5 10; do
      asym_tag=$(echo "$asym" | sed 's/-/n/; s/\./_/')
      label="A_asym${asym_tag}_rot${rot}_s${steps}"
      run_cell "$label" SriYantraAdj_v1.bin "$asym" "$rot" "$steps"
    done
  done
done

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
