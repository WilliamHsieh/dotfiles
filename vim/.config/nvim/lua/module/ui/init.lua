local config = require("module.ui.config")

local plugins = {
  ["folke/tokyonight.nvim"] = {},
  ["rose-pine/neovim"] = {},
  ["rebelot/kanagawa.nvim"] = {},
  ["EdenEast/nightfox.nvim"] = {},
  ["marko-cerovac/material.nvim"] = {},
  ["shaunsingh/nord.nvim"] = {},
  ["catppuccin/nvim"] = {},
  ["Mofiqul/dracula.nvim"] = {},
  ["glepnir/zephyr-nvim"] = {},
  ['Mofiqul/vscode.nvim'] = {
    config = config.vscode
  },

  ["kyazdani42/nvim-web-devicons"] = {},

  ["goolord/alpha-nvim"] = {
    config = config.alpha
  },

  ["kyazdani42/nvim-tree.lua"] = {
    cmd = "NvimTreeToggle",
    module = "nvim-tree",
    config = config.tree
  },

  ["akinsho/bufferline.nvim"] = {
    requires = "moll/vim-bbye",
    after = { "nvim-web-devicons", "vscode.nvim" },
    disable = true,
    config = require("module.ui.bufferline")
  },

  ['feline-nvim/feline.nvim'] = {
    after = "vscode.nvim",
    config = require("module.ui.feline")
  },

  ["vimpostor/vim-tpipeline"] = {
    config = config.tpipeline
  },
}

return plugins
