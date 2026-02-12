# Homebrew (macOS)
if [ "$(uname)" = "Darwin" ] && [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ensure local bin and cargo are on PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
