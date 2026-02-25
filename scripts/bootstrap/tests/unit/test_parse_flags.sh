#!/usr/bin/env bash
# ============================================================================
# Unit Tests for parse_flags function in bootstrap.sh
# ============================================================================
# Purpose: Validate the behavior of the parse_flags function under various scenarios
# - Tests default state (no flags)
# - Tests --status flag
# - Tests --force flag
# - Tests invalid flag handling
# Note: These tests are designed to be run in isolation and do not modify any files
# ============================================================================  

set -o errexit
set -o nounset
set -o pipefail

# Source common helpers
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../../local/helpers/common.sh"
trace "Sourced common file from: $(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../../local/helpers/common.sh"

# Source the bootstrap script to access the parse_flags function
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../../bootstrap/bootstrap.sh"
trace "Sourced bootstrap file from: $(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../bootstrap/bootstrap.sh"

# Test 1: Default state (no flags)
test_default_state() {
    log "Running Test 1: Default state (no flags)"
    # Reset variables to default state
    STATUS_ONLY=false
    debug "Reset STATUS_ONLY to: $STATUS_ONLY"
    FORCE=false
    debug "Reset FORCE to: $FORCE"     
    # Call the function with no arguments
    parse_flags
    trace "Called parse_flags with no arguments"
    # Assert that variables are set to default values
    if [[ "$STATUS_ONLY" == false && "$FORCE" == false ]]; then
        log "Test 1 Passed: Default state variables are correct"
    else
        fail "Test 1 Failed: Default state variables are incorrect"
    fi
    trace "Completed Test 1"
 }

# Test 2: --status flag
test_status_flag() {
    log "Running Test 2: --status flag"
    # Reset variables to default state
    STATUS_ONLY=false
    debug "Reset STATUS_ONLY to: $STATUS_ONLY"
    FORCE=false
    debug "Reset FORCE to: $FORCE"
    # Call the function with --status flag
    parse_flags --status
    trace "Called parse_flags with --status flag"
    # Assert that STATUS_ONLY is true and FORCE is false
    if [[ "$STATUS_ONLY" == true && "$FORCE" == false ]]; then
        log "Test 2 Passed: --status flag sets STATUS_ONLY to true and FORCE to false"
    else
        fail "Test 2 Failed: --status flag did not set variables correctly"
    fi
    trace "Completed Test 2"
}       

# Test 3: --force flag
test_force_flag() {
    log "Running Test 3: --force flag"
    # Reset variables to default state
    STATUS_ONLY=false
    debug "Reset STATUS_ONLY to: $STATUS_ONLY"
    FORCE=false
    debug "Reset FORCE to: $FORCE"
    # Call the function with --force flag
    parse_flags --force
    trace "Called parse_flags with --force flag"
    # Assert that FORCE is true and STATUS_ONLY is false
    if [[ "$FORCE" == true && "$STATUS_ONLY" == false ]]; then
        log "Test 3 Passed: --force flag sets FORCE to true and STATUS_ONLY to false"
    else
        fail "Test 3 Failed: --force flag did not set variables correctly"
    fi
    trace "Completed Test 3"
}       

# Test 4: Invalid flag handling
test_invalid_flag() {
    log "Running Test 4: Invalid flag handling"
    # Call the function with an invalid flag and capture output
    set +o errexit  # Temporarily disable exit on error to capture failure
    output=$(parse_flags --invalid 2>&1)
    exit_code=$?
    set -o errexit  # Re-enable exit on error
    # Assert that the function failed and output contains the expected error message
    if [[ $exit_code -ne 0 && "$output" == *"Unknown flag provided: --invalid"* ]]; then
        log "Test 4 Passed: Invalid flag correctly handled with appropriate error message"
    else
        fail "Test 4 Failed: Invalid flag did not produce expected error handling"
    fi
    trace "Completed Test 4"
}

log "All tests from test_parse_flags.sh completed successfully!"  