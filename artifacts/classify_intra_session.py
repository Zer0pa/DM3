#!/usr/bin/env python3
"""Intra-session basin correlation analyzer for Phase P2a.

Reads session_*.jsonl files from a phase dir. Each session is one 20-episode
run from --steps 20. Computes:
- Marginal P(HIGH), P(LOW), P(OTHER) across all episodes in all sessions
- Per-index marginal: P(HIGH | k) for k in 1..20
- Transition matrix: P(basin_k | basin_{k-1})
- Run-length distribution (same-basin streaks)

Usage: classify_intra_session.py <phase_dir> [--out FILE]
"""
from __future__ import annotations
import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path


def classify(E: float, Coh: float) -> str:
    if E > 82.0 and Coh < 0.82:
        return "HIGH"
    if E < 82.0 and Coh > 0.82:
        return "LOW"
    if E < 20.0 and 0.68 <= Coh <= 0.78:
        return "RETRY"
    return "OTHER"


def load_session(path: Path):
    episodes = []
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            d = json.loads(line)
        except json.JSONDecodeError:
            continue
        E = float(d.get("delta_E", 0.0))
        C = float(d.get("coherence", 0.0))
        episodes.append({
            "episode": int(d.get("episode", 0)),
            "E": round(E, 3),
            "Coh": round(C, 4),
            "regime": classify(E, C),
            "duration_ms": d.get("duration_ms"),
            "decision": d.get("decision"),
        })
    episodes.sort(key=lambda e: e["episode"])
    return episodes


def summarize(phase_dir: Path) -> dict:
    sessions = {}
    all_regimes = []
    max_k = 0
    for jf in sorted(phase_dir.glob("session_*.jsonl")):
        episodes = load_session(jf)
        sessions[jf.stem] = {
            "n_episodes": len(episodes),
            "episodes": episodes,
            "regime_sequence": [e["regime"] for e in episodes],
        }
        all_regimes.extend(e["regime"] for e in episodes)
        max_k = max(max_k, len(episodes))

    # Marginal distribution
    marg = Counter(all_regimes)
    total = sum(marg.values())

    # Per-index marginal
    per_index = defaultdict(lambda: Counter())
    for s in sessions.values():
        for i, r in enumerate(s["regime_sequence"], start=1):
            per_index[i][r] += 1
    per_index_out = {}
    for k in range(1, max_k + 1):
        c = per_index[k]
        n = sum(c.values())
        per_index_out[k] = {
            "n": n,
            "HIGH_rate": f"{c.get('HIGH', 0)}/{n}" if n else "0/0",
            "LOW_rate": f"{c.get('LOW', 0)}/{n}" if n else "0/0",
            "OTHER_rate": f"{c.get('OTHER', 0)}/{n}" if n else "0/0",
        }

    # Transition matrix
    trans = defaultdict(lambda: Counter())
    for s in sessions.values():
        seq = s["regime_sequence"]
        for a, b in zip(seq, seq[1:]):
            trans[a][b] += 1
    trans_out = {}
    for a, c in trans.items():
        n = sum(c.values())
        trans_out[a] = {
            "n_transitions": n,
            "to_HIGH": f"{c.get('HIGH', 0)}/{n}",
            "to_LOW": f"{c.get('LOW', 0)}/{n}",
            "to_OTHER": f"{c.get('OTHER', 0)}/{n}",
        }

    # Run-length distribution
    runlens = []
    for s in sessions.values():
        seq = s["regime_sequence"]
        if not seq:
            continue
        cur = seq[0]
        length = 1
        for x in seq[1:]:
            if x == cur:
                length += 1
            else:
                runlens.append((cur, length))
                cur = x
                length = 1
        runlens.append((cur, length))
    rl_by_regime = defaultdict(list)
    for r, L in runlens:
        rl_by_regime[r].append(L)
    rl_out = {
        r: {
            "count": len(L),
            "mean": round(sum(L)/len(L), 2) if L else 0,
            "max": max(L) if L else 0,
            "distribution": Counter(L),
        } for r, L in rl_by_regime.items()
    }
    for v in rl_out.values():
        v["distribution"] = dict(sorted(v["distribution"].items()))

    # First-episode conditional: does session_k start with the same basin as session_1?
    first_eps = [s["regime_sequence"][0] for s in sessions.values() if s["regime_sequence"]]

    return {
        "phase_dir": str(phase_dir),
        "n_sessions": len(sessions),
        "n_episodes_total": total,
        "marginal": {
            "HIGH": f"{marg.get('HIGH', 0)}/{total}",
            "LOW": f"{marg.get('LOW', 0)}/{total}",
            "OTHER": f"{marg.get('OTHER', 0)}/{total}",
            "RETRY": f"{marg.get('RETRY', 0)}/{total}",
        },
        "per_index_marginal": per_index_out,
        "transition_matrix": trans_out,
        "run_lengths": rl_out,
        "first_episodes": first_eps,
        "sessions": sessions,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("phase_dir")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()
    phase_dir = Path(args.phase_dir)
    summary = summarize(phase_dir)
    out = Path(args.out) if args.out else phase_dir / "intra_session_summary.json"
    out.write_text(json.dumps(summary, indent=2, default=str))
    print(f"Wrote {out}")
    # Print concise report
    print(f"\nSessions: {summary['n_sessions']}, total eps: {summary['n_episodes_total']}")
    print(f"Marginal: {summary['marginal']}")
    print(f"First episodes: {summary['first_episodes']}")
    print("\nTransition matrix:")
    for a, row in summary["transition_matrix"].items():
        print(f"  {a} -> {row}")
    print("\nPer-index HIGH rate (first 10):")
    for k in range(1, min(11, len(summary["per_index_marginal"])+1)):
        r = summary["per_index_marginal"].get(k, {})
        print(f"  k={k}: {r.get('HIGH_rate', 'N/A')}")


if __name__ == "__main__":
    main()
