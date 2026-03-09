# WSL Ansible Bootstrap

Small Ansible baseline for a fresh WSL Ubuntu install.

The repository is intentionally minimal. It should succeed on a new WSL instance without requiring you to edit usernames, dotfiles URLs, or role variables first.

## What it does

- Installs Ansible with a bootstrap shell script
- Runs a local playbook against `localhost`
- Installs a small set of base packages
- Creates a few development directories in your home directory

## Fresh WSL usage

Clone the repository and run:

```bash
./scripts/bootstrap.sh
```

That script installs Ansible, then runs:

```bash
ansible-playbook -i inventory/hosts.yml playbook.yml --ask-become-pass
```

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
