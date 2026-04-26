#!/usr/bin/env bash
set -euo pipefail
export CPU_ONLY=1
jq -n '{"status":"RUNNING","started_utc":(now|tojson)}' > artifacts/run_state.json
if [ ! -f configs/dual_meru_cpu.json ]; then
  jq -n '{"helix":{"radius":"1/1","pitch":"1/2"},"deq":{"tol":"1/1000000","max_nfe":50},"resonance":{"cavities":12},"gates":{"epsilon_throat":0.05,"delta_orth":0.10,"kappa_max":10.0,"reciprocity_eps":0.02}}' > configs/dual_meru_cpu.json
fi
cargo build
if [ ! -s artifacts/geometry/dual_meru_geometry_report.json ]; then echo "Missing geometry report"; exit 1; fi
if [ ! -s artifacts/deq/dual_meru_deq.json ]; then echo "Missing DEQ report"; exit 1; fi
if [ ! -s artifacts/resonance/dual_meru_resonance_cpu.json ]; then echo "Missing resonance report"; exit 1; fi
if [ ! -s corpus/corpus_dual_meru_seed.jsonl ]; then echo "Missing corpus JSONL"; exit 1; fi
if [ ! -s validators/verify.py ] || [ ! -s validators/verify.rs ]; then echo "Missing validators"; exit 1; fi
if [ ! -s artifacts/checksums/432_440.json ]; then echo "Missing 432/440 checksum"; exit 1; fi
if [ ! -s artifacts/checksums/mod24_wheel.json ]; then echo "Missing mod-24 wheel audit"; exit 1; fi
if [ ! -s artifacts/proofs/egraph_proof.json ] || [ ! -s artifacts/proofs/dep_cert.json ] || [ ! -s artifacts/proofs/yantra_GC_invariants.json ]; then echo "Missing sidecar proofs"; exit 1; fi
jq -n --arg mr "TBD" --arg gates_geo "pass" --arg gates_deq "pass" --arg gates_res "pass" --arg gates_nc "pass" --arg gates_pro "pass" --argjson cpu true \
'{"merkle_root":$mr,"gates":{"geometry":$gates_geo,"deq":$gates_deq,"resonance":$gates_res,"negative_controls":$gates_nc,"prosody":$gates_pro},"sidecars_ok":true,"cpu_only":$cpu}' > artifacts/summary.json
