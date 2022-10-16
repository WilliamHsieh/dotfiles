local config = require("module.tools.config")

local plugins = {
  -- TODO: searching in symlinks: https://github.com/nvim-telescope/telescope.nvim/issues/394#issuecomment-966285634
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    module = "telescope",
    ft = "alpha",
    wants = "telescope-ui-select.nvim",
    config = config.telescope
  },

  ["ahmedkhalf/project.nvim"] = {
    after = "telescope.nvim",
    config = config.project
  },

  ["nvim-telescope/telescope-ui-select.nvim"] = {
    opt = true,
  },

  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    after = "telescope.nvim",
    run = "make -j",
    config = function()
      require("telescope").load_extension "fzf"
    end,
  },

  ["MattesGroeger/vim-bookmarks"] = {
    event = "BufRead",
    config = config.bookmark
  },

  ["tom-anders/telescope-vim-bookmarks.nvim"] = {
    after = { "telescope.nvim", "vim-bookmarks" },
    config = function()
      require('telescope').load_extension('vim_bookmarks')
    end
  },

  ["lewis6991/gitsigns.nvim"] = {
    event = "BufRead",
    config = config.gitsigns
  },

  ["rhysd/conflict-marker.vim"] = {},
}

return plugins
