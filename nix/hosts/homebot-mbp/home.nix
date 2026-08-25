{ lib, config, pkgs, nixpks, ... }:
{
  imports = [
    ../common.nix
  ];

  home.packages = with pkgs; [
    circleci-cli
    fnm # node version manager; see pre-compinit.zsh
    yarn
  ];

  programs = {
    zsh = {
      shellAliases = import ./homebotAliases.nix;
      initContent = lib.mkMerge [
        (lib.mkOrder 555 (builtins.readFile ./pre-compinit.zsh))
        (lib.mkOrder 1050 (builtins.readFile ./post-compinit.zsh))
      ];

      profileExtra = ''
        export PGHOST='127.0.0.1'
        export PGPORT='5432'
        export PGUSER='postgres'
        export AWS_VAULT_BACKEND='pass'

        # Set PATH, MANPATH, etc., for Homebrew.
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
