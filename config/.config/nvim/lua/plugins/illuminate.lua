local M = {
  "RRethy/vim-illuminate",
  lazy = true,
}

function M.config()
  require('illuminate').configure {
    providers = {
      'lsp',
      'treesitter',
    },
    filetypes_denylist = {
      'alpha',
      'NvimTree',
      'toggleterm',
    },
    modes_denylist = {
      "v", "vs", "V", "Vs", "CTRL-V", "CTRL-Vs"
    },
  }
end

return M
