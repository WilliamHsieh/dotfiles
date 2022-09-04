local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.highlight.config")

use {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  event = { "BufRead", "BufNewFile" },
  module = "nvim-treesitter",
  cmd = "TSUpdate",
  config = config.treesitter
}

use {
  "p00f/nvim-ts-rainbow",
  after = "nvim-treesitter",
}

use {
  "andymass/vim-matchup", -- TODO: this is SUPPER slow
  after = "nvim-treesitter",
}

use {
  "JoosepAlviste/nvim-ts-context-commentstring",
  module = "ts_context_commentstring",
}
use {
  "nvim-treesitter/playground",
  cmd = { "TSPlaygroundToggle" , "TSHighlightCapturesUnderCursor" }
}

use {
  "windwp/nvim-ts-autotag",
  after = "nvim-treesitter",
  config = config.autotag
}

use {
  "windwp/nvim-autopairs",
  after = "nvim-treesitter",
  config = config.autopairs
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
  config = config.twilight
}

use {
  "folke/zen-mode.nvim",
  after = "twilight.nvim",
  config = config.zen
}

return plugins
