-- init.lua
local o = vim.o -- global options
local wo = vim.wo --window-local options
local bo = vim.bo -- buffer-local options
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
o.clipboard = 'unnamed'
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
vim.keymap.set('n', '<leader>sv', ':source ~/dotfiles/nix/xdg-config/nvim/init.lua<cr>', options)
vim.keymap.set('n', '<leader>ev', ':edit ~/dotfiles/nix/xdg-config/nvim/init.lua<cr>', options)

-- kj = <esc>
vim.keymap.set('i', 'kj', '<esc>', options)
vim.keymap.set('c', 'kj', '<esc>', options)
vim.keymap.set('v', 'kj', '<esc>', options)

-- Jumping between windows
vim.keymap.set('n', '<C-h>', '<C-w>h', options)
vim.keymap.set('n', '<C-j>', '<C-w>j', options)
vim.keymap.set('n', '<C-k>', '<C-w>k', options)
vim.keymap.set('n', '<C-l>', '<C-w>l', options)

-- }}}

-- native lsp config {{{
-- TODO: Look into using mason.nvim to manage this stuff

local lspconfig = require 'lspconfig'

local servers = {
	gopls = true,
	solargraph = true,
        terraformls = true,
	pylsp = true,
        pyright = true,
}

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
      vim.lsp.buf.format({async=false})
  end,
  -- callback = vim.lsp.buf.formatting_sync,
})

-- TODO: Determine if omnifunc is worth using
-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

-- TODO: do some sort of formatting, when to use this vs Ale?
--   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)


local custom_attach = function()
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0})
	vim.keymap.set('n', '<c-s>', vim.lsp.buf.signature_help, {buffer=0})
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {buffer=0})
	vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, {buffer=0})
	vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, {buffer=0})
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, {buffer=0})
	vim.keymap.set('n', '<leader>df', "<cmd>Telescope diagnostics<cr>", {buffer=0})
	vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, {buffer=0})
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer=0})
	--- Diagnostics - TODO determine if i should move this out of LSP custom_attach
	vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, {buffer=0})
	vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, {buffer=0})
	vim.keymap.set('n', '<leader>sl', function()vim.diagnostic.open_float(0,{scope='line'})end, {buffer=0})
end

-- lua {{{
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup({
	on_attach = custom_attach,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
-- }}}

local setup_server = function(server, config)
	if not config then
		return
	end

	if type(config) ~= "table" then
		config = {}
	end


	config = vim.tbl_deep_extend("force", {
		on_attach = custom_attach,
	}, config)

	lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
	setup_server(server, config)
end

-- }}}


-- completion + snippets {{{
local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup{
        -- i -- insert
        -- x -- visual
        -- s -- select
        -- c -- cmdline
        -- S-Tab -- Shift-Tab
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
		["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		},

		["<c-space>"] = cmp.mapping {
			i = cmp.mapping.complete(), -- Opens the suggestions
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
                -- I don't think this does anything w/ my current config.. 
                ["<c-r>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
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
		{ name = "luasnip" },
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

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,

	},

	-- TODO add Highlight groups, can highlight deprecated functions and other fun things
}

-- }}}

-- Plugin config {{{

-- nvim-telescope telescope.nvim {{{
-- https://github.com/tjdevries/config_manager/blob/286d247041868b45fbd00c972af8e5d0aeb24caa/xdg_config/nvim/lua/tj/telescope/mappings.lua

local builtin = require('telescope.builtin')


local function find_files()
  -- local opts = themes.get_ivy {
  --   hidden = false,
  --   sorting_strategy = "ascending",
  --   layout_config = { height = 9 },
  -- }
  builtin.find_files {
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
    layout_config = {
      -- height = 10,
    },
  }
end

-- function M.curbuf()
--   local opts = themes.get_dropdown {
--     winblend = 10,
--     border = true,
--     previewer = false,
--     shorten_path = false,
--   }
--   require("telescope.builtin").current_buffer_fuzzy_find(opts)
-- end
local function search_all_files()
  require("telescope.builtin").find_files({hidden=true})
end

-- local function grep_prompt()
--   require("telescope.builtin").grep_string {
--     path_display = { "shorten" },
--     search = vim.fn.input "Grep String > ",
--   }
-- end

-- local function fs()
--   require("telescope.builtin").find_files({hidden=false, sorting_strategy = "descending"})
-- end

-- search
-- vim.keymap.set('n', '<leader>fs', fs, {})
vim.keymap.set('n', '<leader>fa', search_all_files, {})
vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fd', find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fe', ":Telescope file_browser<CR>", { noremap = true })
-- vim.keymap.set('n', '<leader>gp', grep_prompt, { noremap = true })

-- map_tele("<space>gp", "grep_prompt")

require("telescope").setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}

require("telescope").load_extension "fzf"
require("telescope").load_extension "file_browser"
-- }}}

-- nvim-treesitter {{{
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true, } }
-- }}}

-- lualine {{{
require('lualine').setup {
  options = {
      theme = 'gruvbox-material',
      always_divide_middle = true;
  }
}
-- }}}

-- vim-go {{{
-- TOOD: fix this, for some reason GOBIN isn't working w/ nix, :help GoInstallBinaries not very helpful
vim.g['go_bin_path'] = '/Users/dylanmeskis/go/bin'
vim.cmd [[
let g:go_metalinter_command = 'golangci-lint'
let g:go_metalinter_autosave_enabled = []
let g:go_metalinter_enabled = []
let g:go_fmt_command = 'goimports'
]]
-- }}}
