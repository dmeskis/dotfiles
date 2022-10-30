-- init.lua
local o = vim.o -- global options
local wo = vim.wo --window-local options
local bo = vim.bo -- buffer-local options
local map = vim.api.nvim_set_keymap
local os = os

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
o.backupdir = os.getenv("HOME") .. '/.local/state/nvim/backup//'
o.directory = os.getenv("HOME") .. '/.local/state/nvim/swap//'
o.undodir = os.getenv("HOME") .. '/.local/state/nvim/undo//'
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
		vim.keymap.set('n', '<c-s>', vim.lsp.buf.signature_help, {buffer=0})
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {buffer=0})
		vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, {buffer=0})
		vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, {buffer=0})
		vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, {buffer=0})
		vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, {buffer=0})
		vim.keymap.set('n', '<leader>dl', "<cmd>Telescope diagnostics<cr>", {buffer=0})
		vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, {buffer=0})
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer=0})
	end,
}
-- }}}
	
-- }}}


-- completion {{{
local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup{
	-- more to do here
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
		["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		["<C-y>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		},

		["<c-space>"] = cmp.mapping {
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
				)
				if cmp.visible() then
					if not cmp.confirm { select = true } then
						return
					end
				else
					cmp.complete()
				end
			end,
		},

		["<tab>"] = cmp.config.disable,
	},
	-- Order matters (by default). That gives them priority
	-- you can configure:
	-- 	keyword_length
	-- 	priority
	-- 	max_item_count
	-- 	(more?)
	sources = {
		-- you can only enable for specific file types, but the source knows to do that
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
		-- TODO: watch youtube.com/watch?v=_Dnmphlwnjo around 26 min & add github_issues
	},

	formatting = {
		format = lspkind.cmp_format {
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
			}
		}
	},

	-- TODO add Highlight groups, can highlight deprecated functions and other fun things
}

-- }}}

-- Plugin config {{{

-- nvim-telescope telescope.nvim {{{
-- https://github.com/tjdevries/config_manager/blob/286d247041868b45fbd00c972af8e5d0aeb24caa/xdg_config/nvim/lua/tj/telescope/mappings.lua
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

