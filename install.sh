#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

echo "Installing dotfiles from $DOTFILES"
echo "Detected OS: $OS"

# --- Package installation ---

if [ "$OS" = "Darwin" ]; then
    echo ""
    echo "==> Installing Homebrew packages..."
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Install it first:"
        echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi
    brew bundle --file="$DOTFILES/Brewfile"

elif [ "$OS" = "Linux" ]; then
    echo ""
    echo "==> Installing apt packages..."
    sudo apt update
    sudo apt install -y $(cat "$DOTFILES/packages-apt.txt")
fi

# --- Cross-platform tools ---

echo ""
echo "==> Installing cross-platform tools..."

# Starship (if not already installed)
if ! command -v starship &>/dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin
fi

# NVM (if not already installed)
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Rustup (if not already installed)
if ! command -v rustup &>/dev/null; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Cargo tools
if command -v cargo &>/dev/null; then
    echo "Installing cargo tools..."
    cargo install cross --locked 2>/dev/null || true
fi

# Go tools
if command -v go &>/dev/null; then
    echo "Installing go tools..."
    go install github.com/jesseduffield/lazygit@latest 2>/dev/null || true
    [ -f ~/go/bin/lazygit ] && mkdir -p ~/.local/bin && ln -sf ~/go/bin/lazygit ~/.local/bin/lazygit
fi

# NPM global tools
if command -v npm &>/dev/null; then
    echo "Installing npm global tools..."
    npm install -g turbo 2>/dev/null || true
fi

# --- Symlinks ---

echo ""
echo "==> Creating symlinks..."

mkdir -p ~/.config

ln -sf "$DOTFILES/shell/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml

# bat symlink (Ubuntu installs as batcat)
if [ "$OS" = "Linux" ] && command -v batcat &>/dev/null; then
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
fi

# --- Shell ---

# Set zsh as default shell if it isn't already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo ""
    echo "==> Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

echo ""
echo "Done! Open a new shell to pick up changes."
