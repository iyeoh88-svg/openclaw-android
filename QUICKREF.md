# 📋 Quick Reference Card

## Installation

### One-Line Install
```bash
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash
```

### Manual Install
```bash
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh
chmod +x install.sh
./install.sh
```

---

## Daily Usage

### Starting OpenClaw (2 Sessions Required)

**Session 1 - Gateway:**
```bash
proot-distro login debian
start-claw
```

**Session 2 - TUI:**
```bash
# Swipe left for new session
proot-distro login debian
openclaw tui
```

---

## Essential Commands

### Inside Debian

| Command | Purpose |
|---------|---------|
| `start-claw` | Start OpenClaw gateway |
| `openclaw tui` | Open terminal interface |
| `openclaw onboard` | Configure API keys |
| `update-openclaw` | Update OpenClaw |
| `claw-status` | Check running processes |
| `exit` | Exit Debian, return to Termux |

### In Termux

| Command | Purpose |
|---------|---------|
| `termux-wake-lock` | Prevent CPU throttling |
| `termux-wake-unlock` | Release wake lock |
| `proot-distro login debian` | Enter Debian environment |
| `pkg update` | Update Termux packages |

---

## Quick Fixes

### Performance Slow
```bash
# In Termux (not Debian)
termux-wake-lock
```

### Out of Storage
```bash
# Inside Debian
npm cache clean --force
apt clean

# In Termux
pkg clean
```

### Gateway Won't Start
```bash
# Inside Debian
# Check if port is in use
lsof -i :3000

# Kill existing process (replace PID)
kill -9 [PID]
```

### Connection Issues
```bash
# Inside Debian
# Restart gateway
start-claw
```

---

## Maintenance

### Weekly Cleanup
```bash
# Inside Debian
npm cache clean --force
apt clean
apt autoremove -y
```

### Update Everything
```bash
# Update OpenClaw
update-openclaw

# Update Debian packages
apt update && apt upgrade -y

# Update Node.js
nvm install 22 --latest-npm
nvm use 22
```

---

## File Locations

### Important Directories

| Location | Contents |
|----------|----------|
| `/root/openclaw-shim.cjs` | Network fix shim |
| `~/.openclaw/` | OpenClaw data and config |
| `~/.openclaw/logs/` | Log files |
| `~/.nvm/` | Node Version Manager |
| `~/.bashrc` | Bash configuration |

### Configuration Files

```bash
# View OpenClaw config
cat ~/.openclaw/config.json

# Edit bash configuration
nano ~/.bashrc

# View logs
tail -f ~/.openclaw/logs/gateway.log
```

---

## Troubleshooting

### Error: "Permission denied"
```bash
# In Termux
termux-setup-storage
```

### Error: "Cannot find module"
```bash
# Inside Debian
npm cache clean --force
npm install -g openclaw@latest
```

### Error: "ENOSPC: no space"
```bash
# Clean everything
npm cache clean --force
apt clean
pkg clean
```

### Error: Gateway unreachable
```bash
# Verify gateway is running
claw-status

# Check binding
start-claw  # Should show 127.0.0.1:3000
```

---

## Emergency Procedures

### Complete Reset
```bash
# In Termux
proot-distro remove debian -y
./install.sh --reinstall
```

### Reset OpenClaw Only
```bash
# Inside Debian
rm -rf ~/.openclaw
npm install -g openclaw@latest --force
openclaw onboard
```

---

## Performance Tips

1. **Enable Wake Lock:**
   ```bash
   termux-wake-lock
   ```

2. **Disable Battery Optimization:**
   - Settings → Apps → Termux → Battery → Unrestricted

3. **Keep Device Plugged In** during intensive tasks

4. **Close Other Apps** to free RAM

5. **Increase Node Memory:**
   ```bash
   # Add to ~/.bashrc
   export NODE_OPTIONS="--max-old-space-size=2048"
   ```

---

## Useful Aliases

Add these to `~/.bashrc` for convenience:

```bash
# Quick navigation
alias cdhome='cd ~'
alias cdclaw='cd ~/.openclaw'

# Log viewing
alias logs='tail -f ~/.openclaw/logs/gateway.log'
alias errors='grep -i error ~/.openclaw/logs/*.log'

# System info
alias sysinfo='echo "Node: $(node -v) | NPM: $(npm -v) | OpenClaw: $(openclaw -v)"'

# Process management
alias killclaw='pkill -f openclaw'
```

---

## Common Workflows

### Initial Setup
```bash
# 1. Install (one time)
curl -fsSL https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh | bash

# 2. Configure API
proot-distro login debian
openclaw onboard

# 3. Start using
# Session 1: start-claw
# Session 2: openclaw tui
```

### Daily Use
```bash
# Morning: Start OpenClaw
proot-distro login debian
start-claw

# Use OpenClaw
# (in another session)
proot-distro login debian
openclaw tui

# Evening: Stop OpenClaw
# Ctrl+C in both sessions
```

### Weekly Maintenance
```bash
# Inside Debian
npm cache clean --force
apt clean
update-openclaw
```

---

## Getting Help

### Documentation
- **Installation Guide**: [GUIDE.md](GUIDE.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)

### Support Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and community help
- **OpenClaw Docs**: https://docs.openclaw.ai

### Before Asking for Help

1. ✅ Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. ✅ Search existing GitHub issues
3. ✅ Update to latest version
4. ✅ Try basic fixes (restart, clear cache)
5. ✅ Gather error messages and logs

---

## Version Information

**Current Version**: 2026.2.6  
**Last Updated**: February 2026  
**Supported Android**: 12+  
**Recommended RAM**: 4GB+  
**Required Storage**: 2GB+

---

## Quick Links

- 📖 [Full Documentation](README.md)
- 🔧 [Troubleshooting Guide](TROUBLESHOOTING.md)
- 🐛 [Report Issues](https://github.com/iyeoh88-svg/openclaw-android/issues)
- 💬 [Community Discussions](https://github.com/iyeoh88-svg/openclaw-android/discussions)
- 📝 [Changelog](CHANGELOG.md)

---

**Print this page and keep it handy! 📄**

Save this quick reference:
```bash
curl -O https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/QUICKREF.md
```
