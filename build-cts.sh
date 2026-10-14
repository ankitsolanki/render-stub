#!/usr/bin/env bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0
: "${CTS_GIT_URL:?}" "${CTS_GIT_USER:?}" "${CTS_GIT_TOKEN:?}"

rm -rf app
git clone --depth 1 "https://${CTS_GIT_USER}:${CTS_GIT_TOKEN}@${CTS_GIT_URL#https://}" app
rm -rf app/.git

cd app
corepack enable
pnpm install --frozen-lockfile
NODE_OPTIONS="--no-deprecation --max-old-space-size=7000" pnpm exec next build --webpack
