#!/usr/bin/env bash
set -euo pipefail
BRANCH="hyperboloid-snic"
TOKEN_LINE=$(grep '^GITHUB_TOKEN=' .env || true)
if [ -z "$TOKEN_LINE" ]; then echo "Missing GITHUB_TOKEN in .env"; exit 1; fi
TOKEN="${TOKEN_LINE#GITHUB_TOKEN=}"
REPO_LINE=$(grep '^REPO_URL=' .env || true)
if [ -z "$REPO_LINE" ]; then echo "Missing REPO_URL in .env"; exit 1; fi
REPO_URL="${REPO_LINE#REPO_URL=}"
git add -A
git -c user.name="Priniven" -c user.email="priniven@users.noreply.github.com" commit -m "cpu: dual-meru proof pack" || true
LOCAL_SHA="$(git rev-parse HEAD)"
git push -u "https://${TOKEN}@${REPO_URL#https://}" HEAD:refs/heads/$BRANCH
TAG="dual-meru-cpu-$(date -u +%Y%m%dT%H%M%SZ)"
git tag -a "$TAG" -m "CPU proof pack (dual-meru)"
git push "https://${TOKEN}@${REPO_URL#https://}" refs/tags/$TAG
REMOTE_SHA="$(git ls-remote "https://${TOKEN}@${REPO_URL#https://}" "refs/heads/$BRANCH" | awk '{print $1}')"
PASS=false; [ "$LOCAL_SHA" = "$REMOTE_SHA" ] && PASS=true
jq -n --arg repo "$REPO_URL" --arg branch "$BRANCH" --arg tag "$TAG" --arg local "$LOCAL_SHA" --arg remote "$REMOTE_SHA" --argjson pass $PASS --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
'{"repo":$repo,"branch":$branch,"tag":$tag,"local_sha":$local,"remote_sha":$remote,"pushed_and_verified":$pass,"timestamp_utc":$now}' > git_checkpoint_proof.json
