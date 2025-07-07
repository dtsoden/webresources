# WSL Ubuntu Setup Script
# Run this in PowerShell as Administrator

Write-Host "Setting up WSL Ubuntu with Node.js and Claude Code..." -ForegroundColor Green

# Install WSL Ubuntu
Write-Host "Installing WSL Ubuntu..." -ForegroundColor Yellow
wsl --install Ubuntu

# Wait for installation to complete
Write-Host "Waiting for WSL installation to complete..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check if WSL is ready
$timeout = 120
$timer = 0
do {
    $wslStatus = wsl --list --quiet
    if ($wslStatus -match "Ubuntu") {
        Write-Host "WSL Ubuntu is ready!" -ForegroundColor Green
        break
    }
    Start-Sleep -Seconds 5
    $timer += 5
    Write-Host "Waiting for WSL to be ready... ($timer seconds)" -ForegroundColor Yellow
} while ($timer -lt $timeout)

# Create the setup script for inside WSL
$setupScript = @"
#!/bin/bash
set -e

echo "Starting Ubuntu setup..."

# Update system
echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install curl if not present
sudo apt install -y curl

# Install NVM
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Source NVM
export NVM_DIR="`$HOME/.nvm"
[ -s "`$NVM_DIR/nvm.sh" ] && \. "`$NVM_DIR/nvm.sh"

# Install Node.js
echo "Installing Node.js..."
nvm install node
nvm use node

# Install Claude Code
echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Setup complete!"
echo "Node version: `$(node --version)"
echo "NPM version: `$(npm --version)"
echo "Claude Code installed successfully!"
"@

# Write the setup script to a temporary file
$tempScript = "$env:TEMP\wsl_setup.sh"
$setupScript | Out-File -FilePath $tempScript -Encoding UTF8

# Copy script to WSL and execute
Write-Host "Running setup inside WSL..." -ForegroundColor Yellow
wsl --distribution Ubuntu --exec bash -c "cat > /tmp/setup.sh << 'EOF'
$setupScript
EOF"

wsl --distribution Ubuntu --exec chmod +x /tmp/setup.sh
wsl --distribution Ubuntu --exec bash /tmp/setup.sh

Write-Host "Setup completed successfully!" -ForegroundColor Green
Write-Host "You can now access your Ubuntu environment with: wsl" -ForegroundColor Cyan

# Clean up
Remove-Item $tempScript -ErrorAction SilentlyContinue