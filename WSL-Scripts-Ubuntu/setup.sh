#!/bin/bash

# Ubuntu Development Environment Setup Script
# Run this inside WSL Ubuntu after initial setup
# Usage: curl -fsSL https://your-github-url/setup.sh | bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Banner
echo "=================================================="
echo "    Ubuntu Development Environment Setup"
echo "    Node.js + Claude Code Installation"
echo "=================================================="
echo ""

# Check if running in WSL
if ! grep -qi microsoft /proc/version 2>/dev/null && ! grep -qi wsl /proc/version 2>/dev/null; then
    print_warning "This doesn't appear to be WSL. Continuing anyway..."
fi

# Update system
print_step "Updating system packages..."
export DEBIAN_FRONTEND=noninteractive
sudo apt update -y
sudo apt upgrade -y

# Install essential packages
print_step "Installing essential packages..."
sudo apt install -y curl wget git build-essential software-properties-common

print_status "Essential packages installed successfully"

# Install NVM
print_step "Installing Node Version Manager (NVM)..."
if [ -d "$HOME/.nvm" ]; then
    print_warning "NVM directory already exists, skipping download"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    print_status "NVM installation script completed"
fi

# Source NVM for current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Verify NVM installation
if command -v nvm >/dev/null 2>&1; then
    print_status "NVM is available in current session"
else
    print_error "NVM not found in current session, but may work in new terminals"
fi

# Install Node.js
print_step "Installing Node.js (latest stable)..."
nvm install node
nvm use node

# Verify Node installation
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    print_status "Node.js installed: $NODE_VERSION"
    print_status "NPM installed: $NPM_VERSION"
else
    print_error "Node.js installation failed"
    exit 1
fi

# Install Claude Code
print_step "Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Verify Claude Code installation
if command -v claude-code >/dev/null 2>&1; then
    CLAUDE_VERSION=$(claude-code --version 2>/dev/null || echo "installed")
    print_status "Claude Code installed: $CLAUDE_VERSION"
else
    print_error "Claude Code installation may have failed"
    print_warning "Try running: npm install -g @anthropic-ai/claude-code"
fi

# Configure shell for future sessions
print_step "Configuring shell environment..."

# Add NVM to bashrc if not already there
if ! grep -q "NVM_DIR" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# NVM Configuration (added by setup script)" >> ~/.bashrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
    print_status "NVM configuration added to ~/.bashrc"
else
    print_status "NVM already configured in ~/.bashrc"
fi

# Add helpful aliases
if ! grep -q "claude-code aliases" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Claude Code aliases (added by setup script)" >> ~/.bashrc
    echo 'alias claude="claude-code"' >> ~/.bashrc
    echo 'alias cc="claude-code"' >> ~/.bashrc
    print_status "Claude Code aliases added (claude, cc)"
fi

# Create a simple test to verify everything works
print_step "Running verification tests..."

# Test Node.js
if node -e "console.log('Node.js test: OK')" >/dev/null 2>&1; then
    print_status "✓ Node.js is working"
else
    print_error "✗ Node.js test failed"
fi

# Test NPM
if npm --version >/dev/null 2>&1; then
    print_status "✓ NPM is working"
else
    print_error "✗ NPM test failed"
fi

# Test Claude Code
if claude-code --help >/dev/null 2>&1; then
    print_status "✓ Claude Code is working"
else
    print_warning "✗ Claude Code test failed (may still work in new terminal)"
fi

# Final summary
echo ""
echo "=================================================="
echo "                SETUP COMPLETE!"
echo "=================================================="
echo ""
print_status "Installed components:"
echo "  • Node.js: $(node --version 2>/dev/null || echo 'Unknown version')"
echo "  • NPM: $(npm --version 2>/dev/null || echo 'Unknown version')"
echo "  • Claude Code: Available globally"
echo ""
print_status "Available commands:"
echo "  • claude-code --help"
echo "  • claude --help (alias)"
echo "  • cc --help (short alias)"
echo ""
print_warning "Important: Open a NEW terminal or run 'source ~/.bashrc' to use NVM in future sessions"
echo ""
print_status "To get started:"
echo "  1. Close this terminal and open a new one"
echo "  2. Type: wsl (if using from Windows)"
echo "  3. Type: claude-code --help"
echo ""
echo "Happy coding! 🚀"