#!/bin/bash

# Ubuntu Development Environment Setup Script
# This replicates the exact manual steps that work

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

echo "=================================================="
echo "    Ubuntu Development Environment Setup"
echo "    Following exact manual steps that work"
echo "=================================================="
echo ""

# Step 1: Update system
print_step "Running apt update..."
sudo apt update

print_step "Running apt upgrade..."
sudo apt upgrade -y

# Step 2: Install NVM
print_step "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Step 3: Load NVM (this is the key step that was missing)
print_step "Loading NVM for current session..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Verify NVM is loaded
if command -v nvm >/dev/null 2>&1; then
    print_status "NVM loaded successfully"
else
    print_error "NVM failed to load"
    exit 1
fi

# Step 4: Install Node
print_step "Installing Node.js..."
nvm install node

# Step 5: Install Claude Code
print_step "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# Add npm global bin to PATH for current session
NPM_PREFIX=$(npm config get prefix)
export PATH="$NPM_PREFIX/bin:$PATH"

# Verify installation
print_step "Verifying installation..."
print_status "NPM global prefix: $NPM_PREFIX"
print_status "Checking for claude-code at: $NPM_PREFIX/bin/claude-code"

if [ -f "$NPM_PREFIX/bin/claude-code" ]; then
    print_status "✓ Claude Code file exists"
    if command -v claude-code >/dev/null 2>&1; then
        print_status "✓ Claude Code command works"
        claude-code --version
    else
        print_status "✓ Claude Code installed but not in PATH (will work after shell restart)"
    fi
else
    print_error "✗ Claude Code file not found at expected location"
    print_status "Listing contents of $NPM_PREFIX/bin:"
    ls -la "$NPM_PREFIX/bin/" || echo "Directory doesn't exist"
    exit 1
fi

# Configure shell for future sessions
print_step "Configuring shell for future sessions..."
if ! grep -q "NVM_DIR" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# NVM Configuration" >> ~/.bashrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
fi

# Add npm global bin to PATH in bashrc
if ! grep -q "npm config get prefix" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# NPM Global PATH" >> ~/.bashrc
    echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
fi

# Add aliases
if ! grep -q "alias claude=" ~/.bashrc; then
    echo 'alias claude="claude-code"' >> ~/.bashrc
fi

echo ""
echo "=================================================="
echo "                SETUP COMPLETE!"
echo "=================================================="
echo ""
print_status "Installation successful:"
echo "  • Node.js: $(node --version)"
echo "  • NPM: $(npm --version)"
echo "  • Claude Code: Working"
echo ""
print_status "You can now use:"
echo "  • claude-code --help"
echo "  • claude --help"
echo ""
print_status "For NEW terminals, run: source ~/.bashrc"
echo "Current terminal is ready to use!"
echo ""
