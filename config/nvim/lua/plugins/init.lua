return {
  ---------- lib ----------
  { "nvim-lua/popup.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "echasnovski/mini.icons", lazy = true },
  {
    "nvim-lua/plenary.nvim",
    keys = {
      {
        -- NOTE: A flamegraph can be created using https://github.com/jonhoo/inferno
        -- $ inferno-flamegraph profile.log > flame.svg
        "<f3>",
        function()
          vim.notify("start recording")
          ---@diagnostic disable-next-line: param-type-mismatch
          require("plenary.profile").start("profile.log", { flame = true })
        end,
      },
      {
        "<f4>",
        function()
          vim.notify("stop recording")
          require("plenary.profile").stop()
        end,
      },
    },
  },

  ---------- Treesitter ----------
  {
    "folke/todo-comments.nvim",
    lazy = true,
    opts = {
      signs = false,
    },
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = true,
  },

  ---------- LSP ----------
  {
    "ray-x/lsp_signature.nvim",
    lazy = true,
    opts = {
      doc_lines = 0,
      floating_window = false,
    },
  },

  {
    "b0o/SchemaStore.nvim",
    ft = "json",
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = true,
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
        pscrollup = "<C-u>",
        pscrolldown = "<C-d>",
      },
    },
  },

  {
    "moll/vim-bbye",
    cmd = "Bdelete",
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
    cmd = "ProjectRoot",
    config = function()
      require("project_nvim").setup {
        manual_mode = true,
        ignore_lsp = { "null-ls", "copilot" },
      }
      require("core.utils").on_load("telescope.nvim", function()
        require("telescope").load_extension("projects")
      end)
    end,
  },

  {
    "kevinhwang91/nvim-fundo",
    event = "BufReadPre",
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
    end,
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
    event = "LazyFile",
    init = function()
      vim.opt.fillchars:append { fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      open_fold_hl_timeout = 100,
    },
  },

  {
    "max397574/better-escape.nvim",
    version = "v1.0.0",
    event = "InsertEnter",
    opts = {
      mapping = { "kj" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>bh",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "harpoon open ui",
      },
      {
        "<leader>ba",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "harpoon add file",
      },
      {
        "<leader><tab>",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "harpoon next buffer",
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion", "copilot-chat" },
    opts = {
      code = {
        border = "thin",
      },
      win_options = {
        conceallevel = {
          default = 1,
          rendered = 1,
        },
      },
    },
  },

  {
    "smjonas/live-command.nvim",
    cmd = { "Norm", "G", "Preview" },
    main = "live-command",
    opts = {
      commands = {
        Norm = { cmd = "norm" },
        G = { cmd = "g", hl_range = { 1, -1, kind = "visible" } },
      },
    },
  },

  {
    "seandewar/killersheep.nvim",
    cmd = "KillKillKill",
  },

  {
    "direnv/direnv.vim",
    event = "VeryLazy",
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },

  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },
}
