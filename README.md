# Install


Clone repo to $HOME/dotfiles & init submodules

https://git-scm.com/book/en/v2/Git-Tools-Submodules

```
git clone -C ~/ --recurse-submodules <url> 

```

Run bin/install.sh


Run commands

$ darwin-rebuild switch -I darwin-config=$HOME/dotfiles/nix/darwin.nix

$ home-manager switch -f ~/dotfiles/nix/home.nix

Install Rectangle app
