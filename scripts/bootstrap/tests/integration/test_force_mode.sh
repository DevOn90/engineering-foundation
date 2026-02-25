#!/usr/bin/env bash
# ============================================================================
# Integration Test for --force Mode of Bootstrap Script
# ============================================================================
# Purpose: Verify that the --force flag correctly forces re-bootstrap and recreates marker

set -o errexit
set -o nounset
set -o pipefail

# Source common helpers
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../../local/helpers/common.sh"
trace "Sourced common file from: $(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../../local/helpers/common.sh"
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"
debug "Script directory path: $SCRIPT_DIR"  

# Source the bootstrap script to access its functions
source "$SCRIPT_DIR/../../bootstrap.sh"
trace "Sourced bootstrap script from: $SCRIPT_DIR/../../bootstrap.sh"   

log "To be completed: Implement integration tests for --force mode of bootstrap script"