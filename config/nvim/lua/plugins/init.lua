return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

  ---------- LazyLoader ----------
  {
    "WilliamHsieh/placeholder.nvim",
    name = "lazyloader",
    event = "LazyFile",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      "lewis6991/gitsigns.nvim",
      "Shatur/neovim-session-manager",
      "akinsho/bufferline.nvim",
      "kevinhwang91/nvim-ufo",
      "RRethy/vim-illuminate",
    },
  },

  ---------- Treesitter ----------
  {
    "folke/todo-comments.nvim",
    lazy = true,
    opts = {
      signs = false
    }
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
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
    opts = {
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
    lazy = true,
    config = true,
  },

  ---------- Others ----------
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      func_map = {
        pscrollup = '<C-u>',
        pscrolldown = '<C-d>',
      }
    }
  },

  {
    "moll/vim-bbye",
    cmd = "Bdelete"
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("telescope").load_extension("ui-select")
        return vim.ui.select(...)
      end
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    event = "LazyFile",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern" }, -- otherwise cwd is overwriten by lsp
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "CMakeLists.txt" },
      }
    end,
  },

  {
    "Shatur/neovim-session-manager",
    cmd = "SessionManager",
    config = function()
      require("session_manager").setup {
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
      }
    end,

    -- NOTE: ultimately, what i want is open a project with cwd set, and open files from harpoon list
    -- do this after harpoon2 is release and stable
  },

  {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "kevinhwang91/nvim-fundo",
    dependencies = { "kevinhwang91/promise-async" },
    build = function()
      require("fundo").install()
    end,
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
    "nullchilly/fsread.nvim",
    cmd = "FSToggle",
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    lazy = true,
    init = function()
      vim.opt.fillchars:append { fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      open_fold_hl_timeout = 100,
    }
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts = {
      mapping = { "kj" },
    }
  },

  {
    'ThePrimeagen/harpoon',
    keys = {
      {
        "<leader>bh",
        function() require("harpoon.ui").toggle_quick_menu() end,
        desc = "harpoon open ui",
      },
      {
        "<leader>ba",
        function() require("harpoon.mark").add_file() end,
        desc = "harpoon add file",
      },
      {
        "<leader><tab>",
        function() require("harpoon.ui").nav_next() end,
        desc = "harpoon next buffer",
      },
    },
  },

  {
    "smjonas/live-command.nvim",
    cmd = { "Norm", "G" },
    main = "live-command",
    opts = {
      commands = {
        Norm = { cmd = "norm" },
        G = { cmd = "g", hl_range = { 1, -1, kind = "visible" } },
      },
    },
  },

  {
    "akinsho/git-conflict.nvim",
    opts = {},
    keys = {
      { "cr", "<cmd>GitConflictRefresh<cr>", desc = "Refresh conflict marks" },
    },
  },

  -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
  {
    "nvimtools/none-ls.nvim",
    lazy = true,
    opts = {},
  },

  {
    "seandewar/killersheep.nvim",
    cmd = "KillKillKill",
  },
}
