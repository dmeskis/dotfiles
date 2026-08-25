-- init.lua
local o = vim.o -- global options
local wo = vim.wo --window-local options
local bo = vim.bo -- buffer-local options
local os = os

vim.cmd('colorscheme gruvbox-material')

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
-- nvim-lspconfig >= 2.0 is just a bundle of `lsp/<name>.lua` default configs
-- (cmd/filetypes/root_markers) that vim.lsp.config reads off the runtimepath.
-- The old `require('lspconfig').<server>.setup{}` framework is deprecated and
-- goes away in nvim-lspconfig v3. See :help lspconfig-nvim-0.11
-- TODO: Look into using mason.nvim to manage the server binaries

-- Default log level is WARN already, but solargraph streams gem warnings over
-- stderr, which nvim logs at ERROR -- that grew lsp.log to 3.3GB. Keep it off
-- unless actively debugging a server (:lua vim.lsp.set_log_level('debug')).
vim.lsp.log.set_level('off')

-- Buffer-local keymaps for whatever server attaches. Replaces the old
-- per-server on_attach + setup_server wrapper.
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local opts = { buffer = args.buf }
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<c-s>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>df', '<cmd>Telescope diagnostics<cr>', opts)
		vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
		--- Diagnostics - TODO determine if i should move this out of LspAttach
		vim.keymap.set('n', '<leader>dn', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
		vim.keymap.set('n', '<leader>dp', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
		vim.keymap.set('n', '<leader>sl', function() vim.diagnostic.open_float(0, { scope = 'line' }) end, opts)
	end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.tf', '*.tfvars' },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- TODO: do some sort of formatting, when to use this vs Ale?

-- lua {{{
-- Pattern lifted from nvim-lspconfig's lsp/lua_ls.lua docs: only teach lua_ls
-- about the neovim runtime when the workspace doesn't ship its own .luarc.json.
-- Note the narrow `library` -- nvim_get_runtime_file('', true) pulls in every
-- plugin and is slow enough to cause problems (lspconfig issue #3189).
vim.lsp.config('lua_ls', {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath('config')
				and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				version = 'LuaJIT',
				-- Find lua modules the same way neovim does (:h lua-module-load)
				path = { 'lua/?.lua', 'lua/?/init.lua' },
			},
			workspace = {
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				library = { vim.env.VIMRUNTIME },
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = { enable = false },
		})
	end,
	settings = { Lua = {} },
})
-- }}}

-- Defaults from lspconfig's lsp/<name>.lua are enough for these; add a
-- vim.lsp.config('<name>', {...}) block above to override one.
vim.lsp.enable({
	'gopls',
	'lua_ls',
	'pyright',
	'solargraph',
	'terraformls',
})

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
-- Parsers come from pkgs.vimPlugins.nvim-treesitter.withPlugins in common.nix,
-- which lands them (plus their matching queries) in a separate
-- nvim-treesitter-grammars plugin dir, so there is nothing to :TSInstall and no
-- need for tree-sitter-cli. To add a language, add its parser there.
vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		-- language.add returns nil (not an error) when we shipped no parser for
		-- this filetype, which is the common case -- stay quiet and let the
		-- regex syntax from vim-nix/vim-ruby/etc. handle those buffers.
		if lang and vim.treesitter.language.add(lang) then
			vim.treesitter.start(args.buf, lang)
		end
	end,
})
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


-- nvim-dap {{{
-- require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
require('dap-python').setup()
local dap = require('dap')
local dapui = require('dapui')
local dap_python = require('dap-python')

-- set up nvim-dap-ui
dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end

-- keymaps
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, options)
vim.keymap.set('n', '<leader>dB', function()dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))end, options)
vim.keymap.set('n', '<leader>dr', dap.repl.toggle, options)
vim.keymap.set('n', '<leader>dc', dap.continue, options)
vim.keymap.set('n', '<leader>dp', dap.pause, options)
vim.keymap.set('n', '<leader>dt', dap.terminate, options)
vim.keymap.set('n', '<leader>dn', dap.run_to_cursor, options)
vim.keymap.set('n', '<leader>de', dap.step_over, options)
vim.keymap.set('n', '<leader>di', dap.step_into, options)
vim.keymap.set('n', '<leader>do', dap.step_out, options)
vim.keymap.set('n', '<leader>du', dap.up, options)
vim.keymap.set('n', '<leader>dd', dap.down, options)
vim.keymap.set('n', '<leader>dg', function()require('dapui').toggle()end, options)
vim.keymap.set('n', '<leader>dTp', dap_python.test_method, options)

-- adapters
--
-- dap.adapters.python = {
--     type = 'executable';
--     command = '/Users/dylanmeskis/.local/share/nvim/lspinstall/python/node_modules/.bin/pyright-langserver';
--     args = { '--stdio' };
-- }
table.insert(dap.configurations.python, {
  name = 'Dagon Configuration',
  type = 'python',
  request = 'attach',
  connect = {
	  host = 'localhost',
	  port = 5678,
  },
  cwd = vim.fn.getcwd(),
  pathMappings = {
	  {
		  localRoot = function()
			  return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
		  end,
		  remoteRoot = function()
			  return vim.fn.input("Container code folder > ", "/opt/dagster/app", "file")
		  end,
	  },
  },
  justMyCode = true,
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
})

table.insert(dap.configurations.python, {
  name = 'Dagster: Debug dagit',
  type = 'python',
  request = 'launch',
  module = 'dagster',
  args = {'dev'},
  envFile = '/Users/dylanmeskis/code/homebot/dagon/.env',
  justMyCode = true,
})

-- }}}




-- TODO: Finish setting up neotest, might need some additional deps installed
-- require("neotest").setup({
--   adapters = {
--     require("neotest-python")({
--       dap = { justMyCode = false },
--     }),
--     require("neotest-rspec")({
--       dap = { justMyCode = false },
--     }),
--     require("neotest-plenary"),
--     -- require("neotest-vim-test")({
--     --   ignore_file_types = { "python", "vim", "lua" },
--     -- }),
--   },
-- })
-- https://github.com/nvim-lua/plenary.nvim
-- https://github.com/nvim-neotest/neotest
-- https://github.com/rhysd/git-messenger.vim
-- https://github.com/nix-community/nixvim
-- https://github.com/nvimtools/none-ls.nvim
