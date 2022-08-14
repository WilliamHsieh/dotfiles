local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.highlight.config")

use {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  event = { "BufRead", "BufNewFile" },
  module = "nvim-treesitter",
  wants = { "nvim-ts-autotag", "nvim-ts-rainbow", "nvim-ts-context-commentstring", "playground" },
  cmd = { "TSInstall", "TSInstallInfo", "TSInstallSync", "TSUninstall", "TSUpdate", "TSUpdateSync", "TSDisableAll", "TSEnableAll" },
  config = config.treesitter
}
use { "windwp/nvim-ts-autotag", opt = true, }
use { "p00f/nvim-ts-rainbow", opt = true, }
use { "JoosepAlviste/nvim-ts-context-commentstring", opt = true, }
use { "nvim-treesitter/playground", opt = true }

use {
  "windwp/nvim-autopairs",
  after = "nvim-treesitter",
  config = config.autopairs
}

use {
  "andymass/vim-matchup", -- TODO: this is SUPPER slow
  after = "nvim-treesitter",
}

use {
  "norcalli/nvim-colorizer.lua",
  after = "nvim-treesitter",
  config = config.colorizer
}

use {
  "folke/todo-comments.nvim",
  after = "nvim-treesitter",
  config = config.todo
}

use {
  "RRethy/vim-illuminate",
  after = "nvim-treesitter",
  module = "illuminate",
  config = config.illuminate
}

use {
  "lukas-reineke/indent-blankline.nvim",
  after = "nvim-treesitter",
  config = config.indentline
}

use {
  "folke/twilight.nvim",
  cmd = "ZenMode",
  config = function()
    require('twilight').setup()
  end
}

use {
  "folke/zen-mode.nvim",
  after = "twilight.nvim",
  config = config.zen
}

return plugins
