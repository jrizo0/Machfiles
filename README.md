# Machfiles

Personal dotfiles and development environment setup for macOS and Linux.

## Quick Start

```bash
# VPS/Server (Ubuntu 22.04+)
git clone https://github.com/jrizo0/Machfiles ~/.machfiles && cd ~/.machfiles && ./programs/setup.sh --server

# Linux Desktop (Ubuntu 22.04+)
git clone https://github.com/jrizo0/Machfiles ~/.machfiles && cd ~/.machfiles && ./programs/setup.sh --desktop

# macOS
git clone https://github.com/jrizo0/Machfiles ~/.machfiles && cd ~/.machfiles && brew bundle --file=brew/.Brewfile && stow zsh tmux git gh lazygit scripts
```

## What's Included

### Stow Packages

| Package | Description | Server | Desktop | macOS |
|---------|-------------|:------:|:-------:|:-----:|
| zsh | Shell config + Zap plugins | ✓ | ✓ | ✓ |
| tmux | Terminal multiplexer config | ✓ | ✓ | ✓ |
| git | Global gitignore | ✓ | ✓ | ✓ |
| gh | GitHub CLI config | ✓ | ✓ | ✓ |
| lazygit | Git UI theming | ✓ | ✓ | ✓ |
| scripts | Utility scripts | ✓ | ✓ | ✓ |
| alacritty | GPU terminal config | - | ✓ | ✓ |
| kitty | Cross-platform terminal | - | ✓ | ✓ |
| fontconfig | Font aliases (Linux) | - | ✓ | - |
| yabai | macOS window manager | - | - | ✓ |
| skhd | macOS hotkeys | - | - | ✓ |
| karabiner | macOS keyboard remap | - | - | ✓ |
| i3 | Linux window manager | - | ✓ | - |
| polybar | Linux status bar | - | ✓ | - |
| picom | Linux compositor | - | ✓ | - |
| dunst | Linux notifications | - | ✓ | - |

### CLI Tools (via Homebrew)

- **Search/Navigation:** fzf, fd, ripgrep, zoxide
- **File Viewing:** bat, eza, glow, jq
- **Git:** lazygit, delta, gh
- **Editors:** neovim
- **Dev Tools:** fnm (Node.js), uv (Python), stow
- **System:** tmux, htop, wget, curl

---

## Setup Guides

### VPS / Server Setup

For headless Ubuntu 22.04+ servers.

#### Prerequisites

- Ubuntu 22.04 or later
- `sudo` access
- Internet connection

#### One-Command Setup

```bash
git clone https://github.com/jrizo0/Machfiles ~/.machfiles && cd ~/.machfiles && ./programs/setup.sh --server
```

#### What Gets Installed

- **APT packages:** build-essential, curl, wget, git, stow, zsh, tmux, jq, htop, tree, unzip, fontconfig
- **Homebrew** (Linux)
- **CLI tools:** fzf, bat, eza, fd, ripgrep, zoxide, lazygit, delta, fnm, gh, neovim, glow
- **fnm** + Node.js LTS
- **uv** (Python package manager)
- **Zap** (ZSH plugin manager)
- **TPM** (Tmux Plugin Manager)

#### Stow Packages Applied

`zsh`, `tmux`, `git`, `gh`, `lazygit`, `scripts`

#### Post-Install Steps

1. Restart terminal or run: `exec zsh`
2. Start tmux and press `Ctrl+a I` to install plugins
3. Configure Git credentials if prompted during setup

---

### Linux Desktop Setup

For Ubuntu 22.04+ workstations with GUI.

#### Prerequisites

- Ubuntu 22.04 or later with desktop environment
- `sudo` access
- Internet connection

#### One-Command Setup

```bash
git clone https://github.com/jrizo0/Machfiles ~/.machfiles && cd ~/.machfiles && ./programs/setup.sh --desktop
```

#### What Gets Installed

Everything from server setup, plus:

