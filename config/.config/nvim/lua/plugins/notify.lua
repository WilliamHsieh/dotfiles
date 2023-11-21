local M = {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<C-L>",
      function()
        require("notify").dismiss({ silent = true, pending = true })
        ---@diagnostic disable-next-line: param-type-mismatch
        pcall(vim.cmd, "nohlsearch | diffupdate | mode")
      end,
      desc = "Dismiss all Notifications and refresh",
    },
  },
}

function M.init()
  vim.notify = function(...)
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

    vim.notify(...)
  end
end

return M
