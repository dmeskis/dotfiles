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
  home.packages = pkgs.callPackage ./packages.nix {};

  xdg.enable = true;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    htop.enable = true;
    jq.enable = true;
    man.enable = true;

    gh.enable = true;

    git = {
      enable = true;
      package = pkgs.gitFull;

      userName = "Dylan Meskis";
      userEmail = "dmeskis@gmail.com";

      aliases = {
        a = "add";
        ap = "add -p";
        b = "branch --color -v";
        bd = "branch -d";
        bdf = "branch -D";
        branches = "branch -a";
        ca = "commit --amend";
        changes = "diff --name-status -r";
        clone = "clone --recursive";
        co = "checkout";
        cp = "cherry-pick";
        dc = "diff --cached";
        dh = "diff HEAD";
        ds = "diff --staged";
        l = "log";
        lr = "log --reverse";
        ls-ignored = "ls-files --exclude-standard --ignored --others";
        remotes = "remote -v";
        ri = "rebase --interactive";
        st = "status";
        tags = "tag -l";
        undo = "reset --soft HEAD^";
        cleanup = "git branch --merged master | grep -v -e 'master' -e '\*' | xargs -n 1 git branch -d && git remote prune origin";
      };

      delta = {
        enable = true;
        options = {
          navigate = true;
          side-by-side = true;
        };
      };

      extraConfig = {
        credential.helper = "osxkeychain";

        color.ui = true;
        color.branch = {
          current = "magenta reverse";
          local = "yellow"; remote = "green"; }; color.diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
        };
        color.status = {
          added = "green";
          changed = "yellow";
          untracked = "cyan";
          branch = "magenta";
          nobranch = "normal";
          unmerged = "red";
        };

        pager = {
          diff = "delta";
          log = "delta";
          reflog = "delta";
          show = "delta";
          branch = false;
        };

        # push.autoSetupRemote = true;
        url."https://github.com/homebotapp/".insteadOf = [
          "git@github.com:homebotapp/"
          "ssh://git@github.com/homebotapp/"
        ];
      };

      ignores = [
        "*~"
        "*.swp"
        "*.pyc"
        ".bundle"
        ".direnv/"
        ".DS_STORE"
        ".envrc"
        ".envrc.cache"
        ".envrc.override"
        "venv/**/*"
        ".idea/**/*"
      ];
    };

    lazygit = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      history = {
        path = "${config.xdg.dataHome}/zsh/.zsh_history";
        size = 50000;
        save = 50000;
      };
      shellAliases = import ../home/aliases.nix;
      defaultKeymap = "emacs";
      initExtraBeforeCompInit = builtins.readFile ../home/pre-compinit.zsh;
      initExtra = builtins.readFile ../home/post-compinit.zsh;
      completionInit = "autoload -Uz compinit && compinit";

      sessionVariables = rec {
        NVIM_TUI_ENABLE_TRUE_COLOR = "1";

        HOME_MANAGER_CONFIG = "${config.home.homeDirectory}/dotfiles/nix/home.nix";

        EDITOR = "vim";
        VISUAL = EDITOR;
        GIT_EDITOR = EDITOR;

        CHEAT_CONFIG_PATH = "${config.home.homeDirectory}/dotfiles/cheat/conf.yml";
        # GOPATH = "$HOME";

        # PATH = "$HOME/.emacs.d/bin:$HOME/bin:$PATH";
      };
        # envExtra
        # profileExtra
        # loginExtra
        # logoutExtra
        # localVariables
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
      };

      bat.enable = true;

      direnv = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf.enable = true;

      neovim = {
        enable = true;
        vimAlias = true;
        plugins = with pkgs.vimPlugins; [
           # Language + Syntax
           vim-nix
           vim-ruby
           vim-go
           vim-terraform
           rust-vim

           (nvim-treesitter.withPlugins (
             plugins: with plugins; [
               # tree-sitter-bash
               tree-sitter-c
               tree-sitter-cpp
               tree-sitter-dockerfile
               tree-sitter-fish
               tree-sitter-go
               tree-sitter-html
               tree-sitter-json
               tree-sitter-latex
               tree-sitter-lua
               tree-sitter-nix
               tree-sitter-python
               tree-sitter-r
               tree-sitter-regex
               tree-sitter-rust
               tree-sitter-toml
               tree-sitter-vim
               tree-sitter-yaml
             ]
             ))

           # UI
           colorbuddy-nvim
           gruvbox-material
           vim-gitgutter
           lualine-nvim

           # Editor features
           # vim-abolish
           # vim-characterize
           vim-surround # cs"'
           vim-repeat # cs"'...
           vim-commentary # gcap
           vim-indent-object # >aI
           # vim-easy-align # vipga
           vim-eunuch # :Rename foo.rb
           # vim-sneak # Or leap.nvim || hop.nvim
           ale # linting - ALEFix
           tabular # TODO add https://github.com/tjdevries/config_manager/blob/7958de40dac4400a244ab5a0f04b9a9e60202fab/xdg_config/nvim/after/plugin/tabular.vim
           # nerdtree

           # Buffer / Pane / File Management
           telescope-nvim
           telescope-file-browser-nvim
           telescope-fzf-native-nvim

           # Panes / Larger features
           # tagbar - look into
           vim-fugitive # Gblame

           # lsp
           nvim-lspconfig

           # completion
           nvim-cmp
           cmp-nvim-lsp
           cmp-nvim-lua
           cmp-buffer
           cmp-path
           lspkind-nvim
           cmp_luasnip

           # which-key-nvim

           # Snippets
           luasnip

           # Lua
           # plenary-nvim
           # popup-nvim

           # Check out
           # nvim-dap
           # packer.nvim
           # undotree
           # refactoring.nvim
           # fidget.nvim
           # trouble.nvim *
           # https://github.com/nvim-telescope/telescope-github.nvim
           # git-messenger * Looks neat!
           # octo-nvim
           # git-worktree
           # marks.nvim
           # harpoon *
           # neorg (replace obsidian/notion?)
           # obsidian.nvim * complement obsidian?
           # dirbuf
           # targets.nvim
         ];
       };

       wezterm = {
         enable = true;
         extraConfig = builtins.readFile ../home/extraConfig.wezterm.lua;
       };

       zoxide = {
         enable = true;
         enableZshIntegration = true;
       };

     };

  # More config files
  xdg.configFile = {
    "nvim/init.lua".text = builtins.readFile ../home/init.lua;
    "ideavim/ideavimrc".text = builtins.readFile ../home/ideavimrc;
  };

}
