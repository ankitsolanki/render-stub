#!/usr/bin/env bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0
: "${CTS_GIT_URL:?}" "${CTS_GIT_USER:?}" "${CTS_GIT_TOKEN:?}" "${DATABASE_URL:?}"

rm -rf app
git clone --depth 1 "https://${CTS_GIT_USER}:${CTS_GIT_TOKEN}@${CTS_GIT_URL#https://}" app
rm -rf app/.git

cd app
corepack enable
pnpm install --frozen-lockfile
NODE_OPTIONS="--no-deprecation --max-old-space-size=${BUILD_HEAP:-6144}" pnpm exec next build --webpack

PAGES=$(find .next/server/app -name '*.html' | wc -l)
echo "prerendered pages: ${PAGES}"
[ "${PAGES}" -ge "${MIN_PAGES:-0}" ] || { echo "too few pages (${PAGES} < ${MIN_PAGES}): database empty or unreachable at build time"; exit 1; }
