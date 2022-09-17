local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.basics.config")

-- Plugin manager
use {
  "wbthomason/packer.nvim",
  cmd = { "PackerSync", "PackerCompile", "PackerProfile", "PackerStatus" },
  config = function()
    require("core.plugins")
  end
}

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

-- Keymap
use {
  "folke/which-key.nvim",
  keys = { "<leader>", '"', "'", "g", "m" },
  config = config.whichkey
}

return plugins
