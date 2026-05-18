#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUNDLED_CONFIG="${REPO_ROOT}/.gitleaks.toml"
OVERRIDE_FILE=".gitleaks.override.toml"

if ! command -v gitleaks >/dev/null 2>&1; then
    printf 'ERROR: gitleaks is not installed. See: https://github.com/gitleaks/gitleaks#installing\n' >&2
    exit 1
fi

if [ -f "$OVERRIDE_FILE" ]; then
    if grep -q '^\[extend\]' "$OVERRIDE_FILE"; then
        printf 'ERROR: .gitleaks.override.toml must not contain [extend]\n' >&2
        exit 1
    fi
    TMPCONFIG="$(mktemp)"
    trap 'rm -f "$TMPCONFIG"' EXIT
    printf '[extend]\npath = "%s"\n\n' "$BUNDLED_CONFIG" > "$TMPCONFIG"
    cat "$OVERRIDE_FILE" >> "$TMPCONFIG"
    CONFIG="$TMPCONFIG"
else
    CONFIG="$BUNDLED_CONFIG"
fi

gitleaks git --pre-commit --staged --no-banner --redact --verbose --exit-code 1 --config "$CONFIG"
