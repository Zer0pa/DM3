# F2 Outlier Outcome

- outcome_class: `BLOCKED`
- reason: row_cpu_b_failed
- detail: Row cpu_b timed out and residue runners were terminated.
Command timed out after 180 seconds: adb shell 'cd /data/local/tmp && rm -f /data/local/tmp/f2_20260405T183712Z_cpu_b.jsonl && /system/bin/timeout 180 /data/local/tmp/dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/f2_20260405T183712Z_cpu_b.jsonl'
STDOUT:
b'Entering Training Mode...\nForcing CPU Mode (GPU Disabled).\nEntering Resonance Mode (Legacy)...\nStarting Resonance Training (Episodes: 1, Asymmetry: 0)\n'
STDERR:

- residue classification did not run because the top-level F2 root surface is not yet ready.
- surface_probe_summary: `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/artifacts/phase_01_2_3_4_1_f2_toplevel_20260405T183234Z/summary.json`
- comparison_index: `artifacts/phase_01_2_3_4_1_outlier_rerun_20260405T183712Z/comparisons/index.tsv`
