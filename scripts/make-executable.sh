#!/usr/bin/bash env
set -euo pipefail

# --------------------------------------------------
# Helpers
# --------------------------------------------------

log() {
  echo "[make-exec][INFO] $1"
}

fail() {
  echo "[make-exec][ERROR] $1"
  exit 1
}

# --------------------------------------------------
# Initialization
# --------------------------------------------------

log "Starting Scripts executability settings."

# Resolve repository root to ensure consistent path resolution
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# -------------------------------------------------- 
# Step 1: Make all shell script in script/ executable
# --------------------------------------------------

find "$REPO_ROOT/scripts/" -type f -name "*.sh" -exec chmod +x {} \;
log "All scripts in scripts/ are executable"

# --------------------------------------------------
# Step 2: Make all shell scripts in .githooks executable
# --------------------------------------------------

HOOKS_DIR="$REPO_ROOT/.githooks"
chmod +x "$HOOKS_DIR"/*
log "All git hooks are executable"

# --------------------------------------------------
# Finalization
# --------------------------------------------------

log "All scripts are executable."