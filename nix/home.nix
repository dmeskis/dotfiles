{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dylanmeskis";
  home.homeDirectory = "/Users/dylanmeskis";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    shellAliases = import ./home/aliases.nix;
    defaultKeymap = "emacs";
    initExtraBeforeCompInit = builtins.readFile ./home/pre-compinit.zsh;
    initExtra = builtins.readFile ./home/post-compinit.zsh;
    # initExtraBeforeCompInit = ''
    #     eval $(${pkgs.coreutils}/bin/dircolors -b ${./home/LS_COLORS})
    #     ${builtins.readFile ./home/pre-compinit.zsh}
    # '';

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.34.0";
          sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
      }
    ];

    sessionVariables = rec {
      NVIM_TUI_ENABLE_TRUE_COLOR = "1";

      HOME_MANAGER_CONFIG = ~/dotfiles/nix/home.nix;

      EDITOR = "vim";
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;

      CHEAT_CONFIG_PATH = ~/dotfiles/cheat/conf.yml;
      # GOPATH = "$HOME";

      # PATH = "$HOME/.emacs.d/bin:$HOME/bin:$PATH";
    };
      # envExtra
      # profileExtra
      # loginExtra
      # logoutExtra
      # localVariables
    };

     programs.bat.enable = true;
 
     programs.direnv = {
       enable = true;
       enableZshIntegration = true;
     };
 
     programs.fzf = {
       enable = false;
     };
 
     programs.neovim = {
       enable = true;
       vimAlias = true;
       extraConfig = builtins.readFile ./home/extraConfig.vim;
       plugins = with pkgs.vimPlugins; [
         # Syntax
         vim-nix
         vim-ruby
         vim-go
         rust-vim

         # UI
         gruvbox
         vim-gitgutter
         vim-airline

         # Editor features
         # vim-abolish
         vim-surround # cs"'
         vim-repeat # cs"'...
         vim-commentary # gcap
         vim-indent-object # >aI
         # vim-easy-align # vipga
         vim-eunuch # :Rename foo.rb
         # vim-sneak
         # supertab
         ale # linting - ALEFix
         nerdtree

         # Buffer / Pane / File Management
         fzf-vim

         # Panes / Larger features
         # tagbar - look into
         vim-fugitive # Gblame
       ];
     };
 
     programs.wezterm = {
       enable = true;
     };
}
