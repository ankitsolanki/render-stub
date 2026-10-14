#!/usr/bin/env bash
set -euo pipefail
cd app
exec node "$(node -p "require.resolve('next/dist/bin/next')")" start -p "${PORT:-10000}"
