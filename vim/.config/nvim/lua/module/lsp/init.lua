local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.lsp.config")

use {
  "williamboman/mason-lspconfig.nvim",
  requires = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = config.lsp
}

use {
  "ray-x/lsp_signature.nvim",
  after = "nvim-lspconfig",
  config = config.signature
}

use {
  'glepnir/lspsaga.nvim',
  cmd = "Lspsaga",
  config = config.lspsaga
}

use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight

use {
  "b0o/SchemaStore.nvim",
  ft = "json"
}

use {
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
}

use {
  "preservim/tagbar",
  cmd = "TagbarToggle"
}

use {
  "simrat39/symbols-outline.nvim",
  cmd = "SymbolsOutline",
  config = config.outline
}

return plugins
