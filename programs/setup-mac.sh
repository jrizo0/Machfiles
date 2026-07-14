#!/usr/bin/env bash
# setup-mac.sh - Setup completo de un Mac nuevo desde Machfiles
# Usage: ./setup-mac.sh [--skip-brew] [--skip-defaults] [-h]
#
# Idempotente: se puede correr varias veces sin romper nada.
# Orden recomendado en un Mac nuevo:
#   1. Iniciar sesión en App Store (para las apps `mas`)
#   2. git clone https://github.com/jrizo0/Machfiles.git ~/Machfiles
#      (https, no ssh: la SSH key se genera después, dentro del script)
#   3. cd ~/Machfiles && ./programs/setup-mac.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
SKIP_BREW=false
SKIP_DEFAULTS=false

# Stow packages para macOS (los mismos symlinks que existen hoy)
MAC_STOW_PACKAGES=(zsh tmux git gh lazygit brew alacritty karabiner nvim opencode skhd yabai fontconfig scripts)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}::${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}!${NC} $1"; }
error()   { echo -e "${RED}✗${NC} $1"; }

command_exists() { command -v "$1" &>/dev/null; }

backup_if_exists() {
    local target="$1"
    # Solo respaldar archivos/dirs reales, no symlinks ya stoweados
    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        info "Backed up: $target -> $BACKUP_DIR/"
    fi
}

# ══════════════════════════════════════════════════════════
# CHECKS
# ══════════════════════════════════════════════════════════

check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        error "Este script es solo para macOS. Para Ubuntu usa ./setup.sh"
        exit 1
    fi
    success "macOS $(sw_vers -productVersion) detectado"
}

install_xcode_clt() {
    if xcode-select -p &>/dev/null; then
        success "Xcode Command Line Tools (ya instaladas)"
        return
    fi
    info "Instalando Xcode Command Line Tools (aparecerá un diálogo)..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    success "Xcode Command Line Tools instaladas"
}

install_rosetta() {
    # Necesaria para apps Intel en Apple Silicon
    [[ "$(uname -m)" == "arm64" ]] || return 0
    if /usr/bin/pgrep -q oahd; then
        success "Rosetta 2 (ya instalada)"
        return
    fi
    info "Instalando Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license \
        && success "Rosetta 2 instalada" || warn "Rosetta 2 falló"
}

# ══════════════════════════════════════════════════════════
# HOMEBREW
# ══════════════════════════════════════════════════════════

install_homebrew() {
    if command_exists brew; then
        success "Homebrew (ya instalado)"
    else
        info "Instalando Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        success "Homebrew instalado"
    fi
    # Apple Silicon
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

run_brew_bundle() {
    if $SKIP_BREW; then
        warn "brew bundle omitido (--skip-brew)"
        return
    fi

    info "Instalando fnm y mas primero (el Brewfile los necesita durante el bundle)..."
    brew list fnm &>/dev/null || brew install fnm
    brew list mas &>/dev/null || brew install mas
    eval "$(fnm env 2>/dev/null)" || true
    if ! command_exists node; then
        info "Instalando Node LTS via fnm..."
        fnm install --lts && fnm default lts-latest
        eval "$(fnm env)"
    fi

    # `mas account` no funciona en todas las versiones de macOS; es solo informativo
    if ! mas account &>/dev/null; then
        warn "No se pudo verificar la sesión de App Store. Si las líneas 'mas' fallan,"
        warn "inicia sesión en la app App Store y re-corre: brew bundle --file=$DOTFILES_DIR/brew/.Brewfile"
    fi

    info "Ejecutando brew bundle (esto tarda un buen rato)..."
    brew bundle --file="$DOTFILES_DIR/brew/.Brewfile" || warn "brew bundle terminó con errores — revisa arriba"
    success "brew bundle completado"
}

# ══════════════════════════════════════════════════════════
# DOTFILES (STOW)
# ══════════════════════════════════════════════════════════

apply_stow_packages() {
    info "Aplicando dotfiles con stow..."
    cd "$DOTFILES_DIR"

    # Respaldos de configs que macOS/apps crean por defecto
    backup_if_exists "$HOME/.zshrc"
    backup_if_exists "$HOME/.tmux.conf"
    backup_if_exists "$HOME/.config/karabiner"
    backup_if_exists "$HOME/.config/nvim"

    for pkg in "${MAC_STOW_PACKAGES[@]}"; do
        if [[ -d "$pkg" ]]; then
            if stow "$pkg" 2>/dev/null; then
                success "stow: $pkg"
            else
                warn "stow: $pkg (conflicto — resuelve manualmente con: stow -v $pkg)"
            fi
        else
            warn "stow: $pkg (no existe en el repo)"
        fi
    done
}

# ══════════════════════════════════════════════════════════
# SHELL Y HERRAMIENTAS
# ══════════════════════════════════════════════════════════

setup_zsh() {
    if [[ -d "$HOME/.local/share/zap" ]]; then
        success "Zap plugin manager (ya instalado)"
    else
        info "Instalando Zap plugin manager..."
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep \
            && success "Zap instalado" || warn "Zap falló"
    fi
}

setup_tmux_plugins() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        success "TPM (ya instalado)"
    else
        info "Instalando TPM..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir" && success "TPM instalado" || warn "TPM falló"
    fi
}

install_claude_code() {
    if command_exists claude; then
        success "Claude Code (ya instalado)"
        return
    fi
    info "Instalando Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash && success "Claude Code instalado" || warn "Claude Code falló"
}

