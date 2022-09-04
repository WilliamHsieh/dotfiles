local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.cmp.config")

use {
  "rafamadriz/friendly-snippets",
  opt = true,
}

use {
  "L3MON4D3/LuaSnip",
  module = "luasnip",
  wants = "friendly-snippets",
}

use {
  'hrsh7th/nvim-cmp',
  event = { "InsertEnter", "CmdlineEnter" },
  config = config.cmp
}

use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
use { "hrsh7th/cmp-cmdline", after = "nvim-cmp" }
use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
use { "hrsh7th/cmp-path", after = "nvim-cmp" }
use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", module = "cmp_nvim_lsp" }
use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
use { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }

return plugins
