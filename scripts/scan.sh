# scan.sh - Ministry of Justice DevSecOps Secret Scanner
#
# Description:
#   This script scans source code repositories for secrets and sensitive information
#   using GitLeaks. It supports both Git-based scanning (for commits) and directory-based
#   scanning (non-Git mode).
#
# Prerequisites:
#   - gitleaks: Must be installed and available in PATH
#   - Source code: Must be mounted at /src directory
#
# Environment Variables:
#   VERSION                      - Scanner version to display in header
#   GIT_MODE                     - Set to "false" to disable Git mode (default: enabled)
#   GITLEAKS_CONFIGURATION_FILE  - Optional path to custom GitLeaks configuration file
#   GITLEAKS_IGNORE_FILE         - Optional path to GitLeaks ignore file (.gitleaksignore)
#
# Exit Codes:
#   0 - Success: No secrets detected
#   1 - Failure: Missing dependencies, directory not found, or secrets detected
#
# Usage:
#   # Git mode (for pre-commit hooks):
#   GIT_MODE=true ./scan.sh
#
#   # Non-Git mode (for directory scanning):
#   GIT_MODE=false ./scan.sh
#
#   # With custom configuration:
#   GITLEAKS_CONFIGURATION_FILE=.gitleaks.toml ./scan.sh
#
# Output:
#   - Displays scan progress and results to stdout
#   - In non-Git mode: Generates gitleaks-report.json with findings
#
# Notes:
#   - All secrets are redacted in output for security
#   - Script uses 'set -euo pipefail' for strict error handling

#!/bin/bash
set -euo pipefail

echo -e "\n⚡️ Ministry of Justice - Scanner ${VERSION} ⚡️\n";

# Dependencies
if ! command -v gitleaks >/dev/null 2>&1; then
    echo "❌ Missing gitleaks executable.";
    exit 1;
fi

# Pre-requisites
cd /src || { echo "❌ Unable to find /src directory."; exit 1; }

if [ -f "$GITLEAKS_CONFIGURATION_FILE" ]; then
    CONFIGURATION_ARGUMENT="--config $GITLEAKS_CONFIGURATION_FILE"
else
    CONFIGURATION_ARGUMENT=""
fi

if [ -f "$GITLEAKS_IGNORE_FILE" ]; then
    IGNORE_ARGUMENT="--gitleaks-ignore-path $GITLEAKS_IGNORE_FILE"
else
    IGNORE_ARGUMENT=""
fi

echo -e "========${GIT_MODE}--${GITLEAKS_IGNORE_FILE}--${GITLEAKS_CONFIGURATION_FILE}";

# GitLeaks
if [ "$GIT_MODE" != "false" ]; then
    gitleaks git --pre-commit --redact --exit-code 1 --verbose $CONFIGURATION_ARGUMENT $IGNORE_ARGUMENT
else
    gitleaks detect --source . --no-git --redact --report-path gitleaks-report.json --report-format json --exit-code 1 --verbose $CONFIGURATION_ARGUMENT $IGNORE_ARGUMENT
fi

# Successful
echo "✅ No secrets have been detected."
exit 0;
