{ lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    plugins =
      (with pkgs.vimPlugins; [
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
      ])

      # Syntax for ~/.config/ghostty/config, shipped inside the app bundle.
      # ghostty-bin is darwin-only; a Linux host would use pkgs.ghostty.vim.
      # Spliced in here rather than appended so plugin order is unchanged.
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.ghostty-bin.vim ]

      ++ (with pkgs.vimPlugins; [
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
        # vim-sneak # Or leap.nvim || hop.nvim
        ale # linting - ALEFix
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
      ]);
  };

  xdg.configFile = {
    "nvim".source = ../../xdg-config/nvim;
  };
}
