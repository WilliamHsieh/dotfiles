---@module "snacks"
return {
  "folke/snacks.nvim",
  priority = 1000,

  ---@type snacks.config
  opts = {
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 12, total = 210 },
      },
    },
    input = { enabled = true },
  },
}
