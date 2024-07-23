---@module "ibl"
local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "LazyFile",
}

---@type ibl.config?
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
  scope = {
    show_start = false,
    show_end = false,
  },
}

return M
