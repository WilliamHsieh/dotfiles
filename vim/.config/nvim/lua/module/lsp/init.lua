local config = require("module.lsp.config")

local plugins = {
  ["williamboman/mason-lspconfig.nvim"] = {
    requires = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "antoinemadec/FixCursorHold.nvim",
    },
    config = config.lsp
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