- **JetBrainsMono Nerd Font**
- **VSCode extensions** (if VSCode is installed)
- **Terminal configs:** alacritty, kitty
- **Font configuration**

#### Stow Packages Applied

`zsh`, `tmux`, `git`, `gh`, `lazygit`, `scripts`, `alacritty`, `kitty`, `fontconfig`

#### Post-Install Steps

1. Restart terminal or run: `exec zsh`
2. Start tmux and press `Ctrl+a I` to install plugins
3. Set terminal font to "JetBrainsMono Nerd Font"
4. Optionally stow i3 window manager configs: `stow i3 polybar picom dunst`

---

### macOS Setup

For macOS workstations with Homebrew.

#### Prerequisites

- macOS with Homebrew installed
- If Homebrew is not installed:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

#### Setup Steps

```bash
# Clone dotfiles
git clone https://github.com/jrizo0/Machfiles ~/.machfiles
cd ~/.machfiles

# Install packages from Brewfile
brew bundle --file=brew/.Brewfile

# Apply dotfiles
stow zsh tmux git gh lazygit scripts alacritty kitty yabai skhd karabiner
```

#### What Gets Installed

- All CLI tools from the Brewfile
- GUI apps: Alacritty, Raycast, Alt-Tab, etc.
- Nerd Fonts: JetBrains Mono, Hack, CaskaydiaCove
- Window management: yabai + skhd
- VSCode extensions

#### Post-Install Steps

1. Restart terminal or run: `exec zsh`
2. Start tmux and press `Ctrl+a I` to install plugins
3. Install Zap plugin manager:
   ```bash
   zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
   ```
4. Start yabai and skhd services:
   ```bash
   yabai --start-service
   skhd --start-service
   ```
5. Grant accessibility permissions for yabai and skhd in System Settings

---

### Connecting to a Remote Server

Steps for setting up SSH access to a new server.

#### 1. Generate SSH Key (if not exists)

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

#### 2. Copy SSH Key to Server

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@remote
```

#### 3. Test Connection

```bash
ssh user@remote
```

#### 4. Create Non-Root User (if needed)

```bash
# On the server as root
sudo adduser username
sudo usermod -aG sudo username

# Switch to new user
su - username
```

#### 5. Port Tunneling

```bash
# Forward remote port to local (access remote:3000 at localhost:3001)
ssh -N -L 3001:localhost:3000 user@remote

# Reverse tunnel (expose local:3001 on remote:3000)
ssh -N -R 3000:localhost:3001 user@remote

# Run in background with -f
ssh -f -N -L 3000:localhost:3000 user@remote
```

**Access remote dev server via local domain (e.g., HTTPS):**

If your dev server uses a local domain like `https://local.example.com:3000`:

1. Run the dev server on the VPS (port 3000)
2. Tunnel the port: `ssh -N -L 3000:localhost:3000 user@remote`
3. Ensure `/etc/hosts` on your Mac has: `127.0.0.1 local.example.com`
4. Access `https://local.example.com:3000` locally

---

### Git SSH Authentication

Set up SSH keys for GitHub/GitLab to avoid entering passwords.

#### 1. Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

#### 2. Start SSH Agent and Add Key

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### 3. Copy Public Key

```bash
# macOS
pbcopy < ~/.ssh/id_ed25519.pub

# Linux
cat ~/.ssh/id_ed25519.pub
# Then copy the output manually
```

#### 4. Add Key to GitHub/GitLab

- **GitHub:** Settings > SSH and GPG keys > New SSH key
- **GitLab:** Preferences > SSH Keys > Add new key

Paste the public key and save.

#### 5. Test Connection

```bash
ssh -T git@github.com
# Should see: "Hi username! You've successfully authenticated..."

ssh -T git@gitlab.com
# Should see: "Welcome to GitLab, @username!"
```

#### 6. Use SSH URLs for Repos

```bash
# Clone with SSH
git clone git@github.com:user/repo.git

# Change existing repo from HTTPS to SSH
git remote set-url origin git@github.com:user/repo.git
```

