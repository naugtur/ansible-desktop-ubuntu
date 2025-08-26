# Automated Xubuntu Desktop Setup

This repository contains a modernized Ansible playbook for setting up a development environment on Xubuntu/Ubuntu desktop systems. It has been updated to work with current Ansible versions (2.9+) and uses modern best practices.

## Features

This playbook will configure your Xubuntu desktop with:

- **Essential packages**: Development tools, system utilities, and desktop applications
- **Third-party repositories**: Docker, VS Code, Google Chrome, and Node.js
- **Desktop customization**: XFCE themes, keyboard shortcuts, and tweaks
- **Development environment**: Git configuration, shell enhancements, and productivity tools

## Prerequisites

- Xubuntu or Ubuntu desktop system
- Python 3 and pip3 installed
- Internet connection
- Sudo access

## Installation

### 1. Install Ansible

```bash
# Update package cache
sudo apt update

# Install Python 3 and pip
sudo apt install -y python3-pip git curl

# Install Ansible
sudo pip3 install ansible

# Verify installation
ansible-playbook --version
```

### 2. Clone this repository

```bash
git clone <your-repo-url>
cd ansible-desktop-ubuntu
```

### 3. Customize variables

Edit the user variable in `group_vars/all.yml` to match your username:

```bash
nano group_vars/all.yml
```

## Usage

### Quick Start

Run the entire playbook:

```bash
./run.sh
```

You will be prompted for your sudo password.

### Advanced Usage

The `run.sh` script supports several options:

```bash
# Dry run (see what would be changed without making changes)
./run.sh --check

# Run only specific parts
./run.sh --tags packages
./run.sh --tags ppas
./run.sh --tags configs

# Skip specific parts
./run.sh --skip-tags docker

# Verbose output
./run.sh -v
./run.sh -vv
./run.sh -vvv

# Combine options
./run.sh --tags packages --check -vv
```

### Available Tags

- `packages`: Install system packages and applications
- `ppas`: Add third-party repositories (Docker, VS Code, Chrome)
- `configs`: Apply desktop configurations and shell tweaks
- `docker`: Docker-specific installation

### Manual Execution

If you prefer to run ansible-playbook directly:

```bash
ansible-playbook --inventory hosts --connection local --ask-become-pass laptop.yml
```

## What Gets Installed

### System Packages
- Development tools: git, vim, curl, wget, build-essential
- System utilities: htop, atop, iotop, iftop, nmap, unzip
- Desktop applications: VLC, GIMP, Inkscape, Calibre, Audacity

### Third-party Software
- **Docker CE**: Container platform with docker-compose
- **Visual Studio Code**: Microsoft's code editor
- **Google Chrome Beta**: Web browser
- **Node.js**: JavaScript runtime (system package + n version manager)

### Desktop Customization
- Dark compact XFCE theme
- Custom keyboard shortcuts for window tiling
- Enhanced bash prompt with git integration
- Shell aliases and productivity tweaks

## Configuration

### User Settings

The playbook uses the `user` variable defined in `group_vars/all.yml`. Make sure this matches your actual username.

### Customizing Packages

To add or remove packages, edit:
- `roles/packages/tasks/main.yml` for system packages
- Individual files in `roles/ppas/tasks/` for third-party software

### Shell Customization

The playbook modifies your `~/.bashrc` with:
- Large history settings (100k commands)
- Git-aware prompt
- thefuck alias (if installed)
- NPM global packages path
- Node version manager (n) path

## System Optimizations

### SSD Optimization (Recommended)

For SSD users, manually add `noatime` option to your `/etc/fstab`:

```bash
sudo nano /etc/fstab
```

Add `noatime,` to the options column for your SSD partitions. Example:
```
UUID=your-uuid / ext4 noatime,errors=remount-ro 0 1
```

### Swap Configuration

Consider removing swap configuration for SSD systems to reduce wear.

## Troubleshooting

### Permission Errors

If you encounter permission errors:
```bash
# Make sure your user is in the sudo group
sudo usermod -aG sudo $USER

# Log out and back in, then try again
```

### Ansible Version Issues

This playbook requires Ansible 2.9 or newer. Check your version:
```bash
ansible-playbook --version
```

If you have an older version, update it:
```bash
sudo pip3 install --upgrade ansible
```

### Repository Key Errors

If you encounter GPG key errors, the playbook will handle modern key management automatically. If issues persist, you can manually clean old keys:

```bash
# Remove old Docker keys (if present)
sudo apt-key del 0EBFCD88

# Re-run the playbook
./run.sh --tags docker
```

### XFCE Keyboard Shortcuts

The keyboard shortcut configuration may not work immediately. You might need to:
1. Log out and back in
2. Manually verify shortcuts in XFCE Settings → Keyboard → Application Shortcuts

## Development

### Project Structure

```
ansible-desktop-ubuntu/
├── group_vars/all.yml          # Global variables
├── hosts                       # Inventory file
├── laptop.yml                  # Main playbook
├── run.sh                      # Execution script
└── roles/
    ├── configs/               # Desktop configuration
    ├── packages/              # System packages
    └── ppas/                  # Third-party repositories
```

### Adding New Software

1. For system packages: Add to `roles/packages/tasks/main.yml`
2. For third-party repos: Create new file in `roles/ppas/tasks/` and include it in `main.yml`
3. For configuration: Add tasks to appropriate file in `roles/configs/tasks/`

## License

This is a personal setup configuration. Feel free to fork and adapt for your needs.

## Contributing

This is a personal configuration, but suggestions and improvements are welcome via issues and pull requests.