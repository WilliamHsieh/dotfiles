local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  module = false,
  lazy = true,
  dependencies = {
    "andymass/vim-matchup",
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
    "folke/todo-comments.nvim",
    "norcalli/nvim-colorizer.lua",
    "lukas-reineke/indent-blankline.nvim",
  },
}

function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vim", "markdown", },
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if lang == "latex" or ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
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
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    playground = {
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
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
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

  vim.api.nvim_create_autocmd("User", {
    pattern = "MatchupOffscreenEnter",
    callback = function()
      vim.g.sl = vim.g.tpipeline_statusline
      vim.g.tpipeline_statusline = vim.o.stl
    end
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "MatchupOffscreenLeave",
    callback = function()
      vim.g.tpipeline_statusline = vim.g.sl
    end
  })
end

return M
