#!/usr/bin/env bash
# setup.sh - Dotfiles setup para Ubuntu 22.04+
# Usage: ./setup.sh --server | --desktop | -h

set -euo pipefail

# ══════════════════════════════════════════════════════════
# VARIABLES Y COLORES
# ══════════════════════════════════════════════════════════

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
MODE=""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Stow packages por modo
SERVER_PACKAGES=(zsh tmux git gh lazygit scripts)
DESKTOP_PACKAGES=(alacritty kitty fontconfig)

# Homebrew packages (CLI tools para ambos modos)
BREW_PACKAGES=(fzf bat eza fd ripgrep zoxide lazygit delta fnm gh neovim stow tmux glow jq htop wget curl tree-sitter-cli)

# APT packages esenciales
APT_PACKAGES=(build-essential curl wget git stow zsh tmux jq htop tree unzip fontconfig)

# ══════════════════════════════════════════════════════════
# FUNCIONES DE UTILIDAD
# ══════════════════════════════════════════════════════════

info() {
    echo -e "${BLUE}::${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}✗${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

command_exists() {
    command -v "$1" &>/dev/null
}

backup_if_exists() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        info "Backed up: $target -> $BACKUP_DIR/"
    fi
}

# ══════════════════════════════════════════════════════════
# FUNCIONES DE VERIFICACION
# ══════════════════════════════════════════════════════════

check_ubuntu() {
    if [[ ! -f /etc/os-release ]]; then
        error "Cannot detect OS. This script requires Ubuntu 22.04+"
        exit 1
    fi

    source /etc/os-release

    if [[ "$ID" != "ubuntu" ]]; then
        error "This script is designed for Ubuntu. Detected: $ID"
        exit 1
    fi

    local version="${VERSION_ID%%.*}"
    if [[ "$version" -lt 22 ]]; then
        error "Ubuntu 22.04+ required. Detected: $VERSION_ID"
        exit 1
    fi

    success "Ubuntu $VERSION_ID detected"
}

check_dotfiles_dir() {
    if [[ ! -d "$DOTFILES_DIR/zsh" ]]; then
        error "Cannot find dotfiles. Run from dotfiles directory."
        exit 1
    fi
    success "Dotfiles directory: $DOTFILES_DIR"
}

# ══════════════════════════════════════════════════════════
# FUNCIONES DE INSTALACION
# ══════════════════════════════════════════════════════════

install_apt_packages() {
    info "Updating apt and installing base packages..."

    sudo apt update -qq

    for pkg in "${APT_PACKAGES[@]}"; do
        if dpkg -s "$pkg" &>/dev/null; then
            success "$pkg (already installed)"
        else
            if sudo apt install -y -qq "$pkg" 2>/dev/null; then
                success "$pkg"
            else
                warn "$pkg (failed to install)"
            fi
        fi
    done
}

