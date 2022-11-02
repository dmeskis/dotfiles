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

Bootstrap nix-darwin
```
nix build .#darwinConfigurations.<HOSTNAME>.system

./result/sw/bin/darwin-rebuild switch --flake .

```

After bootstrapping you can run the following to apply changes.
`darwin-rebuild switch --flake /Users/dylanmeskis/dotfiles/nix`

- Boot strap home-manager
```
nix build .#homeConfigurations.dylanmeskis.activationPackage
./result/activate

```

After bootstrapping:
`home-manager switch --flake /Users/dylanmeskis/dotfiles/nix`

- Download Brave Browser. Sync it.
- Download 1Password. Set quick access to Shift + Meta + P
- Replace Spotlight w/ Raycast

# Notes

- Flakes are copied to the store and evaluted there. Uncommitted changes aren't copied to the store. Look into this
