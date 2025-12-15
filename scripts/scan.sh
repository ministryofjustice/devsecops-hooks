# scan.sh - Security scanning script for Ministry of Justice DevSecOps hooks
#
# DESCRIPTION:
#   This script performs security scanning on git repositories to detect
#   secrets and sensitive information before commits are finalized.
#
# DEPENDENCIES:
#   - gitleaks: Secret detection tool (required)
#   - bash/sh: Shell interpreter
#
# ENVIRONMENT VARIABLES:
#   VERSION - Version number of the scanner tool
#
# USAGE:
#   ./scan.sh
#
# EXIT CODES:
#   0 - Success, no secrets detected
#   1 - Failure, either missing dependencies or secrets detected
#
# BEHAVIOR:
#   - Runs with strict error handling (set -euo pipefail)
#   - Checks for gitleaks installation
#   - Changes to /src directory
#   - Executes gitleaks in pre-commit mode with verbose output
#   - Exits with code 1 if secrets are found
#
# NOTES:
#   This script is typically run as a git pre-commit hook to prevent
#   sensitive information from being committed to the repository.

#!/bin/sh
set -euo pipefail

echo -e "\n⚡️ Ministry of Justice - Scanner ${VERSION} ⚡️\n";

# Dependencies
if ! command -v gitleaks >/dev/null 2>&1; then
    echo "❌ Missing gitleaks executable.";
    exit 1;
fi

# Pre-requisites
cd /src

# Arguments
CONFIGURATION="/src/.gitleaks/config.toml"
IGNORE="/src/.gitleaks/.gitleaksignore"

if [ -f "$CONFIGURATION" ]; then
    CONFIGURATION_ARGUMENT="--config $CONFIGURATION"
else
    CONFIGURATION_ARGUMENT=""
fi

if [ -f "$IGNORE" ]; then
    IGNORE_ARGUMENT="--gitleaks-ignore-path $IGNORE"
else
    IGNORE_ARGUMENT=""
fi

# GitLeaks
gitleaks git --pre-commit --redact --exit-code 1 --verbose $CONFIGURATION_ARGUMENT $IGNORE_ARGUMENT

# Successful
echo "✅ No secrets have been detected."
exit 0;
