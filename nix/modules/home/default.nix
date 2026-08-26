# Portable home-manager core.
#
# Everything in this directory (except darwin.nix) must evaluate on Linux as
# well as macOS -- no /Applications paths, no `defaults write`, no darwin-only
# packages. Platform-specific configuration belongs in ./darwin.nix, which the
# macOS hosts import alongside this module.
{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./git.nix
    ./shell
    ./editor.nix
  ];

  home.username = "dylanmeskis";
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";

  nixpkgs.config.allowUnfree = true;

  # Determines which home-manager release's option defaults apply. Bumping this
  # is not an upgrade -- it changes stateful defaults -- so read the release
  # notes before touching it.
  home.stateVersion = "26.11";

  home.packages = import ./packages.nix { inherit pkgs; };

  xdg.enable = true;

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    jq.enable = true;
    man.enable = true;
    gh.enable = true;
    lazygit.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    rbenv.enable = true;
    bat.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
      };
    };
  };
}
