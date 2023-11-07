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

  local function map(key, dir, buffer)
    vim.keymap.set("n", key, function()
      require("illuminate")["goto_" .. dir .. "_reference"](false)
    end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
  end

  map("]]", "next")
  map("[[", "prev")

  -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      map("]]", "next", buffer)
      map("[[", "prev", buffer)
    end,
  })
end

return M
