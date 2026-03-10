#!/usr/bin/env bash
set -euo pipefail

# GitLeaks Binary Installation Script
#
# Purpose:
#   Downloads, verifies, and installs the GitLeaks secret detection binary
#   for Alpine Linux x64 architecture. Implements security best practices
#   through SHA-512 checksum verification.
#
# Environment Variables (Required):
#   GIT_LEAKS_VERSION - Version number of GitLeaks to install (e.g., "8.18.0")
#   GIT_LEAKS_SHA512  - Expected SHA-512 checksum for binary verification
#
# Dependencies:
#   - wget: HTTP client for downloading releases from GitHub
#   - tar:  Archive extraction utility for unpacking compressed binaries
#
# Installation Process:
#   1. Validates required environment variables are set
#   2. Downloads GitLeaks binary from GitHub releases (30s timeout, 3 retries)
#   3. Computes SHA-512 checksum and verifies against expected value
#   4. Extracts binary to /usr/local/bin for system-wide access
#   5. Validates successful installation by checking executable presence
#   6. Removes downloaded archive to minimise container size
#
# Exit Codes:
#   0 - Installation completed successfully
#   1 - Missing required environment variable
#   1 - Missing required dependency (wget/tar)
#   1 - Checksum verification failed (security violation)
#   1 - Binary extraction or installation failed
#
# Security Considerations:
#   - Uses SHA-512 checksums to prevent tampering
#   - Implements connection timeout and retry limits
#   - Validates executable installation before cleanup
#
# Example Usage:
#   GIT_LEAKS_VERSION=8.18.0 GIT_LEAKS_SHA512=abc123... ./gitleaks.sh
#

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