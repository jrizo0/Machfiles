# Brewfile — macOS
# Regenerar referencia:  brew bundle dump --file=/tmp/Brewfile.dump --force
# Instalar todo:         brew bundle --file=~/.Brewfile
# Auditar sobrantes:     brew bundle cleanup --file=~/.Brewfile

# ══════════════════════════════════════════════════════════
# TAPS
# ══════════════════════════════════════════════════════════
tap "koekeishiya/formulae"                                               # skhd, yabai
tap "anomalyco/tap", "https://github.com/anomalyco/homebrew-tap.git"     # mole
tap "asmvik/formulae", "https://github.com/asmvik/homebrew-formulae.git" # sheets
tap "ngrok/ngrok"

# ══════════════════════════════════════════════════════════
# CLI — core
# ══════════════════════════════════════════════════════════
brew "bat"
brew "btop"
brew "fd"
brew "fzf"
brew "gh"
brew "git"
brew "glow"
brew "gnu-sed"
brew "htop"
brew "jq"
brew "lazygit"
brew "diff-so-fancy"
brew "neovim"
brew "onefetch"
brew "ripgrep"
brew "stow"
brew "tldr"
brew "tmux"
brew "wget"
brew "xclip"
brew "zellij"
brew "zoxide"
brew "mas"        # Mac App Store CLI (requiere sesión iniciada en App Store)

# ══════════════════════════════════════════════════════════
# CLI — dev / runtimes
# ══════════════════════════════════════════════════════════
brew "fnm"        # node manager activo (zsh/exports.zsh)
brew "nvm"        # lazy-load en .zshrc, solo compatibilidad
brew "uv"
brew "python@3.11"
brew "python@3.14"
brew "elixir"
brew "luarocks"
brew "cocoapods"
brew "cloc"
brew "mkcert"
brew "socat"
brew "telnet"
brew "poppler"
brew "ffmpeg"
brew "scipy"
brew "py3cairo", link: false

# ══════════════════════════════════════════════════════════
# CLI — infra / servicios
# ══════════════════════════════════════════════════════════
brew "azure-cli"
brew "flyctl"
brew "googleworkspace-cli"
brew "mysql-client"
brew "pgbouncer"
brew "tailscale", link: false   # daemon CLI; la GUI va como cask abajo
brew "mole"
brew "sheets"
brew "pkgconf"

# ══════════════════════════════════════════════════════════
# Window management (requieren permisos de Accesibilidad)
# ══════════════════════════════════════════════════════════
brew "koekeishiya/formulae/skhd"
brew "koekeishiya/formulae/yabai"

# ══════════════════════════════════════════════════════════
# CASKS — fuentes
# ══════════════════════════════════════════════════════════
cask "font-caskaydia-cove-nerd-font"
cask "font-hack-nerd-font"
cask "font-jetbrains-mono-nerd-font"

# ══════════════════════════════════════════════════════════
# CASKS — terminal y utilidades de sistema
# ══════════════════════════════════════════════════════════
cask "alacritty"
cask "iterm2"
cask "alt-tab"
cask "raycast"
cask "karabiner-elements"
cask "middleclick"
cask "unnaturalscrollwheels"
cask "keyboardcleantool"
cask "blackhole-2ch"
cask "tailscale-app"
cask "teamviewer"

# ══════════════════════════════════════════════════════════
# CASKS — desarrollo
# ══════════════════════════════════════════════════════════
cask "cursor"
cask "github"            # GitHub Desktop
cask "t3-code"
cask "postman"
cask "tableplus"
cask "postico"
cask "postgres-unofficial"  # Postgres.app
cask "figma"
cask "ngrok"

# ══════════════════════════════════════════════════════════
# CASKS — navegadores
# ══════════════════════════════════════════════════════════
cask "google-chrome"
cask "firefox"

# ══════════════════════════════════════════════════════════
# CASKS — productividad y comunicación
# ══════════════════════════════════════════════════════════
cask "notion-calendar"
cask "obsidian"
cask "slack"
cask "telegram"
cask "legcord"           # cliente Discord
cask "zoom"
cask "chatgpt"
cask "spotify"

# ══════════════════════════════════════════════════════════
# CASKS — audio / video / dictado / archivos
# ══════════════════════════════════════════════════════════
cask "capcut"
cask "wispr-flow"
cask "pdfelement"
cask "powerphotos"

# ══════════════════════════════════════════════════════════
# MAS — App Store (requiere iniciar sesión antes)
# ══════════════════════════════════════════════════════════
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Xcode", id: 497799835
mas "WhatsApp", id: 310633997
mas "Harvest", id: 506189836
mas "KeyBell", id: 1530838633
mas "Microsoft Word", id: 462054704
mas "Microsoft Excel", id: 462058435
mas "Microsoft Outlook", id: 985367838
mas "Windows App", id: 1295203466   # antes Microsoft Remote Desktop
mas "UPDF", id: 1619925971
mas "Developer", id: 640199958
mas "HP Smart", id: 1474276998

# ══════════════════════════════════════════════════════════
# NPM globales (usa el node default de fnm)
# ══════════════════════════════════════════════════════════
npm "@fission-ai/openspec"
npm "@openai/codex"
npm "agent-browser"
npm "corepack"
npm "hrvst-cli"
npm "mcp-chrome-bridge"
npm "ralphy"
npm "ralphy-cli"

# ══════════════════════════════════════════════════════════
# UV tools
# ══════════════════════════════════════════════════════════
uv "claude-monitor"
uv "mcp-server-git"

# ══════════════════════════════════════════════════════════
# LEGACY / OPCIONAL — estaban en el Brewfile viejo pero ya no
# están instalados en esta máquina. Descomentar si hacen falta.
# ══════════════════════════════════════════════════════════
# tap "azure/functions"
# tap "hashicorp/tap"
# tap "pulumi/tap"
# tap "stripe/stripe-cli"
# tap "tursodatabase/tap"
# tap "gromgit/fuse"
# brew "azure/functions/azure-functions-core-tools@4"
# brew "hashicorp/tap/terraform"
# brew "pulumi/tap/pulumi"
# brew "stripe/stripe-cli/stripe"
# brew "tursodatabase/tap/turso"
# brew "gromgit/fuse/sshfs-mac"

# NO automatizables (instalar manualmente):
#   - DaVinci Resolve (blackmagicdesign.com — el cask fue retirado)
#   - Microsoft Teams / Edge / Defender / Company Portal (gestionados por Intune)
#   - Claude Code / OpenCode (instaladores curl — los cubre setup-mac.sh)