install_homebrew() {
    if command_exists brew; then
        success "Homebrew (already installed)"
        return
    fi

    info "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add to current session
    if [[ -d /home/linuxbrew/.linuxbrew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    success "Homebrew installed"
}

install_brew_packages() {
    info "Installing CLI tools via Homebrew..."

    for pkg in "${BREW_PACKAGES[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            success "$pkg (already installed)"
        else
            if brew install "$pkg" 2>/dev/null; then
                success "$pkg"
            else
                warn "$pkg (failed to install)"
            fi
        fi
    done
}

install_fnm() {
    if command_exists fnm; then
        success "fnm (already installed)"
    else
        info "Installing fnm..."
        if brew install fnm 2>/dev/null; then
            success "fnm installed"
        else
            warn "fnm installation failed"
            return
        fi
    fi

    # Install Node LTS
    info "Installing Node.js LTS via fnm..."
    eval "$(fnm env)"
    if fnm install --lts 2>/dev/null; then
        fnm default lts-latest
        success "Node.js LTS installed"
    else
        warn "Node.js LTS installation failed"
    fi
}

install_uv() {
    if command_exists uv; then
        success "uv (already installed)"
        return
    fi

    info "Installing uv (Python manager)..."
    if curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null; then
        success "uv installed"
    else
        warn "uv installation failed"
    fi
}

install_bun() {
    if command_exists bun; then
        success "bun (already installed)"
        return
    fi

    info "Installing bun..."
    if curl -fsSL https://bun.sh/install | bash 2>/dev/null; then
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
        success "bun installed"
    else
        warn "bun installation failed"
    fi
}

install_pnpm() {
    if command_exists pnpm; then
        success "pnpm (already installed)"
        return
    fi

    info "Installing pnpm..."
    if curl -fsSL https://get.pnpm.io/install.sh | sh - 2>/dev/null; then
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
        success "pnpm installed"
    else
        warn "pnpm installation failed"
    fi
}

install_claude_code() {
    if command_exists claude; then
        success "claude code (already installed)"
        return
    fi

    info "Installing Claude Code..."
    if curl -fsSL https://claude.ai/install.sh | bash 2>/dev/null; then
        success "claude code installed"
    else
        warn "claude code installation failed"
    fi
}

install_nerd_fonts() {
    local font_dir="$HOME/.local/share/fonts"
    local font_name="JetBrainsMono"

    if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
        success "JetBrainsMono Nerd Font (already installed)"
        return
    fi

    info "Installing JetBrainsMono Nerd Font..."
    mkdir -p "$font_dir"

    local tmp_dir=$(mktemp -d)
    local release_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip"

    if curl -fsSL "$release_url" -o "$tmp_dir/${font_name}.zip" 2>/dev/null; then
        unzip -q "$tmp_dir/${font_name}.zip" -d "$font_dir/${font_name}NerdFont" 2>/dev/null || true
        fc-cache -f "$font_dir"
        rm -rf "$tmp_dir"
        success "JetBrainsMono Nerd Font installed"
    else
        warn "Font download failed"
        rm -rf "$tmp_dir"
    fi
}

setup_zsh() {
    info "Setting up ZSH..."

    # Install Zap plugin manager
    if [[ -d "$HOME/.local/share/zap" ]]; then
        success "Zap plugin manager (already installed)"
    else
        info "Installing Zap plugin manager..."
        if zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep 2>/dev/null; then
            success "Zap installed"
        else
            warn "Zap installation failed"
        fi
    fi

    # Change default shell
    local current_shell
    current_shell=$(getent passwd "$USER" | cut -d: -f7)

    if [[ "$current_shell" == *"zsh"* ]]; then
        success "ZSH is default shell"
    else
        info "Changing default shell to ZSH..."
        if sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null; then
            success "Default shell changed to ZSH"
        else
            warn "Could not change shell (run: chsh -s \$(which zsh))"
        fi
    fi
}

setup_tmux_plugins() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ -d "$tpm_dir" ]]; then
        success "TPM (already installed)"
        return
    fi

    info "Installing TPM (Tmux Plugin Manager)..."
    if git clone https://github.com/tmux-plugins/tpm "$tpm_dir" 2>/dev/null; then
        success "TPM installed"
    else
        warn "TPM installation failed"
    fi
}

setup_ssh_keys() {
    local ssh_key="$HOME/.ssh/id_ed25519"

    if [[ -f "$ssh_key" ]]; then
        success "SSH key exists: $ssh_key"
        return
    fi

    info "Generating SSH key (ed25519)..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    read -rp "Enter email for SSH key: " ssh_email
    if [[ -n "$ssh_email" ]]; then
        ssh-keygen -t ed25519 -C "$ssh_email" -f "$ssh_key" -N ""
        eval "$(ssh-agent -s)" &>/dev/null
        ssh-add "$ssh_key" 2>/dev/null
        success "SSH key generated"
        info "Public key:"
        cat "${ssh_key}.pub"
        echo ""
    else
        warn "Skipped SSH key generation"
    fi
}

setup_git_config() {
    info "Configuring Git..."

    local current_name current_email
    current_name=$(git config --global user.name 2>/dev/null || echo "")
    current_email=$(git config --global user.email 2>/dev/null || echo "")

    if [[ -n "$current_name" && -n "$current_email" ]]; then
        success "Git configured: $current_name <$current_email>"
        return
    fi

    read -rp "Enter Git user.name: " git_name
    read -rp "Enter Git user.email: " git_email

    if [[ -n "$git_name" ]]; then
        git config --global user.name "$git_name"
    fi
    if [[ -n "$git_email" ]]; then
        git config --global user.email "$git_email"
    fi

    success "Git configured"
}

setup_gh_auth() {
    if gh auth status &>/dev/null; then
        success "GitHub CLI (already authenticated)"
        return
    fi

    info "Authenticating GitHub CLI..."
    echo "Running: gh auth login"
    gh auth login || warn "GitHub CLI authentication skipped"
}

apply_stow_packages() {
    local packages=("$@")

    info "Applying dotfiles with stow..."
    cd "$DOTFILES_DIR"

    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            # Backup existing configs
            case "$pkg" in
                zsh)
                    backup_if_exists "$HOME/.zshrc"
                    backup_if_exists "$HOME/.zshenv"
                    ;;
                tmux)
                    backup_if_exists "$HOME/.tmux.conf"
                    ;;
                git)
                    backup_if_exists "$HOME/.gitconfig"
                    ;;
                alacritty)
                    backup_if_exists "$HOME/.config/alacritty"
                    ;;
                kitty)
                    backup_if_exists "$HOME/.config/kitty"
                    ;;
            esac

            if stow -v "$pkg" 2>/dev/null; then
                success "stow: $pkg"
            else
                warn "stow: $pkg (conflict or error)"
            fi
        else
            warn "stow: $pkg (not found)"
        fi
    done
}

