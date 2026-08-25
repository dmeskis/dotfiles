{ lib, pkgs, ... }:
{
  imports = [
    ../../modules/home
    ../../modules/home/darwin.nix
  ];

  home.packages = with pkgs; [
    circleci-cli
    fnm # node version manager; see pre-compinit.zsh
    yarn
  ];

  # Employer-specific: kept here rather than in modules/home/git.nix so it
  # cannot follow the config onto a personal machine.
  programs.git.settings.url."https://github.com/homebotapp/".insteadOf = [
    "git@github.com:homebotapp/"
    "ssh://git@github.com/homebotapp/"
  ];

  programs.zsh = {
    shellAliases = import ./homebotAliases.nix;

    # 555/1050 land just after the portable 550/1000 fragments in
    # modules/home/shell, on either side of compinit.
    initContent = lib.mkMerge [
      (lib.mkOrder 555 (builtins.readFile ./pre-compinit.zsh))
      (lib.mkOrder 1050 (builtins.readFile ./post-compinit.zsh))
    ];

    profileExtra = ''
      export PGHOST='127.0.0.1'
      export PGPORT='5432'
      export PGUSER='postgres'
      export AWS_VAULT_BACKEND='pass'
    '';
  };
}
