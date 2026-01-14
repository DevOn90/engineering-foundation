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

/usr/bin/echo "===================================================="
/usr/bin/echo "#         Deploy & Test Dev Environment            #"
/usr/bin/echo "===================================================="
/usr/bin/echo

#----------------------------------------------------------
# 1. Validate .env and read IMAGE_TAG 
#---------------------------------------------------------

ENV_FILE=".env"

# 1.1 Check if .env exists
if [[ ! -f "$ENV_FILE" ]];then
    /usr/bin/echo "[Error]: $ENV_FILE not found."
    /usr/bin/echo "Please create it from .env.example and set IMAGE_TAG."
    exit 1
else
    /usr/bin/echo "INFO: .env file found"
fi

# 1.2 Read IMAGE_TAG from .env
/usr/bin/echo "INFO: Reading Docker image tag from .env file."
IMAGE_TAG=$(/usr/bin/grep -E '^IMAGE_TAG=' "$ENV_FILE" | /usr/bin/cut -d '=' -f2- | /usr/bin/tr -d '"')

# 1.3 Validate IMAGE_TAG Presence 
if [[ -z "${IMAGE_TAG:-}" ]]; then
  /usr/bin/echo "ERROR: IMAGE_TAG is not set in $ENV_FILE."
  /usr/bin/echo "Please set IMAGE_TAG to a CI-produced immutable tag (not 'latest')."
  exit 1
fi

# 1.4 Reject 'latest'
if [[ "$IMAGE_TAG" == "ci-latest" ]]; then
  /usr/bin/echo "ERROR: IMAGE_TAG must not be 'ci-latest'."
  /usr/bin/echo "Please use a CI-produced immutable tag (e.g. sha-abc123)."
  exit 1   
fi

/usr/bin/echo "INFO: IMAGE_TAG found = $IMAGE_TAG"

# -------------------------------------------------------------------------
# 2. Validate that Docker image exists in registry and its the latest by ci
# -------------------------------------------------------------------------

IMAGE_NAME="idevon90/api:${IMAGE_TAG}"

/usr/bin/echo "INFO: Validating image exists in registry: $IMAGE_NAME"

# 2.1 Check if Image exists in Docker Hub in "Public Repo"
if ! /usr/bin/docker manifest inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  /usr/bin/echo "ERROR: Docker image not found in registry: $IMAGE_NAME"
  /usr/bin/echo "A. Ensure CI has successfully pushed this image."
  /usr/bin/echo "B. Ensure .env has right/last image created by CI."
  exit 1
fi

echo "INFO: Docker image exists in registry."

# 2.2 Check if Image is the latest created by CI

CURRENT_IMG_DIGEST=$(/usr/bin/docker manifest inspect "$IMAGE_NAME" | /usr/bin/jq -r '.config.digest')
LATEST_IMG_DIGEST=$(/usr/bin/docker manifest inspect idevon90/api:ci-latest | /usr/bin/jq -r '.config.digest')

if [[ "$CURRENT_IMG_DIGEST" != "$LATEST_IMG_DIGEST" ]]; then
    /usr/bin/echo "ERROR: IMAGE_TAG=$IMAGE_TAG is NOT the latest CI image (digest mismatch)"
    /usr/bin/echo "ERROR: Ensure the latest docker image with sha tag in IMAGE_TAG .env file"
    exit 1
fi

/usr/bin/echo "INFO: IMAGE_TAG=$IMAGE_TAG is the latest CI image"

# -------------------------------------------------------------------------
# 3. Pull & Build Docker Image in DEV environment
# -------------------------------------------------------------------------

# 3.1 Pull
/usr/bin/docker compose pull

# 3.2 Build
/usr/bin/docker compose up -d

# -------------------------------------------------------------------------
# 4. Orchestrate DEV environment Tests 
# -------------------------------------------------------------------------

/usr/bin/echo
/usr/bin/echo "===================================================="
/usr/bin/echo "#         Test Dev Environment                     #"
/usr/bin/echo "===================================================="
/usr/bin/echo

# 4.0 Create Tests log folders & time stamp variable
mkdir -p ./logs/smoke ./logs/health ./logs/sanity ./logs/black-box
TS=$(date +%Y%m%d-%H%M%S)

