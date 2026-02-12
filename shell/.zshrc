# Oh My Posh prompt
if [ "$(uname)" = "Darwin" ]; then
    eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/dracula.omp.json)"
else
    eval "$(oh-my-posh init zsh --config ${POSH_THEMES_PATH:-$HOME/.cache/oh-my-posh/themes}/dracula.omp.json)"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source $ZSH/oh-my-zsh.sh

# macOS-specific PATH
if [ "$(uname)" = "Darwin" ]; then
    export PATH="$HOME/Library/Python/3.9/bin:$PATH"
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

# Editor
export EDITOR=thicc

# Modern CLI replacements
alias ls='eza'
alias ll='eza -la --git'
alias tree='eza --tree'
alias cat='bat --paging=never'

# Claude
_c() { claude --print "$*"; }
alias c='noglob _c'
alias clauded='claude --dangerously-skip-permissions'

# Task Master
alias tm='task-master'
alias taskmaster='task-master'

# Zellij
alias qubo='zellij attach qubo || zellij --session qubo --layout qubo'

# Zoxide (smarter cd)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"

# Plugins (Linux only; brew-installed plugins are sourced via Oh My Zsh on macOS)
if [ "$(uname)" = "Linux" ]; then
    [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
        source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Custom prompt for THOCK terminal
if [[ -n "$THOCK_TERM" ]]; then
    PROMPT='%F{205}> %F{51}%1~%F{141}$(git branch --show-current 2>/dev/null | sed "s/^/ @ /")%f %F{205}>>%f '
fi
