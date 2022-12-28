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
    -- FIX: not working
    modes_denylist = {
      "v", "CTRL-V"
    },
  }
end

return M
