local config = require("module.others.config")

local plugins = {
  ["phaazon/hop.nvim"] = {
    cmd = { 'HopChar2', 'HopWord' },
    config = config.hop
  },

  ["kevinhwang91/nvim-bqf"] = {
    ft = "qf"
  },

  ["michaelb/sniprun"] = {
    run = "bash ./install.sh",
    cmd = { "SnipClose", "SnipRun", "SnipInfo", "SnipReplMemoryClean", "SnipReset", "SnipRunToggle", "SnipTerminate", },
    config = function() require('sniprun').setup() end
  },

  ["mbbill/undotree"] = {
    cmd = "UndotreeToggle"
  },

  ['Shatur/neovim-session-manager'] = {
    config = config.session_manager
  },

  ['declancm/cinnamon.nvim'] = {
    config = function() require('cinnamon').setup() end
  },

  ['lervag/vimtex'] = {
    config = config.vimtex
  },
}

return plugins
