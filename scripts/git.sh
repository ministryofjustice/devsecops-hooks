#!/usr/bin/env bash
set -euo pipefail

# Git Installation Script
#
# Purpose:
#   Installs Git version control system in Alpine Linux containers
#   using the Alpine Package Keeper (apk) package manager.
#

apk add --no-cache git