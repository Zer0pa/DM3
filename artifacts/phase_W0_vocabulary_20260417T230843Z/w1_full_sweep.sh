#!/system/bin/sh
# W1 full sweep: Tier A (SY) + Tier C (RA at key cells) integrated.
# Determinism already confirmed (det_SY_default_r1 bit-identical to Session 5).
# N=1 per cell is valid.
#
# Tier A: 15 cells SY (asym ∈ {-1,-0.5,0,+0.5,+1} × rot ∈ {0,60,120}), steps=1.
# Tier C: 5 cells RA at key asymmetry (SY-full coverage would cost 5h+).

set -u
OUT_DIR=/data/local/tmp/phase_W1_full_receipts
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
    --adj "$adj" --asymmetry="$asym" --rotation "$rot" --steps "$steps" \
    -o "$out" > "$log" 2>&1
  rc=$?
  ts_e=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bytes=$(wc -c < "$out" 2>/dev/null || echo 0)
  dur=$((ts_e - ts_s))
  echo "[$end] done $label rc=$rc bytes=$bytes sec=$dur" >> "$PROG"
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$label" "$adj" "$asym" "$rot" "$steps" "$start" "$end" "$rc" "$bytes" "$dur" >> "$RES"
}

# === Tier A — SriYantra asym × rot grid (15 cells, steps=1) ===
for asym in "-1.0" "-0.5" "0.0" "0.5" "1.0"; do
  for rot in 0 60 120; do
    asym_tag=$(echo "$asym" | sed 's/-/n/; s/\./_/')
    run_cell "A_SY_asym${asym_tag}_rot${rot}" SriYantraAdj_v1.bin "$asym" "$rot" 1
  done
done

# === Tier C — RandomAdj at asym=0 rot=0 baseline + one other axis ===
# RA runs ~7x slower (1340s vs 200s). 5 cells × ~1000s ≈ 85 min.
run_cell "C_RA_asym0_rot0"    RandomAdj_v1.bin 0.0 0 1
run_cell "C_RA_asymn05_rot0"  RandomAdj_v1.bin -0.5 0 1
run_cell "C_RA_asym05_rot0"   RandomAdj_v1.bin 0.5 0 1
run_cell "C_RA_asym0_rot60"   RandomAdj_v1.bin 0.0 60 1
run_cell "C_RA_asym0_rot120"  RandomAdj_v1.bin 0.0 120 1

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
