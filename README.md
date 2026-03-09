# WSL Ansible Bootstrap

Small Ansible baseline for a fresh WSL Ubuntu install.

The repository is intentionally minimal. It should succeed on a new WSL instance without requiring you to edit usernames, dotfiles URLs, or role variables first.

The top-level [playbook.yml](/home/pablo/bin/wsl-ansible/playbook.yml) stays thin and imports smaller playbooks from [playbooks/xdg.yml](/home/pablo/bin/wsl-ansible/playbooks/xdg.yml), [playbooks/base.yml](/home/pablo/bin/wsl-ansible/playbooks/base.yml), [playbooks/git.yml](/home/pablo/bin/wsl-ansible/playbooks/git.yml), [playbooks/zsh.yml](/home/pablo/bin/wsl-ansible/playbooks/zsh.yml), [playbooks/neovim.yml](/home/pablo/bin/wsl-ansible/playbooks/neovim.yml), and [playbooks/node.yml](/home/pablo/bin/wsl-ansible/playbooks/node.yml).

## What it does

- Installs Ansible if needed
- Uses `ansible-pull` to fetch and run the playbook on `localhost`
- Installs a small set of base packages
- Creates XDG directories and environment shims first so later playbooks can target clean paths
- Creates a few development directories in your home directory
- Configures Git identity and GitHub SSH from Doppler-provided secrets
- Installs `zsh`, makes it the login shell, and keeps shell config under `~/.config/zsh`
- Installs Neovim and the LazyVim starter config
- Installs Node.js with `nvm` under XDG data

## Fresh WSL usage

This bootstrap expects Doppler project `base` and config `dev`.

### 1. Install Doppler CLI

```bash
curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://cli.doppler.com/install.sh | sudo sh
```

### 2. Authenticate Doppler

```bash
doppler login
```

### 3. Run the bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/harryhosepipe/wsl-ansible/main/install.sh | doppler run -p base -c dev -- bash
```

### What the bootstrap does

- installs `git` and Ansible if needed
- pulls this repository into `~/.local/share/ansible-pull/wsl-ansible`
- runs `playbook.yml` locally with `ansible-pull`

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

The helper script in [scripts/bootstrap.sh](/home/pablo/bin/wsl-ansible/scripts/bootstrap.sh) now does the same thing for a local checkout.

## Current package set

- `git`
- `curl`
- `wget`
- `unzip`
- `openssh-client`
- `stow`
- `build-essential`
- `ripgrep`
- `fd-find`
- `luarocks`

`zsh` is installed by the dedicated shell playbook rather than the generic base package list.

## Git

- Reads Git identity and GitHub SSH key material from environment variables injected by Doppler
- Writes GitHub SSH keys to `~/.ssh/github_ed25519` and `~/.ssh/github_ed25519.pub`
- Writes an SSH config entry for `github.com`
- Configures global Git `user.name` and `user.email`

Expected Doppler secrets:

- `GIT_USER_NAME`
- `GIT_USER_EMAIL`
- `SSH_PRIVATE_KEY`
- `SSH_PUBLIC_KEY`

## Neovim

- Installs the latest Neovim release from the official GitHub release artifacts
- Extracts Neovim directly into `/usr/local`
- Skips the Neovim install step when the latest release is already installed
- Clones the LazyVim starter into `~/.config/nvim` if that directory does not already exist

If `~/.config/nvim` already exists, the playbook leaves it alone.

## XDG first

The repository now establishes XDG conventions before the rest of the bootstrap runs.

- [playbooks/xdg.yml](/home/pablo/bin/wsl-ansible/playbooks/xdg.yml) creates the XDG directory tree
- It installs the required `~/.zshenv` shim so `zsh` can discover `ZDOTDIR`
- It prepares npm config and cache locations up front
- Later playbooks reference shared XDG variables instead of hardcoding `~/.config`, `~/.cache`, or `~/.nvm`

## Zsh and XDG

- Installs `zsh` and sets `/usr/bin/zsh` as the login shell
- Keeps the required `~/.zshenv` file minimal and uses it only to export XDG variables and `ZDOTDIR`
- Stores the main shell config in `~/.config/zsh/.zshrc`
- Uses `~/.config/zsh/.zprofile` to continue loading `~/.profile` on login shells
- Stores zsh history in `~/.local/state/zsh/history`
- Stores zsh completion cache in `~/.cache/zsh`
- Stores `nvm` in `~/.local/share/nvm`
- Stores npm config in `~/.config/npm/npmrc` and npm cache in `~/.cache/npm`

This is about as XDG-compliant as `zsh` gets without hacks: `~/.zshenv` must still exist in `$HOME` so zsh can discover `ZDOTDIR`.

## Current directories

- `~/dev`
- `~/dev/projects`
- `~/.config`
- `~/.local/bin`
- `~/.local/share`
- `~/.local/state`
- `~/.cache`

## Node.js

- Installs `nvm` `v0.40.4`
- Installs Node.js `24`
- Sets Node.js `24` as the default `nvm` version
- Uses `~/.local/share/nvm` instead of `~/.nvm`

## Next steps

We can add features back one at a time:

1. Dotfiles clone and stow
2. Prompt/theme and shell plugins

Each feature should stay optional and should only be added after the previous step is verified.
