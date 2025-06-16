# WSL Ubuntu Development Environment Setup

Ansible playbook to set up a clean WSL Ubuntu environment for web development, following the specifications in CLAUDE.md.

## Quick Start

1. Install Ansible:
```bash
sudo apt update && sudo apt install ansible
```

2. Clone this repository:
```bash
git clone <your-repo-url> ~/dev/wsl-ansible
cd ~/dev/wsl-ansible
```

3. Update variables in `group_vars/all.yml`:
   - Set your `dotfiles_repo` URL
   - Adjust user settings if needed

4. Run the playbook:
```bash
ansible-playbook -i inventory/hosts.yml playbook.yml --ask-become-pass
```

## What This Playbook Does

### Base Setup
- Updates system packages
- Installs essential development tools (git, stow, build-essential, etc.)
- Creates XDG-compliant directory structure
- Installs Fish shell

### Development Environment
- **Neovim**: Downloads latest stable release from GitHub (AppImage method)
- **Node.js**: Installs fnm and latest LTS Node.js version
- **Shell**: Sets Fish as default shell

### Dotfiles Management
- Clones your dotfiles repository
- Uses Stow to symlink configurations
- Sets up XDG-compliant git configuration
- Installs Fisher plugin manager for Fish

## Directory Structure Created

```
~/
├── .config/           # Centralized configurations
├── .local/            # User-specific data
├── .cache/            # Application cache
├── dev/
│   ├── dotfiles/      # Your stowed configurations
│   ├── projects/      # Development projects
│   └── sandbox/       # Experimental code
├── Documents/
└── Downloads/
```

## Customization

Edit `group_vars/all.yml` to:
- Change dotfiles repository URL
- Modify stow packages list
- Adjust directory structure
- Add/remove development tools

## Requirements

- Fresh WSL Ubuntu installation
- Internet connection
- Your dotfiles repository accessible via git