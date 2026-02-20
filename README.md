# 🦞 OpenClaw for Android (Termux)

[![Version](https://img.shields.io/badge/version-2026.2.14-blue.svg)](https://github.com/iyeoh88-svg/openclaw-android)
[![Android](https://img.shields.io/badge/Android-12%2B-green.svg)](https://www.android.com/)
[![Termux](https://img.shields.io/badge/Termux-Required-orange.svg)](https://termux.dev/)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/iyeoh88-svg/openclaw-android.svg)](https://github.com/iyeoh88-svg/openclaw-android/stargazers)
[![Issues](https://img.shields.io/github/issues/iyeoh88-svg/openclaw-android.svg)](https://github.com/iyeoh88-svg/openclaw-android/issues)

> **Automated installer for running OpenClaw AI agent system on Android devices via Termux**

---

##  What's New in v2026.2.14

**Major Architecture Update - Non-Root User Implementation**

-  **Dedicated User**: OpenClaw now runs as `openclaw` user (not root)
-  **Homebrew Support**: Install Homebrew and other dev tools that refuse to run as root
-  **Better Security**: Follows Linux best practices with passwordless sudo
-  **9 Critical Bugs Fixed**: Based on extensive community testing
-  **Broad Compatibility**: Tested on Android 7-16, F-Droid & Play Store Termux

**⚠️ Breaking Change**: New login command required:
```bash
proot-distro login debian --user openclaw
```

[See Upgrade Guide](GUIDE.md#upgrading-from-older-versions) if updating from v2026.2.13 or earlier.

---

## ⚠️ Important Disclaimer

**This project is an independent installer/automation tool created by the community.**

-  **What this is**: An automated installation script that makes it easy to run OpenClaw on Android
-  **What this is NOT**: I did not create OpenClaw itself
-  **OpenClaw**: Visit the [official OpenClaw project](https://github.com/openclaw/openclaw) for the actual AI agent framework
-  **Creator**: This installer was created by [@iyeoh88-svg](https://github.com/iyeoh88-svg) to simplify the Android installation process
-  **Purpose**: To automate the complex setup process and make OpenClaw accessible on Android devices

**All credit for OpenClaw goes to its original creators and maintainers.**

📄 **[Read Full Disclaimer](DISCLAIMER.md)** - Please read to understand the scope of this project

---

##  Features

-  **One-Command Installation** - Fully automated setup in 5-15 minutes
-  **Non-Root User** - Runs as dedicated `openclaw` user (supports Homebrew!)
-  **Auto-Update System** - Checks for installer updates automatically
-  **Android Networking Fix** - Automatically patches Error 13 globally
-  **Wide Compatibility** - Android 7-16, F-Droid/Play Store Termux
-  **Efficient** - Minimal storage footprint with PRoot Debian
-  **Secure** - Passwordless sudo for package installs when needed
-  **Battle-Tested** - 9 critical bugs fixed from community testing

## 📋 Prerequisites

- **Android 7+** (Android 12+ recommended)
- **[Termux from F-Droid](https://f-droid.org/en/packages/com.termux/)** - Required for compatibility
- **2GB+ free storage** (4GB recommended)
- **4GB+ RAM** (6GB+ recommended)
- **Stable internet connection**

> ⚠️ **Critical**: Do NOT use Termux from Google Play Store. The F-Droid version is actively maintained and required for compatibility.

##  Quick Start

### One-Line Install (Recommended)

Open Termux and run:

```bash
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash
```
**Wait 5-15 minutes** for automated installation to complete.


### Manual Download & Install

If you prefer to review the script first:

```bash
# Download the installer
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh

# Review it (optional)
less install.sh

# Make executable
chmod +x install.sh

# Run it
./install.sh
```

### Installation Options

```bash
# Force clean reinstall
./install.sh --reinstall

# Skip update check (faster)
./install.sh --skip-update-check

# Show help
./install.sh --help
```

## Login & run OpenClaw setup wizard
```bash
proot-distro login debian --user openclaw
openclaw onboard
```

## 📖 What Gets Installed

The installer automatically:

1.  **Updates Termux packages** (non-interactively)
2.  **Installs PRoot-Distro** with Debian
3.  **Creates `openclaw` user** (dedicated non-root user)
4.  **Installs NVM** (Node Version Manager)
5.  **Installs Node.js v22** (latest LTS)
6.  **Creates Android networking shim** (fixes Error 13 globally)
7.  **Installs OpenClaw** (latest version from npm)
8.  **Configures bash aliases** (convenient shortcuts)
9.  **Sets up environment** (optimized for Android)

**New in v2026.2.14**: Everything runs under the `openclaw` user with passwordless sudo access.

##  Daily Usage

### Starting OpenClaw (Two Sessions Required)

**Session 1 - Gateway:**
```bash
# In Termux
proot-distro login debian --user openclaw

# Inside Debian
start-claw
```

**Session 2 - TUI:**
```bash
# Swipe left in Termux for new session
proot-distro login debian --user openclaw

# Inside Debian
openclaw tui
```

### Essential Commands

**Inside Debian (as openclaw user):**

| Command | Description |
|---------|-------------|
| `start-claw` | Launch OpenClaw gateway |
| `openclaw tui` | Open terminal interface |
| `openclaw onboard` | Automated configuration wizard |
| `openclaw config` | Manual configuration menu |
| `update-openclaw` | Update OpenClaw to latest |
| `claw-status` | Check running processes |
| `claw-logs` | View log files |

**In Termux (not Debian):**

| Command | Description |
|---------|-------------|
| `proot-distro login debian --user openclaw` | Enter Debian as openclaw user |
| `termux-wake-lock` | Prevent CPU throttling |
| `pkg update` | Update Termux packages |

## 🔧 Configuration

### Option 1: Automated Setup (Recommended)

```bash
# Inside Debian
openclaw onboard
```

Walks you through setting up API keys, providers, and channels.

### Option 2: Manual Configuration

If onboarding skips steps (known issue on some Android versions):

```bash
# Inside Debian
openclaw config
```

Lets you manually configure: model, skills, channels, workspace.

### Option 3: Command Line

```bash
# Inside Debian
openclaw config set providers.anthropic.apiKey "your-key-here"
openclaw config set defaultProvider anthropic
openclaw config set defaultModel "claude-sonnet-4-20250514"
```

See [GUIDE.md](GUIDE.md#post-installation-setup) for detailed configuration instructions.

## 🆕 New Features in v2026.2.14

### Homebrew Support

You can now install Homebrew and other developer tools:

```bash
# Inside Debian as openclaw user
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
source ~/.bashrc

# Install packages
brew install cowsay
```

### Non-Root Architecture Benefits

- ✅ **Homebrew works** (refuses to run as root)
- ✅ **Better security** (isolated user environment)
- ✅ **Linux best practices** (proper user separation)
- ✅ **Passwordless sudo** (still can install packages)

## 🔄 Updating

### Update OpenClaw

```bash
# Inside Debian
update-openclaw
```

### Update Installer

The installer auto-checks for updates. To force update:

```bash
# In Termux
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh
chmod +x install.sh
./install.sh --reinstall
```

### Upgrading from v2026.2.13 or Earlier

**Important**: v2026.2.14 uses a different architecture (non-root user).

See the [complete upgrade guide](GUIDE.md#upgrading-from-older-versions) for:
- Fresh install method (recommended)
- Manual upgrade preserving data
- Migration steps

##  Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Error 13 during onboard | Fixed in v2026.2.13+. Update installer. |
| Installation hangs | Fixed in v2026.2.10+. Update installer. |
| "nvm: command not found" | Fixed in v2026.2.11+. Update installer. |
| "Don't run as root!" | Fixed in v2026.2.14. Use `--user openclaw`. |
| Slow performance | Run `termux-wake-lock` in Termux |
| Out of storage | `npm cache clean --force` in Debian |

### Getting Help

1. **Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Comprehensive solutions
2. **Check [GUIDE.md](GUIDE.md)** - Detailed setup instructions
3. **Search [Issues](https://github.com/iyeoh88-svg/openclaw-android/issues)** - Known problems
4. **Open new issue** - With Android version, error messages, and steps to reproduce

For **OpenClaw-specific issues** (features, AI models, usage): Visit the official OpenClaw repository.

## 📊 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **Android** | 7+ | 12+ |
| **Storage** | 2GB | 4GB |
| **RAM** | 4GB | 6GB+ |
| **Termux** | F-Droid | Latest F-Droid |

**Tested Configurations:**
-  Android 7 (basic support)
-  Android 12-16 (full support)
-  F-Droid Termux (recommended)
-  Play Store Termux (older, works)

##  Documentation

- **[README.md](README.md)** (you are here) - Quick start
- **[GUIDE.md](GUIDE.md)** - Complete installation guide
- **[QUICKREF.md](QUICKREF.md)** - Quick reference card
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues
- **[CHANGELOG.md](CHANGELOG.md)** - Version history
- **[DISCLAIMER.md](DISCLAIMER.md)** - Project scope & attribution

##  Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Ways to contribute:**
-  Report bugs with detailed logs
-  Suggest features or improvements
-  Improve documentation
-  Test on different devices/Android versions
-  Submit pull requests

## 🙏 Acknowledgments

### OpenClaw Framework
**All credit for the OpenClaw AI agent system goes to its original creators and maintainers.**
- Official OpenClaw: [openclaw/openclaw](https://github.com/openclaw/openclaw)
- This installer is a community contribution to make OpenClaw accessible on Android

### This Installer Project
- **Created by**: [@iyeoh88-svg](https://github.com/iyeoh88-svg)
- **Purpose**: Automated installation tool for Android/Termux
- **Status**: Not affiliated with or endorsed by the official OpenClaw team

### Community & Technologies
- **Termux** - For making Linux on Android possible
- **NVM** - Node Version Manager
- **PRoot** - Userspace implementation of chroot
- **Debian** - Stable base system
- **Community testers** - Who reported bugs and tested fixes

**Special thanks** to everyone who tested v2026.2.10-2.14 and reported issues. Your detailed bug reports made this release possible!

## 📝 License

This installer is licensed under the **MIT License** - see [LICENSE](LICENSE) for details.

**Note**: This license covers the installer only. OpenClaw has its own license - see the official OpenClaw repository.

## 📞 Support & Community

### For Installer Issues
- **Bug Reports**: [GitHub Issues](https://github.com/iyeoh88-svg/openclaw-android/issues)
- **Questions**: [GitHub Discussions](https://github.com/iyeoh88-svg/openclaw-android/discussions)
- **Feature Requests**: [GitHub Issues](https://github.com/iyeoh88-svg/openclaw-android/issues)

### For OpenClaw Issues
- Visit the **official OpenClaw repository**
- Check **OpenClaw's documentation**
- Join **OpenClaw's community channels**

**Remember**: This installer automates setup. For OpenClaw features, AI models, and functionality, contact the OpenClaw team.

##  What's Next?

After installation:

1.  **Configure API keys**: `openclaw onboard` or `openclaw config`
2.  **Start the gateway**: `start-claw`
3.  **Open the TUI**: `openclaw tui` (in new session)
4.  **Read OpenClaw docs**: Learn about OpenClaw's features
5.  **Join the community**: Connect with other OpenClaw users

## 🌟 Star History

If this installer helped you, please ⭐ star the repository!

It helps others discover the project and motivates continued development.

---

##  Project Stats

- **Version**: 2026.2.14
- **Release Date**: February 13, 2026
- **Status**: Stable
- **Active Development**: Yes
- **Community Tested**: Yes (Android 7-16)
- **Critical Bugs Fixed**: 9 (v2026.2.10-2.14)

---

## 🔗 Quick Links

- **Download**: [install.sh](https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh)
- **Issues**: [Report a bug](https://github.com/iyeoh88-svg/openclaw-android/issues/new)
- **Discussions**: [Ask questions](https://github.com/iyeoh88-svg/openclaw-android/discussions)
- **Changelog**: [Version history](CHANGELOG.md)
- **Guide**: [Detailed instructions](GUIDE.md)

---

**Made with ❤️ for the Android AI community**

*Bringing AI agents to mobile devices, one install at a time* 
