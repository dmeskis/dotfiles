{ lib, config, pkgs, nixpks, ... }:
{
  imports = [
    ../common.nix
  ];

  home.packages = with pkgs; [
    circleci-cli
  ];

  programs = {
    zsh = {
      shellAliases = import ./homebotAliases.nix;
    };
  };
}
