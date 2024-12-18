---@module "snacks"
return {
  "folke/snacks.nvim",
  priority = 1000,

  ---@type snacks.config
  opts = {
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    input = { enabled = true },
  },
}
