#!/usr/bin/env python3
"""
Session 4 basin classifier.
Given a directory of per-run JSONL files, classify each episode's basin
and emit a summary JSON with HIGH/LOW/OTHER counts per run.

Usage:
    classify_basins.py <phase_dir> [--include-pattern REGEX] [--out FILE]

Default output is <phase_dir>/basin_summary.json
"""
import argparse
import json
import re
from pathlib import Path


def classify(E: float, Coh: float, task: str = "harmonic") -> str:
    """Session 4 locked thresholds."""
    if task == "holography":
        # Holography "Retry cluster" — for now any run with E<20 goes there
        if 12.0 <= E <= 20.0 and 0.68 <= Coh <= 0.78:
            return "RETRY"
        # Still allow HIGH/LOW classification for sweep responsiveness
    if E > 82.0 and Coh < 0.82:
        return "HIGH"
    if E < 82.0 and Coh > 0.82:
        return "LOW"
    if E < 20.0:
        return "LOW_ULTRA"  # holography-like ultra-low
    return "OTHER"


def load_jsonl(path: Path):
    out = []
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            out.append(json.loads(line))
        except json.JSONDecodeError:
            continue
    return out


def summarize(phase_dir: Path, include_pattern: str | None = None) -> dict:
    pat = re.compile(include_pattern) if include_pattern else None
    runs = {}
    for jf in sorted(phase_dir.glob("*.jsonl")):
        label = jf.stem
        if pat and not pat.search(label):
            continue
        episodes = load_jsonl(jf)
        task_hint = "holography" if ("holograph" in label.lower() or "holo" in label.lower()) else "harmonic"
        classified = []
        for ep in episodes:
            E = float(ep.get("delta_E", 0.0))
            Coh = float(ep.get("coherence", 0.0))
            regime = classify(E, Coh, task=task_hint)
            classified.append({
                "episode": ep.get("episode"),
                "E": round(E, 3),
                "Coh": round(Coh, 4),
                "decision": ep.get("decision"),
                "asymmetry": ep.get("asymmetry"),
                "duration_ms": ep.get("duration_ms"),
                "regime": regime,
            })
        counts = {}
        for e in classified:
            counts[e["regime"]] = counts.get(e["regime"], 0) + 1
        runs[label] = {
            "n_episodes": len(classified),
            "episodes": classified,
            "counts": counts,
            "high_rate": f"{counts.get('HIGH', 0)}/{len(classified)}",
        }
    return {"phase_dir": str(phase_dir), "runs": runs}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("phase_dir")
    ap.add_argument("--include-pattern", default=None)
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    phase_dir = Path(args.phase_dir)
    summary = summarize(phase_dir, args.include_pattern)
    out = Path(args.out) if args.out else phase_dir / "basin_summary.json"
    out.write_text(json.dumps(summary, indent=2))
    print(f"Wrote {out}")


if __name__ == "__main__":
    main()
