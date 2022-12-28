return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    config = {
      signs = false
    }
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = {
      plugins = {
        tmux = {
          enabled = true
        }
      }
    },
    dependencies = {
      {
        "folke/twilight.nvim",
        config = true,
      },
    },
  },

  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" , "TSHighlightCapturesUnderCursor" }
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = true
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = {
      doc_lines = 0,
      floating_window = false,
    }
  },

  {
    "b0o/SchemaStore.nvim",
    ft = "json"
  },

  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = true,
  },

  {
    "preservim/tagbar",
    cmd = "TagbarToggle"
  },

  -- "folke/tokyonight.nvim",
  -- "rose-pine/neovim",
  -- "rebelot/kanagawa.nvim",
  -- "EdenEast/nightfox.nvim",
  -- "marko-cerovac/material.nvim",
  -- "shaunsingh/nord.nvim",
  -- "Mofiqul/dracula.nvim",
  -- "glepnir/zephyr-nvim",
  -- 'Mofiqul/vscode.nvim',

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf"
  },

  {
    "michaelb/sniprun",
    run = "bash ./install.sh",
    cmd = { "SnipClose", "SnipRun", "SnipInfo", "SnipReplMemoryClean", "SnipReset", "SnipRunToggle", "SnipTerminate", },
    config = true,
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle"
  },

  {
    'Shatur/neovim-session-manager',
    config = function()
      require('session_manager').setup {
        autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
      }
    end
  },

  {
    'declancm/cinnamon.nvim',
    config = true,
  },

}
