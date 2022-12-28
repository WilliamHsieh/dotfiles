local M = {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
}

function M.config()
  local icons = require "core.icons"
  vim.notify = require("notify")

  vim.notify.setup {
    stages = "fade_in_slide_out",
    minimum_width = 10,
    icons = {
      ERROR = icons.diagnostics.Error,
      WARN = icons.diagnostics.Warning,
      INFO = icons.diagnostics.Information,
      DEBUG = icons.ui.Bug,
      TRACE = icons.ui.Pencil,
    },
    on_open = function (win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  }
end

return M
