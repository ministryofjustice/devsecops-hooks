#!/usr/bin/env bash
set -euo pipefail 

# Install npm package manager and dependencies for the project
# - apk add --no-cache npm: Installs npm without caching to reduce image size
# - npm ci --ignore-scripts: Performs a clean install of dependencies from package-lock.json
#   without running lifecycle scripts for security and reproducibility

apk add --no-cache npm
npm ci --ignore-scripts