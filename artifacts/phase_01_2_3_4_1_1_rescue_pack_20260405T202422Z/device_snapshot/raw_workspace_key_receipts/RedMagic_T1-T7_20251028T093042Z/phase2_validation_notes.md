## Phase B Snapshot 2025-10-28T02:29:59Z
UTC Timestamp: 2025-10-28T02:29:59Z
du -sh .:
2.4G	.
find . -maxdepth 2 -type d | sort | head -n 60:
.
./00_GENESIS_ORGANISM
./00_GENESIS_ORGANISM/snic_workspace_a83f
./01_PROVEN_LINEAGE
./01_PROVEN_LINEAGE/Z_P1_01_C4_Contraction
./01_PROVEN_LINEAGE/Z_P1_02_C5_Stability
./01_PROVEN_LINEAGE/Z_P1_03_C10_Convergence
./01_PROVEN_LINEAGE/Z_P1_04_C2_Replication
./01_PROVEN_LINEAGE/Z_P1_05_C6_Coherence
./01_PROVEN_LINEAGE/Z_P1_06_C9_Isotropy
./01_PROVEN_LINEAGE/Z_P1_07_C8_Holography
./02_PHYLOGENETIC_LEDGER
./audit
./audit/github_upload_verification
./.git
./.git/hooks
./.git/info
./.git/logs
./.git/objects
./.git/refs
rustc --version:
rustc 1.89.0 (29483883e 2025-08-04)
node --version:
v20.19.2

# Phase-2 Notes (UTC 2025-10-28T02:36:05Z)

du -sh .:
2.4G\t.

find . -maxdepth 2 -type d | sort | sed -n '1,60p':
.
./00_GENESIS_ORGANISM
./00_GENESIS_ORGANISM/snic_workspace_a83f
./01_PROVEN_LINEAGE
./01_PROVEN_LINEAGE/Z_P1_01_C4_Contraction
./01_PROVEN_LINEAGE/Z_P1_02_C5_Stability
./01_PROVEN_LINEAGE/Z_P1_03_C10_Convergence
./01_PROVEN_LINEAGE/Z_P1_04_C2_Replication
./01_PROVEN_LINEAGE/Z_P1_05_C6_Coherence
./01_PROVEN_LINEAGE/Z_P1_06_C9_Isotropy
./01_PROVEN_LINEAGE/Z_P1_07_C8_Holography
./02_PHYLOGENETIC_LEDGER
./audit
./audit/github_upload_verification
./.git
./.git/hooks
./.git/info
./.git/logs
./.git/objects
./.git/refs

rustc --version:
rustc 1.89.0 (29483883e 2025-08-04)

node --version:
v20.19.2

Build and smoke test (1 run):
cd /root/work/repo/00_GENESIS_ORGANISM/snic_workspace_a83f
mkdir -p audit
cargo build -p genesis_cli
cargo run -p genesis_cli -- --protocol --runs 1 --output-dir audit/termux_protocol_run
cat audit/termux_protocol_run/hashes.tsv
Expected hashes:
verify.json e8941414a25c7c8e1aed6b3f5c032c00a69e85ae6964555301ff48dee44009e3
solve_h2.json 62897b8c26de3af1a78433807c5607fb8c82f061d1457e9c43e2aa5d35fe7780

Determinism battery (2 runs total):
cargo run -p genesis_cli -- --test-battery 2 --test-output-dir audit/termux_test_cli_two
awk '{print $2, $3}' audit/termux_test_cli_two/hashes.tsv | sort | uniq -c

Optional lineage replay (only if prior steps PASS):
cargo run -p genesis_cli -- --lineage-batch --lineage-root ../../01_PROVEN_LINEAGE --lineage-runs 3 --lineage-output-dir audit/termux_lineage_batch
diff -u audit/lineage_batch_phase1/hashes.tsv audit/termux_lineage_batch/hashes.tsv || true

Lineage diff pending—reference file audit/lineage_batch_phase1/hashes.tsv not present in this workspace.

