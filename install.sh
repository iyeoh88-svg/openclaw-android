#!/data/data/com.termux/files/usr/bin/bash
################################################################################
# OpenClaw Android Installer
# Version: 2026.2.11
# Description: Automated installer for OpenClaw on Android via Termux
# Repository: https://github.com/iyeoh88-svg/openclaw-android
################################################################################

set -e  # Exit on error

# Script Configuration
SCRIPT_VERSION="2026.2.11"
SCRIPT_URL="https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/install.sh"
VERSION_URL="https://raw.githubusercontent.com/iyeoh88-svg/openclaw-android/main/VERSION"
REPO_URL="https://github.com/iyeoh88-svg/openclaw-android"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${MAGENTA}==>${NC} ${CYAN}$1${NC}\n"
}

# Banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════╗
    ║                                               ║
    ║           🦞 OpenClaw for Android 🦞           ║
    ║                                               ║
    ║      Automated Installation & Setup Tool      ║
    ║                                               ║
    ╚═══════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "  Version: ${GREEN}${SCRIPT_VERSION}${NC}"
    echo -e "  Repository: ${BLUE}${REPO_URL}${NC}"
    echo -e ""
    echo -e "${YELLOW}  ⚠️  DISCLAIMER:${NC} This is a community-created installer."
    echo -e "      OpenClaw framework © its original creators"
    echo -e ""
}

