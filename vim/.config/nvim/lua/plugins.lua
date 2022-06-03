-- Automatically install packer{{{
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end
--}}}

-- Autocommand that reloads neovim whenever you save the plugins.lua file{{{
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]
--}}}

-- packer init{{{
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  profile = {
    enable = true,
    threshold = 0, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
  },
}

local function get_config(cfg)
  return string.format('require("config.%s")', cfg)
end
--}}}

-- plugins{{{
packer.startup(function(use)
  -- basics{{{
  use "wbthomason/packer.nvim"

  -- Useful api
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"

  -- Notification
  use { "rcarriga/nvim-notify", config = get_config("notify") }

  -- Profiling
  use "lewis6991/impatient.nvim"

  -- Comment
  use { "numToStr/Comment.nvim", config = get_config("comment") }

  -- floating terminal
  use { "akinsho/toggleterm.nvim", config = get_config("toggleterm") }

  -- keymap
  use { "folke/which-key.nvim", config = get_config('whichkey') }
--}}}

  -- Treesitter, highlight, syntax, etc{{{
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = { "BufRead", "BufNewFile" },
    module = "nvim-treesitter",
    wants = { "nvim-ts-autotag", "nvim-ts-rainbow", "nvim-ts-context-commentstring" },
    cmd = { "TSInstall", "TSInstallInfo", "TSInstallSync", "TSUninstall", "TSUpdate", "TSUpdateSync", "TSDisableAll", "TSEnableAll" },
    config = get_config("treesitter")
  }
  use { "windwp/nvim-ts-autotag", opt = true, }
  use { "p00f/nvim-ts-rainbow", opt = true, }
  use { "JoosepAlviste/nvim-ts-context-commentstring", opt = true, }

  use {
    "windwp/nvim-autopairs",
    after = "nvim-treesitter",
    config = get_config("autopairs"),
  }

  use {
    "andymass/vim-matchup",
    after = "nvim-treesitter",
  }

  use {
    "norcalli/nvim-colorizer.lua",
    after = "nvim-treesitter",
    config = get_config("colorizer")
  }

  use {
    "folke/todo-comments.nvim",
    after = "nvim-treesitter",
    config = function()
      require('todo-comments').setup {
        sign_priority = 0
      }
    end
  }

  use {
    "RRethy/vim-illuminate",
    after = "nvim-treesitter",
    module = "illuminate",
    config = "vim.g.Illuminate_ftblacklist = {'alpha', 'NvimTree'}"
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    after = "nvim-treesitter",
    config = get_config("indentline")
  }
--}}}

  -- Telescope{{{
  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    module = "telescope",
    wants = "telescope-ui-select.nvim",
    config = get_config("telescope"),
  }
  use {
    "ahmedkhalf/project.nvim",
    after = "telescope.nvim",
    config = get_config("project"),
  }
  use {
    "nvim-telescope/telescope-ui-select.nvim",
    opt = true,
  }

  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    after = "telescope.nvim",
    run = "make -j",
    config = function()
      require("telescope").load_extension "fzf"
    end,
  }
--}}}

  -- bookmarks{{{
  use { "MattesGroeger/vim-bookmarks", events = "BufRead", config = get_config("bookmark") }
  use "tom-anders/telescope-vim-bookmarks.nvim"
--}}}

  -- zen mode{{{
  use {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    requires = {
      { "folke/twilight.nvim", config = "require('twilight').setup()" }
    },
    config = get_config("zen"),
  }
--}}}

  -- navigation{{{
  use {
    "phaazon/hop.nvim",
    config = "require('hop').setup()",
    cmd = {'HopChar2', 'HopWord'}
  }
--}}}

  -- Colorschemes{{{
  use "folke/tokyonight.nvim"
  use "rose-pine/neovim"
  use "rebelot/kanagawa.nvim"
  use "EdenEast/nightfox.nvim"
  use "marko-cerovac/material.nvim"
  use "shaunsingh/nord.nvim"
  use "catppuccin/nvim"
  use 'Mofiqul/dracula.nvim'
  use {
    'Mofiqul/vscode.nvim',
    setup = function ()
      vim.g.vscode_style = "dark"
      vim.g.vscode_italic_comment = 1
    end,
    config = function ()
      vim.cmd("colorscheme vscode")
    end,
  }
--}}}

  -- appearance{{{
  use "kyazdani42/nvim-web-devicons"
  use { "kyazdani42/nvim-tree.lua", config = get_config("nvim-tree"), cmd = "NvimTreeToggle" }
  use { "goolord/alpha-nvim", config = get_config('alpha') }
  use { "akinsho/bufferline.nvim", config = get_config("bufferline"), requires = "moll/vim-bbye" }
  use {
    "nvim-lualine/lualine.nvim",
    config = get_config("lualine"),
    events = "BufRead",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
  }
--}}}

  -- completition{{{
  use {
    "rafamadriz/friendly-snippets",
    opt = true,
  }
  use {
    "L3MON4D3/LuaSnip",
    module = "luasnip",
    wants = "friendly-snippets",
  }
  use {
    'hrsh7th/nvim-cmp',
    event = { "InsertEnter", "CmdlineEnter" },
    config = get_config('cmp'),
  }

  -- cmp sources
  use { "hrsh7th/cmp-buffer", after = "nvim-cmp", }
  use { "hrsh7th/cmp-cmdline", after = "nvim-cmp" }
  use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
  use { "hrsh7th/cmp-path", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", }
  use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
  use { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }
--}}}

  -- LSP{{{
  use {
    "neovim/nvim-lspconfig",
    module = "lspconfig",
    event = "BufRead",
  }
  use {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function ()
      require('null-ls').setup()
    end
  }

  use {
    "ray-x/lsp_signature.nvim",
    opt = true,
    config = function()
      require('lsp_signature').setup {
        doc_lines = 0,
        floating_window = false,
      }
    end
  }
  use {
    'tami5/lspsaga.nvim',
    opt = true,
    config = function()
      require('lspsaga').setup {
        use_saga_diagnostic_sign = false,
        code_action_icon = "",
      }
    end
  }
  use {
    "williamboman/nvim-lsp-installer",
    after = "nvim-lspconfig",
    wants = { "lsp_signature.nvim", "lspsaga.nvim" },
    config = get_config("lsp")
  }

  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "b0o/SchemaStore.nvim"
  use {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  }
--}}}

  -- tagbar{{{
  use {
    "preservim/tagbar",
    cmd = "TagbarToggle"
  }
  use {
    "simrat39/symbols-outline.nvim",
    after = "nvim-lspconfig",
    config = get_config("symbol-outline")
  }
--}}}

  -- Git{{{
  use {
    "lewis6991/gitsigns.nvim",
    events = "BufRead",
    config = get_config("gitsigns")
  }
  use "rhysd/conflict-marker.vim"
--}}}

  -- markdown{{{
  use {
    'preservim/vim-markdown',
    requires = 'godlygeek/tabular',
    ft = 'markdown',
    -- config = 'vim.g.markdown_fenced_languages = { "cpp", "bash", "lua", "python" }'
  }
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  }
--}}}

  -- others{{{
  use "kevinhwang91/nvim-bqf" -- better quickfix window
  use { "michaelb/sniprun",
    run = "bash ./install.sh",
    -- cmd = { SnipClose, SnipRun, SnipInfo, SnipReplMemoryClean, SnipReset, SnipRunToggle, SnipTerminate, },
    config = function() require('sniprun').setup() end
  }
  use { "mbbill/undotree", cmd = "UndotreeToggle" }
  use { 'tpope/vim-obsession', cmd = "Obsession" }
--}}}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    packer.sync()
  end
end)
--}}}
