local M = {
  'lervag/vimtex',
}

function M.config()
  -- NOTE: skim config: nvim --headless -c "VimtexInverseSearch %line '%file'"
  vim.g.vimtex_view_method = 'skim'
  vim.g.vimtex_view_skim_sync = 1
  vim.g.vimtex_view_skim_activate = 1

  vim.g.vimtex_mappings_prefix = "<leader>v"
  vim.g.vimtex_quickfix_open_on_warning = 0
  vim.g.vimtex_toc_config = {
    indent_levels = 1,
    show_help = 0,
    layers = {
      'content',
    }
  }
end

return M
