#!/usr/bin/env bash

# init.sh 

set -o errexit
set -o nounset
set -o pipefail

# ----------------------------------------------------
# Source common helpers
# ----------------------------------------------------
INIT_DIR="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/common.sh"

log "Purpose: Initialize this repo for local development."
log "Actions:"
log    "Create .local-initialized marker"
log    "execute scripts/bootstrap/setup.sh"
$INIT_DIR/../../bootstrap/setup.sh 
log    "Create log directories"
log    "Optional: generate or link .env placeholders"
log "Must be run once per repo clone."
log "Other scripts (up, pull-env) will require this marker."



# ---------------------------------------------------
# Step 1: TBD (Provision)
# ---------------------------------------------------
#mkdir -p ${SCRIPT_DIR}/../../logs/api/local
#mkdir -p ${SCRIPT_DIR}/../../logs/api/local
#mkdir -p ${SCRIPT_DIR}/../../logs/api/dev/smoke 
#mkdir -p ${SCRIPT_DIR}/../../logs/api/dev/health
#mkdir -p ${SCRIPT_DIR}/../../logs/api/dev/sanity
#mkdir -p ${SCRIPT_DIR}/../../logs/api/dev/black-box