#!/bin/bash

set -e  # Exit on any error

echo "🚀 Installing packages equivalent to your Brewfile on Linux..."
echo "=================================================="

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

# Update package lists
print_status "Updating package lists..."
sudo apt update

# Install essential build tools first
print_status "Installing essential build tools..."
sudo apt install -y build-essential curl wget git unzip

# Install direct apt equivalents
print_status "Installing apt packages..."
sudo apt install -y \
    git \
    gh \
    stow \
    tmux \
    zsh \
    curl \
    wget \
    fd-find \
    ripgrep \
    bat \
    htop \
    jq \
    glow \
    neovim \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    erlang \
    elixir \
    luarocks \
    telnet \
    gcc \
    ffmpeg \
    tesseract-ocr \
    mysql-client \
    postgresql-client \
    xclip \
    sqlite3 \
    tree \
    2>/dev/null || print_warning "Some apt packages may not be available"

# Create symlinks for renamed packages
print_status "Creating symlinks for renamed packages..."
sudo mkdir -p /usr/local/bin
# fd-find -> fd symlink
if command -v fdfind >/dev/null 2>&1; then
    sudo ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true
    print_success "Created fd symlink"
fi

# batcat -> bat symlink (if bat isn't already available)
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    sudo ln -sf $(which batcat) /usr/local/bin/bat 2>/dev/null || true
    print_success "Created bat symlink"
fi

# Install Alacritty via PPA (more up-to-date than apt)
print_status "Installing Alacritty..."
if ! command -v alacritty >/dev/null 2>&1; then
    sudo add-apt-repository ppa:aslatter/ppa -y >/dev/null 2>&1
    sudo apt update >/dev/null 2>&1
    sudo apt install -y alacritty
    print_success "Alacritty installed"
else
    print_success "Alacritty already installed"
fi

# Install via direct downloads/official repos
print_status "Installing tools from official sources..."

# fnm (Node.js manager)
if ! command -v fnm >/dev/null 2>&1; then
    print_status "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash
    print_success "fnm installed"
else
    print_success "fnm already installed"
fi

# uv (Python package manager)
if ! command -v uv >/dev/null 2>&1; then
    print_status "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    print_success "uv installed"
else
    print_success "uv already installed"
fi

# lazygit
if ! command -v lazygit >/dev/null 2>&1; then
    print_status "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin
    rm /tmp/lazygit /tmp/lazygit.tar.gz
    print_success "lazygit installed"
else
    print_success "lazygit already installed"
fi

# zoxide
if ! command -v zoxide >/dev/null 2>&1; then
    print_status "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    print_success "zoxide installed"
else
    print_success "zoxide already installed"
fi

# zellij
if ! command -v zellij >/dev/null 2>&1; then
    print_status "Installing zellij..."
    curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C /tmp
    sudo mv /tmp/zellij /usr/local/bin/
    print_success "zellij installed"
else
    print_success "zellij already installed"
fi

# fzf
if ! command -v fzf >/dev/null 2>&1; then
    print_status "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    print_success "fzf installed"
else
    print_success "fzf already installed"
fi

# tldr
if ! command -v tldr >/dev/null 2>&1; then
    print_status "Installing tldr..."
    pip3 install --user tldr
    print_success "tldr installed"
else
    print_success "tldr already installed"
fi

# Azure CLI
if ! command -v az >/dev/null 2>&1; then
    print_status "Installing Azure CLI..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    print_success "Azure CLI installed"
else
    print_success "Azure CLI already installed"
fi

# Terraform
if ! command -v terraform >/dev/null 2>&1; then
    print_status "Installing Terraform..."
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y terraform
    print_success "Terraform installed"
else
    print_success "Terraform already installed"
fi

# Pulumi
if ! command -v pulumi >/dev/null 2>&1; then
    print_status "Installing Pulumi..."
    curl -fsSL https://get.pulumi.com | sh
    print_success "Pulumi installed"
else
    print_success "Pulumi already installed"
fi

# Stripe CLI
if ! command -v stripe >/dev/null 2>&1; then
    print_status "Installing Stripe CLI..."
    curl -s https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public | gpg --dearmor | sudo tee /usr/share/keyrings/stripe.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/stripe.gpg] https://packages.stripe.dev/stripe-cli-debian-local stable main" | sudo tee /etc/apt/sources.list.d/stripe.list
    sudo apt update && sudo apt install -y stripe
    print_success "Stripe CLI installed"
else
    print_success "Stripe CLI already installed"
fi

# Turso CLI
if ! command -v turso >/dev/null 2>&1; then
    print_status "Installing Turso CLI..."
    curl -sSfL https://get.tur.so/install.sh | bash
    print_success "Turso CLI installed"
else
    print_success "Turso CLI already installed"
fi

# Fly.io CLI
if ! command -v flyctl >/dev/null 2>&1; then
    print_status "Installing Fly.io CLI..."
    curl -L https://fly.io/install.sh | sh
    print_success "Fly.io CLI installed"
else
    print_success "Fly.io CLI already installed"
fi

# EdgeDB CLI
if ! command -v edgedb >/dev/null 2>&1; then
    print_status "Installing EdgeDB CLI..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.edgedb.com | sh -s -- --no-modify-path
    print_success "EdgeDB CLI installed"
else
    print_success "EdgeDB CLI already installed"
fi

# Install Nerd Fonts (equivalent to your cask fonts)
print_status "Installing Nerd Fonts..."
FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# Function to install font if not exists
install_font() {
    local font_name="$1"
    local download_url="$2"
    
    if ! fc-list | grep -qi "$font_name"; then
        print_status "Installing $font_name..."
        cd /tmp
        wget -q "$download_url" -O "${font_name}.zip"
        unzip -o "${font_name}.zip" -d "$FONTS_DIR/" >/dev/null 2>&1
        rm "${font_name}.zip"
        print_success "$font_name installed"
    else
        print_success "$font_name already installed"
    fi
}

# Install fonts
install_font "JetBrainsMono" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
install_font "Hack" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip"
install_font "CascadiaCode" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip"

# Refresh font cache
print_status "Refreshing font cache..."
fc-cache -fv >/dev/null 2>&1
print_success "Font cache refreshed"

# Install additional useful tools not in your Brewfile but commonly needed on Linux
print_status "Installing additional Linux-specific tools..."
sudo apt install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    2>/dev/null || print_warning "Some additional packages may not be available"

print_success "Additional tools installed"

echo ""
echo "=================================================="
print_success "Installation complete!"
echo "=================================================="
echo ""
print_warning "Important notes:"
echo "• Some tools installed to ~/.cargo/bin, ~/.local/bin, or ~/go/bin"
echo "• Make sure these are in your PATH by adding to ~/.bashrc or ~/.zshrc:"
echo '  export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"'
echo ""
echo "• To install Node.js via fnm, run:"
echo "  fnm install --lts && fnm use lts-latest"
echo ""
echo "• Restart your shell or run: source ~/.bashrc"
echo ""
print_status "Next steps:"
echo "• Run: cd ~/.machfiles && stow */"
echo "• Install VSCode extensions: ./programs/install-vscode-extensions.sh"
echo "• Configure your shell: chsh -s \$(which zsh)"