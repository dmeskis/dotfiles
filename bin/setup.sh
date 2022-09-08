#!/usr/bin/env bash

set -e

# Install things

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

programs=(
	awscli
	asdf
	bat
	cheat
	direnv
	exercism
	exa
	fd
	fzf
	gh
	lua
	make
	neovim
	packer
	postgresql
	pwgen
	shellcheck
	tfenv
	tflint
	tfsec
	tig
	xsv
	yamllint
	rbenv
	ripgrep
	zsh-autosuggestions
	zsh-completions
	zsh-syntax-highlighting
)

for program in "${programs[@]}"
do
	brew install "$program"
done


# Wezterm
ln -nfs $HOME/dotfiles/.wezterm.lua $HOME/.wezterm.lua

# zsh
ln -nfs $HOME/dotfiles/.zshrc $HOME/.zshrc

echo "Completed setup!"
