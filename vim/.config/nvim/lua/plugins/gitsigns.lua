local M = {
  "lewis6991/gitsigns.nvim",
  cmd = "GitSigns",
}

function M.config()
  require("gitsigns").setup {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
    },
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
      delay = 0,
      ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
      relative_time = false,
    },
    preview_config = {
      border = "rounded",
    },
  }
end

return M
