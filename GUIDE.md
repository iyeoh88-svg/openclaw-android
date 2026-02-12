# 📚 Detailed Installation Guide

## Table of Contents
- [Prerequisites](#prerequisites)
- [Automated Installation](#automated-installation)
- [Manual Installation](#manual-installation)
- [Post-Installation Setup](#post-installation-setup)
- [Daily Usage](#daily-usage)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software

1. **Termux (F-Droid version)**
   - Download from: https://f-droid.org/en/packages/com.termux/
   - ⚠️ **Do NOT use the Google Play Store version** - it's outdated and incompatible

2. **System Requirements**
   - Android 12 or higher (Android 11 may work but is not tested)
   - Minimum 2GB free storage (4GB recommended)
   - Minimum 4GB RAM (6GB+ recommended for better performance)
   - Stable internet connection for initial setup

### Optional but Recommended

- **Termux:Widget** - For home screen shortcuts
- **External keyboard** - For easier terminal usage
- **Power adapter** - Installation can take 10-15 minutes

## Automated Installation

### Quick Install (Recommended)

1. Open Termux
2. Run this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash
```

3. Follow the on-screen prompts
4. Wait 5-15 minutes for installation to complete

### Download and Install

If you prefer to review the script first:

```bash
# Download the installer
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh

# Review the script (optional)
cat install.sh

# Make it executable
chmod +x install.sh

# Run the installer
./install.sh
```

### Installation Flags

```bash
# Force reinstallation (removes existing setup)
./install.sh --reinstall

# Skip update check (faster start)
./install.sh --skip-update-check

# Show help
./install.sh --help
```

## Manual Installation

If the automated installer fails or you prefer manual setup:

### Step 1: Prepare Termux

```bash
# Update package lists
pkg update

# Upgrade existing packages
pkg upgrade -y

# Install proot-distro
pkg install proot-distro -y
```

### Step 2: Install Debian

```bash
# Install Debian distribution
proot-distro install debian

# Login to Debian
proot-distro login debian
```

### Step 3: Setup Debian Environment

Now inside Debian environment:

```bash
# Update Debian packages
apt update && apt upgrade -y

# Install dependencies
apt install curl git build-essential -y
```

### Step 4: Install Node.js via NVM

```bash
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Reload bash configuration
source ~/.bashrc

# Install Node.js 22
nvm install 22

# Set as default
nvm use 22
nvm alias default 22

# Verify installation
node --version  # Should show v22.x.x
npm --version   # Should show 10.x.x or higher
```

### Step 5: Create Networking Shim

This fixes the Android Error 13 issue:

```bash
# Create the shim file
cat <<'EOF' > /root/openclaw-shim.cjs
const os = require('os');
os.networkInterfaces = () => ({
  lo: [{
    address: '127.0.0.1',
    netmask: '255.0.0.0',
    family: 'IPv4',
    mac: '00:00:00:00:00:00',
    internal: true,
    cidr: '127.0.0.1/8'
  }]
});
EOF
```

### Step 6: Install OpenClaw

```bash
# Install globally
npm install -g openclaw@latest

# Verify installation
openclaw --version
```

### Step 7: Setup Aliases

Add convenient shortcuts to your bash profile:

```bash
cat >> ~/.bashrc << 'EOF'

# OpenClaw shortcuts
alias start-claw='NODE_OPTIONS="--require /root/openclaw-shim.cjs" openclaw gateway --bind loopback'
alias update-openclaw='npm update -g openclaw'
alias claw-status='ps aux | grep openclaw'
EOF

# Reload configuration
source ~/.bashrc
```

## Post-Installation Setup

### Initial Configuration

1. **Configure API Keys**

```bash
# Inside Debian
openclaw onboard
```

Follow the prompts to:
- Choose your AI provider (Gemini, OpenAI, etc.)
- Enter your API key
- Set preferences

2. **Test the Installation**

```bash
# Start the gateway
start-claw
```

You should see output indicating the gateway is running on `127.0.0.1:3000`

3. **Open the TUI** (in a new session)

```bash
# In a new Termux session
proot-distro login debian

# Launch the interface
openclaw tui
```

## Daily Usage

### Starting OpenClaw

OpenClaw requires two components running simultaneously:

#### Terminal 1: Gateway (The Engine)

```bash
# In Termux
proot-distro login debian

# Inside Debian
start-claw
```

Keep this running in the background.

#### Terminal 2: TUI (The Interface)

```bash
# Swipe left in Termux to open new session
# Then:
proot-distro login debian

# Launch interface
openclaw tui
```

### Quick Reference Commands

Inside Debian environment:

| Command | Description |
|---------|-------------|
| `start-claw` | Start the OpenClaw gateway |
| `openclaw tui` | Open the terminal interface |
| `openclaw onboard` | Reconfigure API settings |
| `update-openclaw` | Update to latest version |
| `claw-status` | Check if OpenClaw is running |
| `openclaw --help` | Show all available commands |

### Stopping OpenClaw

To properly stop OpenClaw:

1. Exit the TUI (usually `Ctrl+C` or `q`)
2. In the gateway terminal, press `Ctrl+C`
3. Wait for graceful shutdown

## Troubleshooting

### Common Issues

#### 1. "Permission denied" errors

```bash
# In Termux
termux-setup-storage

# Grant storage permissions when prompted
```

#### 2. Performance is slow

```bash
# In Termux (not Debian)
termux-wake-lock

# This prevents Android from throttling the CPU
```

#### 3. "Cannot find module" errors

```bash
# Inside Debian
npm cache clean --force
npm install -g openclaw@latest
```

#### 4. Gateway won't start

Check if port 3000 is already in use:

```bash
# Inside Debian
lsof -i :3000

# If something is running, kill it:
kill -9 [PID]
```

#### 5. Out of storage space

```bash
# Inside Debian
npm cache clean --force
apt clean
apt autoremove -y

# In Termux
pkg clean
```

### Advanced Troubleshooting

#### Reset OpenClaw Configuration

```bash
# Inside Debian
rm -rf ~/.openclaw
openclaw onboard
```

#### Complete Reinstall

```bash
# In Termux
proot-distro remove debian -y
./install.sh --reinstall
```

#### Check Logs

```bash
# Inside Debian
cat ~/.openclaw/logs/gateway.log
```

### Getting Help

If you encounter issues:

1. Check the [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Search [existing issues](https://github.com/iyeoh88-svg/openclaw-android/issues)
3. Create a [new issue](https://github.com/iyeoh88-svg/openclaw-android/issues/new) with:
   - Android version
   - Termux version
   - Error message
   - Steps to reproduce

## Performance Optimization

### Battery Optimization

1. Disable battery optimization for Termux:
   - Settings → Apps → Termux → Battery → Unrestricted

2. Keep device plugged in during intensive tasks

3. Use `termux-wake-lock` to prevent CPU throttling

### Network Optimization

For better performance over mobile networks:

```bash
# Inside Debian
export NODE_OPTIONS="--max-old-space-size=2048"
```

Add this to `~/.bashrc` to make it permanent.

### Storage Management

Regularly clean up:

```bash
# Weekly maintenance
npm cache clean --force
apt clean
apt autoremove -y
```

## Updating

### Update OpenClaw

```bash
# Inside Debian
update-openclaw
```

### Update the Installer

The installer checks for updates automatically. To manually update:

```bash
# In Termux
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh
chmod +x install.sh
./install.sh
```

### Update Debian Packages

```bash
# Inside Debian
apt update && apt upgrade -y
```

### Update Node.js

```bash
# Inside Debian
nvm install 22 --latest-npm
nvm use 22
```

## Additional Resources

- **OpenClaw Documentation**: [docs.openclaw.ai](https://docs.openclaw.ai)
- **Termux Wiki**: [wiki.termux.com](https://wiki.termux.com)
- **Community Forum**: [GitHub Discussions](https://github.com/iyeoh88-svg/openclaw-android/discussions)
- **Video Tutorial**: [Coming soon]

## Security Notes

- Keep Termux and all packages updated
- Use strong API keys and rotate them regularly
- Never share your `.openclaw` configuration directory
- Be cautious with scripts from unknown sources

---

**Last Updated**: February 2026  
**Maintainer**: [iyeoh88-svg]  
**License**: MIT
