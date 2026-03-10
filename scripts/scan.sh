#!/usr/bin/env bash
set -euo pipefail

echo -e "\n⚡️ Ministry of Justice - Scanner ${VERSION} ⚡️\n";

COMMAND="${1:-}"
CODEDIR="/src"

case "$COMMAND" in

commit)
    COMMITLINT_CONFIGURATION_ARGUMENT=()
    if [ -f "$COMMITLINT_CONFIGURATION_FILE" ]; then
        COMMITLINT_CONFIGURATION_ARGUMENT=(--config "$COMMITLINT_CONFIGURATION_FILE")
    fi

    COMMIT_MSG_FILE="${2:-}"

    # Validation
    if [[ -z "$COMMIT_MSG_FILE" ]]; then
        echo "❌ Unable to read commit message from '${COMMIT_MSG_FILE}'.";
        exit 1;
    fi


    COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")
    
    # Pre-requisites
    cd "${WORKDIR}" || { echo "❌ Unable to switch to /${WORKDIR} directory."; exit 1; }

    # Commitlint
    echo "${COMMIT_MSG}" | npm run validate:commit:message -- "${COMMITLINT_CONFIGURATION_ARGUMENT[@]}"
    ;;

*)
    # Validation
    if ! command -v gitleaks >/dev/null 2>&1; then
        echo "❌ Missing gitleaks executable.";
        exit 1;
    fi

    
    cd "${CODEDIR}" || { echo "❌ Unable to switch to /${CODEDIR} directory."; exit 1; }

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
        gitleaks git --pre-commit --redact "${STAGED_FILES[@]}" --verbose --exit-code 1 "${GITLEAKS_CONFIGURATION_ARGUMENT[@]}" "${GITLEAKS_IGNORE_ARGUMENT[@]}"
    else
        gitleaks detect --source . --no-git --redact --report-format json --exit-code 1 --verbose "${GITLEAKS_CONFIGURATION_ARGUMENT[@]}" "${GITLEAKS_IGNORE_ARGUMENT[@]}"
    fi
    ;;

esac

# Successful
echo "✅ No secrets have been detected."
exit 0;