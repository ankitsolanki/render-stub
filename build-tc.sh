#!/usr/bin/env bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0
: "${TC_GIT_URL:?}" "${TC_GIT_USER:?}" "${TC_GIT_TOKEN:?}"

rm -rf app
git clone --depth 1 "https://${TC_GIT_USER}:${TC_GIT_TOKEN}@${TC_GIT_URL#https://}" app
rm -rf app/.git

cd app
corepack enable
pnpm install --frozen-lockfile
NODE_OPTIONS="--no-deprecation --max-old-space-size=7000" pnpm --filter @tc/app-site... build
