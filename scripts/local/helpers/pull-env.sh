#!/usr/bin/env bash

# pull-env.sh 

set -o errexit
set -o nounset
set -o pipefail

# Source common helpers
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/common.sh"


# log "Purpose: Pull sensitive .env files from secure storage (Vault, AWS Secrets, local secrets repo)."
# log "Can be rerun if env changes."
# log "Should be run after init (since init sets up the directory structure where .env will go)."

log "Random log message..."
warn "This is a warning, check configs"
error "This is an error"
debug "Debugging details, only if LOG_LEVEL=DEBUG or higher"
trace "Trace-level info, only if LOG_LEVEL=TRACE"