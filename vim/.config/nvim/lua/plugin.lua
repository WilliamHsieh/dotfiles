-- TODO: lazy loading
-- Automatically install packer
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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- TODO: remember to change plugin name
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugin.lua source <afile> | PackerCompile
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

local function get_config(cfg)
  return string.format('require("config.%s")', cfg)
end

-- Have packer use a popup window
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

-- Install your plugins here
-- return packer.startup(function(use)
packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use { "rcarriga/nvim-notify", config = get_config("notify") }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = get_config("treesitter")
  }
  use { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" }
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use "p00f/nvim-ts-rainbow"
  use "windwp/nvim-ts-autotag"
  use { "windwp/nvim-autopairs", config = get_config("autopairs") }

  use { "numToStr/Comment.nvim", config = get_config("comment") }

  use "kyazdani42/nvim-web-devicons"
  use { "kyazdani42/nvim-tree.lua", config = get_config("nvim-tree"), cmd = "NvimTreeToggle" }
  use { "akinsho/bufferline.nvim", config = get_config("bufferline") }
  use "moll/vim-bbye"

  use {
    "nvim-lualine/lualine.nvim",
    config = get_config("lualine"),
    events = "BufReadPost",
    requires = {
      { "SmiteshP/nvim-gps", config = get_config("gps") },
      "kyazdani42/nvim-web-devicons"
    },
  }

  use { "akinsho/toggleterm.nvim", config = get_config("toggleterm") }
  use "lewis6991/impatient.nvim"
  use { "lukas-reineke/indent-blankline.nvim", events = "BufReadPost", config = get_config("indentline") }

  use { "goolord/alpha-nvim", config = get_config('alpha') }
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use { "folke/which-key.nvim", config = get_config('whichkey') }
  use {
    "phaazon/hop.nvim",
    config = "require('hop').setup()",
    cmd = {'HopChar2', 'HopWord'}
  }
  use { "andymass/vim-matchup", events = "BufReadPost", config = get_config("matchup") }
  use { "nacro90/numb.nvim", events = "BufReadPost", config = "require('numb').setup()"}
  use { "norcalli/nvim-colorizer.lua", config = get_config("colorizer") }
  -- use "windwp/nvim-spectre"
  use { "folke/zen-mode.nvim", config = get_config("zen"), cmd = "ZenMode" }
  use {
    "folke/todo-comments.nvim",
    events = "BufReadPost",
    config = "require('todo-comments').setup()"
  }
  use "kevinhwang91/nvim-bqf" -- better quickfix window
  use "ThePrimeagen/harpoon"
  use { "MattesGroeger/vim-bookmarks", events = "BufReadPost", config = get_config("bookmark") }
  -- use "Mephistophiles/surround.nvim"
  use { "tversteeg/registers.nvim", config = get_config("registers") }
  -- use "metakirby5/codi.vim"  -- The interactive scratchpad
  use { "nyngwang/NeoZoom.lua", cmd = "NeoZoomToggle" }
  use { "michaelb/sniprun", run = "bash ./install.sh", config = "require('sniprun').setup()"}
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = "markdown",
  }

  -- Colorschemes
  -- use "folke/tokyonight.nvim"
  use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"
  use "rose-pine/neovim"
  use "rebelot/kanagawa.nvim"
  use { "EdenEast/nightfox.nvim", config = 'vim.cmd[[ colorscheme nightfox ]]' }
  use 'marko-cerovac/material.nvim'
  use { 'Mofiqul/vscode.nvim', ft = 'cpp', config = get_config('vscode') }


  -- cmp plugins
  use { 'hrsh7th/nvim-cmp',
    -- commit = "dbc72290295cfc63075dab9ea635260d2b72f2e5",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-nvim-lua" },
    },
    config = get_config('cmp')
  }
  use {
    "tzachar/cmp-tabnine",
    config = get_config("tabnine"),
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  }

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- TODO: LSP
  use { "neovim/nvim-lspconfig", config = get_config("lsp") } -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use "ray-x/lsp_signature.nvim"
  use "b0o/SchemaStore.nvim"
  use { "folke/trouble.nvim", cmd = "TroubleToggle", }
  use "github/copilot.vim"
  use {
    "RRethy/vim-illuminate", -- highlight word under cursor
    config = "vim.g.Illuminate_ftblacklist = {'alpha', 'NvimTree'}"
  }

  -- tagbar
  use { "preservim/tagbar", cmd = "TagbarToggle" }
  use { "simrat39/symbols-outline.nvim", config = get_config("symbol-outline") }

  -- Telescope
  use { "nvim-telescope/telescope.nvim", config = get_config("telescope") }
  use "nvim-telescope/telescope-media-files.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"
  use "tom-anders/telescope-vim-bookmarks.nvim"
  use { "ahmedkhalf/project.nvim", config = get_config("project") }

  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    events = "BufReadPost",
    config = get_config("gitsigns")
  }
  use { "f-person/git-blame.nvim", config = get_config("git-blame"), cmd = "GitBlameToggle" }
  use "rhysd/conflict-marker.vim"

  -- DAP
  -- use "mfussenegger/nvim-dap"
  -- use "theHamsta/nvim-dap-virtual-text"
  -- use "rcarriga/nvim-dap-ui"
  -- use "Pocco81/DAPInstall.nvim"

  -- filetype
  use {
    'preservim/vim-markdown',
    requires = 'godlygeek/tabular',
    ft = 'markdown',
    -- config = 'vim.g.markdown_fenced_languages = { "cpp", "bash", "lua", "python" }'
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
