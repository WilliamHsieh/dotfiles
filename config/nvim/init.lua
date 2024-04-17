require "core.setting"
require "core.plugins"
require "core.autocmd"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    require("core.mapping")
    require("core.utils").signal_handler("sigusr1", function()
      vim.cmd.terminal()
    end)
  end,
})
