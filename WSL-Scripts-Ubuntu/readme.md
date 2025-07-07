# WSL Ubuntu Development Environment Setup

This guide will help you set up WSL Ubuntu with Node.js and Claude Code CLI.

## Prerequisites

- Windows 10 version 2004 or higher, or Windows 11
- Administrator access on your Windows machine

## Method 1: Automated Setup (Recommended)

### Step 1: Install WSL Ubuntu

Open **PowerShell as Administrator** and run:

```powershell
wsl --install Ubuntu
```

- Your computer may restart during this process
- If prompted to restart, do so and continue with Step 2

### Step 2: Complete Ubuntu Setup

1. After installation, Ubuntu will open automatically
2. Create a username (lowercase, no spaces)
3. Create a password (you won't see characters as you type - this is normal)
4. Wait for the setup to complete

### Step 3: Run Automated Development Setup

Copy and paste this command in your Ubuntu terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/dtsoden/webresources/refs/heads/main/WSL-Scripts-Ubuntu/setup.sh | bash
```

**That's it!** The script will automatically:
- Update your system
- Install Node.js via NVM
- Install Claude Code CLI
- Configure your shell

---

## Method 2: Manual Setup

If you prefer to run commands manually or the automated script doesn't work:

### Step 1: Install WSL Ubuntu
```powershell
wsl --install Ubuntu
```

### Step 2: Update Ubuntu
```bash
sudo apt update
sudo apt upgrade -y
```

### Step 3: Install Node.js via NVM
```bash
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Restart your terminal or run:
source ~/.bashrc

# Install Node.js
nvm install node
nvm use node
```

### Step 4: Install Claude Code
```bash
npm install -g @anthropic-ai/claude-code
```

### Step 5: Verify Installation
```bash
node --version
npm --version
claude-code --version
```

---

## Usage

After setup is complete:

1. Open a terminal
2. Type `wsl` to enter your Ubuntu environment
3. Use Claude Code with: `claude-code --help`

## Troubleshooting

### WSL Installation Issues
- **Error: "WSL 2 requires an update to its kernel component"**
  - Download and install: https://aka.ms/wsl2kernel
  - Restart and try again

- **Ubuntu doesn't start after installation**
  - Try: `wsl --set-default-version 2`
  - Then: `wsl --install Ubuntu`

### Node.js/NVM Issues
- **"nvm command not found"**
  - Close and reopen your terminal
  - Or run: `source ~/.bashrc`

- **"npm command not found"**
  - Run: `nvm use node`
  - Add to ~/.bashrc: `nvm use node`

### Claude Code Issues
- **"claude-code command not found"**
  - Verify Node.js is working: `node --version`
  - Reinstall: `npm install -g @anthropic-ai/claude-code`
  - Check PATH: `echo $PATH`

### General Issues
- **Commands fail with permission errors**
  - Use `sudo` for system commands
  - Never use `sudo` with npm global installs after NVM setup

- **Terminal closes unexpectedly**
  - Check Windows Terminal or use default Ubuntu app
  - Try: `wsl --shutdown` then restart Ubuntu

---

## What Gets Installed

- **WSL 2**: Windows Subsystem for Linux
- **Ubuntu**: Latest LTS version
- **NVM**: Node Version Manager
- **Node.js**: Latest stable version
- **NPM**: Node Package Manager
- **Claude Code**: Anthropic's CLI tool

## Next Steps

After setup, you can:
- Access files: Your Windows C: drive is at `/mnt/c/`
- Install additional tools: `sudo apt install <package>`
- Use VS Code: Install "WSL" extension for seamless development

---

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Restart your terminal/computer
3. Try the manual setup method
4. Search for your specific error message

## File Locations

- Ubuntu files: `\\wsl$\Ubuntu\home\<username>\`
- Windows files from Ubuntu: `/mnt/c/Users/<username>/`
