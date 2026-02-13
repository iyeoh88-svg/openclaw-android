# 🦞 OpenClaw for Android (Termux)

[![Version](https://img.shields.io/badge/version-2026.2.6-blue.svg)](https://github.com/iyeoh88-svg/openclaw-android)
[![Android](https://img.shields.io/badge/Android-12%2B-green.svg)](https://www.android.com/)
[![Termux](https://img.shields.io/badge/Termux-Required-orange.svg)](https://termux.dev/)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/iyeoh88-svg/openclaw-android.svg)](https://github.com/iyeoh88-svg/openclaw-android/stargazers)
[![Issues](https://img.shields.io/github/issues/iyeoh88-svg/openclaw-android.svg)](https://github.com/iyeoh88-svg/openclaw-android/issues)

> **Automated installer for running OpenClaw AI agent system on Android devices via Termux**

OpenClaw is a powerful AI agent framework that can now run natively on Android devices. This installer automates the entire setup process, handling environment configuration, dependency installation, and networking fixes specific to Android.

## ✨ Features

- 🚀 **One-Command Installation** - Fully automated setup process
- 🔄 **Auto-Update System** - Script checks for updates on every run
- 🔧 **Android Networking Fix** - Automatically patches the Error 13 issue
- 📱 **Optimized for Android 12+** - Tested on modern Android devices
- 💾 **Minimal Storage Impact** - Efficient PRoot Debian environment

## 📋 Prerequisites

- Android device running Android 12 or higher
- [Termux](https://f-droid.org/en/packages/com.termux/) installed from F-Droid
- At least 2GB of free storage space
- Stable internet connection

> ⚠️ **Important**: Do not install Termux from Google Play Store. Use the F-Droid version for compatibility.

## 🚀 Quick Start

### Method 1: One-Line Install (Recommended)

Run this command in Termux:

```bash
# Termux main terminal
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash

# First time setup (enter debian)
proot-distro login debian

# Run the openclaw setup wizard (inside debian)
openclaw onboard
```

### Method 2: Manual Download

```bash
# Download the installer
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh

# Make it executable
chmod +x install.sh

# Run the installer
./install.sh
```

## 📖 What Gets Installed

The script automatically:

1. ✅ Updates Termux packages
2. ✅ Installs and configures PRoot-Distro with Debian
3. ✅ Installs Node.js v22 via NVM
4. ✅ Creates networking shim to fix Android Error 13
5. ✅ Installs OpenClaw globally
6. ✅ Sets up convenient aliases for daily use
7. ✅ Configures the environment for optimal performance

## 🎮 Daily Usage

After installation, use these simple commands:

### Starting OpenClaw

**Session 1 - Gateway (The Brain)**
```bash
# In Termux
proot-distro login debian

# Inside Debian
start-claw
```

**Session 2 - TUI (The Interface)**
```bash
# Swipe left in Termux to open new session
proot-distro login debian

# Inside Debian
openclaw tui
```

### Quick Commands

- `start-claw` - Launch the OpenClaw gateway
- `openclaw tui` - Open the terminal interface
- `openclaw onboard` - Configure API keys
- `update-openclaw` - Update to latest version

## 🔧 Troubleshooting

### Performance Issues

If OpenClaw is running slowly:

```bash
# In standard Termux (not Debian)
termux-wake-lock
```

This prevents Android from throttling CPU when the screen is off.

### Storage Issues

```bash
# Inside Debian
npm cache clean --force
apt clean
```

### API Configuration

```bash
# Inside Debian
openclaw onboard
```

Follow the prompts to configure Gemini, OpenAI, or other providers.

### Complete Reinstall

```bash
# In standard Termux
./install.sh --reinstall
```

## 📊 System Requirements

| Component | Requirement |
|-----------|-------------|
| **OS** | Android 12+ |
| **Storage** | 2GB minimum, 4GB recommended |
| **RAM** | 4GB minimum, 6GB+ recommended |
| **Termux** | Latest version from F-Droid |

## 🔄 Updating

The installer automatically checks for updates each time you run it. To manually update:

```bash
# Re-run the installer
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash
```

## 🐛 Known Issues

- **Error 13**: Fixed automatically by the installer
- **Performance**: Use `termux-wake-lock` for better performance
- **Battery**: OpenClaw may drain battery faster; keep device charged during intensive tasks

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- OpenClaw team for the amazing AI agent framework
- Termux community for making Linux on Android possible
- NVM team for Node.js version management

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/iyeoh88-svg/openclaw-android/issues)
- **Discussions**: [GitHub Discussions](https://github.com/iyeoh88-svg/openclaw-android/discussions)
- **Documentation**: [Wiki](https://github.com/iyeoh88-svg/openclaw-android/wiki)

---

**Made with ❤️ for the Android AI community**
