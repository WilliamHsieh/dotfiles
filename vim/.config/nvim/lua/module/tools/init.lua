local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.tools.config")

use {
  -- TODO: searching in symlinks: https://github.com/nvim-telescope/telescope.nvim/issues/394#issuecomment-966285634
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  module = "telescope",
  wants = "telescope-ui-select.nvim",
  config = config.telescope
}

use {
  "ahmedkhalf/project.nvim",
  after = "telescope.nvim",
  config = config.project
}

use {
  "nvim-telescope/telescope-ui-select.nvim",
  opt = true,
}

use {
  "nvim-telescope/telescope-fzf-native.nvim",
  after = "telescope.nvim",
  run = "make -j",
  config = function()
    require("telescope").load_extension "fzf"
  end,
}

use {
  "MattesGroeger/vim-bookmarks",
  event = "BufRead",
  config = config.bookmark
}

use {
  "tom-anders/telescope-vim-bookmarks.nvim",
  after = { "telescope.nvim", "vim-bookmarks" },
  config = function()
    require('telescope').load_extension('vim_bookmarks')
  end
}

use {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  config = config.gitsigns
}
use "rhysd/conflict-marker.vim"

return plugins
