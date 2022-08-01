local plugins = {}
local use = require("utils").insert_table(plugins)
local config = require("module.others.config")

use {
  "phaazon/hop.nvim",
  cmd = { 'HopChar2', 'HopWord' },
  config = function()
    require('hop').setup {
      -- keys = 'asdghklqwertyuiopzxcvbnmfj' -- default
      keys = 'awefjio;sdghklqrtyupvbn'
    }
  end
}

-- Markdown
use {
  'preservim/vim-markdown',
  requires = 'godlygeek/tabular',
  ft = 'markdown',
  disable = true
  -- config = 'vim.g.markdown_fenced_languages = { "cpp", "bash", "lua", "python" }'
}
use {
  "iamcco/markdown-preview.nvim",
  run = "cd app && npm install",
  ft = "markdown",
  disable = true
}

-- Others
use "kevinhwang91/nvim-bqf" -- better quickfix window

use { "michaelb/sniprun",
  run = "bash ./install.sh",
  cmd = { "SnipClose", "SnipRun", "SnipInfo", "SnipReplMemoryClean", "SnipReset", "SnipRunToggle", "SnipTerminate", },
  config = function() require('sniprun').setup() end
}

use { "mbbill/undotree", cmd = "UndotreeToggle" }

use { 'tpope/vim-obsession', cmd = "Obsession" }

use {
  'declancm/cinnamon.nvim',
  -- config = function() require('cinnamon').setup() end
}

return plugins
