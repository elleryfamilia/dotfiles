# dotfiles

Personal dotfiles for macOS and Linux. One script to install everything.

## What's included

| Category | Tools |
|---|---|
| **Shell** | zsh + Oh My Zsh + Oh My Posh (Dracula theme) |
| **Editor** | [Thicc](https://github.com/elleryfamilia/thicc), [Zerminal](https://github.com/elleryfamilia/zerminal) |
| **Terminal tools** | eza, bat, fd, ripgrep, fzf, zoxide, zellij, yazi, lazygit, btop |
| **Languages** | Node (via NVM), Rust (via rustup), Go, Python (via pyenv) |
| **Git** | git, gh CLI, git-crypt |
| **macOS** | Homebrew packages, casks, Nerd Fonts, system defaults |
| **Linux** | apt (Debian/Ubuntu) or pacman (Arch), Oh My Posh via curl |

## Install

```bash
git clone https://github.com/elleryfamilia/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

**Prerequisites:** Homebrew (macOS), apt (Debian/Ubuntu), or pacman (Arch). The script handles the rest.

## What the install script does

1. Installs packages via Homebrew (`Brewfile`), apt (`packages-apt.txt`), or pacman (`packages-pacman.txt`)
2. Installs Oh My Zsh and Oh My Posh
3. Installs NVM + Node LTS, Rustup, Thicc, and Zerminal
4. Symlinks all config files to their expected locations
5. Optionally applies macOS system defaults (dark mode, dock, Finder, etc.)
6. Sets zsh as the default shell

## Repo structure

```
dotfiles/
├── Brewfile            # macOS Homebrew packages, casks, and fonts
├── packages-apt.txt    # Debian/Ubuntu apt packages
├── packages-pacman.txt # Arch pacman packages
├── install.sh          # Cross-platform install script
├── shell/
│   ├── .zshrc          # Shell config (aliases, prompt, plugins)
│   ├── .zprofile       # Login shell (Homebrew, NVM, PATH)
│   └── .zshenv         # Cargo env
├── git/
│   ├── .gitconfig      # Git user, aliases, editor
│   └── ignore          # Global gitignore
├── gh/
│   └── config.yml      # GitHub CLI config
├── zed/
│   └── settings.json   # Zed editor theme
└── macos/
    └── defaults.sh     # macOS system preferences
```

## Key aliases

| Alias | Command |
|---|---|
| `ls` | `eza` |
| `ll` | `eza -la --git` |
| `tree` | `eza --tree` |
| `cat` | `bat --paging=never` |
| `cd` | `zoxide` (learns frequent directories) |
| `c` | `claude --print` (quick questions) |
| `clauded` | `claude --dangerously-skip-permissions` |
| `tm` | `task-master` |
| `git lg` | Pretty git log graph |

## macOS defaults

The `macos/defaults.sh` script sets:

- Dark mode
- Dock: autohide, small tiles (27px), magnification
- Finder: show path bar and status bar
- Fast key repeat (rate: 2, delay: 15)
- Natural scrolling off
