local M = {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<C-L>",
      function()
        require("notify").dismiss { silent = true, pending = true }
        ---@diagnostic disable-next-line: param-type-mismatch
        pcall(vim.cmd, "nohlsearch | diffupdate | mode")
        pcall(require("focus").focus_autoresize)
      end,
      desc = "Dismiss all Notifications and refresh",
    },
  },
}

function M.init()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(...)
    ---@diagnostic disable-next-line: missing-fields
    require("notify").setup {
      stages = "fade_in_slide_out",
      minimum_width = 10,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { focusable = false })
      end,
    }

    vim.notify = require("notify")
    vim.notify(...)
  end
end

return M
