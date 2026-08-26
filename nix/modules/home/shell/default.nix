# Portable zsh configuration. macOS-only aliases live in ../darwin.nix.
{ lib, config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      path = "${config.xdg.dataHome}/zsh/.zsh_history";
      size = 50000;
      save = 50000;

      share = true;
      append = true;
      ignoreDups = true;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = true;
      ignoreSpace = true;
    };

    shellAliases = import ./aliases.nix;
    defaultKeymap = "emacs";

    initContent = lib.mkMerge [
      (lib.mkOrder 550 (builtins.readFile ./pre-compinit.zsh))
      (lib.mkOrder 1000 (builtins.readFile ./post-compinit.zsh))
      (lib.mkOrder 1500 (builtins.readFile ./post-prompt.zsh))
    ];
    completionInit = "autoload -Uz compinit && compinit";

    sessionVariables = rec {
      NVIM_TUI_ENABLE_TRUE_COLOR = "1";

      EDITOR = "vim";
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;

      CHEAT_CONFIG_PATH = "${config.home.homeDirectory}/dotfiles/cheat/conf.yml";

      GOPATH = "$HOME/go";
    };
  };

  # Prefer home.sessionPath over hand-appending to PATH in sessionVariables:
  # home-manager assembles this into a single guarded export, so it cannot
  # double-apply if the session file is sourced twice.
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];
}
