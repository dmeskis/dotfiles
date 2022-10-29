-- init.lua
local o = vim.o -- global options
local wo = vim.wo --window-local options
local bo = vim.bo -- buffer-local options
local map = vim.api.nvim_set_keymap

require('colorbuddy').colorscheme('gruvbox-material')

-- Hacks & quickfixes {{{
-- https://github.com/nvim-telescope/telescope.nvim/issues/2145
vim.cmd('hi NormalFloat ctermfg=LightGrey')
-- }}}


o.number = true
o.relativenumber = true

-- map*leader {{{
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
-- }}}


-- Backup/swap/undo directories {{{
o.backupdir = '~/.config/nvim/backup'
o.directory = '~/.config/nvim/swaps'
o.undodir = '~/.config/nvim/undo'
o.undofile = true
-- }}}

-- Environment {{{
-- map */+ registers to macOS pastebuffer
o.clipboard = unnamed
-- }}}

-- Search {{{
o.ignorecase = true
o.smartcase = true
-- }}}

-- Whitespace {{{
vim.g.tabspace = 4
vim.g.tabstop = 4
bo.softtabstop = 4
bo.shiftwidth = 4
bo.expandtab = true
vim.opt.listchars = {
    tab = '»·',
    trail = '·'
}

-- Misc {{{
o.scrolljump=5
o.scrolloff=3
-- }}}

-- Mappings {{{
options = { noremap = true }
map('n', '<leader>sv', ':source ~/dotfiles/nix/home/init.lua<cr>', options)
map('n', '<leader>ev', ':edit ~/dotfiles/nix/home/init.lua<cr>', options)

-- kj = <esc> {{{
map('i', 'kj', '<esc>', options)
map('c', 'kj', '<esc>', options)
map('v', 'kj', '<esc>', options)

-- Jumping between windows
map('n', '<C-h>', '<C-w>h', options)
map('n', '<C-j>', '<C-w>j', options)
map('n', '<C-k>', '<C-w>k', options)
map('n', '<C-l>', '<C-w>l', options)
-- }}}

-- native lsp config {{{

-- golang {{{
require 'lspconfig'.gopls.setup{
	on_attach = function()
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0})
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
		vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {buffer=0})
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=0})
		vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, {buffer=0})
		vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, {buffer=0})
		vim.keymap.set('n', '<leader>dl', "<cmd>Telescope diagnostics<cr>", {buffer=0})
		vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {buffer=0})
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer=0})
	end,
}
-- tell nvim to use gopls
-- }}}
	
-- }}}




-- Plugin config {{{

-- nvim-telescope telescope.nvim {{{
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- }}}

-- nvim-treesitter {{{
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    }
}
-- }}}

-- lualine {{{
require('lualine').setup {
  options = {
      theme = 'gruvbox-material',
      always_divide_middle = true;
  }
}
-- }}}

