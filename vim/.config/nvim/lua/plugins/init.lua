return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  ---------- Treesitter ----------
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    config = true,
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = true
  },

  ---------- LSP ----------
  {
    "ray-x/lsp_signature.nvim",
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

  ---------- Others ----------
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf"
  },

  {
    "moll/vim-bbye",
    cmd = "Bdelete"
  },

  {
    "tiagovla/scope.nvim",
    event = "BufReadPost",
    config = true,
  },

  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
    cmd = { "SnipClose", "SnipRun", "SnipInfo", "SnipReplMemoryClean", "SnipReset", "SnipRunToggle", "SnipTerminate", },
    config = true,
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle"
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      vim.ui.select = function(...)
        require("telescope").load_extension "ui-select"
        return vim.ui.select(...)
      end
    end
  },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "CMakeLists.txt" },
      }
    end
  },

  {
    'Shatur/neovim-session-manager',
    cmd = "SessionManager",
    event = "BufReadPost",
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
