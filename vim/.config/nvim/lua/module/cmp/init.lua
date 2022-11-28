local config = require("module.cmp.config")

local plugins = {
  ["rafamadriz/friendly-snippets"] = {
    opt = true,
  },

  ["L3MON4D3/LuaSnip"] = {
    module = "luasnip",
    wants = "friendly-snippets",
  },

  ['hrsh7th/nvim-cmp'] = {
    event = { "InsertEnter", "CmdlineEnter" },
    module = "cmp",
    config = config.cmp
  },

  ["hrsh7th/cmp-buffer"] = {
    after = "nvim-cmp"
  },
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp"
  },
  ["hrsh7th/cmp-emoji"] = {
    after = "nvim-cmp"
  },
  ["hrsh7th/cmp-path"] = {
    after = "nvim-cmp"
  },
  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "nvim-cmp",
    module = "cmp_nvim_lsp"
  },
  ["hrsh7th/cmp-nvim-lua"] = {
    after = "nvim-cmp"
  },
  ["saadparwaiz1/cmp_luasnip"] = {
    after = "nvim-cmp"
  },
}

return plugins
