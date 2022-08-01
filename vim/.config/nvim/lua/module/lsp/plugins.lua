local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.lsp.config")

use {
  "neovim/nvim-lspconfig",
  module = "lspconfig",
  event = "BufRead",
}

use {
  "jose-elias-alvarez/null-ls.nvim",
  after = "nvim-lspconfig",
  config = function ()
    require('null-ls').setup()
  end
}

use {
  "ray-x/lsp_signature.nvim",
  opt = true,
  config = config.signature
}

use {
  'tami5/lspsaga.nvim',
  opt = true,
  config = config.lspsaga
}

use {
  "williamboman/nvim-lsp-installer",
  after = "nvim-lspconfig",
  wants = { "lsp_signature.nvim", "lspsaga.nvim" },
  config = config.lsp
}

use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
use "b0o/SchemaStore.nvim"
use {
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
}

-- Tagbar
use {
  "preservim/tagbar",
  cmd = "TagbarToggle"
}

use {
  "simrat39/symbols-outline.nvim",
  after = "nvim-lspconfig",
  config = config.outline
}

return plugins