# Check for updates
check_for_updates() {
    log_step "Checking for installer updates..."
    
    if command -v curl &> /dev/null; then
        # Get latest version, trim whitespace, and only use first line
        LATEST_VERSION=$(curl -s "$VERSION_URL" 2>/dev/null | head -1 | tr -d '[:space:]')
        
        # Validate version format (should be like 2026.2.9)
        if ! [[ "$LATEST_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            log_warn "Unable to check for updates (invalid version format received)"
            LATEST_VERSION="$SCRIPT_VERSION"
        fi
        
        # If curl failed or returned empty, use current version
        if [ -z "$LATEST_VERSION" ]; then
            LATEST_VERSION="$SCRIPT_VERSION"
        fi
        
        if [ "$LATEST_VERSION" != "$SCRIPT_VERSION" ]; then
            log_warn "New installer version available: $LATEST_VERSION (current: $SCRIPT_VERSION)"
            echo -e "\n${YELLOW}Would you like to update the installer? (y/n)${NC}"
            # Read from /dev/tty to ensure interactive input works in Termux
            read -r response < /dev/tty
            
            if [[ "$response" =~ ^[Yy]$ ]]; then
                log_info "Downloading latest installer..."
                # Use $HOME instead of /tmp to avoid permission issues
                curl -fsSL "$SCRIPT_URL" -o "$HOME/install_new.sh"
                chmod +x "$HOME/install_new.sh"
                log_success "Installer updated! Restarting with new version..."
                exec "$HOME/install_new.sh" "$@"
            else
                log_info "Continuing with current version..."
            fi
        else
            log_success "Installer is up to date!"
        fi
    else
        log_warn "Unable to check for updates (curl not available)"
    fi
}

# Check if running in Termux
check_termux() {
    if [ ! -d "/data/data/com.termux" ]; then
        log_error "This script must be run in Termux!"
        log_info "Please install Termux from F-Droid: https://f-droid.org/en/packages/com.termux/"
        exit 1
    fi
    log_success "Termux environment detected"
}

# Check Android version
check_android_version() {
    log_step "Checking Android version..."
    
    ANDROID_VERSION=$(getprop ro.build.version.release)
    log_info "Android version: $ANDROID_VERSION"
    
    if [ "${ANDROID_VERSION%%.*}" -lt 12 ]; then
        log_warn "Android 12+ is recommended for best compatibility"
        echo -e "${YELLOW}Continue anyway? (y/n)${NC}"
        read -r response < /dev/tty
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled"
            exit 0
        fi
    else
        log_success "Android version compatible"
    fi
}

# Check available storage
check_storage() {
    log_step "Checking available storage..."
    
    # Use df -k (more compatible) and convert to MB
    AVAILABLE_KB=$(df -k "$HOME" 2>/dev/null | tail -1 | awk '{print $4}')
    
    # Check if we got a valid number
    if [ -z "$AVAILABLE_KB" ] || ! [[ "$AVAILABLE_KB" =~ ^[0-9]+$ ]]; then
        log_warn "Unable to check available storage automatically"
        log_info "Please ensure you have at least 2GB free space"
        echo -e "${YELLOW}Continue anyway? (y/n)${NC}"
        read -r response < /dev/tty
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled"
            exit 0
        fi
        return 0
    fi
    
    # Convert KB to MB
    AVAILABLE_MB=$((AVAILABLE_KB / 1024))
    log_info "Available storage: ${AVAILABLE_MB}MB"
    
    if [ "$AVAILABLE_MB" -lt 2048 ]; then
        log_error "Insufficient storage! At least 2GB required, ${AVAILABLE_MB}MB available"
        log_info "Please free up some space and try again"
        exit 1
    fi
    log_success "Storage check passed"
}

# Install Termux packages
install_termux_packages() {
    log_step "Installing Termux packages..."
    
    log_info "Updating package lists..."
    pkg update -y
    
    log_info "Upgrading existing packages..."
    # Set environment to avoid interactive prompts
    export DEBIAN_FRONTEND=noninteractive
    # Use apt options to automatically handle config file changes
    apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
    
    log_info "Installing proot-distro..."
    pkg install proot-distro -y
    
    log_success "Termux packages installed"
}

# Install Debian distribution
install_debian() {
    log_step "Installing Debian distribution..."
    
    if proot-distro list | grep -q "debian.*installed"; then
        log_warn "Debian already installed"
        
        if [ "$REINSTALL" = "true" ]; then
            log_info "Reinstalling Debian..."
            proot-distro remove debian -y 2>/dev/null || true
            proot-distro install debian
        else
            echo -e "${YELLOW}Debian is already installed. Reinstall? (y/n)${NC}"
            read -r response < /dev/tty
            if [[ "$response" =~ ^[Yy]$ ]]; then
                proot-distro remove debian -y
                proot-distro install debian
            else
                log_info "Using existing Debian installation"
            fi
        fi
    else
        proot-distro install debian
    fi
    
    log_success "Debian distribution ready"
}

# Create setup script for Debian environment
create_debian_setup() {
    log_step "Creating Debian setup script..."
    
    # Use $HOME instead of /tmp to avoid permission issues
    cat > "$HOME/debian_setup.sh" << 'DEBIAN_SCRIPT'
#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo -e "\n${GREEN}==> Setting up Debian environment...${NC}\n"

# Update Debian packages
log_info "Updating Debian packages..."
apt update && apt upgrade -y

# Install dependencies
log_info "Installing build dependencies..."
apt install -y curl git build-essential ca-certificates

# Install NVM
if [ ! -d "$HOME/.nvm" ]; then
    log_info "Installing NVM (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Source NVM - try multiple methods to ensure it loads
log_info "Loading NVM..."
export NVM_DIR="$HOME/.nvm"

# Method 1: Direct source
if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
elif [ -s "/root/.nvm/nvm.sh" ]; then
    export NVM_DIR="/root/.nvm"
    \. "$NVM_DIR/nvm.sh"
fi

# Method 2: Source from bashrc if NVM added it
if [ -s "$HOME/.bashrc" ]; then
    # Extract and source just the NVM lines
    grep -q 'NVM_DIR' "$HOME/.bashrc" && . "$HOME/.bashrc"
fi

# Verify NVM is loaded
if ! command -v nvm &> /dev/null; then
    log_error "NVM failed to load. Trying manual load..."
    # Last resort: manual load
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# Final verification
if ! command -v nvm &> /dev/null; then
    log_error "NVM installation failed or cannot be loaded"
    log_info "Please check: ls -la $HOME/.nvm/"
    exit 1
fi

log_success "NVM loaded successfully"

# Install Node.js 22
log_info "Installing Node.js v22..."
nvm install 22
nvm use 22
nvm alias default 22

# Verify Node installation
NODE_VERSION=$(node --version)
log_success "Node.js $NODE_VERSION installed"

# Create OpenClaw networking shim
log_info "Creating Android networking fix..."
cat > /root/openclaw-shim.cjs << 'EOF'
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
log_success "Networking shim created"

# Install OpenClaw
log_info "Installing OpenClaw (this may take a few minutes)..."
npm install -g openclaw@latest

# Verify installation
if command -v openclaw &> /dev/null; then
    OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
    log_success "OpenClaw $OPENCLAW_VERSION installed successfully"
else
    log_error "OpenClaw installation failed"
    exit 1
fi

# Create convenient aliases
log_info "Setting up aliases..."
cat >> ~/.bashrc << 'EOF'

# OpenClaw aliases
alias start-claw='NODE_OPTIONS="--require /root/openclaw-shim.cjs" openclaw gateway --bind loopback'
alias update-openclaw='npm update -g openclaw'
alias claw-status='ps aux | grep openclaw'
alias claw-logs='tail -f ~/.openclaw/logs/*.log'

# Welcome message
echo ""
echo -e "\033[0;36m╔═══════════════════════════════════════╗\033[0m"
echo -e "\033[0;36m║  🦞 OpenClaw Environment Ready 🦞      ║\033[0m"
echo -e "\033[0;36m╚═══════════════════════════════════════╝\033[0m"
echo ""
echo -e "\033[0;32mQuick Commands:\033[0m"
echo "  start-claw      - Start OpenClaw gateway"
echo "  openclaw tui    - Open terminal interface"
echo "  openclaw onboard - Configure API keys"
echo "  update-openclaw - Update to latest version"
echo ""
EOF

source ~/.bashrc

log_success "Debian environment setup complete!"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                               ║${NC}"
echo -e "${GREEN}║         ✅ Installation Complete! ✅           ║${NC}"
echo -e "${GREEN}║                                               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Open a NEW Termux session (swipe left)"
echo "2. Run: proot-distro login debian"
echo "3. In Session 1: start-claw"
echo "4. In Session 2: openclaw tui"
echo ""
DEBIAN_SCRIPT

    chmod +x "$HOME/debian_setup.sh"
    log_success "Setup script created"
}

# Execute Debian setup
execute_debian_setup() {
    log_step "Executing Debian environment setup..."
    
    log_info "This will take 5-10 minutes depending on your device..."
    log_info "Please be patient and do not close Termux"
    
    if proot-distro login debian -- /bin/bash -c "bash $HOME/debian_setup.sh"; then
        log_success "Debian setup completed successfully"
        # Clean up the setup script
        rm -f "$HOME/debian_setup.sh"
    else
        log_error "Debian setup failed"
        log_info "Setup script saved at: $HOME/debian_setup.sh"
        log_info "You can try running it manually:"
        log_info "  proot-distro login debian"
        log_info "  bash ~/debian_setup.sh"
        exit 1
    fi
}

# Create helper scripts
create_helper_scripts() {
    log_step "Creating helper scripts..."
    
    # Create launcher script
    cat > "$HOME/start-openclaw.sh" << 'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
echo "Starting OpenClaw..."
echo ""
echo "Opening Debian environment..."
proot-distro login debian
LAUNCHER
    chmod +x "$HOME/start-openclaw.sh"
    
    log_success "Helper scripts created in: $HOME"
}

# Show completion message
show_completion() {
    log_step "Installation Summary"
    
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                   ║${NC}"
    echo -e "${GREEN}║     🎉 OpenClaw Installation Complete! 🎉          ║${NC}"
    echo -e "${GREEN}║                                                   ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Note: This installer is a community tool.${NC}"
    echo -e "   OpenClaw framework © its original creators"
    echo ""
    echo -e "${CYAN}📝 Quick Start Guide:${NC}"
    echo ""
    echo -e "${YELLOW}Step 1:${NC} Start OpenClaw Gateway"
    echo "  $ proot-distro login debian"
    echo "  $ start-claw"
    echo ""
    echo -e "${YELLOW}Step 2:${NC} Open new Termux session (swipe left)"
    echo "  $ proot-distro login debian"
    echo "  $ openclaw tui"
    echo ""
    echo -e "${CYAN}📚 Available Commands:${NC}"
    echo "  start-claw       - Launch gateway"
    echo "  openclaw tui     - Open interface"
    echo "  openclaw onboard - Configure API"
    echo "  update-openclaw  - Update OpenClaw"
    echo ""
    echo -e "${CYAN}⚡ Performance Tip:${NC}"
    echo "  Run 'termux-wake-lock' in Termux to prevent throttling"
    echo ""
    echo -e "${CYAN}🐛 Issues?${NC}"
    echo "  Visit: ${BLUE}${REPO_URL}/issues${NC}"
    echo ""
}

# Parse command line arguments
REINSTALL=false
SKIP_UPDATE_CHECK=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --reinstall)
            REINSTALL=true
            shift
            ;;
        --skip-update-check)
            SKIP_UPDATE_CHECK=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --reinstall           Force reinstallation"
            echo "  --skip-update-check   Skip checking for updates"
            echo "  --help                Show this help message"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Main installation flow
main() {
    show_banner
    
    if [ "$SKIP_UPDATE_CHECK" = "false" ]; then
        check_for_updates
    fi
    
    check_termux
    check_android_version
    check_storage
    
    install_termux_packages
    install_debian
    create_debian_setup
    execute_debian_setup
    create_helper_scripts
    
    show_completion
}

# Run main installation
main "$@"
