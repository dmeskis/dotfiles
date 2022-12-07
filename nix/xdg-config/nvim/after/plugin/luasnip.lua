local ls = require "luasnip"
local types = require "luasnip.util.types"

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/dm/snips/ft/*.lua", true)) do
  loadfile(ft_path)()
end

require("luasnip.loaders.from_vscode").lazy_load()
require'luasnip'.filetype_extend("ruby", {"rails"})

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,
  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
  -- Autosnippets:
  enable_autosnippets = true,
  -- Crazy highlights!!
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " « ", "GruvboxOrange" } },
      },
    },
  },
}

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
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
