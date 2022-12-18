local config = require("module.lsp.config")

local plugins = {
  ["williamboman/mason-lspconfig.nvim"] = {
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "folke/neodev.nvim",
    },
    config = config.lsp
  },

  ["SmiteshP/nvim-navic"] = {
    requires = "neovim/nvim-lspconfig",
    config = config.navic
  },

  ["ray-x/lsp_signature.nvim"] = {
    after = "nvim-lspconfig",
    config = config.signature
  },

  ['glepnir/lspsaga.nvim'] = {
    cmd = "Lspsaga",
    config = config.lspsaga
  },

  ["b0o/SchemaStore.nvim"] = {
    ft = "json"
  },

  ["folke/trouble.nvim"] = {
    cmd = "TroubleToggle",
  },

  ["preservim/tagbar"] = {
    cmd = "TagbarToggle"
  },

  ["simrat39/symbols-outline.nvim"] = {
    cmd = "SymbolsOutline",
    config = config.outline
  },
}

return plugins
