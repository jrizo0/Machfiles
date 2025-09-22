#!/bin/bash

set -e  # Exit on any error

echo "🚀 Installing VSCode extensions from your Brewfile..."
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

# Check if VSCode is installed
if ! command -v code >/dev/null 2>&1; then
    print_error "VSCode is not installed or 'code' command is not available in PATH"
    print_status "Install VSCode first:"
    echo "  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg"
    echo "  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/"
    echo "  sudo sh -c 'echo \"deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main\" > /etc/apt/sources.list.d/vscode.list'"
    echo "  sudo apt update && sudo apt install code"
    exit 1
fi

print_status "Installing VSCode extensions from your Brewfile..."

# Array of extensions from your Brewfile
extensions=(
    "ambar.bundle-size"
    "amiralizadeh9480.laravel-extra-intellisense"
    "astro-build.astro-vscode"
    "austenc.tailwind-docs"
    "bierner.color-info"
    "biomejs.biome"
    "bmewburn.vscode-intelephense-client"
    "bocovo.dbml-erd-visualizer"
    "bradlc.vscode-tailwindcss"
    "dbaeumer.vscode-eslint"
    "devsense.composer-php-vscode"
    "devsense.phptools-vscode"
    "devsense.profiler-php-vscode"
    "djlynn03.insert-color"
    "dsznajder.es7-react-js-snippets"
    "esbenp.prettier-vscode"
    "fernandotherojo.nandorojo-tamagui"
    "github.codespaces"
    "github.vscode-github-actions"
    "jakebecker.elixir-ls"
    "jdinhlife.gruvbox"
    "jock.svg"
    "kuscamara.electron"
    "ms-azuretools.vscode-azurefunctions"
    "ms-azuretools.vscode-azureresourcegroups"
    "ms-azuretools.vscode-azurestaticwebapps"
    "ms-azuretools.vscode-containers"
    "ms-azuretools.vscode-docker"
    "ms-vscode-remote.remote-containers"
    "mvllow.rose-pine"
    "naumovs.color-highlight"
    "nrwl.angular-console"
    "phoenixframework.phoenix"
    "pkief.material-icon-theme"
    "redhat.java"
    "rvest.vs-code-prettier-eslint"
    "sdras.night-owl"
    "simonsiefke.svg-preview"
    "statelyai.stately-vscode"
    "supermaven.supermaven"
    "tyriar.lorem-ipsum"
    "unifiedjs.vscode-mdx"
    "visualstudioexptteam.intellicode-api-usage-examples"
    "visualstudioexptteam.vscodeintellicode"
    "vscjava.vscode-gradle"
    "vscjava.vscode-java-debug"
    "vscjava.vscode-java-dependency"
    "vscjava.vscode-java-pack"
    "vscjava.vscode-java-test"
    "vscjava.vscode-maven"
    "vscodevim.vim"
    "wesbos.theme-cobalt2"
    "xyc.vscode-mdx-preview"
    "yoavbls.pretty-ts-errors"
    "yzhang.markdown-all-in-one"
    "zarifprogrammer.tailwind-snippets"
)

# Function to install extension with retry
install_extension() {
    local extension="$1"
    local max_retries=3
    local retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        if code --install-extension "$extension" >/dev/null 2>&1; then
            print_success "Installed: $extension"
            return 0
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                print_warning "Failed to install $extension, retrying... ($retry_count/$max_retries)"
                sleep 2
            fi
        fi
    done
    
    print_error "Failed to install: $extension (after $max_retries attempts)"
    return 1
}

# Counter for tracking progress
total_extensions=${#extensions[@]}
current_extension=0
failed_extensions=()

# Install each extension
for extension in "${extensions[@]}"; do
    current_extension=$((current_extension + 1))
    print_status "Installing extension $current_extension/$total_extensions: $extension"
    
    # Check if extension is already installed
    if code --list-extensions | grep -q "^$extension$"; then
        print_success "Already installed: $extension"
    else
        if ! install_extension "$extension"; then
            failed_extensions+=("$extension")
        fi
    fi
done

echo ""
echo "=================================================="
print_success "VSCode extension installation complete!"
echo "=================================================="

# Summary
successful_count=$((total_extensions - ${#failed_extensions[@]}))
print_status "Summary:"
echo "• Total extensions: $total_extensions"
echo "• Successfully installed/verified: $successful_count"
echo "• Failed: ${#failed_extensions[@]}"

# List failed extensions if any
if [ ${#failed_extensions[@]} -gt 0 ]; then
    echo ""
    print_warning "Failed to install the following extensions:"
    for failed_ext in "${failed_extensions[@]}"; do
        echo "  - $failed_ext"
    done
    echo ""
    print_status "You can manually install them later with:"
    for failed_ext in "${failed_extensions[@]}"; do
        echo "  code --install-extension $failed_ext"
    done
fi

echo ""
print_status "VSCode is ready with your extensions!"
print_status "Restart VSCode to ensure all extensions are properly loaded."