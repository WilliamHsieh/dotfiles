local config = require("module.basics.config")

local plugins = {
  ["wbthomason/packer.nvim"] = {
    cmd = { "PackerSync", "PackerCompile", "PackerProfile", "PackerStatus" },
    config = function()
      require("core.plugins")
    end
  },

  ["nvim-lua/popup.nvim"] = {},
  ["nvim-lua/plenary.nvim"] = {},
  ["lewis6991/impatient.nvim"] = {},

  ["rcarriga/nvim-notify"] = {
    config = config.notify
  },

  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    config = config.comment
  },

  ["akinsho/toggleterm.nvim"] = {
    module = "toggleterm",
    cmd = { "ToggleTerm", "TermExec" },
    config = config.toggleterm
  },

  ["folke/which-key.nvim"] = {
    keys = { "<leader>", '"', "'", "g", "m" },
    config = config.whichkey
  }
}

return plugins
