#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLED_CONFIG="${SCRIPT_DIR}/.gitleaks.toml"

if ! command -v gitleaks >/dev/null 2>&1; then
    printf 'ERROR: gitleaks is not installed. See: https://github.com/gitleaks/gitleaks#installing\n' >&2
    exit 1
fi

if [ -n "${GITLEAKS_CONFIG:-}" ] || [ -n "${GITLEAKS_CONFIG_TOML:-}" ]; then
    exec gitleaks git --pre-commit --staged --no-banner --redact --verbose --exit-code 1
fi

BASE_CONFIG="${GITLEAKS_BASE_CONFIG:-$BUNDLED_CONFIG}"

CONFIG="$BASE_CONFIG"
if [ -f ".gitleaks.toml" ]; then
    if grep -q '^\[extend\]' ".gitleaks.toml"; then
        printf 'ERROR: .gitleaks.toml must not contain [extend] (injected automatically to extend the base config)\n' >&2
        exit 1
    fi
    TMPCONFIG="$(mktemp)"
    trap 'rm -f "$TMPCONFIG"' EXIT
    { printf '[extend]\npath = "%s"\n\n' "$BASE_CONFIG"; cat ".gitleaks.toml"; } > "$TMPCONFIG"
    CONFIG="$TMPCONFIG"
fi

gitleaks git --pre-commit --staged --no-banner --redact --verbose --exit-code 1 --config "$CONFIG"
