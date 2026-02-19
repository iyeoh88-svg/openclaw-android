#  Detailed Installation Guide

## Table of Contents
- [Prerequisites](#prerequisites)
- [Automated Installation](#automated-installation)
- [Manual Installation](#manual-installation)
- [Post-Installation Setup](#post-installation-setup)
- [Daily Usage](#daily-usage)
- [Troubleshooting](#troubleshooting)
- [What's New in v2026.2.14](#whats-new-in-v202621-4)

## What's New in v2026.2.14

**Major Update**: OpenClaw now runs as a dedicated non-root user!

**Key Changes:**
-  New login command: `proot-distro login debian --user openclaw`
-  Everything installed under `/home/openclaw/` (not `/root/`)
-  Homebrew and other dev tools now work
-  Better security with passwordless sudo
-  9 critical bugs fixed from community testing

**⚠️ Breaking Change**: If you have an existing installation from v2026.2.13 or earlier, see the [Upgrading](#upgrading-from-older-versions) section.

---

## Prerequisites

### Required Software

1. **Termux (F-Droid version REQUIRED)**
   - Download from: https://f-droid.org/en/packages/com.termux/
   - ⚠️ **Do NOT use the Google Play Store version** - it's outdated and incompatible
   - The F-Droid version is actively maintained and recommended

2. **System Requirements**
   - **Android 12+** (recommended)
   - **Android 11** may work but is experimental
   - **Android 7-10** basic support (tested on Android 7)
   - **Minimum 2GB free storage** (4GB recommended)
   - **Minimum 4GB RAM** (6GB+ recommended for better performance)
   - **Stable internet connection** for initial setup

### Optional but Recommended

- **Termux:Widget** - For home screen shortcuts
- **External keyboard** - For easier terminal usage
- **Power adapter** - Installation can take 10-15 minutes
- **Wake lock** - Prevent CPU throttling during installation

### Before You Start

1. **Close other apps** to free up RAM
2. **Connect to stable WiFi** (mobile data works but WiFi is faster)
3. **Ensure phone is charged** or connected to power
4. **Don't close Termux** during installation

---

## Automated Installation

### Quick Install (Recommended)

This is the easiest method and handles everything automatically:

1. **Open Termux from F-Droid**

2. **Run this single command:**

```bash
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash
```

3. **Wait patiently** (5-15 minutes depending on your device)
   - Package updates
   - Debian installation
   - Node.js setup
   - OpenClaw installation

4. **Installation complete!** You'll see a success message with next steps

### Download and Install

If you prefer to review the script first:

```bash
# Download the installer
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh

# Review the script (optional but recommended)
less install.sh
# Press 'q' to quit

# Make it executable
chmod +x install.sh

# Run the installer
./install.sh
```

### Installation Flags

```bash
# Force reinstallation (removes existing Debian setup)
./install.sh --reinstall

# Skip update check (faster start, uses current version)
./install.sh --skip-update-check

# Show help and available options
./install.sh --help
```

### What the Installer Does

The automated installer:

1.  Checks system requirements (Android version, storage, Termux compatibility)
2.  Updates Termux packages
3.  Installs and configures PRoot-Distro
4.  Sets up Debian environment
5.  Creates dedicated `openclaw` user (non-root)
6.  Installs NVM (Node Version Manager)
7.  Installs Node.js v22
8.  Creates Android networking fix (shim)
9.  Installs OpenClaw globally
10.  Sets up convenient aliases
11.  Configures environment for optimal performance

---

## Manual Installation

If the automated installer fails or you prefer manual setup:

### Step 1: Prepare Termux

```bash
# Update package lists
pkg update

# Upgrade existing packages (will be non-interactive)
pkg upgrade -y

# Install proot-distro
pkg install proot-distro -y
```

### Step 2: Install Debian

```bash
# Install Debian distribution
proot-distro install debian

# Login to Debian as root (temporary, for setup)
proot-distro login debian
```

### Step 3: Create Dedicated User

**Inside Debian (as root):**

```bash
# Install sudo first
apt update
apt install -y sudo

# Create the openclaw user
useradd -m -s /bin/bash openclaw

# Grant passwordless sudo
echo "openclaw ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Exit root session
exit
```

### Step 4: Login as OpenClaw User

**Back in Termux:**

```bash
# From now on, always login as openclaw user
proot-distro login debian --user openclaw
```

### Step 5: Setup Debian Environment

**Inside Debian (as openclaw user):**

```bash
# Update Debian packages
sudo apt update && sudo apt upgrade -y

# Install build dependencies
sudo apt install -y curl git build-essential ca-certificates
```

### Step 6: Install Node.js via NVM

```bash
# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Load NVM into current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js 22
nvm install 22

# Set as default
nvm use 22
nvm alias default 22

# Verify installation
node --version  # Should show v22.x.x
npm --version   # Should show 10.x.x or higher
```

### Step 7: Create Networking Shim

This fixes the Android Error 13 issue:

```bash
# Create the shim file in your home directory
cat <<'EOF' > $HOME/openclaw-shim.cjs
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

# Verify it was created
ls -la $HOME/openclaw-shim.cjs
```

**Why this is needed:** Android blocks low-level network interface access. This shim provides a safe mock interface that OpenClaw can use.

### Step 8: Install OpenClaw

```bash
# Install globally
npm install -g openclaw@latest

# Verify installation
openclaw --version
```

### Step 9: Setup Environment

Add convenient shortcuts and the networking fix to your bash profile:

```bash
cat >> ~/.bashrc << 'EOF'

# ========================================
# OpenClaw Configuration
# ========================================

# Android networking fix - applies to ALL openclaw commands
export NODE_OPTIONS="--require /home/openclaw/openclaw-shim.cjs"

# Convenient aliases
alias start-claw='openclaw gateway --bind loopback'
alias update-openclaw='npm update -g openclaw'
alias claw-status='ps aux | grep openclaw'
alias claw-logs='tail -f ~/.openclaw/logs/*.log'

EOF

# Reload configuration
source ~/.bashrc
```

**What this does:**
- `NODE_OPTIONS` applies the networking shim globally (fixes Error 13)
- `start-claw` launches the OpenClaw gateway
- `update-openclaw` updates to the latest version
- `claw-status` shows running processes
- `claw-logs` tails log files

---

## Post-Installation Setup

### Initial Configuration

**Option 1: Automated Onboarding (Recommended)**

```bash
# Inside Debian (as openclaw user)
openclaw onboard
```

Follow the prompts to:
- Choose your AI provider (Claude/Anthropic, OpenAI, Gemini, etc.)
- Enter your API key
- Configure preferences
- Set up channels (optional)

**Option 2: Manual Configuration**

If onboarding skips steps or doesn't work properly:

```bash
# Use interactive configuration menu
openclaw config
```

This opens a menu where you can manually configure:
- **model** - Choose AI provider and model
- **skills** - Configure available skills
- **channel** - Set up Telegram, WhatsApp, etc.
- **workspace** - Configure your workspace

**Option 3: Command-Line Configuration**

For advanced users or scripting:

```bash
# Set API key for Anthropic (Claude)
openclaw config set providers.anthropic.apiKey "sk-ant-your-key-here"

# Set default provider
openclaw config set defaultProvider anthropic

# Set specific model
openclaw config set defaultModel "claude-sonnet-4-20250514"

# View current configuration
openclaw config list
```

### Test the Installation

1. **Start the Gateway** (Session 1)

```bash
# In Termux
proot-distro login debian --user openclaw

# Inside Debian
start-claw
```

You should see output indicating the gateway is running on `127.0.0.1:18789` or similar port.

2. **Open the TUI** (Session 2)

```bash
# Swipe left in Termux to open new session
# In the new Termux session:
proot-distro login debian --user openclaw

# Inside Debian
openclaw tui
```

If both work, your installation is successful! 🎉

---

## Daily Usage

### Starting OpenClaw (Two Sessions Required)

**Session 1 - Gateway (The Brain):**

```bash
# In Termux
proot-distro login debian --user openclaw

# Inside Debian
start-claw
```

**What it does:** Starts the OpenClaw gateway that processes commands and communicates with AI models.

**Session 2 - TUI (The Interface):**

```bash
# Swipe left in Termux to open new session

# Login to Debian
proot-distro login debian --user openclaw

# Launch the interface
openclaw tui
```

**What it does:** Opens the terminal user interface where you interact with OpenClaw.

### Quick Reference Commands

**Inside Debian (as openclaw user):**

| Command | Purpose |
|---------|---------|
| `start-claw` | Launch OpenClaw gateway |
| `openclaw tui` | Open terminal interface |
| `openclaw onboard` | Automated configuration wizard |
| `openclaw config` | Manual configuration menu |
| `update-openclaw` | Update to latest OpenClaw version |
| `claw-status` | Check running processes |
| `claw-logs` | View log files |
| `exit` | Exit Debian, return to Termux |

**In Termux (not inside Debian):**

| Command | Purpose |
|---------|---------|
| `proot-distro login debian --user openclaw` | Enter Debian environment |
| `termux-wake-lock` | Prevent CPU throttling |
| `termux-wake-unlock` | Release wake lock |
| `pkg update` | Update Termux packages |

### Stopping OpenClaw

1. **In the TUI session:** Press `Ctrl+C` or type `exit`
2. **In the Gateway session:** Press `Ctrl+C`
3. **Exit Debian:** Type `exit`

### Updating OpenClaw

**To update OpenClaw itself:**

```bash
# Inside Debian
update-openclaw
```

**To update the installer:**

```bash
# In Termux (not Debian)
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh
chmod +x install.sh
./install.sh --reinstall
```

---

## Upgrading from Older Versions

### If You Have v2026.2.13 or Earlier

The architecture changed significantly in v2026.2.14. You have two options:

**Option 1: Fresh Install (Recommended)**

Cleanest approach, ensures everything is set up correctly:

```bash
# In Termux
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh
chmod +x install.sh
./install.sh --reinstall
```

Then always login with:
```bash
proot-distro login debian --user openclaw
```

**Option 2: Manual Upgrade (Keep Existing Data)**

If you want to keep your existing OpenClaw configuration:

```bash
# 1. Login to Debian as root one last time
proot-distro login debian

# 2. Create the openclaw user
useradd -m -s /bin/bash openclaw
echo "openclaw ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 3. Copy your OpenClaw config (if you want to keep it)
cp -r /root/.openclaw /home/openclaw/.openclaw 2>/dev/null || true
chown -R openclaw:openclaw /home/openclaw/.openclaw 2>/dev/null || true

# 4. Exit root
exit

# 5. From now on, always login as openclaw user
proot-distro login debian --user openclaw

# 6. Reinstall NVM and Node.js as openclaw user
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install 22
nvm use 22
nvm alias default 22

# 7. Reinstall OpenClaw
npm install -g openclaw@latest

# 8. Create shim in new location
cat > $HOME/openclaw-shim.cjs << 'EOF'
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

# 9. Update bashrc with new paths
cat >> ~/.bashrc << 'EOF'

# Android networking fix - applies globally
export NODE_OPTIONS="--require /home/openclaw/openclaw-shim.cjs"

# Aliases
alias start-claw='openclaw gateway --bind loopback'
alias update-openclaw='npm update -g openclaw'
alias claw-status='ps aux | grep openclaw'
alias claw-logs='tail -f ~/.openclaw/logs/*.log'
EOF

source ~/.bashrc
```

---

## Troubleshooting

### Installation Issues

**Problem: Installation hangs during package upgrade**

**Solution**: The installer now handles this automatically (v2026.2.10+). If using an older version, update:

```bash
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh
chmod +x install.sh
./install.sh
```

**Problem: "nvm: command not found"**

**Solution**: Fixed in v2026.2.11+. If you see this, update the installer.

**Problem: Error 13 during `openclaw onboard` or `openclaw config`**

**Solution**: Fixed in v2026.2.13+. Update to latest version or manually add to bashrc:

```bash
echo 'export NODE_OPTIONS="--require /home/openclaw/openclaw-shim.cjs"' >> ~/.bashrc
source ~/.bashrc
```

**Problem: "Don't run this as root!" (Homebrew)**

**Solution**: Fixed in v2026.2.14. Use the new non-root architecture:

```bash
./install.sh --reinstall
proot-distro login debian --user openclaw
```

### Runtime Issues

**Problem: Gateway won't start**

```bash
# Check if port is already in use
lsof -i :18789

# Kill existing process if needed
kill -9 [PID]

# Try starting again
start-claw
```

**Problem: Can't connect to TUI**

1. Make sure gateway is running in Session 1
2. Make sure you're logged in as openclaw user
3. Try restarting the gateway

**Problem: Slow performance**

```bash
# In Termux (not Debian)
termux-wake-lock

# Check available RAM
free -h

# Close other apps to free memory
```

### Getting Help

1. **Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Comprehensive solutions
2. **Search [Issues](https://github.com/iyeoh88-svg/openclaw-android/issues)** - Someone may have had the same problem
3. **Open a new issue** with:
   - Android version
   - Termux version (F-Droid/Play Store)
   - Installer version
   - Error messages
   - Steps to reproduce

---

## Performance Tips

### Optimize for Battery Life vs Performance

**Maximum Performance:**
```bash
# In Termux
termux-wake-lock
```

**Battery Saving:**
```bash
# In Termux
termux-wake-unlock
```

### Free Up Storage

```bash
# Inside Debian
npm cache clean --force
sudo apt clean

# In Termux
pkg clean
```

### Check Resource Usage

```bash
# Inside Debian
free -h        # RAM usage
df -h          # Disk usage
top            # Process monitor
```

---

## Advanced Usage

### Using Homebrew (Now Supported in v2026.2.14!)

```bash
# Inside Debian as openclaw user
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (follow Homebrew's instructions)
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
source ~/.bashrc

# Install packages
brew install cowsay
cowsay "Hello from OpenClaw on Android!"
```

### Custom Aliases

Add your own shortcuts to `~/.bashrc`:

```bash
# Quick OpenClaw status check
alias claw-check='openclaw --version && echo "Gateway:" && claw-status'

# Quick restart
alias claw-restart='killall openclaw; start-claw'
```

### Environment Variables

Customize OpenClaw behavior:

```bash
# Add to ~/.bashrc
export OPENCLAW_LOG_LEVEL=debug
export OPENCLAW_PORT=3000
```

---

## Security Notes

### API Keys

- **Never commit API keys to git**
- **Don't share your config files**
- **Rotate keys if exposed**

### Permissions

The `openclaw` user has **passwordless sudo** for convenience. This is safe within the proot environment but be aware:

- Only use trusted scripts
- Don't run unknown commands with sudo
- The proot environment is isolated from your main Android system

---

## Next Steps

After installation:

1.  **Configure your API keys** (`openclaw onboard` or `openclaw config`)
2.  **Test the gateway** (`start-claw`)
3.  **Explore the TUI** (`openclaw tui`)
4.  **Read the docs** (OpenClaw's official documentation)
5.  **Join the community** (OpenClaw's Discord/forum if available)

---

## Additional Resources

- **README.md** - Quick start guide
- **QUICKREF.md** - Quick reference card  
- **TROUBLESHOOTING.md** - Common issues and solutions
- **CHANGELOG.md** - Version history
- **OpenClaw Documentation** - Official docs for OpenClaw itself

---

**Questions?** Open an issue or discussion on GitHub!

**Found a bug?** Please report it with details!

**Want to contribute?** Pull requests welcome!

---

*Guide last updated: v2026.2.14 - February 2026*

If onboarding skips steps or doesn't work properly:

```bash
# Use interactive configuration menu
openclaw config
```

This opens a menu where you can manually configure:
- **model** - Choose AI provider and model
- **skills** - Configure available skills
- **channel** - Set up Telegram, WhatsApp, etc.
- **workspace** - Configure your workspace

**Option 3: Command-Line Configuration**

```bash
# Set API key
openclaw config set providers.anthropic.apiKey "your-api-key-here"

# Set default provider
openclaw config set defaultProvider anthropic

# Set model
openclaw config set defaultModel "claude-sonnet-4-20250514"

# View current configuration
openclaw config list
```

2. **Test the Installation**

```bash
# Start the gateway
start-claw
```

You should see output indicating the gateway is running on `127.0.0.1:3000`

3. **Open the TUI** (in a new session)

```bash
# In a new Termux session
proot-distro login debian --user openclaw

# Launch the interface
openclaw tui
```

## Daily Usage

### Starting OpenClaw

OpenClaw requires two components running simultaneously:

#### Terminal 1: Gateway (The Engine)

```bash
# In Termux
proot-distro login debian --user openclaw

# Inside Debian
start-claw
```

Keep this running in the background.

#### Terminal 2: TUI (The Interface)

```bash
# Swipe left in Termux to open new session
# Then:
proot-distro login debian --user openclaw

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
