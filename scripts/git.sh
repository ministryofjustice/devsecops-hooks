#!/usr/bin/env bash
set -euo pipefail

# Git Installation Script
#
# Purpose:
#   Installs Git version control system in Alpine Linux containers.
#   Required for GitLeaks to perform Git-aware secret scanning on repositories.
#
# Dependencies:
#   - apk: Alpine Package Keeper for package management
#
# Installation process:
#   1. Installs git package via Alpine's package manager
#   2. Uses --no-cache flag to minimise image size
#
# Exit codes:
#   0 - Installation completed successfully
#   1 - Installation failed (network issues, package unavailable, etc.)
#
# Example usage:
#   ./git.sh
#

apk add --no-cache git