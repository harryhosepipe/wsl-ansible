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

for var_name in \
  GIT_USER_NAME \
  GIT_USER_EMAIL \
  SSH_PRIVATE_KEY \
  SSH_PUBLIC_KEY; do
  if [ -z "${!var_name:-}" ]; then
    echo "Missing required environment variable: ${var_name}" >&2
    echo "Run this bootstrap under doppler run so Git credentials and SSH keys are injected." >&2
    exit 1
  fi
done

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
