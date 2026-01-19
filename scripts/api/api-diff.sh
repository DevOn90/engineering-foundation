#!/usr/bin/env bash
set -euo pipefail

####################################################
# NAME: api-diff.sh
#
# PURPOSE
# -------
# Verifies that the committed OpenAPI contract matches the API implementation.
#
# The script:
#   1. Starts the local API using docker compose
#   2. Waits until the API health endpoint is UP
#   3. Fetches the live OpenAPI contract from /v3/api-docs
#   4. Normalizes the contract (canonical JSON)
#   5. Compares it with the committed contract in git
#
# If differences are found, the script fails and prints a unified diff.
#
# USAGE
# -----
#   ./api-diff.sh
#
# PREREQUISITES
# -------------
# - docker + docker compose
# - jq
# - curl
# - Local API exposes:
#     - /actuator/health
#     - /v3/api-docs
#
# EXPECTED FILES
# --------------
# - infra/01_local-dev/.env
# - docs/design/api-contract.openapi.json
#
# EXIT CODES
# ----------
# 0  - OpenAPI contract matches implementation
# 1  - Contract differs or API failed to start
####################################################

# --------------------------------------------------
# Helpers
# --------------------------------------------------

log() {
    /usr/bin/echo "[api-diff][INFO] $1"
}

fail() {
    /usr/bin/echo "[api-diff][ERROR] $1"
    exit 1
}

# --------------------------------------------------
# Initialization
# --------------------------------------------------

log "Check of API contract matches the API implementation starts."

# --------------------------------------------------
# INIT-Step 1: Source .env for local dev Build
# --------------------------------------------------
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
ENV_FILE="$ROOT_DIR/infra/01_local-dev/.env"

# Check if .env exists
if [[ ! -f "$ENV_FILE" ]];then
    log ".env file not found at "$ENV_FILE""
fi

# Source & Auto-export variables from .env
set -a                # auto export ON
source "$ENV_FILE" 
set +a                # auto export OFF

# Ensure SERVICE_PORT avaialble in .env
: "${SERVICE_PORT:?SERVICE_PORT is not set in .env}"

# --------------------------------------------------
# INIT-Step 2: Configuration
# --------------------------------------------------
SERVICE_NAME="api"
API_URL="http://localhost:${SERVICE_PORT}/v3/api-docs"
CONTRACT_FILE="$ROOT_DIR/docs/design/api-contract.openapi.json"
COMPOSE_DIR="$ROOT_DIR/infra/01_local-dev"
HEALTH_URL="http://localhost:${SERVICE_PORT}/actuator/health"

# Create unique temporary file for generated contract
TMP_CONTRACT=$(mktemp /tmp/api-contract.XXXXXX.json)

# --------------------------------------------------
# INIT-Step 3: Cleanup
# --------------------------------------------------

# Ensure temp file is always removed
cleanup() {
    rm -f "$TMP_CONTRACT"
}
trap cleanup EXIT


# --------------------------------------------------
# Flow-Step 1: Ensure API is running
# --------------------------------------------------
log "Ensuring API is running via docker compose"
cd "$COMPOSE_DIR"
/usr/bin/docker compose up -d --build  


# Wait for API
log "Waiting for API to become available"

MAX_WAIT=60

for i in $(seq 1 $MAX_WAIT); do
  if curl -sf "$HEALTH_URL" | jq -e '.status=="UP"' >/dev/null 2>&1; then
    log "API is healthy"
    break
  fi
  sleep 1
done

curl -sf "$HEALTH_URL" | jq -e '.status=="UP"' >/dev/null 2>&1 \
  || fail "API did not become healthy within ${MAX_WAIT}s"

# --------------------------------------------------
# Flow-Step 2: Fetch live OpenAPI contract
# --------------------------------------------------
log "Fetching live OpenAPI contract"
# format in canonical JSON output
curl -s "$API_URL" | jq -S '.' > "$TMP_CONTRACT"

# --------------------------------------------------
# Flow-Step 3: Compare with committed contract
# --------------------------------------------------
if [[ ! -f "$CONTRACT_FILE" ]]; then
  log "No committed contract found"
  log "Creating initial contract at $CONTRACT_FILE"
  cp "$TMP_CONTRACT" "$CONTRACT_FILE"
  fail "Initial OpenAPI contract created. Please review and commit."
fi

log "Comparing OpenAPI contracts"
if diff -u \
  <(jq -S '.' "$CONTRACT_FILE") \
  <(jq -S '.' "$TMP_CONTRACT"); then
  log "No OpenAPI changes detected"
  exit 0
else
  fail "OpenAPI contract changes detected. Please review and commit."
fi