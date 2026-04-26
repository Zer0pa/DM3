# Entrance Condition Contract

## Regime Classification Thresholds

| Metric | HIGH regime | LOW regime | Boundary |
|--------|-------------|------------|----------|
| delta_E | > 82 | < 82 | 82.0 |
| coherence | < 0.82 | > 0.82 | 0.82 |
| duration_ms | < 170000 | > 185000 | 170000-185000 |

## Session Speed Classification

| Speed | Duration range | Notes |
|-------|---------------|-------|
| FAST | < 170000 ms | Seen only in repaired packet |
| SLOW | > 185000 ms | Seen in all subsequent packets |
| INDETERMINATE | 170000-185000 ms | Not yet observed |

## Locked Envelope

- binary: `/data/local/tmp/dm3_runner`
- binary_sha256: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- cwd: `/data/local/tmp`
- command template: `cd /data/local/tmp && /system/bin/timeout 420 /data/local/tmp/dm3_runner --mode train --task harmonic --steps 1 --cpu --output /data/local/tmp/<anchor_name>.jsonl`
- row timeout: 420 seconds
- no explicit `--adj`, `--tags`, `--patterns` (use binary defaults)
- device serial: FY25013101C8

## Anchor Sequence

| Anchor | Clean type | Idle | Purpose |
|--------|-----------|------|---------|
| A | deep (rm all .jsonl) | 120s | True cold baseline |
| B | none | 0s | Immediate rerun after A |
| C | shallow (rm target only) | 0s | Test output-file presence |
| D | deep (rm all .jsonl) | 10s | Test idle duration vs clean |
