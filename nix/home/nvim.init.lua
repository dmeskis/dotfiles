-- init.lua
local o = vim.o -- global options
local wo = vim.wo --window-local options
local bo = vim.bo -- buffer-local options
local map = vim.api.nvim_set_keymap

vim.g.colorscheme = 'gruvbox'

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
map('n', '<leader>sv', ':source ~/dotfiles/nix/home/nvim.init.lua<cr>', options)
map('n', '<leader>ev', ':edit ~/dotfiles/nix/home/nvim.init.lua<cr>', options)

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

-- Plugin config {{{

-- nvim-telescope telescope.nvim {{{
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- }}}




-- lualine {{{
require('lualine').setup {
  options = {
      theme = 'gruvbox',
      always_divide_middle = true;
  }
}
-- }}}

