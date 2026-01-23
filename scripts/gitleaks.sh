# GitLeaks Installation Script
#
# This script downloads, verifies, and installs GitLeaks - a tool for detecting hardcoded secrets
# in git repositories.
#
# Required Environment Variables:
#   GIT_LEAKS_VERSION - The version of GitLeaks to install (e.g., "8.18.0")
#   GIT_LEAKS_SHA512  - The SHA-512 checksum for the downloaded archive
#
# Dependencies:
#   - wget: Required for downloading the GitLeaks archive
#   - tar: Required for extracting the archive
#
# Installation Process:
#   1. Validates required environment variables are set
#   2. Checks for required dependencies (wget, tar)
#   3. Downloads GitLeaks archive from GitHub releases
#   4. Verifies download integrity using SHA-512 checksum
#   5. Extracts the binary to /usr/local/bin
#   6. Validates successful installation
#   7. Cleans up temporary files (currently commented out)
#
# Exit Codes:
#   0 - Installation completed successfully
#   1 - Installation failed (missing dependencies, checksum mismatch, etc.)
#
# Example Usage:
#   export GIT_LEAKS_VERSION="8.18.0"
#   export GIT_LEAKS_SHA512="<checksum-value>"
#   ./gitleaks.sh
#

#!/bin/bash
set -euo pipefail

# Environment variable definition
if [ -z "${GIT_LEAKS_VERSION:-}" ]; then
    echo "❌ Missing GIT_LEAKS_VERSION environment variable";
    exit 1;
fi

# Variables
URL="https://github.com/gitleaks/gitleaks/releases/download/v${GIT_LEAKS_VERSION}/gitleaks_${GIT_LEAKS_VERSION}_linux_x64.tar.gz"
FILE="gitleaks_${GIT_LEAKS_VERSION}_linux_x64.tar.gz"

# Dependencies
if ! command -v wget >/dev/null 2>&1; then
    echo "❌ Missing wget executable.";
    exit 1;
fi

echo $(wget --version);

if ! command -v tar >/dev/null 2>&1; then
    echo "❌ Missing tar executable.";
    exit 1;
fi

echo "⚡️ Installing GitLeaks ${GIT_LEAKS_VERSION}.";

# Download
wget -q -T 30 --tries=3 -O "$FILE" "$URL"

# Checksum
CHECKSUM=$(sha512sum "$FILE" | awk '{print $1}')

if [ "$GIT_LEAKS_SHA512" != "$CHECKSUM" ]; then
    echo "❌ Failed checksum";
    exit 1;
fi

# Extract
tar -xzf "$FILE" -C /usr/local/bin

# Validate
command -v gitleaks >/dev/null 2>&1 || { echo "❌ Missing gitleaks executable."; exit 1; }

# Cleanup
rm -f "$FILE"

echo "✅ GitLeaks ${GIT_LEAKS_VERSION} has been installed."
exit 0;
