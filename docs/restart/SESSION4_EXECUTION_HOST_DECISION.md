# Session 4 Execution Host Decision

Written: `2026-04-16`
Decision: **Session 4 runs on Mac with adb to RM10, same as Session 3.**

## Summary

Three independent blockers make a phone-native agent (Claude Code in Termux)
unviable for DM3's workflow profile right now:

1. **Claude Code + Node v24 event-loop hang.** Termux ships only Node.js v24;
   Claude Code v2.1.12+ hangs 60+ seconds per API call on Node v24/v25 (GitHub
   issue #23634). No downgrade path in Termux pkg.
2. **Claude Code /tmp hardcoding.** Claude Code hardcodes `/tmp/claude/...`
   for task tracking and ignores `$TMPDIR` / `$CLAUDE_CODE_TMPDIR`. Android
   has no writable `/tmp`. The workaround is `proot` wrapping (issue #17366,
   closed "not planned" March 2026). This breaks **background and
   long-running tasks specifically** — which is DM3's entire profile.
3. **`/data/local/tmp` inaccessibility.** Termux runs as its own app UID.
   SELinux blocks Termux from reading or executing `/data/local/tmp/dm3_runner`
   without ADB, regardless of file mode. Wireless ADB self-loopback is
   technically possible but stacks another moving part.

Additional friction:

- **OpenAI Codex CLI** compiles for `aarch64-unknown-linux-musl` which fails
  against Termux's bionic libc. Only a community fork (`DioNanos/codex-termux`)
  works, and OAuth login is broken (issue #6632).
- **Android 12+ phantom-process-killer** caps child processes at 32 across
  all apps combined. The bypass (`adb shell device_config put
  activity_manager max_phantom_processes 2147483647`) resets on reboot and
  may need root to persist on Android 14.

## Sources

- Claude Code issue #23634 (Node v24 hang)
- Claude Code issue #17366 (`/tmp` hardcoding, closed not-planned)
- OpenAI Codex discussion #832 (Termux bionic incompatibility)
- OpenAI Codex issue #6632 (OAuth fail on Termux)
- Termux discussion #3372 (`/data/local/tmp` access)
- Termux issue #2366 (phantom process killer)

## What Would Change This Decision

Revisit phone-native execution when ALL of:
- Claude Code's Node v24 event-loop bug is fixed.
- Either `/tmp` hardcoding is addressed, or the agent's task-tracking is
  routed through a writable path on Android.
- Either `/data/local/tmp` access is solved (via a reliable `adb tcpip`
  self-loopback or by relocating the binary and assets into Termux `$PREFIX`
  with an aarch64-Android-native rebuild).

Estimated realistic timeline: 3-6 months, maybe longer.

## Alternative (If Remote Terminal Needed)

For mobile observation of a running Session 4 without moving the agent to
the phone:

- Run Claude Code on Mac as the agent.
- SSH from operator's mobile device into Termux on the RM10 OR into the Mac.
- Operator can view session status, tail logs, inspect receipts.
- Agent infrastructure stays on the Mac where it works.

This gives ~80% of the mobility benefit without the agent-compatibility
debugging cost.
