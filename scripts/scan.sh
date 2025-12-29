# scan.sh - Secrets scanning script using GitLeaks
#
# Description:
#   This script runs GitLeaks to scan for secrets in the codebase. It supports both
#   Git-based scanning (pre-commit) and direct filesystem scanning (non-Git mode).
#
# Environment Variables:
#   VERSION                     - Version number displayed in the banner
#   GITLEAKS_CONFIGURATION_FILE - Path to custom GitLeaks configuration file (optional)
#   GITLEAKS_IGNORE_FILE        - Path to GitLeaks ignore file (optional)
#   GIT_MODE                    - Set to "false" to scan without Git history
#
# Exit Codes:
#   0 - Scan completed successfully with no secrets detected
#   1 - Missing dependencies, unable to find /src directory, or secrets detected
#
# Dependencies:
#   - gitleaks: Must be installed and available in PATH
#   - /src directory: Must exist and contain the source code to scan
#
# Modes:
#   Git Mode (default): Runs pre-commit scan using Git history
#   Non-Git Mode: Scans filesystem directly without Git, outputs JSON report

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

# Argument build
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

# GitLeaks
if [ "$GIT_MODE" != "false" ]; then
    gitleaks git --pre-commit --redact --exit-code 1 --verbose $CONFIGURATION_ARGUMENT $IGNORE_ARGUMENT
else
    gitleaks detect --source . --no-git --redact --report-path gitleaks-report.json --report-format json --exit-code 1 --verbose $CONFIGURATION_ARGUMENT $IGNORE_ARGUMENT
fi

# Successful
echo "✅ No secrets have been detected."
exit 0;
