# WSL Ansible Bootstrap

Small Ansible baseline for a fresh WSL Ubuntu install.

The repository is intentionally minimal. It should succeed on a new WSL instance without requiring you to edit usernames, dotfiles URLs, or role variables first.

## What it does

- Installs Ansible if needed
- Uses `ansible-pull` to fetch and run the playbook on `localhost`
- Installs a small set of base packages
- Creates a few development directories in your home directory

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

## Current directories

- `~/dev`
- `~/dev/projects`
- `~/dev/sandbox`
- `~/.config`
- `~/.local/bin`
- `~/.local/share`
- `~/.cache`

## Next steps

We can add features back one at a time:

1. Dotfiles clone and stow
2. Neovim install
3. Node.js install
4. Shell defaults

Each feature should stay optional and should only be added after the previous step is verified.
