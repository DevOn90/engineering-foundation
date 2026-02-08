#!/usr/bin/env bash
# ----------------------------------------------------
# local.sh
# Entry point for local dev environment management
# Usage: ./local.sh [FLAGS] <COMMAND>
# ----------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail

# ----------------------------------------------------
# Parse flags (optional)
#
# LOG_LEVEL controls verbosity:
#   ERROR < WARN < INFO < DEBUG < TRACE
#   --quiet    => LOG_LEVEL=WARN
#   --verbose  => LOG_LEVEL=DEBUG
#   --trace    => LOG_LEVEL=TRACE
#
# --ci      => sets CI=true (JSON logging)
# --no-color => disables colorized logs
# ----------------------------------------------------
LOG_LEVEL="INFO"
NO_COLOR=false
ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-color) export NO_COLOR=true; shift ;;
    --quiet)   export LOG_LEVEL="WARN"; shift ;;
    --verbose) export LOG_LEVEL="DEBUG"; shift ;;
    --trace)   export LOG_LEVEL="TRACE"; shift ;;
    --ci) export CI=true; shift ;; 
    --help|-h) COMMAND="help"; shift ;;
    --*) echo "Unknown flag: $1"; exit 1 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done

# The first non-flag argument is the command
COMMAND="${ARGS[0]:-help}"

# ----------------------------------------------------
# Source common helpers
# ----------------------------------------------------

source "$(cd "${BASH_SOURCE[0]%/*}" && pwd)/helpers/common.sh"

# Debug & trace initial
trace "local.sh started"
trace "Common helpers sourced."
debug "LOG_LEVEL set to ${LOG_LEVEL}"
debug "NO_COLOR=${NO_COLOR}"
debug "CI=${CI:-false}"
debug "Commnad resolved, command=${COMMAND}"

# ----------------------------------------------------
# Dispatch commands
# ----------------------------------------------------
trace "Dispatching command=${COMMAND}"
case "$COMMAND" in
  init)
    log "Initializing local environment..." 
    "$SCRIPT_DIR/init.sh"
    ;;

  pull-env)
    log "Pulling environment files..." 
    "$SCRIPT_DIR/pull-env.sh" 
    ;;

  up)
    log "Starting local stack..." 
    "$SCRIPT_DIR/up.sh"
    ;;

  down)
    log "Stopping local stack..."
    "$SCRIPT_DIR/down.sh"
    ;;

  reset)
    log "Resetting local environment..."
    "$SCRIPT_DIR/reset.sh"
    ;;

  help|*)
    cat <<EOF
Usage: $0 [FLAGS] <COMMAND>

FLAGS:
  --quiet     Only warnings & errors
  --verbose   Debug logs
  --trace     Trace level logs
  --ci        Force CI JSON logging
  --help      Show this message

COMMANDS:
  init        First-time local setup. Calls helpers/init.sh
  pull-env    Pull environment variables from secure store. Calls helpers/pull-env.sh 
  up          Start local dev stack. Calls helpers/up.sh
  down        Stop local dev stack. Calls helpers/down.sh
  reset       Nuke & rebuild local stack. Calls helpers/reset.sh
  help        Show this message.
EOF
    ;;
esac
trace "local.sh finished..."


