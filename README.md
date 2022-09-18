# Install


Clone repo to $HOME/dotfiles & init submodules

https://git-scm.com/book/en/v2/Git-Tools-Submodules

```
git clone -C ~/ --recurse-submodules <url> 

```

Run bin/install.sh

Manually install homebrew for use w/ nix-darwin


Run commands

$ darwin-rebuild switch -I darwin-config=$HOME/dotfiles/nix/darwin.nix

$ home-manager switch -f ~/dotfiles/nix/home.nix
