#!/usr/bin/env bash
# Call NiceAI's OpenAI-compatible chat completions endpoint.
# Usage:
#   export NICEAI_API_KEY="sk-..."
#   export NICEAI_BASE_URL="https://api.niceai.dev/v1"   # official SDK-style base
# Default example model: gpt-6.1-sol. Copy the exact model ID from the console model list.
# Another currently live model ID is: gpt-6-astro
#   export NICEAI_MODEL="gpt-6.1-sol"
#   bash examples/curl.sh

set -euo pipefail

if [[ -z "${NICEAI_API_KEY:-}" ]]; then
  echo "Set NICEAI_API_KEY first. Do not hard-code the key in this file." >&2
  exit 1
fi

BASE_URL="${NICEAI_BASE_URL:-https://api.niceai.dev/v1}"
MODEL="${NICEAI_MODEL:-gpt-6.1-sol}"

curl -sS "${BASE_URL}/chat/completions" \
  -H "Authorization: Bearer ${NICEAI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"model\": \"${MODEL}\", \"messages\": [{\"role\": \"user\", \"content\": \"Reply with the word pong.\"}]}"
echo
