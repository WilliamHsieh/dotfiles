local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.basics.config")

use "wbthomason/packer.nvim"

-- Useful api
use "nvim-lua/popup.nvim"
use "nvim-lua/plenary.nvim"

-- Notification
use {
  "rcarriga/nvim-notify",
  after = "vscode.nvim",
  config = config.notify
}

-- Profiling
use "lewis6991/impatient.nvim"

-- Comment
use {
  "numToStr/Comment.nvim",
  module = "Comment",
  config = config.comment
}

-- floating terminal
use {
  "akinsho/toggleterm.nvim",
  module = "toggleterm",
  cmd = "ToggleTerm",
  config = config.toggleterm
}

-- keymap
use {
  "folke/which-key.nvim",
  config = config.whichkey
}

return plugins
