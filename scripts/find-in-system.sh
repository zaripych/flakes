#!/usr/bin/env bash
# Search the current nix-darwin system closure for files or directories
# matching a pattern (case-insensitive).
# Usage: ./scripts/find-in-system.sh <pattern>

set -euo pipefail

pattern="${1:?usage: $0 <pattern>}"

nix-store --query --requisites /run/current-system | while IFS= read -r p; do
  find "$p" -maxdepth 5 -iname "*${pattern}*" 2>/dev/null
done
