#!/usr/bin/env bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0
: "${TC_GIT_URL:?}" "${TC_GIT_USER:?}" "${TC_GIT_TOKEN:?}" "${DATABASE_URL:?}"

rm -rf app
git clone --depth 1 "https://${TC_GIT_USER}:${TC_GIT_TOKEN}@${TC_GIT_URL#https://}" app
rm -rf app/.git

cd app
corepack enable
pnpm install --frozen-lockfile

cd apps/site
NODE_OPTIONS="--no-deprecation --max-old-space-size=${BUILD_HEAP:-6144}" pnpm build --webpack

# A build against an empty or unreachable database silently drops the Payload-backed pages.
PAGES=$(find .next/server/app -name '*.html' | wc -l)
echo "prerendered pages: ${PAGES}"
[ "${PAGES}" -ge "${MIN_PAGES:-1000}" ] || { echo "too few pages (${PAGES} < ${MIN_PAGES:-1000}): database empty or unreachable at build time"; exit 1; }
