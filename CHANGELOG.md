# Changelog

All notable changes to the OpenClaw Android Installer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2026.2.7] - 2026-02-13

### Fixed
- 🐛 Fixed "Permission denied" error when creating Debian setup script
- Changed temporary script location from `/tmp` to `$HOME` to avoid Termux permission issues
- Added automatic cleanup of setup script after successful installation

### Changed
- Improved error messages for failed Debian setup with manual recovery instructions

## [2026.2.6] - 2026-02-12

### Added
- 🎉 Initial public release
- ✅ Fully automated installation script with progress indicators
- 🔄 Auto-update system that checks for new installer versions
- 🛠️ Comprehensive error handling and recovery
- 📝 Detailed documentation (README, GUIDE, TROUBLESHOOTING)
- 🎨 Colorful CLI output with status indicators
- ⚙️ Automatic creation of convenience aliases
- 🔧 Android Error 13 networking fix (shim system)
- 📊 Storage and system compatibility checks
- 🎯 Command-line flags (--reinstall, --skip-update-check)

### Features
- Automatic Termux package updates
- PRoot Debian installation and configuration
- NVM and Node.js 22 installation
- OpenClaw global package installation
- Helper scripts for easy launching
- Complete environment setup automation
- Version compatibility checks
- Progress tracking and ETA estimates

### Documentation
- README.md with quick start guide
- GUIDE.md with detailed instructions
- TROUBLESHOOTING.md with solutions to common issues
- Inline script documentation
- Usage examples and best practices

## Version History

### Pre-release Development

**2026-02-10**: Alpha testing phase
- Internal testing with select users
- Bug fixes and optimization
- Documentation refinement

**2026-02-05**: Initial development
- Proof of concept
- Basic installation workflow
- Error 13 fix implementation

---

## Release Notes

### v2026.2.6 - "First Light" 🚀

This is the first public release of the OpenClaw Android installer. After extensive testing, we're excited to bring OpenClaw to Android devices via Termux.

**Highlights:**
- One-command installation
- Automatic problem detection and fixing
- Comprehensive documentation
- Active community support

**Known Issues:**
- Performance may vary on devices with less than 4GB RAM
- Android 11 support is experimental
- Some Android skins may require additional battery optimization tweaks

**Upgrading:**
If you were using a pre-release version, please run:
```bash
./install.sh --reinstall
```

**Contributors:**
Thank you to our alpha testers and the Termux community for making this possible!

---

## Deprecation Notices

None currently.

## Security Updates

None currently. We will document any security-related updates here.

---

**How to Update:**

The installer automatically checks for updates. To manually check:
```bash
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash
```

**Reporting Issues:**

Found a bug? Please report it:
- GitHub Issues: https://github.com/iyeoh88-svg/openclaw-android/issues
- Include: Android version, Termux version, error message, steps to reproduce

---

[2026.2.6]: https://github.com/iyeoh88-svg/openclaw-android/releases/tag/v2026.2.6
