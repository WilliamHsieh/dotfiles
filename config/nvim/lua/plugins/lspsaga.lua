local M = {
  "glepnir/lspsaga.nvim",
  cmd = "Lspsaga",
}

M.opts = {
  scroll_preview = {
    scroll_down = "<C-d>",
    scroll_up = "<C-u>",
  },
  finder = {
    keys = {
      edit = "<CR>",
      vsplit = "v",
      split = "s",
    },
  },
  definition = {
    width = 0.8,
    height = 0.6,
  },
  callhierarchy = {
    keys = {
      edit = "<CR>",
    },
  },
  lightbulb = {
    enable = true,
    sign = false,
    virtual_text = true,
  },
  symbol_in_winbar = {
    enable = false,
  },
}

return M
