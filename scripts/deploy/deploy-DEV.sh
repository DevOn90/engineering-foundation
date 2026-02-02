#!/bin/bash

# ------------------------------------------------------------------
# Script: deploy-DEV.sh
# Purpose: Orchestrate DEV environment deployment, testing, and
#          promotion of Docker image to DEV-approved.
#
# Usage:
#   ./deploy-DEV.sh
#
# Preconditions:
#   - Docker daemon running
#   - .env file exists with IMAGE_TAG
#   - Tests scripts exist in ./tests/...
#   - Docker Hub credentials configured for push
#
# Postconditions:
#   - DEV environment tested and validated
#   - Image optionally promoted to DEV-approved tags
#
# Logging:
#   - Test logs saved under ./logs/<test-type>/
# ------------------------------------------------------------------

set -euo pipefail

# ---------------------------------------------------------
# Helpers
# ---------------------------------------------------------

# Resolve script directory path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

COMPOSE_BASE="${SCRIPT_DIR}/../docker-compose.base.yml"
COMPOSE_DEV="${SCRIPT_DIR}/docker-compose.dev.yml"
COMPOSE_CMD="/usr/bin/docker compose \
            --env-file "${SCRIPT_DIR}/.env" \
            -f ${COMPOSE_BASE} \
            -f ${COMPOSE_DEV}" 
              

log() {
    /usr/bin/echo "[DEV-ENV][INFO] $1"
}

fail() {
    /usr/bin/echo "[DEV-ENV][ERROR] $1"
    exit 1
}

docker_down() {
  log "Removing created Docker Containers."
  $COMPOSE_CMD down
}

trap docker_down EXIT

log ""
log "===================================================="
log "#         Deploy & Test Dev Environment            #"
log "===================================================="
log "" 

#----------------------------------------------------------
# 1. Validate .env and read IMAGE_TAG 
#---------------------------------------------------------

ENV_FILE=".env"

# 1.1 Check if .env exists
if [[ ! -f "$ENV_FILE" ]];then
    fail "$ENV_FILE not found."
    fail "Please create it from .env.example and set IMAGE_TAG."
    exit 1
else
    log ".env file found"
fi

# 1.2 Read IMAGE_TAG from .env
log "Reading Docker image tag from .env file."
IMAGE_TAG=$(/usr/bin/grep -E '^IMAGE_TAG=' "$ENV_FILE" | /usr/bin/cut -d '=' -f2- | /usr/bin/tr -d '"')

# 1.3 Validate IMAGE_TAG Presence 
if [[ -z "${IMAGE_TAG:-}" ]]; then
  fail "IMAGE_TAG is not set in $ENV_FILE."
  fail "Please set IMAGE_TAG to a CI-produced immutable tag (not 'latest')."
  exit 1
fi

# 1.4 Reject 'latest'
if [[ "$IMAGE_TAG" == "ci-latest" ]]; then
  fail "IMAGE_TAG must not be 'ci-latest'."
  fail "Please use a CI-produced immutable tag (e.g. sha-abc123)."
  exit 1   
fi

log "IMAGE_TAG found = $IMAGE_TAG"

# -------------------------------------------------------------------------
# 2. Validate that Docker image exists in registry and its the latest by ci
# -------------------------------------------------------------------------

IMAGE_NAME="idevon90/api:${IMAGE_TAG}"

log "Validating image exists in registry: $IMAGE_NAME"

# 2.1 Check if Image exists in Docker Hub in "Public Repo"
if ! /usr/bin/docker manifest inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  fail "Docker image not found in registry: $IMAGE_NAME"
  fail "A. Ensure CI has successfully pushed this image."
  fail "B. Ensure .env has right/last image created by CI."
  exit 1
fi

log "Docker image exists in registry."

# 2.2 Check if Image is the latest created by CI

CURRENT_IMG_DIGEST=$(/usr/bin/docker manifest inspect "$IMAGE_NAME" | /usr/bin/jq -r '.config.digest')
LATEST_IMG_DIGEST=$(/usr/bin/docker manifest inspect idevon90/api:ci-latest | /usr/bin/jq -r '.config.digest')

if [[ "$CURRENT_IMG_DIGEST" != "$LATEST_IMG_DIGEST" ]]; then
    fail "IMAGE_TAG=$IMAGE_TAG is NOT the latest CI image (digest mismatch)"
    fail "Ensure the latest docker image with sha tag in IMAGE_TAG .env file"
    exit 1
fi

log "IMAGE_TAG=$IMAGE_TAG is the latest CI image"

# -------------------------------------------------------------------------
# 3. Pull & Build Docker Image in DEV environment
# -------------------------------------------------------------------------
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 3.1 Pull
$COMPOSE_CMD pull
#/usr/bin/docker compose --env-file "${SCRIPT_DIR}/.env" -f "${SCRIPT_DIR}/../docker-compose.base.yml" -f "${SCRIPT_DIR}/docker-compose.dev.yml" pull

