{ lib, config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dylanmeskis";
  home.homeDirectory = "/Users/dylanmeskis";

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.11";
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

      settings = {
        user.name = "Dylan Meskis";
        user.email = "dmeskis@gmail.com";

        alias = {
          b = "branch --color -v";
          branches = "branch -a";
          changes = "diff --name-status -r";
          clone = "clone --recursive";
          co = "checkout";
          cp = "cherry-pick";
          ri = "rebase --interactive";
          st = "status";
          tags = "tag -l";
          undo = "reset --soft HEAD^";
        };

        color.ui = true;
        color.branch = {
          current = "magenta reverse";
          local = "yellow"; remote = "green";
        }; 
        color.diff = {
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
          # diff/log/show/blame come from programs.delta.enableGitIntegration.
          reflog = "delta";
          branch = false;
        };

        push.autoSetupRemote = true;
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

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };

    lazygit = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        path = "${config.xdg.dataHome}/zsh/.zsh_history";
        size = 50000;
        save = 50000;
      };
      shellAliases = import ../home/aliases.nix;
      defaultKeymap = "emacs";
      initContent = lib.mkMerge [
        (lib.mkOrder 550 (builtins.readFile ../home/pre-compinit.zsh))
        (lib.mkOrder 1000 (builtins.readFile ../home/post-compinit.zsh))
      ];
      completionInit = "autoload -Uz compinit && compinit";

      sessionVariables = rec {
        NVIM_TUI_ENABLE_TRUE_COLOR = "1";

        EDITOR = "vim";
        VISUAL = EDITOR;
        GIT_EDITOR = EDITOR;

        CHEAT_CONFIG_PATH = "${config.home.homeDirectory}/dotfiles/cheat/conf.yml";

        GOPATH = "$HOME/go";
        PATH = "$PATH:$GOPATH/bin:$HOME/.local/bin";
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

      bat = {
        enable = true;
        syntaxes.ghostty = {
          src = pkgs.ghostty-bin;
          file = "Applications/Ghostty.app/Contents/Resources/bat/syntaxes/ghostty.sublime-syntax";
        };
        config.map-syntax = [ "${config.xdg.configHome}/ghostty/config:Ghostty Config" ];
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf.enable = true;

      neovim = {
        enable = true;
        vimAlias = true;
        withRuby = false;
        withPython3 = false;
        plugins = with pkgs.vimPlugins; [
           # Language + Syntax
           vim-nix
           vim-ruby
           vim-go
           vim-terraform
           rust-vim
           vim-rails

           (nvim-treesitter.withPlugins (
             plugins: with plugins; [
               # tree-sitter-bash
               tree-sitter-c
               tree-sitter-cpp
               tree-sitter-dockerfile
               tree-sitter-fish
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
           gruvbox-material
           pkgs.ghostty-bin.vim # syntax for ~/.config/ghostty/config
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
           vim-eunuch # :Rename foo.rb # todo - do i need this? telescope can probably do this stuff for me. Don't thinnk i've ever used
           # vim-sneak # Or leap.nvim || hop.nvim
           ale # linting - ALEFix
           tabular # TODO add https://github.com/tjdevries/config_manager/blob/7958de40dac4400a244ab5a0f04b9a9e60202fab/xdg_config/nvim/after/plugin/tabular.vim -- todo: don't think i've ever used this..
           # nerdtree

           # Buffer / Pane / File Management
           telescope-nvim
           telescope-file-browser-nvim
           telescope-fzf-native-nvim

           # Panes / Larger features
           # tagbar - look into

           # Git
           vim-fugitive # Gblame

           # lsp
           nvim-lspconfig

           # completion
           # check out blink.nvim as replacement for nvim-cmp
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
           friendly-snippets

           # Lua
           plenary-nvim
           # popup-nvim

           # testing
           neotest
           neotest-go
           neotest-rspec
           neotest-python
           neotest-plenary

           # Check out
           nvim-dap
           nvim-dap-ui
           nvim-dap-python
           # hunk-nvim
           # packer.nvim
           # undotree
           # refactoring.nvim https://github.com/ThePrimeagen/refactoring.nvim?tab=readme-ov-file
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

       gpg = {
         enable = true;
       };

       password-store = {
         enable = true;
         # Set this explicitly. home-manager's legacy default (for
         # home.stateVersion < 25.11, i.e. ours) is exactly this value, but the
         # default is suppressed the moment `settings` is assigned at all -- so
         # `settings = { }` exports no PASSWORD_STORE_DIR, pass falls back to
         # ~/.password-store, which has no .gpg-id, and aws-vault's pass backend
         # dies with "You must run: pass init your-gpg-id".
         settings = {
           PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
         };
       };

       rbenv = {
        enable = true;
       };

       # Ghostty itself is installed system-wide as `ghostty-bin` in darwin.nix
       # (pkgs.ghostty doesn't build on darwin), so `package = null` here means
       # home-manager only manages ~/.config/ghostty and doesn't try to install it.
       ghostty = {
         enable = true;
         package = null;

         settings = {
           # Same palette neovim renders with `colorscheme gruvbox-material`
           # at its defaults (medium background, material foreground). Follows
           # the macOS appearance; neovim >= 0.10 queries the terminal
           # background (OSC 11) on startup, so it tracks this on its own.
           theme = "dark:Gruvbox Material Dark,light:Gruvbox Material Light";

           font-size = 13;

           macos-option-as-alt = true;
           window-padding-x = 4;
           window-padding-y = 4;
           copy-on-select = "clipboard";
         };
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
    "nvim".source = ../xdg-config/nvim;
    "ideavim/ideavimrc".text = builtins.readFile ../home/ideavimrc;
  };

}
