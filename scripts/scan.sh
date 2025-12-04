#!/bin/sh
set -eu

echo -e "\n⚡️ MoJ scanner ${VERSION}⚡️\n";

# Dependencies
if ! command -v gitleaks >/dev/null 2>&1; then
    echo "❌ Missing gitleaks executable.";
    exit 1;
fi

# GitLeaks
gitleaks detect --source=/src --exit-code 1 --no-git --verbose

# Successful
echo "✅ No secrets have been detected."
exit 0;
