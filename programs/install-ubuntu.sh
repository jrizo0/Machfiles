#!/bin/bash

echo "Installing Ubuntu packages based on your macOS Brew setup..."

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install packages from list
echo "Installing packages from packages.list..."
while read package; do
    # Skip comments and empty lines
    [[ "$package" =~ ^#.*$ ]] && continue
    [[ -z "$package" ]] && continue
    
    echo "Installing: $package"
    sudo apt install -y "$package"
done < packages.list

echo "Installing additional tools not available in apt..."

# fnm (Fast Node Manager)
echo "Installing fnm..."
curl -fsSL https://fnm.vercel.app/install | bash

# Stripe CLI
echo "Installing Stripe CLI..."
curl -s https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public | gpg --dearmor | sudo tee /usr/share/keyrings/stripe.gpg
echo "deb [signed-by=/usr/share/keyrings/stripe.gpg] https://packages.stripe.dev/stripe-cli-debian-local stable main" | sudo tee /etc/apt/sources.list.d/stripe.list
sudo apt update && sudo apt install -y stripe

# Turso CLI
echo "Installing Turso CLI..."
curl -sSfL https://get.tur.so/install.sh | bash

# UV (Python package manager)
echo "Installing UV..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Lazygit
echo "Installing Lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz

# Zellij
echo "Installing Zellij..."
curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz
sudo mv zellij /usr/local/bin/

# Azure CLI
echo "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Terraform
echo "Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# Pulumi
echo "Installing Pulumi..."
curl -fsSL https://get.pulumi.com | sh

# Alacritty (AppImage or build from source)
echo "Installing Alacritty..."
if ! command -v alacritty &> /dev/null; then
    sudo add-apt-repository ppa:aslatter/ppa -y
    sudo apt update
    sudo apt install -y alacritty
fi

# Zoxide (smart cd command)
echo "Installing Zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Bun (JavaScript runtime and package manager)
echo "Installing Bun..."
curl -fsSL https://bun.com/install | bash

# Zap (ZSH plugin manager)
echo "Installing Zap ZSH plugin manager..."
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

echo ""
echo "Installation complete!"
echo ""
echo "Note: Some tools installed to ~/.cargo/bin or ~/.local/bin"
echo "Make sure these are in your PATH by adding to ~/.bashrc or ~/.zshrc:"
echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"'
echo ""
echo "Restart your shell or run: source ~/.bashrc"