setup_scripts() {
    local scripts_dir="$DOTFILES_DIR/scripts/.local/bin"

    if [[ -d "$scripts_dir" ]]; then
        chmod +x "$scripts_dir"/* 2>/dev/null || true
        success "Scripts made executable"
    fi
}

install_vscode_extensions() {
    if ! command_exists code; then
        warn "VSCode not installed, skipping extensions"
        return
    fi

    info "Installing VSCode extensions..."
    local extensions=(
        "vscodevim.vim"
        "pkief.material-icon-theme"
        "esbenp.prettier-vscode"
        "dbaeumer.vscode-eslint"
        "bradlc.vscode-tailwindcss"
    )

    for ext in "${extensions[@]}"; do
        if code --list-extensions | grep -qi "$ext"; then
            success "$ext (already installed)"
        else
            if code --install-extension "$ext" &>/dev/null; then
                success "$ext"
            else
                warn "$ext (failed)"
            fi
        fi
    done
}

# ══════════════════════════════════════════════════════════
# FUNCIONES PRINCIPALES
# ══════════════════════════════════════════════════════════

setup_server() {
    echo ""
    info "=== Server Mode Setup ==="
    echo ""

    check_ubuntu
    check_dotfiles_dir

    echo ""
    info "--- Installing Packages ---"
    install_apt_packages
    install_homebrew
    install_brew_packages
    install_fnm
    install_uv
    install_bun
    install_pnpm
    install_claude_code

    echo ""
    info "--- Applying Dotfiles ---"
    apply_stow_packages "${SERVER_PACKAGES[@]}"
    setup_scripts

    echo ""
    info "--- Configuring Tools ---"
    setup_zsh
    setup_tmux_plugins
    setup_ssh_keys
    setup_git_config
    setup_gh_auth
}

setup_desktop() {
    echo ""
    info "=== Desktop Mode Setup ==="
    echo ""

    check_ubuntu
    check_dotfiles_dir

    echo ""
    info "--- Installing Packages ---"
    install_apt_packages
    install_homebrew
    install_brew_packages
    install_fnm
    install_uv
    install_bun
    install_pnpm
    install_claude_code

    echo ""
    info "--- Applying Dotfiles ---"
    apply_stow_packages "${SERVER_PACKAGES[@]}" "${DESKTOP_PACKAGES[@]}"
    setup_scripts

    echo ""
    info "--- Configuring Tools ---"
    setup_zsh
    setup_tmux_plugins
    setup_ssh_keys
    setup_git_config
    setup_gh_auth

    echo ""
    info "--- Desktop Extras ---"
    install_nerd_fonts
    install_vscode_extensions
}

# ══════════════════════════════════════════════════════════
# AYUDA Y ARGUMENTOS
# ══════════════════════════════════════════════════════════

show_help() {
    cat << EOF
Dotfiles Setup for Ubuntu 22.04+

Usage: ./setup.sh [OPTION]

Options:
  --server    Install CLI-only setup (no GUI apps or fonts)
              Stow: zsh, tmux, git, gh, lazygit, scripts

  --desktop   Full workstation setup (includes GUI apps)
              Everything from --server plus:
              Stow: alacritty, kitty, fontconfig
              Extras: Nerd Fonts, VSCode extensions

  -h, --help  Show this help message

Examples:
  ./setup.sh --server   # For servers/containers
  ./setup.sh --desktop  # For workstations with GUI

What gets installed (both modes):
  - Homebrew (Linux)
  - CLI tools: fzf, bat, eza, fd, ripgrep, zoxide, lazygit, delta
  - fnm + Node.js LTS
  - uv (Python manager)
  - ZSH + Zap plugin manager
  - TPM (Tmux plugins)
  - SSH key generation (ed25519)
  - Git user configuration
  - GitHub CLI authentication

Backups:
  Existing configs are backed up to ~/.dotfiles-backup-YYYYMMDD-HHMMSS

EOF
}

parse_args() {
    if [[ $# -eq 0 ]]; then
        error "No mode specified. Use --server or --desktop"
        echo ""
        show_help
        exit 1
    fi

    case "$1" in
        --server)
            MODE="server"
            ;;
        --desktop)
            MODE="desktop"
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# ══════════════════════════════════════════════════════════
# MAIN
# ══════════════════════════════════════════════════════════

main() {
    parse_args "$@"

    echo ""
    echo "Dotfiles Setup - Ubuntu"
    echo "========================"

    case "$MODE" in
        server)
            setup_server
            ;;
        desktop)
            setup_desktop
            ;;
    esac

    echo ""
    echo "========================"
    success "Setup complete!"
    echo ""

    if [[ -d "$BACKUP_DIR" ]]; then
        info "Backups saved to: $BACKUP_DIR"
    fi

    echo ""
    info "Next steps:"
    echo "  1. Restart terminal or run: exec zsh"
    echo "  2. Start tmux and press Ctrl+a I to install plugins"
    if [[ "$MODE" == "desktop" ]]; then
        echo "  3. Set terminal font to 'JetBrainsMono Nerd Font'"
    fi
    echo ""
}

main "$@"
