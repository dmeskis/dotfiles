# Install


Clone repo to $HOME/dotfiles & init submodules

https://git-scm.com/book/en/v2/Git-Tools-Submodules

```
git clone -C ~/ --recurse-submodules <url> 

```

# macOS
- Install Nix and enable flakes
- Install Homebrew
- Setup nix-darwin
```
nix build .#darwinConfigurations.<HOSTNAME>.system

./result/sw/bin/darwin-rebuild switch --flake .

```
- Setup home-manager
```
nix build .#homeConfigurations.dylanmeskis

```

- Download Brave Browser. Sync it.
- Download 1Password. Set quick access to Shift + Meta + P
- Replace Spotlight w/ Raycast







Run commands

$ darwin-rebuild switch -I darwin-config=$HOME/dotfiles/nix/darwin.nix

$ home-manager switch -f ~/dotfiles/nix/home.nix
