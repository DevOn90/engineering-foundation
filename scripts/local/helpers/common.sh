#!/usr/bin/env bash

# ----------------------------------------------------
# common.sh
# Shared helpers for local scripts
# DO NOT execute directly, instead 'source'
#
# Version: 2.0.0
# Stability: stable
#
# Contract:
# - Logging levels: ERROR, WARN, INFO, DEBUG, TRACE
# - LOG_LEVEL controls verbosity
# - CI=true enables JSON logs
# - Colors enabled only for human output
# - Supports --no-color flag tp disable colors manually
# - Supports LOG_CONTEXT environment variable for log scoping
#   * If LOG_CONTEXT is exported, logs shows it e.g.: [service=db]
#   * If LOG_CONTEXT is not exported, placeholder id shows: [LOG_CONTEXT]
# - All logging function (log,debug,trace,warn,error,fail) respects 
#   environment variables LOG_LEVEL, CI, LOG_CONTEXT
#
# Details:
# For more details, check README.local.md 
# Source common helpers AFTER LOG_FD is configured
# so all logging functions inherit the correct output FD.
#
# Breaking changes require version bump
# ----------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail

# Minimal safe PATH to control centrally
export PATH="/usr/local/bin:/usr/bin:/bin"

# --------------------------------------------------
# Logging configuration (passive)
# --------------------------------------------------

# Contract for Logging
LOG_LEVEL="${LOG_LEVEL:-INFO}"   # ERROR | WARN | INFO | DEBUG | TRACE
NO_COLOR="${NO_COLOR:-false}"
LOG_CONTEXT="${LOG_CONTEXT:-LOG_CONTEXT}"
CI="${CI:-false}"
LOG_FD="${LOG_FD:-1}"

# --------------------------------------------------
# Paths (resolved once, safely)
# --------------------------------------------------
SCRIPT_NAME="${SCRIPT_NAME:-$(basename "${0}")}"
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" && pwd)"
LOCAL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$LOCAL_DIR/../.." && pwd)"

LOGS_DIR="$REPO_ROOT/logs/local/shell"
INFRA_DIR="$REPO_ROOT/infra"
ENV_DIR="$INFRA_DIR/runtime/env"

# --------------------------------------------------
# Color Handling (TTY-aware + --no-color)
# --------------------------------------------------

if [[ "$NO_COLOR" == "true"  ]] || [[ ! -t 2 ]]; then
  COLOR_YELLOW=""
  COLOR_RED=""
  COLOR_BLUE=""
  COLOR_DIM=""
  COLOR_RESET=""
else
  COLOR_YELLOW="\033[33m"
  COLOR_RED="\033[31m"
  COLOR_BLUE="\033[34m"
  COLOR_DIM="\033[2m"
  COLOR_RESET="\033[0m"
fi

# --------------------------------------------------
# Log level helpers
# --------------------------------------------------
_level_to_num() {
  case "$1" in
    ERROR) echo 0 ;;
    WARN)  echo 1 ;;
    INFO)  echo 2 ;;
    DEBUG) echo 3 ;;
    TRACE) echo 4 ;;
    *)     echo 2 ;;
  esac
}

_should_log() {
  [[ $(_level_to_num "$1") -le $(_level_to_num "$LOG_LEVEL") ]]
}

timestamp() {
  date +"%Y-%m-%dT%H:%M:%S%z"
}

# --------------------------------------------------
# Logging functions
# --------------------------------------------------
_log() {
  local level="$1"; shift
  _should_log "$level" || return 0

  local color=""
  case "$level" in
    DEBUG) color="$COLOR_BLUE" ;;
    TRACE) color="$COLOR_DIM" ;; 
  esac

  if [[ "$CI" == "true" ]]; then
    printf '{"ts":"%s","level":"%s","context":"%s","script":"%s","msg":"%s"}\n' \
      "$(timestamp)" "$level" "$LOG_CONTEXT" "$SCRIPT_NAME" "$*"
  else
    printf '%b[%s][%s][%s][%s]: %s%b\n' "$color" "$(timestamp)" "$level" "$LOG_CONTEXT" "$SCRIPT_NAME" "$*" "$COLOR_RESET" >&"$LOG_FD"
  fi
}

log()   { _log INFO  "$@"; }
debug() { _log DEBUG "$@"; }
trace() { _log TRACE "$@"; }

warn() {
  _should_log WARN || return 0
  if [[ "$CI" == "true" ]]; then
    _log WARN "$@"
  else
    printf '%b[%s][WARN][%s][%s]: %s%b\n' \
    "$COLOR_YELLOW" "$(timestamp)" "$LOG_CONTEXT" "$SCRIPT_NAME" "$*" "$COLOR_RESET" >&"$LOG_FD"
  fi
  
}

error() {
  if [[ "$CI" == "true" ]]; then
    _log ERROR "$@"
  else
    printf '%b[%s][ERROR][%s][%s]: %s%b\n' \
      "$COLOR_RED" "$(timestamp)" "$LOG_CONTEXT" "$SCRIPT_NAME" "$*" "$COLOR_RESET" >&"$LOG_FD"
  fi
}

fail() {
  error "$@"
  return 1
}

# --------------------------------------------------
# Guards
# --------------------------------------------------
require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command '$1' not found"
}

require_file() {
  [[ -f "$1" ]] || fail "Required file '$1' not found"
}

require_dir() {
  [[ -d "$1" ]] || fail "Required directory '$1' not found"
}

# --------------------------------------------------
# State markers
# --------------------------------------------------
require_initialized() {
  [[ -f "$REPO_ROOT/.local-initialized" ]] \
    || fail "Local environment not initialized. Run: scripts/local/local.sh init"
}


##########################################################################
## Related to above 'require_initialized'
## Flow
## local.sh init   → creates .local-initialized
## local.sh up     → requires_initialized → OK
## local.sh reset  → removes marker
## local.sh up     → FAILS (correctly)

###########################################################################
## For new logging FS 
## adjust deploy-DEv.sh
## dcoker-compose.local.yml 

##############################################################################
# INFO - What is happening?
# DEBUG - Developer diagnostic, values, decisions, resolved path
# TRACE - Where exactly, we are right now?
