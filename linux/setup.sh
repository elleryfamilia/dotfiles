#!/bin/bash
# Linux desktop extras. Every section gates on the tools it needs, so this
# is safe to run on any distro — unsupported pieces are skipped silently.

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

# --- COSMIC desktop tweaks (theme toggle button, battery %, icon buttons) ---

if command -v cosmic-panel &>/dev/null; then
    echo "==> COSMIC detected: installing desktop tweaks..."
    mkdir -p ~/.local/bin ~/.local/share/applications

    ln -sf "$DOTFILES/linux/cosmic/cosmic-toggle-theme" ~/.local/bin/cosmic-toggle-theme

    # Desktop entries are copied, not symlinked: the toggle script rewrites
    # the installed entry's Icon= line at runtime (sed -i would break a link).
    cp "$DOTFILES/linux/cosmic/io.ellery.CosmicThemeToggle.desktop" \
       "$DOTFILES/linux/cosmic/io.ellery.CosmicThemeToggleButton.desktop" \
       ~/.local/share/applications/
    sed -i "s|^Exec=cosmic-toggle-theme$|Exec=$HOME/.local/bin/cosmic-toggle-theme|" \
        ~/.local/share/applications/io.ellery.CosmicThemeToggle.desktop

    # Show battery percentage in the top panel
    mkdir -p ~/.config/cosmic/com.system76.CosmicAppletBattery/v1
    printf 'true' > ~/.config/cosmic/com.system76.CosmicAppletBattery/v1/show_percentage

    # Panel buttons render as icons (XS-size panels default to text labels)
    mkdir -p ~/.config/cosmic/com.system76.CosmicPanelButton/v1
    cat > ~/.config/cosmic/com.system76.CosmicPanelButton/v1/configs <<'EOF'
{
    "Panel": (
        force_presentation: Some(Icon),
    ),
    "Dock": (
        force_presentation: Some(Icon),
    ),
}
EOF

    if ! grep -q CosmicThemeToggleButton \
            ~/.config/cosmic/com.system76.CosmicPanel.Panel/v1/plugins_wings 2>/dev/null; then
        echo "    NOTE: add 'Theme Toggle Button' to the panel via"
        echo "    COSMIC Settings -> Desktop -> Panel -> Configure panel applets"
    fi
fi

# --- Power profile auto-switching (AC -> performance, battery -> balanced) ---

rule="$DOTFILES/linux/udev/99-power-profile-switch.rules"
target=/etc/udev/rules.d/99-power-profile-switch.rules
if command -v powerprofilesctl &>/dev/null && [ -d /etc/udev/rules.d ]; then
    if cmp -s "$rule" "$target"; then
        echo "==> Power-profile udev rule already installed"
    elif sudo install -m 644 "$rule" "$target" &&
         sudo udevadm control --reload &&
         sudo udevadm trigger --subsystem-match=power_supply --action=change; then
        echo "==> Installed power-profile udev rule"
    else
        echo "    Skipped power-profile udev rule (sudo failed). Install manually:"
        echo "    sudo install -m 644 $rule $target && sudo udevadm control --reload"
    fi
fi
