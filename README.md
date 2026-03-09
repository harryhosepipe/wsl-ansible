# WSL Ansible Bootstrap

Small Ansible baseline for a fresh WSL Ubuntu install.

The repository is intentionally minimal. It should succeed on a new WSL instance without requiring you to edit usernames, dotfiles URLs, or role variables first.

The top-level [playbook.yml](/home/pablo/projects/wsl-ansible/playbook.yml) stays thin and imports smaller playbooks from [playbooks/base.yml](/home/pablo/projects/wsl-ansible/playbooks/base.yml), [playbooks/neovim.yml](/home/pablo/projects/wsl-ansible/playbooks/neovim.yml), and [playbooks/node.yml](/home/pablo/projects/wsl-ansible/playbooks/node.yml).

## What it does

- Installs Ansible if needed
- Uses `ansible-pull` to fetch and run the playbook on `localhost`
- Installs a small set of base packages
- Creates a few development directories in your home directory
- Installs Neovim and the LazyVim starter config
- Installs Node.js with `nvm`

## Fresh WSL usage

One-command install:

```bash
curl -fsSL https://raw.githubusercontent.com/harryhosepipe/wsl-ansible/main/install.sh | bash
```

That installer will:

- install `git` and Ansible if needed
- pull this repository into `~/.local/share/ansible-pull/wsl-ansible`
- run `playbook.yml` locally with `ansible-pull`

Manual install:

```bash
sudo apt update
sudo apt install -y git ansible
ansible-pull \
  --url https://github.com/harryhosepipe/wsl-ansible.git \
  --directory ~/.local/share/ansible-pull/wsl-ansible \
  --inventory localhost, \
  --limit localhost \
  --checkout main \
  --clean \
  --ask-become-pass \
  playbook.yml
```

The helper script in [scripts/bootstrap.sh](/home/pablo/projects/wsl-ansible/scripts/bootstrap.sh) now does the same thing for a local checkout.

## Current package set

- `git`
- `curl`
- `wget`
- `unzip`
- `stow`
- `fish`
- `build-essential`
- `ripgrep`
- `fd-find`
- `luarocks`

## Neovim

- Installs the latest Neovim release from the official GitHub release artifacts
- Extracts Neovim directly into `/usr/local`
- Skips the Neovim install step when the latest release is already installed
- Clones the LazyVim starter into `~/.config/nvim` if that directory does not already exist

If `~/.config/nvim` already exists, the playbook leaves it alone.

## Current directories

- `~/dev`
- `~/dev/projects`
- `~/.config`
- `~/.local/bin`
- `~/.local/share`
- `~/.cache`

## Node.js

- Installs `nvm` `v0.40.4`
- Installs Node.js `24`
- Sets Node.js `24` as the default `nvm` version

## Next steps

We can add features back one at a time:

1. Dotfiles clone and stow
2. Shell defaults

Each feature should stay optional and should only be added after the previous step is verified.
