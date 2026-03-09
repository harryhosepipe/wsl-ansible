#!/usr/bin/env bash

set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap script expects Ubuntu/Debian with apt-get." >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1 || ! command -v ansible-pull >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y git ansible
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

ansible-pull \
  --url "${REPO_ROOT}" \
  --directory "${HOME}/.local/share/ansible-pull/wsl-ansible" \
  --inventory localhost, \
  --limit localhost \
  --clean \
  --ask-become-pass \
  playbook.yml
