#!/usr/bin/env bash

set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap script expects Ubuntu/Debian with apt-get." >&2
  exit 1
fi

if ! command -v ansible-playbook >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y ansible
fi

ansible-playbook -i inventory/hosts.yml playbook.yml --ask-become-pass
