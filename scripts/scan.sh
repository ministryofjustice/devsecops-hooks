# scan.sh - Secrets Scanning Script using GitLeaks
#
# Purpose:
#   Main entry point for scanning repositories for hardcoded secrets and credentials
#   using GitLeaks. Supports both Git-based pre-commit scanning and direct filesystem
#   scanning for non-Git environments.
#
# Description:
#   This script is the Docker container's ENTRYPOINT and orchestrates the secret
#   scanning process. It validates dependencies, changes to the source directory,
#   constructs appropriate GitLeaks command-line arguments, and executes the scan.
#
# Required Environment Variables:
#   VERSION     - Version number displayed in the startup banner (e.g., "1.4.0")
#   GIT_MODE    - Scanning mode: "true" for Git mode, "false" for filesystem mode
#
# Optional Environment Variables:
#   GITLEAKS_CONFIGURATION_FILE - Path to custom GitLeaks configuration file
#                                 (default: ./.gitleaks.toml)
#   GITLEAKS_IGNORE_FILE        - Path to GitLeaks ignore file for false positives
#                                 (default: ./.gitleaksignore)
#
# Exit Codes:
#   0 - Scan completed successfully with no secrets detected
#   1 - One of the following occurred:
#       - GitLeaks executable not found
#       - /src directory not accessible
#       - Secrets detected in codebase
#
# Dependencies:
#   - gitleaks: Must be installed and available in PATH
#   - /src directory: Must exist and contain the source code to scan
#   - bash: Bourne Again Shell
#
# Scanning Modes:
#
#   1. Git Mode (GIT_MODE=true, default):
#      - Purpose: Pre-commit hook scanning using Git history
#      - Command: gitleaks git --pre-commit --redact --staged --verbose --exit-code 1
#      - Scans: Only staged files in Git repository
#      - Use case: Integrated pre-commit hooks
#      - Output: Terminal output with coloured results
#
#   2. Non-Git Mode (GIT_MODE=false):
#      - Purpose: Direct filesystem scanning without Git
#      - Command: gitleaks detect --source . --no-git --redact --report-format json
#      - Scans: All files in the source directory
#      - Use case: CI/CD pipelines, non-Git repositories
#      - Output: JSON report (gitleaks-report.json)
#
# Configuration Files:
#   - .gitleaks.toml: Custom rules and patterns for secret detection
#   - .gitleaksignore: Fingerprints of false positives to ignore
#
# Workflow:
#   1. Display startup banner with version
#   2. Validate GitLeaks executable exists
#   3. Change to /src directory (mounted volume)
#   4. Build command-line arguments based on config files
#   5. Execute GitLeaks in appropriate mode
#   6. Display results and exit with appropriate code
#
# Example Usage:
#   # In Docker container (Git mode)
#   docker run --rm -v $(pwd):/src devsecops-hooks:local
#
#   # In Docker container (Non-Git mode)
#   docker run --rm -v $(pwd):/src -e GIT_MODE=false devsecops-hooks:local
#
#   # Direct execution
#   export VERSION="1.4.0"
#   export GIT_MODE="true"
#   ./scan.sh
#
# Security Considerations:
#   - Runs in isolated Docker container as non-root user
#   - Redacts actual secret values in output
#   - Exit code 1 blocks Git commits when secrets found
#   - Configuration files can customize sensitivity
#
# Integration:
#   - Pre-commit framework: Triggered automatically on git commit
#   - GitHub Actions: Can be integrated in CI/CD workflows
#   - Manual: Can be executed directly for ad-hoc scans
#
# Notes:
#   - Staged files only in Git mode (--staged flag)
#   - Full repository scan in non-Git mode
#   - Verbose output enabled for debugging
#   - GitLeaks v8.30.0 currently in use
#

#!/bin/bash
set -euo pipefail

echo -e "\n⚡️ Ministry of Justice - Scanner ${VERSION} ⚡️\n";

# Dependencies validation
if ! command -v gitleaks >/dev/null 2>&1; then
    echo "❌ Missing gitleaks executable.";
    exit 1;
fi

# Pre-requisites check
cd /src || { echo "❌ Unable to find /src directory."; exit 1; }

# Argument construction
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

# GitLeaks execution
if [ "$GIT_MODE" != "false" ]; then
    # Git mode: Pre-commit scanning with staged files
    gitleaks git --pre-commit --redact --staged --verbose --exit-code 1 $CONFIGURATION_ARGUMENT $IGNORE_ARGUMENT
else
    # Non-Git mode: Filesystem scanning with JSON output
    gitleaks detect --source . --no-git --redact --report-format json --exit-code 1 --verbose $CONFIGURATION_ARGUMENT $IGNORE_ARGUMENT
fi

# Success message
echo "✅ No secrets have been detected."
exit 0;
