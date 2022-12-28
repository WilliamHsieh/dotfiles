local M = {
  'glepnir/lspsaga.nvim',
  cmd = "Lspsaga",
}

function M.config()
  require('lspsaga').init_lsp_saga {
    finder_action_keys = {
      open = "<CR>",
      vsplit = "v",
      split = "s",
      quit = "q",
      scroll_down = "<C-d>",
      scroll_up = "<C-u>",
    },
  }
end

return M
