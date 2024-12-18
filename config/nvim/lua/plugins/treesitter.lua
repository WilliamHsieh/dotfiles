local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  cmd = "TSUpdate",
  event = { "LazyFile", "VeryLazy" },

  -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
  -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
  -- no longer trigger the **nvim-treesitter** module to be loaded in time.
  -- Luckily, the only things that those plugins need are the custom queries, which we make available
  -- during startup.
  init = function(plugin)
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,

  dependencies = {
    "andymass/vim-matchup",
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "folke/todo-comments.nvim",
    { "nvchad/nvim-colorizer.lua", config = true },
  },
}

function M.config()
  -- disable if ts-context is enable in current buffer
  vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
  vim.g.bigfile_size = 1.5 * 1024 * 1024

  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vim", "markdown", "markdown_inline" },
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if lang == "latex" or ok and stats and stats.size > vim.g.bigfile_size then
          return true
        end
        return false
      end,
    },
    indent = {
      enable = true,
      disable = { "python", "css" }
    },
    matchup = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    autopairs = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader><a'] = '@parameter.inner',
        },
      },
    },
  }

  vim.treesitter.language.register("bash", "zsh")

  require("treesitter-context").setup {
    max_lines = 5,
  }

  -- HACK: this semantic token is overriding the custom sql injection highlight
  vim.api.nvim_set_hl(0, "@lsp.type.string.rust", {})
end

return M
