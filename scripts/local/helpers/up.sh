#!/usr/bin/env bash

# up.sh 

set -o errexit
set -o nounset
set -o pipefail

# ----------------------------------------------------
# Source common helpers
# ----------------------------------------------------
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/common.sh"

# log "I am up.sh"
# log "Purpose: Start local Docker stack."
# log "Depends on: .local-initialized + env files."
# log "Typical flow:"
# log "  1. Check require_initialized"
# log "  2. Run docker compose up using .env files"
# log "  3. Map logs, volumes, networks"

log "Random log message..."
warn "This is a warning, check configs"
error "This is an error"
debug "Debugging details, only if LOG_LEVEL=DEBUG or higher"
trace "Trace-level info, only if LOG_LEVEL=TRACE"