#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# CI API Contract Check
# ------------------------------------------------------------------------------
# Purpose:
#   Runs the OpenAPI contract diff check in CI environment without relying
#   on local .env or Docker Compose.
#
# Usage:
#   Invoked by GitHub Actions workflow.
#
# Notes:
#   - SERVICE_PORT must be provided via environment (default: 8080)
#   - Assumes the app is already built in a previous CI step
#   - No local container build is required
# ==============================================================================

# --------------------------------------------------
# Helpers
# --------------------------------------------------
log() {
    echo "[api-diff-CI][INFO] $1"
}

fail() {
    echo "[api-diff-CI][ERROR] $1"
    exit 1
}

# --------------------------------------------------
# Config
# --------------------------------------------------
SERVICE_PORT="${SERVICE_PORT:-8080}"
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CONTRACT_FILE="$ROOT_DIR/docs/design/api-contract.openapi.json"
TMP_CONTRACT=$(mktemp /tmp/api-contract.XXXXXX.json)

# --------------------------------------------------
# Step 1: Start the Spring Boot app
# --------------------------------------------------
log "Starting API for contract check"

cd "$ROOT_DIR/apps/api"

# Start Spring Boot app in background
java -jar target/*.jar --server.port="$SERVICE_PORT" &
APP_PID=$!

# Ensure cleanup happens on EXIT or error
cleanup() {
    log "Shutting down API"
    kill "$APP_PID" 2>/dev/null || true
    rm -f "$TMP_CONTRACT"
}
trap cleanup EXIT


# Wait for app to become healthy
HEALTH_URL="http://localhost:${SERVICE_PORT}/actuator/health"
MAX_WAIT=60
for i in $(seq 1 $MAX_WAIT); do
    if curl -sf "$HEALTH_URL" | grep -q '"status":"UP"'; then
        log "API is healthy"
        break
    fi
    sleep 1
done

curl -sf "$HEALTH_URL" | grep -q '"status":"UP"' \
    || fail "API did not become healthy in $MAX_WAIT seconds"

# --------------------------------------------------
# Step 2: Fetch live OpenAPI contract
# --------------------------------------------------
API_URL="http://localhost:${SERVICE_PORT}/v3/api-docs"
log "Fetching live OpenAPI contract"
curl -s "$API_URL" | jq -S '.' > "$TMP_CONTRACT"

# --------------------------------------------------
# Step 3: Compare with committed contract
# --------------------------------------------------
if [[ ! -f "$CONTRACT_FILE" ]]; then
    log "No committed contract found, creating initial contract"
    cp "$TMP_CONTRACT" "$CONTRACT_FILE"
    fail "Initial contract created. Please review and commit."
fi

log "Comparing OpenAPI contracts"
if diff -u <(jq -S '.' "$CONTRACT_FILE") <(jq -S '.' "$TMP_CONTRACT"); then
    log "No OpenAPI changes detected"
else
    fail "OpenAPI contract changes detected. Please review and commit."
fi