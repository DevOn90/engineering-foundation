#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Helpers
# --------------------------------------------------

log() {
  echo "[setup-hooks][INFO] $1"
}

fail() {
  echo "[setup-hooks][ERROR] $1"
  exit 1
}

# ---------------------------------------------------
# Initialization
# ---------------------------------------------------

log "Starting Git hooks settings."

# Resolve repository root to ensure consistent path resolution
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

HOOKS_DIR="$REPO_ROOT/.githooks"

# ---------------------------------------------------
# Step 2: Setting Git hooks path to .githooks
# ---------------------------------------------------

if [[ ! -d "$HOOKS_DIR" ]]; then
  fail ".githooks directory not found"
fi

log "Setting Git hooks path to .githooks"
git config core.hooksPath .githooks

log "Ensuring hooks are executable"
chmod +x "$HOOKS_DIR"/*

log "Git hooks configured successfully"

# Other future setup tasks
# e.g., install dependencies, run migrations, etc.