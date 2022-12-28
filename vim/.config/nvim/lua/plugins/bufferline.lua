local M = {
  "akinsho/bufferline.nvim",
  dependencies = {
    "moll/vim-bbye",
    {
      "tiagovla/scope.nvim",
      config = true,
    },
  }
}

function M.config()
  require("bufferline").setup {
    options = {
      numbers = "none",
      close_command = "Bdelete %d",
      right_mouse_command = "Bdelete %d",
      diagnostics = false,
      diagnostics_update_in_insert = false,
      offsets = { {
        filetype = "NvimTree",
        text = function ()
          return " " .. vim.fn.strftime("%T")
        end, padding = 0
      } },
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      separator_style = "slant",
      always_show_bufferline = true,
      sort_by = "insert_after_current",
      hover = {
        enabled = true,
        delay = 100,
        reveal = { 'close' },
      },
    },
    highlights = require("catppuccin.groups.integrations.bufferline").get(),
  }

  local timer = vim.loop.new_timer()
  timer:start(1000, 1000, vim.schedule_wrap(function()
    vim.cmd("redrawtabline")
  end))
end

return M
