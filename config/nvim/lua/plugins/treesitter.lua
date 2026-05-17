local M = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,

  dependencies = {
    "andymass/vim-matchup",
    "windwp/nvim-ts-autotag",
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    "nvim-treesitter/nvim-treesitter-context",
    "folke/todo-comments.nvim",
    { "nvchad/nvim-colorizer.lua", config = true },
  },
}

function M.config()
  -- disable if ts-context is enable in current buffer
  vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
  vim.g.matchup_delim_stopline = 200
  vim.g.matchup_matchparen_timeout = 100
  vim.g.matchup_matchparen_deferred = true
  vim.g.matchup_matchparen_deferred_show_delay = 100

  vim.g.bigfile_size = 1.5 * 1024 * 1024

  require("nvim-treesitter").install {
    "lua",
    "vim",
    "vimdoc",
    "markdown",
    "markdown_inline",
    "doxygen",
  }

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then
      return
    end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  local available_parsers = require("nvim-treesitter").get_available()

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then
        return
      end

      local installed_parsers = require("nvim-treesitter").get_installed("parsers")

      if not vim.tbl_contains(installed_parsers, language) and vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require("nvim-treesitter").install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      else
        -- Enable the parser if it is already installed, or
        -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })

  vim.treesitter.language.register("bash", "zsh")

  require("nvim-ts-autotag").setup()

  require("nvim-treesitter-textobjects").setup()
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")
  local nxo = { "n", "x", "o" }

  vim.keymap.set(nxo, "]f", function()
    move.goto_next_start("@function.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "]c", function()
    move.goto_next_start("@class.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "]a", function()
    move.goto_next_start("@parameter.inner", "textobjects")
  end)
  vim.keymap.set(nxo, "]F", function()
    move.goto_next_end("@function.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "]C", function()
    move.goto_next_end("@class.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "]A", function()
    move.goto_next_end("@parameter.inner", "textobjects")
  end)
  vim.keymap.set(nxo, "[f", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "[c", function()
    move.goto_previous_start("@class.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "[a", function()
    move.goto_previous_start("@parameter.inner", "textobjects")
  end)
  vim.keymap.set(nxo, "[F", function()
    move.goto_previous_end("@function.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "[C", function()
    move.goto_previous_end("@class.outer", "textobjects")
  end)
  vim.keymap.set(nxo, "[A", function()
    move.goto_previous_end("@parameter.inner", "textobjects")
  end)

  vim.keymap.set("n", "<leader>>a", function()
    swap.swap_next("@parameter.inner")
  end)
  vim.keymap.set("n", "<leader><a", function()
    swap.swap_previous("@parameter.inner")
  end)

  require("treesitter-context").setup {
    max_lines = 5,
  }

  -- HACK: this semantic token is overriding the custom sql injection highlight
  vim.api.nvim_set_hl(0, "@lsp.type.string.rust", {})
end

return M
