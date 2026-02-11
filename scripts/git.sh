# Git Installation Script
#
# Purpose:
#   Installs Git version control system in Alpine Linux Docker containers
#   using the Alpine Package Keeper (apk) package manager.
#
# Description:
#   Performs a minimal, cache-free installation of Git to reduce Docker image size.
#   The --no-cache flag prevents apk from storing package indices and downloaded
#   files locally, keeping the final image as small as possible.
#
# Dependencies:
#   - apk: Alpine Package Keeper (package manager for Alpine Linux)
#   - Internet connectivity: Required to fetch packages from Alpine repositories
#
# Behaviour:
#   - Installs the latest stable version of Git from Alpine repositories
#   - Does not cache package index locally (saves space)
#   - Does not store downloaded .apk files (saves space)
#   - Automatically resolves and installs Git dependencies
#
# Exit Codes:
#   0 - Installation completed successfully
#   Non-zero - Installation failed (returned by apk)
#
# Package Details:
#   - Package name: git
#   - Source: Alpine Linux official repositories
#   - Typical size: ~10-15 MB (including dependencies)
#
# Usage:
#   ./git.sh
#   or
#   sh git.sh
#
# Docker Context:
#   This script is executed during the Docker image build process
#   to provide Git functionality for GitLeaks scanning operations.
#
# Security:
#   - Uses official Alpine repositories (signed packages)
#   - No custom repositories or untrusted sources
#   - Minimal attack surface due to no cached files
#
# Notes:
#   - Designed specifically for Alpine Linux
#   - For other distributions, use appropriate package manager (apt, yum, dnf)
#   - The --no-cache flag is Alpine-specific and highly recommended for containers
#

#!/bin/bash
set -euo pipefail

apk add --no-cache git