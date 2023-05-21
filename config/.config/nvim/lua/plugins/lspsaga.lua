local M = {
  'glepnir/lspsaga.nvim',
  cmd = "Lspsaga",
}

M.opts = {
  scroll_preview = {
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  finder = {
    keys = {
      edit = "<CR>",
      vsplit = "v",
      split = "s",
    }
  },
  symbol_in_winbar = {
    enable = true,
  }
}

return M
