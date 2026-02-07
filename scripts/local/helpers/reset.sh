#!/usr/bin/env bash

# reset.sh 

set -o errexit
set -o nounset
set -o pipefail

# ----------------------------------------------------
# Source common helpers
# ----------------------------------------------------
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/common.sh"

# log "Purpose: Nuke & rebuild local environment."
# log "Actions:"
# log    "Stop Docker containers (down)"
# log    "Remove volumes, logs, caches"
# log    "Remove .local-initialized marker (forces fresh init)"

log "Random log message..."
warn "This is a warning, check configs"
error "This is an error"
debug "Debugging details, only if LOG_LEVEL=DEBUG or higher"
trace "Trace-level info, only if LOG_LEVEL=TRACE"