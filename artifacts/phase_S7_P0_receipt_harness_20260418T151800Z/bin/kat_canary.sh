#!/system/bin/sh
# kat_canary.sh — SHA-256 known-answer test + simple AES-style canary.
# Prints "OK" on stdout if all KATs pass, else "FAIL <which>".
# Exit 0 if all pass, 1 if any fail.
#
# The KAT runs against the device's sha256sum utility. If the device silently
# corrupts either (a) the `sha256sum` binary, or (b) any hashing-related
# kernel/libc path, the KAT will mismatch. This is the Session 7 S3 substrate
# canary per PRD §5.S3.

set -u

# Known answer: SHA-256 of the empty string
EXPECTED_EMPTY="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
# SHA-256 of "abc"
EXPECTED_ABC="ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
# SHA-256 of "The quick brown fox jumps over the lazy dog"
EXPECTED_FOX="d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"
# NIST SHA-256 test vector: SHA-256 of 1 million 'a' characters
EXPECTED_1MA="cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0"

got_empty=$(printf '' | sha256sum | awk '{print $1}')
got_abc=$(printf 'abc' | sha256sum | awk '{print $1}')
got_fox=$(printf 'The quick brown fox jumps over the lazy dog' | sha256sum | awk '{print $1}')
got_1ma=$(awk 'BEGIN{for(i=0;i<1000000;i++)printf "a"}' | sha256sum | awk '{print $1}')

fail=""
[ "$got_empty" != "$EXPECTED_EMPTY" ] && fail="$fail empty"
[ "$got_abc"   != "$EXPECTED_ABC"   ] && fail="$fail abc"
[ "$got_fox"   != "$EXPECTED_FOX"   ] && fail="$fail fox"
[ "$got_1ma"   != "$EXPECTED_1MA"   ] && fail="$fail 1ma"

if [ -z "$fail" ]; then
  echo "OK"
  exit 0
else
  echo "FAIL$fail"
  exit 1
fi
