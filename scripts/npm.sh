#!/usr/bin/env bash
set -euo pipefail

# NPM Installation and Dependencies Script
#
# Purpose:
#   Installs Node.js package manager (npm) in Alpine Linux containers and
#   installs project dependencies using deterministic installation method.
#   Used for commitlint and other Node-based validation tools.
#
# Environment Variables:
#   None required - uses system defaults
#
# Dependencies:
#   - apk: Alpine Package Keeper for package management
#   - package-lock.json: Must exist in project root for deterministic installs
#
# Installation Process:
#   1. Installs npm via Alpine's package manager without caching layer
#   2. Performs clean install of dependencies using npm ci (faster, stricter)
#   3. Ignores package scripts for security (prevents arbitrary code execution)
#
# Exit Codes:
#   0 - Installation completed successfully
#   1 - Installation failed (missing package-lock.json, network issues, etc.)
#
# Security Considerations:
#   - Uses npm ci instead of npm install for reproducible builds
#   - Ignores scripts to prevent malicious package hooks
#   - No cache layer reduces container attack surface
#
# Example Usage:
#   ./npm.sh
#

apk add --no-cache npm
npm ci --ignore-scripts