---

## Configuration Details

### ZSH

- Plugin manager: [Zap](https://github.com/zap-zsh/zap)
- Plugins loaded via `.zshrc`
- Custom aliases and functions
- PATH includes `~/.local/bin` for scripts

### Tmux

- Prefix: `Ctrl+a`
- Plugin manager: TPM (auto-installed)
- Theme: Catppuccin
- Plugins: tmux-resurrect

### Git & GitHub CLI

- Global gitignore for common files
- Delta for better diffs
- GitHub CLI (`gh`) configuration

### Terminal Emulators

- **Alacritty:** GPU-accelerated terminal
- **Kitty:** Cross-platform terminal with graphics support

### Window Managers

#### yabai/skhd (macOS)

- Binary space partitioning layout
- Mouse follows focus
- Apps excluded: System Settings, Calculator, Discord, etc.

#### i3 (Linux)

- Mod key: `Alt`
- Status bar: i3status
- Compositor: picom
- Notifications: dunst

---

## Utility Scripts

Located in `scripts/.local/bin/`:

| Script | Description |
|--------|-------------|
| `tmux-sessionizer` | Fuzzy find and switch to project directories as tmux sessions |
| `tmux-windowizer` | Create new tmux window from selected directory |
| `getnf` | Interactive Nerd Fonts installer |
| `git-clone-bare-for-worktrees` | Clone repo as bare for git worktree workflow |

---

## Key Bindings Reference

### Tmux (prefix: `Ctrl+a`)

| Binding | Action |
|---------|--------|
| `prefix + h/j/k/l` | Navigate panes |
| `prefix + f` | tmux-sessionizer (fuzzy project switcher) |
| `prefix + g` | tmux-windowizer |
| `prefix + I` | Install TPM plugins |
| `prefix + c` | New window (current path) |
| `prefix + "` | Split horizontal (current path) |
| `prefix + %` | Split vertical (current path) |
| `prefix + r` | Reload config |

### Yabai/skhd (macOS)

| Binding | Action |
|---------|--------|
| `alt + h/j/k/l` | Focus window left/down/up/right |
| `shift + alt + h/j/k/l` | Swap window |
| `ctrl + alt + h/j/k/l` | Warp window (move and split) |
| `alt + f` | Toggle fullscreen |
| `shift + alt + space` | Toggle float |
| `shift + alt + 1-9` | Move window to space |
| `ctrl + alt + r` | Restart yabai |

### i3 (Linux, mod: `Alt`)

| Binding | Action |
|---------|--------|
| `mod + h/j/k/l` | Focus window |
| `mod + shift + h/j/k/l` | Move window |
| `mod + f` | Toggle fullscreen |
| `mod + shift + space` | Toggle float |
| `mod + 1-9` | Switch workspace |
| `mod + shift + 1-9` | Move to workspace |
| `mod + Return` | Open Alacritty |
| `mod + d` | dmenu launcher |
| `mod + shift + q` | Kill window |
| `mod + r` | Resize mode |

---

## Troubleshooting

### Stow Conflicts

If stow reports conflicts with existing files:

```bash
# Dry run to see what would happen
stow -n -v zsh

# Backup and remove conflicting files, then retry
mv ~/.zshrc ~/.zshrc.bak
stow zsh
```

### Shell Not Changing

After running `chsh -s $(which zsh)`, log out and back in for the change to take effect.

### Missing Fonts

Refresh font cache after installing fonts:

```bash
fc-cache -fv
```

### TPM Plugins Not Installing

Inside tmux, press `Ctrl+a I` (capital I) to install plugins. If TPM isn't installed:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Homebrew PATH Issues

For Linux, ensure Homebrew is in your PATH:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### yabai/skhd Not Working (macOS)

1. Grant accessibility permissions in System Settings > Privacy & Security > Accessibility
2. Restart services:
   ```bash
   yabai --restart-service
   skhd --restart-service
   ```

---

## License

MIT
