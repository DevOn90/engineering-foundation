#!/usr/bin/env bash
set -euo pipefail

# ==================================================
# Engineering Foundation - Repository Setup
#
# Purpose:
#   Bootstraps local development environment after
#   cloning the repository.
#
# Usage:
#   ./scripts/setup.sh
#
# Idempotent:
#   Safe to run multiple times.
# ==================================================

# --------------------------------------------------
# Helpers
# --------------------------------------------------

log() {
    echo "[Setup][INFO] $1"
}

fail() {
    echo "[Setup][ERROR] $1"
    exit 1
}

# ---------------------------------------------------
# Initialization
# ---------------------------------------------------

log "Starting repository setup"

# Resolve repository root to ensure consistent path resolution
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------------------------------------------------
# Step1: Ensure all repo scripts executability
# ---------------------------------------------------

bash ./make-executable.sh

# ---------------------------------------------------
# Step 2: Git Hooks Setup
# ---------------------------------------------------

log "Configuraing Git Hooks"

"$REPO_ROOT/scripts/setup-hooks.sh"

# ----------------------------------------------------
# Finalization
# ----------------------------------------------------

log "Repository setup completed successfully"