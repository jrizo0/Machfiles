# Machfiles

Personal dotfiles and development environment setup for macOS and Linux.

## Installing

You will need `git` and GNU `stow`

Clone into your `$HOME` directory or `~`

```bash
git clone https://github.com/jrizo0/Machfiles ~/.machfiles
```

Run `stow` to symlink everything or just select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # Just my zsh config
```

## Linux Machine Initialization

For setting up a fresh Linux machine with your dotfiles and development environment.

### Prerequisites

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl wget git build-essential
```

### Option 1: Using Homebrew (Recommended for consistency)

Install Homebrew on Linux for package management consistency with macOS:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (follow the instructions shown after installation)
echo >> ~/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Clone your dotfiles
git clone https://github.com/jrizo0/Machfiles ~/.machfiles

# Install your packages from Brewfile
cd ~/.machfiles/brew
brew bundle install
```

### Option 2: Native Linux Package Installation (Automated)

Use the automated script that maps your Brewfile packages to Linux equivalents:

```bash
# Clone your dotfiles
git clone https://github.com/jrizo0/Machfiles ~/.machfiles
cd ~/.machfiles

# One-command complete setup (recommended)
./programs/setup-linux.sh

# Or run individual scripts
chmod +x programs/install-from-brewfile.sh
chmod +x programs/install-vscode-extensions.sh

# Install all programs from your Brewfile
./programs/install-from-brewfile.sh

# Install VSCode extensions (if you use VSCode)  
./programs/install-vscode-extensions.sh
```

### Essential Setup Steps

1. **Install GNU Stow** (if not installed via Brew/apt):
   ```bash
   # Via apt (Ubuntu/Debian)
   sudo apt install -y stow
   
   # Via Homebrew
   brew install stow
   ```

2. **Setup dotfiles**:
   ```bash
   cd ~/.machfiles
   
   # Link all configurations
   stow */
   
   # Or selectively link what you need
   stow zsh tmux alacritty kitty
   ```

3. **Set ZSH as default shell**:
   ```bash
   chsh -s $(which zsh)
   ```

4. **Install ZSH plugin manager (Zap)**:
   ```bash
   zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
   ```

### Post-Installation

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

2. **Verify installations**:
   ```bash
   # Check key tools
   tmux -V
   nvim --version
   git --version
   lazygit --version
   ```

3. **Setup development environments** as needed:
   ```bash
   # Node.js via fnm
   fnm install --lts
   fnm use lts-latest
   
   # Python via uv
   uv python install 3.12
   ```

4. **Install VSCode** (if not done automatically):
   ```bash
   wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
   sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
   sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
   sudo apt update && sudo apt install code
   ```

### Programs Installation Details

The `install-from-brewfile.sh` script automatically maps your Homebrew packages to their Linux equivalents:

| Brewfile Package | Linux Equivalent | Installation Method |
|------------------|------------------|-------------------|
| `git, gh, stow, tmux, zsh` | Same names | `apt install` |
| `fd` | `fd-find` + symlink | `apt install fd-find` |
| `bat` | `batcat` + symlink | `apt install bat` |
| `lazygit` | Direct download | GitHub releases |
| `zoxide` | Install script | Official installer |
| `fnm` | Install script | Official installer |
| `azure-cli` | Official repo | Microsoft installer |
| `terraform` | Official repo | HashiCorp repo |
| Nerd Fonts | Direct download | GitHub releases |

### Notes

- **Homebrew on Linux** provides excellent package management and keeps your setup consistent across macOS and Linux
- **Native package installation** offers better system integration and performance
- The automated scripts handle font installation, symlink creation, and PATH management
- All VSCode extensions from your Brewfile are automatically installed
- Some GUI applications may need additional setup depending on your desktop environment

### Troubleshooting

If you encounter issues:

1. **Missing packages**: Some packages might not be available in older Ubuntu versions
2. **Permission errors**: Ensure your user has sudo privileges
3. **PATH issues**: Restart your shell or manually source your profile
4. **Font issues**: Run `fc-cache -fv` to refresh font cache

This approach gives you flexibility to use either Homebrew (for consistency) or native package managers (for performance/system integration), while maintaining the same dotfile structure across all your machines.