# 3.2 Build
$COMPOSE_CMD up -d
#/usr/bin/docker compose --env-file "${SCRIPT_DIR}/.env" -f "${SCRIPT_DIR}/../docker-compose.base.yml" -f "${SCRIPT_DIR}/docker-compose.dev.yml" up -d

# -------------------------------------------------------------------------
# 4. Orchestrate DEV environment Tests 
# -------------------------------------------------------------------------

log ""
log "===================================================="
log "#         Test Dev Environment                     #"
log "===================================================="
log ""

# 4.0 Create Tests log folders & time stamp variable
mkdir -p ./logs/smoke ./logs/health ./logs/sanity ./logs/black-box
TS=$(date +%Y%m%d-%H%M%S)

# 4.1 Run Smoke tests
log "Running Smoke Tests"
if ! ./tests/smoke-tests/dev-smt-01.sh 2>&1 | tee ./logs/smoke/smoke-$TS.log; then
    fail "Smoke tests failed! Check ./logs/smoke/smoke-*.log"
    exit 1
fi

# 4.2 Run Health tests
log "Running Health Tests"
if ! ./tests/health-tests/dev-health-01.sh 2>&1 | tee ./logs/health/health-$TS.log; then
    fail "Health tests failed! Check ./logs/health/health-*.log"
    exit 1
fi
  
# 4.3 API sanity tests
log "Running API Sanity Tests"
if ! ./tests/api-sanity-tests/dev-sanity-01.sh 2>&1 | tee ./logs/sanity/api-sanity-$TS.log; then
    fail "API Sanity tests failed! Check ./logs/sanity/api-sanity-*.log"
    exit 1
fi

# 4.4 Black-box only  
log "Running Black-box Tests"
if ! ./tests/black-box-tests/api-endpoints.sh 2>&1 | tee ./logs/black-box/black-box-$TS.log; then
    fail "Black-box tests failed! Check ./logs/black-box/black-box-*.log"
    exit 1
fi

# -------------------------------------------------------------------------
# 5. Promotion  
# -------------------------------------------------------------------------

log ""
log "===================================================="
log "#         Promote Image: DEV Approved               #"
log "===================================================="
log ""

SOURCE_IMAGE="idevon90/api:${IMAGE_TAG}"
SOURCE_DIGEST=$(/usr/bin/docker manifest inspect "$SOURCE_IMAGE" | /usr/bin/jq -r '.config.digest')
PROMOTED_TAG="dev-approved-${IMAGE_TAG}"
TARGET_IMAGE="idevon90/api:${PROMOTED_TAG}"

# 5.0 Check if dev-approved tag already exists
if /usr/bin/docker manifest inspect "$TARGET_IMAGE" >/dev/null 2>&1; then
  EXISTING_DIGEST=$(/usr/bin/docker manifest inspect "$TARGET_IMAGE" | /usr/bin/jq -r '.config.digest')

  if [[ "$EXISTING_DIGEST" == "$SOURCE_DIGEST" ]]; then
    log "Image already promoted to DEV-approved ($TARGET_IMAGE)"
    log "Promotion is idempotent — nothing to do."
    exit 0
  else
    fail "$TARGET_IMAGE already exists but points to a DIFFERENT image"
    fail "Manual intervention required."
    exit 1
  fi
fi

# 5.1 Tag image as DEV-approved
log "Tagging image for DEV approval"
/usr/bin/docker tag "$SOURCE_IMAGE" "$TARGET_IMAGE"

# 5.2 Ensure Docker is authenticated
log "Checking Docker Hub authentication"

if ! /usr/bin/docker info >/dev/null 2>&1; then
  fail "Docker daemon is not running"
  exit 1
fi

if ! /usr/bin/docker manifest inspect idevon90/api:ci-latest >/dev/null 2>&1; then
  fail "Docker Hub authentication required"
  fail "Please login using: docker login"
  exit 1
fi

log "Docker Hub authentication verified"

# 5.4 Push DEV-approved image
log "Pushing DEV-approved image to registry"
/usr/bin/docker push "$TARGET_IMAGE"

# 5.5 Optional: also maintain a moving DEV pointer
log "Updating dev-approved-latest pointer"
/usr/bin/docker tag "$SOURCE_IMAGE" idevon90/api:dev-approved-latest
/usr/bin/docker push idevon90/api:dev-approved-latest

log ""
log "SUCCESS: Image promoted to DEV-approved"
log " - Immutable tag: $PROMOTED_TAG"
log " - Rolling tag: dev-approved-latest"

# -------------------------------------------------------------------------
# 6. Finalization  
# -------------------------------------------------------------------------

log ""
log "===================================================="
log "#       DEV Environment Completed Sucessfully      #"
log "===================================================="
log ""