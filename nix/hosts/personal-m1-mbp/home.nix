{ lib, config, pkgs, nixpks, ... }:
{
  imports = [
    ../common.nix
  ];

  programs = {
    zsh = {
      # shellAliases = import ./homebotAliases.nix;
      # initContent = lib.mkMerge [
      #   (lib.mkOrder 555 (builtins.readFile ./pre-compinit.zsh))
      #   (lib.mkOrder 1050 (builtins.readFile ./post-compinit.zsh))
      # ];

      profileExtra = ''
        # Set PATH, MANPATH, etc., for Homebrew.
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
