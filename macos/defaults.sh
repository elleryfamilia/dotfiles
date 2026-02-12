#!/bin/bash
# macOS system preferences
# Run this script to apply preferred system settings.
# Some changes require a logout/restart to take effect.

set -e

echo "Applying macOS defaults..."

# --- Appearance ---

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# --- Dock ---

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Small icon size (27px)
defaults write com.apple.dock tilesize -int 27

# Enable magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 51

# --- Keyboard ---

# Fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Short delay before key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# --- Finder ---

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# --- Scroll ---

# Natural scrolling off
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# --- Apply changes ---

echo "Restarting affected apps..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

echo "macOS defaults applied."
