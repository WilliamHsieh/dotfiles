local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "LazyFile",
}

M.opts = {
  indent = {
    char = "▏",
  },
  exclude = {
    filetypes = {
      "help",
      "NvimTree",
      "trouble",
    },
  },
}

return M
