# Complete WSL Ubuntu Setup Script - Actually Automated
# Run this in PowerShell as Administrator

Write-Host "🚀 Setting up WSL Ubuntu with Node.js and Claude Code (FULLY AUTOMATED)" -ForegroundColor Green

# Check if running as admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as administrator'" -ForegroundColor Yellow
    exit 1
}

# Install WSL Ubuntu if not already installed
Write-Host "📦 Installing WSL Ubuntu..." -ForegroundColor Yellow
try {
    $wslList = wsl --list --quiet
    if ($wslList -notmatch "Ubuntu") {
        wsl --install Ubuntu --no-launch
        Write-Host "⏳ WSL Ubuntu installed. Reboot may be required." -ForegroundColor Yellow
        Write-Host "🔄 If prompted to reboot, do so and run this script again." -ForegroundColor Cyan
    }
} catch {
    Write-Host "❌ WSL installation failed. Enable WSL feature first." -ForegroundColor Red
    exit 1
}

# Wait for WSL to be ready
Write-Host "⏳ Waiting for WSL to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Create a comprehensive setup script
$setupScript = @'
#!/bin/bash
set -e

echo "🔧 Starting Ubuntu setup inside WSL..."

# Update system
echo "📦 Updating system packages..."
export DEBIAN_FRONTEND=noninteractive
sudo apt update -y
sudo apt upgrade -y

# Install essential packages
echo "🛠️ Installing essential packages..."
sudo apt install -y curl wget git build-essential

# Install NVM
echo "📦 Installing Node Version Manager (NVM)..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

# Source NVM immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install Node.js
echo "🟢 Installing Node.js..."
nvm install node
nvm use node

# Install Claude Code
echo "🤖 Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# Add NVM to bashrc for future sessions
echo "⚙️ Configuring shell..."
if ! grep -q "NVM_DIR" ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo '# NVM Configuration' >> ~/.bashrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
fi

# Create claude-code alias for easier access
echo "🔗 Creating claude-code alias..."
echo 'alias claude="claude-code"' >> ~/.bashrc

# Test installations
echo "🧪 Testing installations..."
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
echo "Claude Code path: $(which claude-code)"

echo "✅ Setup complete!"
echo "🎉 You can now use 'claude-code' or 'claude' command!"
'@

# Execute the setup script in WSL
Write-Host "🔧 Running setup inside WSL Ubuntu..." -ForegroundColor Yellow

try {
    # Write script to WSL
    $setupScript | wsl --distribution Ubuntu --exec bash -c "cat > /tmp/setup.sh"
    
    # Make executable and run
    wsl --distribution Ubuntu --exec chmod +x /tmp/setup.sh
    wsl --distribution Ubuntu --exec bash /tmp/setup.sh
    
    Write-Host "✅ Setup completed successfully!" -ForegroundColor Green
    Write-Host "" 
    Write-Host "🎯 To use Claude Code:" -ForegroundColor Cyan
    Write-Host "1. Open a new terminal" -ForegroundColor White
    Write-Host "2. Type: wsl" -ForegroundColor White
    Write-Host "3. Type: claude-code --help" -ForegroundColor White
    Write-Host "" 
    Write-Host "Or use the shortcut: claude --help" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Setup failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "🔄 Try running: wsl --distribution Ubuntu" -ForegroundColor Yellow
    Write-Host "Then manually run the setup commands" -ForegroundColor Yellow
}

# Test the installation
Write-Host "🧪 Testing installation..." -ForegroundColor Yellow
try {
    $testResult = wsl --distribution Ubuntu --exec bash -c "source ~/.bashrc && claude-code --version"
    if ($testResult) {
        Write-Host "✅ Claude Code is working!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Test failed, but installation may still work" -ForegroundColor Yellow
}

Write-Host "" 
Write-Host "🚀 All done! Open a new terminal and type 'wsl' to access your Ubuntu environment." -ForegroundColor Green