install_opencode() {
    if command_exists opencode; then
        success "OpenCode (ya instalado)"
        return
    fi
    info "Instalando OpenCode..."
    curl -fsSL https://opencode.ai/install | bash && success "OpenCode instalado" || warn "OpenCode falló"
}

setup_ssh_keys() {
    local ssh_key="$HOME/.ssh/id_ed25519"
    if [[ -f "$ssh_key" ]]; then
        success "SSH key existe: $ssh_key"
        return
    fi
    info "Generando SSH key (ed25519)..."
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    read -rp "Email para la SSH key: " ssh_email
    if [[ -n "$ssh_email" ]]; then
        ssh-keygen -t ed25519 -C "$ssh_email" -f "$ssh_key" -N ""
        eval "$(ssh-agent -s)" &>/dev/null
        ssh-add --apple-use-keychain "$ssh_key" 2>/dev/null || ssh-add "$ssh_key"
        success "SSH key generada. Agrégala a GitHub:"
        cat "${ssh_key}.pub"
    else
        warn "SSH key omitida"
    fi
}

setup_git_config() {
    local name email
    name=$(git config --global user.name 2>/dev/null || echo "")
    email=$(git config --global user.email 2>/dev/null || echo "")
    if [[ -n "$name" && -n "$email" ]]; then
        success "Git configurado: $name <$email>"
        return
    fi
    read -rp "Git user.name [Julian Rizo]: " git_name
    read -rp "Git user.email [64757757+jrizo0@users.noreply.github.com]: " git_email
    git config --global user.name "${git_name:-Julian Rizo}"
    git config --global user.email "${git_email:-64757757+jrizo0@users.noreply.github.com}"
    git config --global init.defaultBranch main
    success "Git configurado"
}

setup_gh_auth() {
    if gh auth status &>/dev/null; then
        success "GitHub CLI (ya autenticado)"
        return
    fi
    info "Autenticando GitHub CLI..."
    gh auth login || warn "gh auth omitido"
}

# ══════════════════════════════════════════════════════════
# SERVICIOS (yabai / skhd)
# ══════════════════════════════════════════════════════════

setup_wm_services() {
    if command_exists yabai; then
        yabai --start-service 2>/dev/null && success "yabai service iniciado" \
            || warn "yabai: inícialo tras dar permisos de Accesibilidad (yabai --start-service)"
    fi
    if command_exists skhd; then
        skhd --start-service 2>/dev/null && success "skhd service iniciado" \
            || warn "skhd: inícialo tras dar permisos de Accesibilidad (skhd --start-service)"
    fi
}

# ══════════════════════════════════════════════════════════
# MACOS DEFAULTS (valores copiados de la máquina anterior)
# ══════════════════════════════════════════════════════════

apply_macos_defaults() {
    if $SKIP_DEFAULTS; then
        warn "defaults omitidos (--skip-defaults)"
        return
    fi
    info "Aplicando macOS defaults..."

    # Teclado: repetición rápida
    defaults write -g KeyRepeat -int 1
    defaults write -g InitialKeyRepeat -int 15

    # Dock
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock tilesize -int 36

    # Finder
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write -g AppleShowAllExtensions -bool true

    # Trackpad: tap to click
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    killall Dock 2>/dev/null || true
    killall Finder 2>/dev/null || true
    success "Defaults aplicados (algunos requieren re-login)"
}

# ══════════════════════════════════════════════════════════
# CHECKLIST MANUAL
# ══════════════════════════════════════════════════════════

print_manual_steps() {
    echo ""
    echo "════════════════════════════════════════════"
    success "Setup completado."
    [[ -d "$BACKUP_DIR" ]] && info "Backups en: $BACKUP_DIR"
    echo ""
    info "Pasos manuales pendientes:"
    cat << 'EOF'
  1. Reinicia la terminal:  exec zsh
  2. tmux: Ctrl+a I para instalar plugins
  3. Permisos de Accesibilidad (Ajustes > Privacidad y seguridad):
     yabai, skhd, Karabiner-Elements, AltTab, Raycast, MiddleClick
     Luego: yabai --start-service && skhd --start-service
  4. Karabiner: abrir la app una vez para activar el driver
  5. Tailscale: abrir app e iniciar sesión
  6. Syncthing: reconectar dispositivos/carpetas
  7. Raycast: importar settings (o iniciar sesión para sync)
  8. DaVinci Resolve: descargar de blackmagicdesign.com
  9. Apps de trabajo (Teams/Edge/Defender): via Company Portal (Intune)
 10. Iniciar sesión: navegadores, Slack, Notion, Linear, Spotify, etc.
 11. Licencias: Screen Studio, superwhisper, PDFelement, TeamViewer
EOF
    echo ""
}

# ══════════════════════════════════════════════════════════
# MAIN
# ══════════════════════════════════════════════════════════

show_help() {
    sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        --skip-brew)     SKIP_BREW=true ;;
        --skip-defaults) SKIP_DEFAULTS=true ;;
        -h|--help)       show_help ;;
        *) error "Opción desconocida: $arg"; exit 1 ;;
    esac
done

echo ""
echo "Machfiles Setup — macOS"
echo "════════════════════════"

check_macos
install_xcode_clt
install_rosetta
install_homebrew
run_brew_bundle
apply_stow_packages
setup_zsh
setup_tmux_plugins
install_claude_code
install_opencode
setup_ssh_keys
setup_git_config
setup_gh_auth
setup_wm_services
apply_macos_defaults
print_manual_steps
