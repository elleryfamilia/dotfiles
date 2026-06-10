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
| **Linux desktop** | COSMIC theme-toggle panel button, battery %, AC/battery power-profile switching |

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
5. On Linux, runs `linux/setup.sh` — each piece self-gates on its dependencies, so it's a no-op on systems without them:
   - **COSMIC only:** panel light/dark theme-toggle button, battery percentage in the panel, icon-style panel buttons
   - **power-profiles-daemon only:** udev rule switching to `performance` on AC and `balanced` on battery (needs sudo)
6. Optionally applies macOS system defaults (dark mode, dock, Finder, etc.)
7. Sets zsh as the default shell

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
├── linux/
│   ├── setup.sh        # Linux desktop extras (self-gating per tool)
│   ├── cosmic/         # COSMIC theme-toggle button + desktop entries
│   └── udev/           # AC/battery power-profile switching rule
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
