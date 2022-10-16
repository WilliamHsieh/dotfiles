local config = require("module.tools.config")

local plugins = {
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    module = "telescope",
    ft = "alpha",
    config = config.telescope
  },

  ["ahmedkhalf/project.nvim"] = {
    after = "telescope.nvim",
    config = config.project
  },

  ["nvim-telescope/telescope-ui-select.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },

  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    after = "telescope.nvim",
    run = "make -j",
    config = function()
      require("telescope").load_extension "fzf"
    end,
  },

  ["lewis6991/gitsigns.nvim"] = {
    event = "BufRead",
    config = config.gitsigns
  },

  ["rhysd/conflict-marker.vim"] = {},
}

return plugins
