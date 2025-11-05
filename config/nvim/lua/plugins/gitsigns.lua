local M = {
  "lewis6991/gitsigns.nvim",
  cmd = "GitSigns",
  event = "LazyFile",
}

M.opts = {
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
  },
  signs_staged = {
    add = { text = "▎" },
    change = { text = "▎" },
  },
  current_line_blame_opts = {
    virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
  },
  preview_config = {
    border = "rounded",
  },
  update_debounce = 1000,
}

return M
