require "core.setting"
require "core.plugins"
require "core.autocmd"

-- TODO: set nofoldenable

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    require "core.mapping"
  end
})

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldenable = false