# 4.1 Run Smoke tests
/usr/bin/echo "INFO: Running Smoke Tests"
if ! ./tests/smoke-tests/dev-smt-01.sh 2>&1 | tee ./logs/smoke/smoke-$TS.log; then
    /usr/bin/echo "ERROR: Smoke tests failed! Check ./logs/smoke/smoke-*.log"
    exit 1
fi

# 4.2 Run Health tests
/usr/bin/echo "INFO: Running Health Tests"
if ! ./tests/health-tests/dev-health-01.sh 2>&1 | tee ./logs/health/health-$TS.log; then
    /usr/bin/echo "ERROR: Health tests failed! Check ./logs/health/health-*.log"
    exit 1
fi
  
# 4.3 API sanity tests
/usr/bin/echo "INFO: Running API Sanity Tests"
if ! ./tests/api-sanity-tests/dev-sanity-01.sh 2>&1 | tee ./logs/sanity/api-sanity-$TS.log; then
    /usr/bin/echo "ERROR: API Sanity tests failed! Check ./logs/sanity/api-sanity-*.log"
    exit 1
fi

# 4.4 Black-box only  
/usr/bin/echo "INFO: Running Black-box Tests"
if ! ./tests/black-box-tests/api-endpoints.sh 2>&1 | tee ./logs/black-box/black-box-$TS.log; then
    /usr/bin/echo "ERROR: Black-box tests failed! Check ./logs/black-box/black-box-*.log"
    exit 1
fi

# -------------------------------------------------------------------------
# 5. Promotion  
# -------------------------------------------------------------------------

/usr/bin/echo
/usr/bin/echo "===================================================="
/usr/bin/echo "#         Promote Image: DEV Approved               #"
/usr/bin/echo "===================================================="
/usr/bin/echo

SOURCE_IMAGE="idevon90/api:${IMAGE_TAG}"
SOURCE_DIGEST=$(/usr/bin/docker manifest inspect "$SOURCE_IMAGE" | /usr/bin/jq -r '.config.digest')
PROMOTED_TAG="dev-approved-${IMAGE_TAG}"
TARGET_IMAGE="idevon90/api:${PROMOTED_TAG}"

# 5.0 Check if dev-approved tag already exists
if /usr/bin/docker manifest inspect "$TARGET_IMAGE" >/dev/null 2>&1; then
  EXISTING_DIGEST=$(/usr/bin/docker manifest inspect "$TARGET_IMAGE" | /usr/bin/jq -r '.config.digest')

  if [[ "$EXISTING_DIGEST" == "$SOURCE_DIGEST" ]]; then
    /usr/bin/echo "INFO: Image already promoted to DEV-approved ($TARGET_IMAGE)"
    /usr/bin/echo "INFO: Promotion is idempotent — nothing to do."
    exit 0
  else
    /usr/bin/echo "ERROR: $TARGET_IMAGE already exists but points to a DIFFERENT image"
    /usr/bin/echo "Manual intervention required."
    exit 1
  fi
fi

# 5.1 Tag image as DEV-approved
/usr/bin/echo "INFO: Tagging image for DEV approval"
/usr/bin/docker tag "$SOURCE_IMAGE" "$TARGET_IMAGE"

# 5.2 Ensure Docker is authenticated
/usr/bin/echo "INFO: Checking Docker Hub authentication"

if ! /usr/bin/docker info >/dev/null 2>&1; then
  /usr/bin/echo "ERROR: Docker daemon is not running"
  exit 1
fi

if ! /usr/bin/docker manifest inspect idevon90/api:ci-latest >/dev/null 2>&1; then
  /usr/bin/echo "ERROR: Docker Hub authentication required"
  /usr/bin/echo "Please login using: docker login"
  exit 1
fi

/usr/bin/echo "INFO: Docker Hub authentication verified"

# 5.4 Push DEV-approved image
/usr/bin/echo "INFO: Pushing DEV-approved image to registry"
/usr/bin/docker push "$TARGET_IMAGE"

# 5.5 Optional: also maintain a moving DEV pointer
/usr/bin/echo "INFO: Updating dev-approved-latest pointer"
/usr/bin/docker tag "$SOURCE_IMAGE" idevon90/api:dev-approved-latest
/usr/bin/docker push idevon90/api:dev-approved-latest

/usr/bin/echo
/usr/bin/echo "SUCCESS: Image promoted to DEV-approved"
/usr/bin/echo " - Immutable tag: $PROMOTED_TAG"
/usr/bin/echo " - Rolling tag: dev-approved-latest"