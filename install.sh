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
    brew bundle --file="$DOTFILES/Brewfile" || echo "Warning: some Brewfile packages failed to install/upgrade"

elif [ "$OS" = "Linux" ]; then
    if command -v pacman &>/dev/null; then
        echo ""
        echo "==> Installing pacman packages..."
        sudo pacman -S --needed --noconfirm $(cat "$DOTFILES/packages-pacman.txt")
    elif command -v apt &>/dev/null; then
        echo ""
        echo "==> Installing apt packages..."
        sudo apt update
        sudo apt install -y $(cat "$DOTFILES/packages-apt.txt")
    else
        echo "Warning: no supported package manager found (apt or pacman)"
    fi
fi

# --- Oh My Zsh ---

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    echo "==> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Oh My Posh (Linux only; Homebrew handles macOS) ---

if [ "$OS" = "Linux" ] && ! command -v oh-my-posh &>/dev/null; then
    echo ""
    echo "==> Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
    mkdir -p ~/.cache/oh-my-posh/themes
    curl -sL "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/dracula.omp.json" \
        -o ~/.cache/oh-my-posh/themes/dracula.omp.json
fi

# --- Cross-platform tools ---

echo ""
echo "==> Installing cross-platform tools..."

# NVM + Node
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
if ! nvm ls --no-colors 2>/dev/null | grep -q "lts"; then
    echo "Installing Node LTS via nvm..."
    nvm install --lts
fi

# Rustup (if not already installed)
if ! command -v rustup &>/dev/null; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Thicc editor (if not already installed)
if ! command -v thicc &>/dev/null; then
    echo "Installing thicc..."
    curl -fsSL https://raw.githubusercontent.com/elleryfamilia/thicc/main/install.sh | sh
fi

# Zerminal (Linux; macOS handled by Brewfile cask)
if [ "$OS" = "Linux" ] && ! command -v zerminal &>/dev/null; then
    echo "Installing zerminal..."
    curl -fsSL https://github.com/elleryfamilia/zerminal/releases/latest/download/install.sh | sh
fi

# bat symlink (Ubuntu installs as batcat)
if [ "$OS" = "Linux" ] && command -v batcat &>/dev/null; then
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
fi

# --- Symlinks ---

echo ""
echo "==> Creating symlinks..."

mkdir -p ~/.config/gh ~/.config/git ~/.config/zed

# Shell
ln -sf "$DOTFILES/shell/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/shell/.zprofile" ~/.zprofile
ln -sf "$DOTFILES/shell/.zshenv" ~/.zshenv

# Git
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES/git/ignore" ~/.config/git/ignore

# GitHub CLI
ln -sf "$DOTFILES/gh/config.yml" ~/.config/gh/config.yml

# Zed
ln -sf "$DOTFILES/zed/settings.json" ~/.config/zed/settings.json

# --- Linux desktop extras (each piece gates on its own dependencies) ---

if [ "$OS" = "Linux" ]; then
    echo ""
    bash "$DOTFILES/linux/setup.sh"
fi

# --- macOS defaults ---

if [ "$OS" = "Darwin" ]; then
    echo ""
    read -p "Apply macOS system defaults? [y/N] " apply_defaults
    if [ "$apply_defaults" = "y" ] || [ "$apply_defaults" = "Y" ]; then
        bash "$DOTFILES/macos/defaults.sh"
    fi
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
