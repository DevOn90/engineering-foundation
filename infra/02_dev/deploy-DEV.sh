#!/bin/bash


# 2. If not the same ask to enter the latest image (should not be the 'latest')
# 3. Update .emv with entered image
# 4. Run image validation again after manual update
# 5. docker compose pull
# 6. docker compose up -d
# 7. if above success act as test executor orchestrator
# 8. start individual tests
  # Smoke tests
  # Health tests
  # API sanity tests
  # Black-box only  
# 9. if all tests pass: 
  # docker tag idevon90/api:sha-abc123 idevon90/api:dev-approved
  # docker push idevon90/api:dev-approved


set -euo pipefail

/usr/bin/echo "===================================================="
/usr/bin/echo "#         Deploy & Test Dev Environment            #"
/usr/bin/echo "===================================================="
/usr/bin/echo

#----------------------------------------------------------
# 1. Validate.env and read IMAGE_TAG 
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
  /usr/bin/echo "ERROR: IMAGE_TAG must not be 'latest'."
  /usr/bin/echo "Please use a CI-produced immutable tag (e.g. sha-abc123)."
  exit 1   
fi

/usr/bin/echo "INFO: IMAGE_TAG found = $IMAGE_TAG"

# -------------------------------------------------------------------------
# 2. Validate that Docker image exists in registry and its the latest by ci
# -------------------------------------------------------------------------

IMAGE_NAME="idevon90/api:${IMAGE_TAG}"

/usr/bin/echo "INFO: Validating image exists in registry: $IMAGE_NAME"

# 2.1 Check if Image exists in Docker Hub
if ! docker manifest inspect "$IMAGE_NAME" >/dev/null 2>&1; then
  echo "ERROR: Docker image not found in registry: $IMAGE_NAME"
  echo "Ensure CI has successfully pushed this image."
  exit 1
fi

echo "INFO: Docker image exists in registry."

# 2.2 Check if Image is the latest created by CI

CURRENT_IMG_DIGEST=$(docker manifest inspect "$IMAGE_NAME" | jq -r '.config.digest')
LATEST_IMG_DIGEST=$(docker manifest inspect idevon90/api:ci-latest | jq -r '.config.digest')

if [[ "$CURRENT_IMG_DIGEST" != "$LATEST_IMG_DIGEST" ]]; then
    echo "ERROR: IMAGE_TAG=$IMAGE_TAG is NOT the latest CI image (digest mismatch)"
    echo "ERROR: Ensure the latest docker image with sha tag in IMAGE_TAG .env file"
    exit 1
fi

echo "INFO: IMAGE_TAG=$IMAGE_TAG is the latest CI image"