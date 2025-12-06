# scan.sh - Security scanner for detecting secrets in code
#
# DESCRIPTION:
#   This script runs the MoJ (Ministry of Justice) security scanner to detect
#   secrets and sensitive information in source code using GitLeaks.
#
# REQUIREMENTS:
#   - gitleaks: Command-line tool for detecting hardcoded secrets
#   - bash shell with set -eu (exit on error, exit on undefined variables)
#
# ENVIRONMENT VARIABLES:
#   VERSION: Version number of the MoJ scanner to be displayed
#   SCAN_SOURCE: Directory to scan for secrets (default: /src)
#
# USAGE:
#   ./scan.sh
#
# EXIT CODES:
#   0 - Success: No secrets detected
#   1 - Failure: Either gitleaks is missing or secrets were detected
#
# NOTES:
#   - The script scans the /src directory
#   - GitLeaks runs in no-git mode (doesn't require a git repository)
#   - Verbose output is enabled for detailed scanning information

#!/bin/sh
set -eu

SCAN_SOURCE="${SCAN_SOURCE:-/src}"

echo -e "\n⚡️ Ministry of Justice - Scanner [ ${VERSION} ] ⚡️\n";

# Dependencies
if ! command -v gitleaks >/dev/null 2>&1; then
    echo "❌ Missing gitleaks executable.";
    exit 1;
fi

# GitLeaks
gitleaks detect --source="${SCAN_SOURCE}" --exit-code 1 --no-git --verbose

# Successful
echo "✅ No secrets have been detected."
exit 0;
