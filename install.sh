#!/usr/bin/env bash

set -euo pipefail

REPO_HTTPS_URL="https://github.com/harryhosepipe/wsl-ansible.git"
PULL_DIR="${HOME}/.local/share/ansible-pull/wsl-ansible"

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This installer expects Ubuntu/Debian with apt-get." >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1 || ! command -v ansible-pull >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y git ansible
fi

mkdir -p "${PULL_DIR}"

ansible-pull \
  --url "${REPO_HTTPS_URL}" \
  --directory "${PULL_DIR}" \
  --inventory localhost, \
  --checkout main \
  --clean \
  --ask-become-pass \
  playbook.yml
