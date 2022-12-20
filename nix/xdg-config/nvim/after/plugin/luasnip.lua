-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua

local ls = require "luasnip"
local types = require "luasnip.util.types"

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/dm/snips/ft/*.lua", true)) do
  loadfile(ft_path)()
end

require("luasnip.loaders.from_vscode").lazy_load()
require'luasnip'.filetype_extend("ruby", {"rails"})

ls.config.set_config {
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " « ", "GruvboxOrange" } },
      },
    },
  },
}

-- Jump to next node
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- Jump to previous node
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Cycle choices
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("i", "<c-h>", function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")
vim.keymap.set('n', '<leader><leader>s', ':runtime! ~/dotfiles/nix/xdg-config/nvim/lua/dm/snips/**/*.lua<cr>', options)
