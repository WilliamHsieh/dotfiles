local M = {
  "akinsho/bufferline.nvim",
  event = "LazyFile",
}

function M.config()
  require("bufferline").setup {
    options = {
      mode = "tabs",
      numbers = "none",
      show_close_icon = false,
      separator_style = "slant",
      always_show_bufferline = false,
      hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      },
    },
    highlights = require("catppuccin.groups.integrations.bufferline").get(),
  }
end

return M
