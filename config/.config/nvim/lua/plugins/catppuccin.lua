local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
}

function M.config()
  require("catppuccin").setup {
    flavour = "macchiato",
    background = {
      dark = "macchiato"
    },
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.base },
        ExtraWhitespace = { fg = colors.yellow, style = { "underline" } },
        StatusLine = { link = "WinSeparator" },
        StatusLineNC = { link = "WinSeparator" },
      }
    end,
    integrations = {
      cmp = true,
      gitsigns = true,
      hop = true,
      illuminate = true,
      leap = true,
      lsp_saga = true,
      lsp_trouble = true,
      markdown = true,
      mason = true,
      neogit = true,
      notify = true,
      nvimtree = true,
      telescope = {
        enabled = true,
        -- style = "nvchad",
      },
      treesitter = true,
      treesitter_context = true,
      which_key = true,
      symbols_outline = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      native_lsp = {
        enabled = true,
      },
    }
  }
  vim.cmd.colorscheme "catppuccin"
end

-- "folke/tokyonight.nvim",
-- "rose-pine/neovim",
-- "rebelot/kanagawa.nvim",
-- "EdenEast/nightfox.nvim",
-- "marko-cerovac/material.nvim",
-- "shaunsingh/nord.nvim",
-- "Mofiqul/dracula.nvim",
-- "glepnir/zephyr-nvim",
-- "Mofiqul/vscode.nvim",

return M
