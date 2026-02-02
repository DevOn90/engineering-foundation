#!/bin/bash

set -euo pipefail

# --------------------------------------------------
# Helpers
# --------------------------------------------------

log() {
    /usr/bin/echo "[DEV-ENV][INFO] $1"
}

fail() {
    /usr/bin/echo "[DEV-ENV][ERROR] $1"
    exit 1
}

log "Health test placeholder"