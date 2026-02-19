# Changelog

All notable changes to the OpenClaw Android Installer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2026.2.14] - 2026-02-13

### Added
-  Dedicated non-root user `openclaw` is now created inside Debian
-  NVM, Node.js, OpenClaw, and all configs are installed under the `openclaw` user
-  Passwordless sudo granted to `openclaw` user for package installs (e.g. Homebrew)
-  Networking shim stored at `/home/openclaw/openclaw-shim.cjs`

### Changed
- **BREAKING**: Login command updated to `proot-distro login debian --user openclaw`
- All documentation updated to use new login command
- Completion message updated with correct login instructions
- `NODE_OPTIONS="--require /root/openclaw-shim.cjs"` is now set globally in `.bashrc`
- All openclaw commands (`onboard`, `config`, `tui`, `gateway`, etc.) now work without Error 13
- Added `openclaw config` to the welcome message quick commands

### Fixed
-  **CRITICAL**: Fixed Error 13 appearing during `openclaw onboard`, `openclaw config`, `openclaw tui` and all other openclaw commands
  - Root cause: The Android networking shim was only applied to `start-claw` alias
  - Fix: Moved `NODE_OPTIONS` to a global export in `.bashrc` so ALL openclaw commands automatically use the shim
  - `start-claw` alias simplified (no longer needs NODE_OPTIONS inline)
-  Homebrew and other tools that refuse to run as root now work correctly
-  `useradd` and `sudo` installed as part of base packages

### Context
[##Unable to install brew](https://github.com/iyeoh88-svg/openclaw-android/issues/2): Previously everything ran as `root` inside Debian. Tools like Homebrew explicitly block root usage. Now OpenClaw runs in a proper non-root user environment while still having sudo access for any package installations needed. 

[##Error 13 after running OpenClaw Onboard](https://github.com/iyeoh88-svg/openclaw-android/issues/3): Previously the networking shim was only injected when running `start-claw`. Any other openclaw command run directly would trigger the Android Error 13. Now the shim applies globally to the entire Debian session.


## [2026.2.10] - 2026-02-13

### Fixed
-  **CRITICAL**: Fixed `pkg upgrade` hanging on interactive prompts (dpkg config file conflicts)
  - Now uses `apt-get upgrade` with `--force-confold` to avoid prompts
  - Sets `DEBIAN_FRONTEND=noninteractive` to prevent any interactive dialogs
-  Fixed `df: Unknown option 'm'` error on some Termux versions
  - Changed from `df -m` to `df -k` (more universally supported)
  - Added proper validation and error handling for storage check
-  Fixed version comparison validation
  - Added regex validation to ensure version format is correct (e.g., 2026.2.10)
  - Only uses first line from VERSION file to prevent concatenation
  - Better handling of malformed version responses
-  Fixed "integer expression expected" error when storage check fails
  - Added proper null/empty checks before numeric comparisons
  - Fallback to user confirmation if storage can't be determined
- **CRITICAL**: Fixed "nvm: command not found" error during Node.js installation
  - Added multiple fallback methods to load NVM
  - Improved NVM sourcing with better error detection
  - Added verification steps before attempting to use nvm
  - Now tries: direct source, bashrc source, and manual load

### Changed
- Improved error messages for storage check failures
- Added user prompt to continue if storage check fails (rather than hard exit)
- Better validation of curl responses in version checking
- Enhanced NVM loading with 3-tier fallback system
- Better error messages when NVM fails to load
- Added explicit verification that nvm command is available

### Context
These fixes address issues reported by users running F-Droid Termux on Android 16. The interactive dpkg prompt was the most critical issue preventing unattended installation. After NVM installation, the script needs to explicitly source it before use. Some environments don't automatically load it, causing "command not found" errors.

## [2026.2.9] - 2026-02-13

### Added
-  **DISCLAIMER.md** - Comprehensive disclaimer clarifying project scope
-  Attribution notices in README and installer banner
-  Proper credit to OpenClaw's original creators throughout documentation
-  Updated marketing materials with attribution guidelines

### Changed
- Clarified in all documentation that this is an installer tool, not OpenClaw itself
- Updated CONTRIBUTING.md to specify contribution scope
- Added disclaimer notices to completion messages
- Updated README badges to show correct version (2026.2.9)

### Context
This update ensures proper attribution to OpenClaw's creators and clarifies that this project is a community-created installation tool, not the OpenClaw framework itself.

## [2026.2.8] - 2026-02-13

### Fixed
-  Fixed version comparison showing incorrect concatenated versions
-  Fixed "No command y found" error when responding to prompts
-  Fixed auto-update download using /tmp (permission denied)
-  All user input prompts now use `/dev/tty` for proper input handling in Termux

### Changed
- Improved version checking with whitespace trimming
- Auto-update now downloads to `$HOME` instead of `/tmp`
- Better error handling for empty version responses

## [2026.2.7] - 2026-02-13

### Fixed
- Fixed "Permission denied" error when creating Debian setup script
- Changed temporary script location from `/tmp` to `$HOME` to avoid Termux permission issues
- Added automatic cleanup of setup script after successful installation

### Changed
- Improved error messages for failed Debian setup with manual recovery instructions

## [2026.2.6] - 2026-02-12

### Added
-  Initial public release
-  Fully automated installation script with progress indicators
-  Auto-update system that checks for new installer versions
-  Comprehensive error handling and recovery
-  Detailed documentation (README, GUIDE, TROUBLESHOOTING)
-  Colorful CLI output with status indicators
-  Automatic creation of convenience aliases
-  Android Error 13 networking fix (shim system)
-  Storage and system compatibility checks
-  Command-line flags (--reinstall, --skip-update-check)

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

## [Unreleased]

### Planned
-  Video tutorial
-  Termux:Widget integration for home screen shortcuts
-  Android 11 compatibility testing
-  Multi-language support
-  Custom themes for TUI
-  Performance benchmarking tools
-  Desktop notifications integration
-  Backup and restore functionality
-  One-command update for OpenClaw and all dependencies
-  Alternative installation via Docker (if possible on Android)

### Under Consideration
- GUI installer (Termux:API integration)
- Automatic log rotation
- Performance profiling mode
- Cloud sync for configurations
- Plugin system for extensions

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
