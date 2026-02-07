#!/usr/bin/env bash

# down.sh 

set -o errexit
set -o nounset
set -o pipefail

# ----------------------------------------------------
# Source common helpers
# ----------------------------------------------------
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/common.sh"

# log "Purpose: Stop running local stack without removing setup"
# log "Actions:"
# log    "docker compose down"
# log    "Keep .local-initialized and logs"

log "Random log message..."
warn "This is a warning, check configs"
error "This is an error"
debug "Debugging details, only if LOG_LEVEL=DEBUG or higher"
trace "Trace-level info, only if LOG_LEVEL=TRACE"