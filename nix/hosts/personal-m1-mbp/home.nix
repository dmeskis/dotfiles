{ lib, config, pkgs, nixpks, ... }:
{
  imports = [
    ../common.nix
  ];

  programs = {
    zsh = {
      # shellAliases = import ./homebotAliases.nix;
      # initExtraBeforeCompInit = builtins.readFile ./pre-compinit.zsh;
      # initExtra = builtins.readFile ./post-compinit.zsh;

      profileExtra = ''
        # Set PATH, MANPATH, etc., for Homebrew.
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
