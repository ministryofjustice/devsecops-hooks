#!/usr/bin/env bash
set -euo pipefail

# Secret Scanning and Commit Validation Script
#
# Purpose:
#   Main execution script for the Ministry of Justice DevSecOps scanner.
#   Performs secret detection using GitLeaks and commit message validation
#   using Commitlint. Designed to run as a Docker container entrypoint.
#
# Environment Variables:
#   VERSION                       - Scanner version number for display
#   WORKDIR                       - Working directory for commit validation (default: /app)
#   STAGE_MODE                    - Enable staged files scanning (default: true)
#   GIT_MODE                      - Enable Git-aware scanning (default: true)
#   GITLEAKS_CONFIGURATION_FILE   - Path to .gitleaks.toml configuration file
#   GITLEAKS_IGNORE_FILE          - Path to .gitleaksignore file for false positives
#   COMMITLINT_CONFIGURATION_FILE - Path to commitlint.config.js file
#
# Commands:
#   commit <message_file> - Validate commit message against conventional commits format
#   (default)             - Scan for hardcoded secrets using GitLeaks
#
# Dependencies:
#   - gitleaks: Secret detection binary (required for default mode)
#   - npm: Node package manager for commitlint (required for commit mode)
#   - git: Version control system (required when GIT_MODE=true)
#
# Scanning Modes:
#   Git mode (GIT_MODE=true):
#     - Scans Git repository with awareness of .gitignore rules
#     - Can scan staged files only (STAGE_MODE=true) for pre-commit hooks
#     - Outputs redacted findings to protect discovered secrets
#   
#   Filesystem mode (GIT_MODE=false):
#     - Scans all files in directory tree recursively
#     - Ignores Git metadata and .gitignore rules
#     - Generates JSON report of findings for audit trail
#
# Exit Codes:
#   0 - No secrets detected / Commit message valid
#   1 - Secrets detected / Invalid commit message / Validation errors
#
# Security Considerations:
#   - Redacts secrets in output to prevent exposure
#   - Supports custom ignore patterns for false positives
#   - Validates commit messages before allowing commits
#
# Example Usage:
#   # Scan staged files for secrets (pre-commit hook)
#   ./scan.sh
#
#   # Validate commit message (commit-msg hook)
#   ./scan.sh commit /path/to/COMMIT_EDITMSG
#
#   # Scan entire directory without Git awareness
#   GIT_MODE=false ./scan.sh
#
#   # Scan all files (not just staged)
#   STAGE_MODE=false ./scan.sh
#

echo -e "\n⚡️ Ministry of Justice - Scanner ${VERSION} ⚡️\n";

COMMAND="${1:-}"
CODEDIR="/src"

case "$COMMAND" in

commit)
    COMMITLINT_CONFIGURATION_ARGUMENT=()
    if [ -f "$COMMITLINT_CONFIGURATION_FILE" ]; then
        COMMITLINT_CONFIGURATION_ARGUMENT=(--config "$COMMITLINT_CONFIGURATION_FILE")
    fi

    COMMIT_FILE="${2:-}"

    # Validation
    if [[ -z "$COMMIT_FILE" || ! -f "$COMMIT_FILE" ]]; then
        echo "❌ Unable to read commit message from '${COMMIT_FILE}'.";
        exit 1;
    fi

    COMMIT_MESSAGE=$(cat "${COMMIT_FILE}")

     if ! command -v npm >/dev/null 2>&1; then
        echo "❌ Missing npm executable.";
        exit 1;
    fi
    
    # Pre-requisites
    cd "${WORKDIR}" || { echo "❌ Unable to switch to ${WORKDIR} directory."; exit 1; }

    # Commitlint
    echo "${COMMIT_MESSAGE}" | npm run validate:commit:message -- "${COMMITLINT_CONFIGURATION_ARGUMENT[@]}"

    # Successful
    echo "✅ Commit conforms to conventional commit."
    exit 0;
    ;;

*)
    # Validation
    if ! command -v gitleaks >/dev/null 2>&1; then
        echo "❌ Missing gitleaks executable.";
        exit 1;
    fi

    
    cd "${CODEDIR}" || { echo "❌ Unable to switch to ${CODEDIR} directory."; exit 1; }

    # Argument build
    STAGED_FILES=()
    if [ "${STAGE_MODE:-true}" == "true" ]; then
        STAGED_FILES=("--staged")
    fi

    GITLEAKS_CONFIGURATION_ARGUMENT=()
    if [ -f "$GITLEAKS_CONFIGURATION_FILE" ]; then
        GITLEAKS_CONFIGURATION_ARGUMENT=(--config "$GITLEAKS_CONFIGURATION_FILE")
    fi

    GITLEAKS_IGNORE_ARGUMENT=()
    if [ -f "$GITLEAKS_IGNORE_FILE" ]; then
        GITLEAKS_IGNORE_ARGUMENT=(--gitleaks-ignore-path "$GITLEAKS_IGNORE_FILE")
    fi

    # GitLeaks
    if [ "${GIT_MODE:-true}" != "false" ]; then
        gitleaks git --no-banner --pre-commit --redact "${STAGED_FILES[@]}" --verbose --exit-code 1 "${GITLEAKS_CONFIGURATION_ARGUMENT[@]}" "${GITLEAKS_IGNORE_ARGUMENT[@]}"
    else
        gitleaks detect --no-banner --source . --no-git --redact --report-format json --exit-code 1 --verbose "${GITLEAKS_CONFIGURATION_ARGUMENT[@]}" "${GITLEAKS_IGNORE_ARGUMENT[@]}"
    fi

    # Successful
    echo "✅ No secrets have been detected."
    exit 0;
    ;;

esac

