return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  ---------- LazyLoader ----------
  {
    "WilliamHsieh/placeholder.nvim",
    name = "lazyloader",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      "lewis6991/gitsigns.nvim",
      "Shatur/neovim-session-manager",
      "akinsho/bufferline.nvim",
    },
  },

  ---------- Treesitter ----------
  {
    "folke/todo-comments.nvim",
    lazy = true,
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
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = true
  },

  ---------- LSP ----------
  {
    "ray-x/lsp_signature.nvim",
    lazy = true,
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
    "michaelb/sniprun",
    build = "bash ./install.sh",
    cmd = { "SnipClose", "SnipRun", "SnipInfo", "SnipReplMemoryClean", "SnipReset", "SnipRunToggle", "SnipTerminate", },
    config = true,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    init = function()
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
        detection_methods = { "pattern" }, -- otherwise cwd is overwriten by lsp
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "CMakeLists.txt" },
      }
    end
  },

  {
    'Shatur/neovim-session-manager',
    cmd = "SessionManager",
    config = function()
      require('session_manager').setup {
        autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
      }
    end
  },

  {
    'declancm/cinnamon.nvim',
    event = "VeryLazy",
    config = true,
  },

  {
    'kevinhwang91/nvim-fundo',
    dependencies = { 'kevinhwang91/promise-async' },
    build = function() require('fundo').install() end,
    config = true,
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
}
