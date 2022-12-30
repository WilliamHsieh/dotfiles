local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
}

function M.vscode()
  local c = require("vscode.colors")
  require("vscode").setup {
    group_overrides = {
      cppTSKeyword = { fg = c.vscBlue },
      cppTSConstMacro = { fg = c.vscPink },
      NvimTreeFolderName = { fg = c.vscBlue },
      NvimTreeOpenedFolderName = { fg = c.vscBlue },
    }
  }
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', { fg = c.vscYellow, bg = "NONE", underline = true })
end

function M.config()
  require("catppuccin").setup {
    flavour = "macchiato",
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.base },
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
      -- noice = true,
      notify = true,
      nvimtree = true,
      telescope = true,
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

return M