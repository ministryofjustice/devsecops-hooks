# GitLeaks Installation Script
#
# Purpose:
#   Downloads, verifies, and installs GitLeaks binary for detecting hardcoded secrets
#   in Git repositories. Used during Docker image build process.
#
# Description:
#   This script performs a secure installation of GitLeaks by downloading the official
#   release from GitHub, verifying its integrity with SHA-512 checksum, and installing
#   it to /usr/local/bin for system-wide access.
#
# Required Environment Variables:
#   GIT_LEAKS_VERSION - The version of GitLeaks to install (e.g., "8.30.0")
#   GIT_LEAKS_SHA512  - The SHA-512 checksum for the downloaded archive (for integrity verification)
#
# Optional Environment Variables:
#   None
#
# Dependencies:
#   - wget: Command-line utility for downloading files from the web
#   - tar: Archive extraction utility
#   - sha512sum: Checksum calculation utility
#   - awk: Text processing utility
#
# Installation Process:
#   1. Validates required environment variables are set
#   2. Constructs download URL and file name
#   3. Checks for required dependencies (wget, tar)
#   4. Downloads GitLeaks archive from GitHub releases
#   5. Calculates SHA-512 checksum of downloaded file
#   6. Verifies download integrity by comparing checksums
#   7. Extracts the gitleaks binary to /usr/local/bin
#   8. Validates successful installation by checking binary availability
#   9. Cleans up temporary download files
#
# Exit Codes:
#   0 - Installation completed successfully
#   1 - Installation failed due to:
#       - Missing required environment variables
#       - Missing system dependencies (wget, tar)
#       - Checksum verification failure
#       - Binary not found after extraction
#
# Example Usage:
#   export GIT_LEAKS_VERSION="8.30.0"
#   export GIT_LEAKS_SHA512="3ae7b3e80a19ee9dd16098577d61f280b6b87d908ead1660deef27911aa407165ac68dbed0d60fbe16dc8e1d7f2e5f9f2945b067f54f0f64725070d16e0dbb58"
#   ./gitleaks.sh
#
# Security Considerations:
#   - Uses SHA-512 checksum verification to ensure download integrity
#   - Downloads from official GitHub releases only
#   - Fails immediately if checksum doesn't match (prevents tampered binaries)
#   - Timeout and retry limits prevent indefinite hanging
#
# Notes:
#   - Designed for Alpine Linux but compatible with most Linux distributions
#   - Assumes x86_64 architecture (linux_x64)
#   - Requires internet connectivity to download from GitHub
#   - Installation requires write permissions to /usr/local/bin
#

#!/bin/bash
set -euo pipefail

# Environment variable validation
if [ -z "${GIT_LEAKS_VERSION:-}" ]; then
    echo "❌ Missing GIT_LEAKS_VERSION environment variable";
    exit 1;
fi

if [ -z "${GIT_LEAKS_SHA512:-}" ]; then
    echo "❌ Missing GIT_LEAKS_SHA512 environment variable";
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

# Checksum verification
CHECKSUM=$(sha512sum "$FILE" | awk '{print $1}')

if [ "$GIT_LEAKS_SHA512" != "$CHECKSUM" ]; then
    echo "❌ Checksum verification failed";
    echo "  Expected: $GIT_LEAKS_SHA512";
    echo "  Got:      $CHECKSUM";
    exit 1;
fi

# Extract
tar -xzf "$FILE" -C /usr/local/bin

# Validate installation
command -v gitleaks >/dev/null 2>&1 || { echo "❌ GitLeaks executable not found after installation."; exit 1; }

# Cleanup
rm -f "$FILE"

echo "✅ GitLeaks ${GIT_LEAKS_VERSION} has been installed successfully."
exit 0;
