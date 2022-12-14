#!/usr/bin/env bash

set -e

# Install nix

if ! command -v nix &> /dev/null
then
	sh <(curl -L https://nixos.org/nix/install)
fi


# Install nix-darwin

nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer


# Wezterm
# ln -nfs $HOME/dotfiles/.wezterm.lua $HOME/.wezterm.lua

# zsh
# ln -nfs $HOME/dotfiles/.zshrc $HOME/.zshrc

echo "Setup complete."
