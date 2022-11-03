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
- Set a static hostname with `sudo scutil --set HostName '<NAME>'`, hostname is used in the flake file to apply each machine's respective config.

# Notes

- Flakes are copied to the store and evaluted there. Unadded changes aren't copied to the store.
