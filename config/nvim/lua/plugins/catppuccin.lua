local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
}

function M.config()
  require("catppuccin").setup {
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.base },
        ExtraWhitespace = { fg = colors.yellow, style = { "underline" } },
        -- HACK: https://github.com/neovim/neovim/pull/25941
        StatusLine = { fg = colors.crust, bg = "none" },
        StatusLineNC = { fg = colors.mantle, bg = "none" },
      }
    end,
    integrations = {
      cmp = true,
      gitsigns = true,
      diffview = true,
      hop = true,
      leap = true,
      lsp_saga = true,
      lsp_trouble = true,
      markdown = true,
      mason = true,
      neogit = true,
      nvimtree = true,
      telescope = {
        enabled = true,
        -- style = "nvchad",
      },
      treesitter = true,
      treesitter_context = true,
      which_key = true,
      symbols_outline = true,
      native_lsp = {
        enabled = true,
      },
    },
  }
  vim.cmd.colorscheme("catppuccin")
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
