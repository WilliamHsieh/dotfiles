local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.ui.config")

use "folke/tokyonight.nvim"
use "rose-pine/neovim"
use "rebelot/kanagawa.nvim"
use "EdenEast/nightfox.nvim"
use "marko-cerovac/material.nvim"
use "shaunsingh/nord.nvim"
use "catppuccin/nvim"
use 'Mofiqul/dracula.nvim'
use 'glepnir/zephyr-nvim'
use {
  'Mofiqul/vscode.nvim',
  config = config.vscode
}

use "kyazdani42/nvim-web-devicons"

use {
  "goolord/alpha-nvim",
  config = config.alpha
}

use {
  "kyazdani42/nvim-tree.lua",
  cmd = "NvimTreeToggle",
  config = config.tree
}

use {
  "akinsho/bufferline.nvim",
  requires = "moll/vim-bbye",
  config = require("module.ui.bufferline")
}

use {
  'feline-nvim/feline.nvim',
  after = "vscode.nvim",
  config = require("module.ui.feline")
}

return plugins
