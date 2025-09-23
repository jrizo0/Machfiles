#!/bin/bash

set -e  # Exit on any error

echo "🚀 Minimal Linux Setup Script"
echo "=============================="
echo "This script will set up the essential development environment"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is designed for Linux systems only."
    exit 1
fi

# Ensure we're in the right directory
if [[ ! -f "./programs/packages.list" ]]; then
    print_error "Please run this script from your dotfiles directory"
    print_status "Run: cd ~/.dotfiles && ./programs/setup-minimal.sh"
    exit 1
fi

print_status "Starting minimal Linux setup..."
echo ""

# Step 1: Update system and install essential packages
print_status "Step 1/5: Installing essential packages..."
sudo apt update
sudo apt install -y build-essential curl wget git stow zsh tmux

# Install packages from list
if [[ -f "programs/packages.list" ]]; then
    print_status "Installing packages from packages.list..."
    sudo apt install -y $(grep -v '^#' programs/packages.list | grep -v '^$' | tr '\n' ' ')
    print_success "✓ Packages installed"
else
    print_warning "packages.list not found, skipping package installation"
fi

echo ""

# Step 2: Apply all dotfiles with stow
print_status "Step 2/5: Setting up dotfiles with stow..."
print_status "Applying all configurations with: stow */"
stow */
print_success "✓ All dotfiles linked"

echo ""

# Step 3: Setup ZSH
print_status "Step 3/5: Setting up ZSH..."

# Install Zap ZSH plugin manager
if [[ ! -d "$HOME/.local/share/zap" ]]; then
    print_status "Installing Zap ZSH plugin manager..."
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
    print_success "✓ Zap installed"
else
    print_success "✓ Zap already installed"
fi

# Change default shell to zsh
current_shell=$(echo $SHELL)
if [[ "$current_shell" != *"zsh"* ]]; then
    read -p "Do you want to set ZSH as your default shell? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s $(which zsh)
        print_success "✓ Default shell changed to ZSH (restart terminal to take effect)"
    fi
else
    print_success "✓ ZSH is already your default shell"
fi

echo ""

# Step 4: Setup Tmux plugins
print_status "Step 4/5: Setting up Tmux..."

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    print_status "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_success "✓ TPM installed"
else
    print_success "✓ TPM already installed"
fi

echo ""

# Step 5: Make scripts executable
print_status "Step 5/5: Setting up scripts..."

if [[ -d "scripts/.local/bin" ]]; then
    print_status "Making scripts executable..."
    chmod +x scripts/.local/bin/*
    print_success "✓ Scripts are executable"
else
    print_warning "scripts/.local/bin directory not found"
fi

echo ""

echo "=============================="
print_success "🎉 Minimal setup complete!"
echo "=============================="
echo ""
print_status "What was set up:"
echo "✓ Essential packages (git, stow, zsh, tmux, etc.)"
echo "✓ All dotfiles linked via stow"
echo "✓ ZSH with Zap plugin manager"
echo "✓ Tmux with TPM"
echo "✓ Scripts made executable"
echo ""
print_warning "Important next steps:"
echo "1. Restart your terminal to load new shell and configurations"
echo "2. If you changed your shell to ZSH, log out and back in"
echo "3. Start tmux and press 'Ctrl+a I' to install tmux plugins"
echo "4. Source your shell config: source ~/.zshrc"
echo ""
print_status "Your minimal development environment is ready! 🚀"