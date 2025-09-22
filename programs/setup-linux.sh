#!/bin/bash

set -e  # Exit on any error

echo "🚀 Complete Linux Setup Script"
echo "=============================="
echo "This script will set up your complete development environment on Linux"
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
if [[ ! -f "./programs/install-from-brewfile.sh" ]]; then
    print_error "Please run this script from your ~/.machfiles directory"
    print_status "Run: cd ~/.machfiles && ./programs/setup-linux.sh"
    exit 1
fi

print_status "Starting complete Linux setup..."
echo ""

# Step 1: Install core packages
print_status "Step 1/6: Installing core packages from Brewfile equivalents..."
./programs/install-from-brewfile.sh

echo ""
print_success "✓ Core packages installed"
echo ""

# Step 2: Setup dotfiles with stow
print_status "Step 2/6: Setting up dotfiles with stow..."

if command -v stow >/dev/null 2>&1; then
    # Ask user what they want to stow
    echo "Available configurations:"
    ls -d */ | grep -v programs | sed 's|/||g' | while read dir; do
        echo "  - $dir"
    done
    echo ""
    
    read -p "Do you want to stow all configurations? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Stowing all configurations..."
        stow */
        print_success "✓ All dotfiles linked"
    else
        print_status "You can manually stow configurations later with:"
        echo "  cd ~/.machfiles"
        echo "  stow zsh tmux alacritty  # Example"
    fi
else
    print_warning "GNU stow not found. Install it first, then run:"
    echo "  cd ~/.machfiles && stow */"
fi

echo ""

# Step 3: Setup ZSH
print_status "Step 3/6: Setting up ZSH..."

if command -v zsh >/dev/null 2>&1; then
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
else
    print_error "ZSH not installed. This should have been installed in step 1."
fi

echo ""

# Step 4: Setup Node.js environment
print_status "Step 4/6: Setting up Node.js environment..."

if command -v fnm >/dev/null 2>&1; then
    # Source fnm for current session
    eval "$(fnm env --use-on-cd)"
    
    print_status "Installing latest LTS Node.js..."
    fnm install --lts
    fnm use lts-latest
    print_success "✓ Node.js $(node --version) installed"
else
    print_warning "fnm not found. Install Node.js manually later."
fi

echo ""

# Step 5: Setup Python environment
print_status "Step 5/6: Setting up Python environment..."

if command -v uv >/dev/null 2>&1; then
    print_status "Installing Python 3.12 via uv..."
    uv python install 3.12
    print_success "✓ Python environment ready"
else
    print_warning "uv not found. Python 3 should be available via apt."
fi

echo ""

# Step 6: Install VSCode extensions
print_status "Step 6/6: Installing VSCode extensions..."

if command -v code >/dev/null 2>&1; then
    read -p "Do you want to install VSCode extensions from your Brewfile? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./programs/install-vscode-extensions.sh
    else
        print_status "You can install VSCode extensions later with:"
        echo "  ./programs/install-vscode-extensions.sh"
    fi
else
    print_warning "VSCode not installed. Install it first:"
    echo "  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg"
    echo "  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/"
    echo "  sudo sh -c 'echo \"deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main\" > /etc/apt/sources.list.d/vscode.list'"
    echo "  sudo apt update && sudo apt install code"
fi

echo ""
echo "=============================="
print_success "🎉 Linux setup complete!"
echo "=============================="
echo ""
print_status "What was installed:"
echo "✓ All packages from your Brewfile (Linux equivalents)"
echo "✓ Nerd Fonts (JetBrains Mono, Hack, CascadiaCode)"
echo "✓ Development tools (git, gh, tmux, neovim, etc.)"
echo "✓ Language runtimes (Python, Node.js, Elixir, etc.)"
echo "✓ Cloud tools (Azure CLI, Terraform, Pulumi, etc.)"
echo "✓ ZSH with Zap plugin manager"
echo "✓ VSCode extensions (if selected)"
echo ""
print_warning "Important next steps:"
echo "1. Restart your terminal to load new shell and PATH changes"
echo "2. If you changed your shell to ZSH, log out and back in"
echo "3. Verify installations with: tmux -V, nvim --version, node --version"
echo ""
print_status "Your dotfiles are ready! Happy coding! 🚀"