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
    cmd = { "TSInstall", "TSInstallInfo", "TSInstallSync", "TSUninstall", "TSUpdate", "TSUpdateSync", "TSDisableAll", "TSEnableAll" },
    config = get_config("treesitter")
  }
  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    after = "nvim-treesitter",
  }
  use {
    "p00f/nvim-ts-rainbow",
    after = "nvim-treesitter",
  }
  use {
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
  }
  use {
    "windwp/nvim-autopairs",
    after = "nvim-treesitter",
    config = get_config("autopairs"),
  }
  use {
    "andymass/vim-matchup",
    events = "BufRead",
    config = get_config("matchup")
  }
  use {
    "norcalli/nvim-colorizer.lua",
    events = "BufRead",
    config = get_config("colorizer")
  }
  use {
    "folke/todo-comments.nvim",
    events = "BufRead",
    config = function()
      require('todo-comments').setup {
        sign_priority = 0
      }
    end
  }
  -- highlight word under cursor
  use {
    "RRethy/vim-illuminate",
    events = "BufRead",
    config = "vim.g.Illuminate_ftblacklist = {'alpha', 'NvimTree'}"
  }

  -- indentation
  use { "lukas-reineke/indent-blankline.nvim", events = "BufRead", config = get_config("indentline") }
--}}}

  -- Telescope{{{
  use {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    module = "telescope",
    requires = {
      "nvim-telescope/telescope-ui-select.nvim",
      { "ahmedkhalf/project.nvim", config = get_config("project") },
    },
    config = get_config("telescope")
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
  use { 'Mofiqul/vscode.nvim', config = get_config('vscode') }
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
    event = {'InsertEnter', 'CmdlineEnter'},
  }
  use {
    "L3MON4D3/LuaSnip",
    after = "friendly-snippets"
  }
  use {
    'hrsh7th/nvim-cmp',
    after = "LuaSnip",
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
    requires = "ray-x/lsp_signature.nvim",
  }
  use {
    "williamboman/nvim-lsp-installer",
    after = "nvim-lspconfig",
    config = get_config("lsp")
  }
  use {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function ()
      require('null-ls').setup()
    end
  }

  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "b0o/SchemaStore.nvim"
  use {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  }
  use {
    'tami5/lspsaga.nvim',
    cmd = "Lspsaga",
    config = function()
      require('lspsaga').setup()
    end
  }
--}}}

  -- tagbar{{{
  use { "preservim/tagbar", cmd = "TagbarToggle" }
  use { "simrat39/symbols-outline.nvim", config = get_config("symbol-outline") }
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
