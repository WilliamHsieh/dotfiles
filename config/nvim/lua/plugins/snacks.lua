---@module "snacks"
return {
  "folke/snacks.nvim",
  priority = 1000,

  ---@type snacks.config
  opts = {
    quickfile = { enabled = true },
    input = { enabled = true },
  },
}
