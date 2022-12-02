{ lib, config, pkgs, nixpks, ... }:
{
  imports = [
    ../common.nix
  ];

  home.packages = with pkgs; [
    circleci-cli
    yarn
  ];

  programs = {
    zsh = {
      shellAliases = import ./homebotAliases.nix;
      initExtraBeforeCompInit = builtins.readFile ./pre-compinit.zsh;
      initExtra = builtins.readFile ./post-compinit.zsh;

      profileExtra = ''
        export PGHOST='127.0.0.1'
        export PGPORT='5432'
        export PGUSER='postgres'

        # Set PATH, MANPATH, etc., for Homebrew.
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
