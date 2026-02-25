#!/usr/bin/env bash
# ============================================================================
# Orchestrator Script to Run All Bootstrap Tests
# ============================================================================
# Purpose: Sequentially execute all unit and integration tests for the bootstrap script

set -o errexit
set -o nounset
set -o pipefail

# Source common helpers
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../local/helpers/common.sh"
trace "Sourced common file from: $(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../local/helpers/common.sh"
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"
trace "Script directory path: $SCRIPT_DIR"

# List of unit test scripts to execute (relative to this script's directory)
TEST_UNIT_SCRIPTS=(
    "unit/test_parse_flags.sh"
    "unit/test_make_bootstrap_marker.sh"
    "unit/test_validate_bootstrap_marker.sh"     
)
trace "Defined test scripts to run: ${TEST_UNIT_SCRIPTS[*]}"

# List of integration test scripts to execute (relative to this script's directory)
TEST_INTEGRATION_SCRIPTS=(
    "integration/test_status_mode.sh"
    "integration/test_force_mode.sh"
    "integration/test_normal_bootstrap.sh"
    "integration/test_conflicting_flags.sh"
)
trace "Defined integration test scripts to run: ${TEST_INTEGRATION_SCRIPTS[*]}"

# ================================================================
# Execute unit tests
# ================================================================
log "Starting to run bootstrap unit tests..."
for TEST_SCRIPT in "${TEST_UNIT_SCRIPTS[@]}"; do     
    log "Executing test script: $SCRIPT_DIR/$TEST_SCRIPT"
    bash "$SCRIPT_DIR/$TEST_SCRIPT"
    log "Completed test: $SCRIPT_DIR/$TEST_SCRIPT"
    log "----------------------------------------"
done    

log "All bootstrap unit tests completed successfully!"

# ================================================================
# Execute integration tests
# ================================================================
log "Starting to run bootstrap integration tests..."
for TEST_SCRIPT in "${TEST_INTEGRATION_SCRIPTS[@]}"; do
    log "Executing test script: $SCRIPT_DIR/$TEST_SCRIPT"
    bash "$SCRIPT_DIR/$TEST_SCRIPT"
    log "Completed test: $SCRIPT_DIR/$TEST_SCRIPT"
    log "----------------------------------------"
done    

log "All bootstrap integration tests completed successfully!"
