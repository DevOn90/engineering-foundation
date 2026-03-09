#!/usr/bin/env bash

# Common setup for bootstrap units and integration tests
  
# ============================================================================
# Common Setup for Bootstrap Script Tests
# ============================================================================
# Purpose: Provide shared setup and utilities for both unit and integration tests of the bootstrap script
# - Sets strict error handling for robust test execution
# - Sources common helper functions for logging and tracing
# - Determines and logs the script directory for reference in test scripts
#  
# Note: This file is intended to be sourced by individual test scripts, not executed directly
# ============================================================================

# Enable strict error handling to ensure that any command failure causes the test to fail immediately
set -o errexit
set -o nounset
set -o pipefail

# Source common helpers for logging and tracing functions
source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../local/helpers/common.sh"

# Log the path from which the common file is sourced for debugging purposes
trace "Sourced common file from: $(cd "${BASH_SOURCE[0]%/*}" && pwd)/../../local/helpers/common.sh"

# Determine the directory of the current script for reference in test scripts
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"

# Log the script directory path for debugging purposes
debug "Script directory path: $SCRIPT_DIR" 

# Source the bootstrap script to access its functions
source "$SCRIPT_DIR/../bootstrap.sh"
trace "Sourced bootstrap script from: $SCRIPT_DIR/../bootstrap.sh"