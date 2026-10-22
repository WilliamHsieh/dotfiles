local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
}

function M.config()
  require("catppuccin").setup {
    custom_highlights = function(colors)
      local options = require("catppuccin").options

      return {
        NormalFloat = { bg = colors.base },
        ExtraWhitespace = { fg = colors.yellow, style = { "underline" } },
        -- HACK: https://github.com/neovim/neovim/pull/25941
        StatusLine = { fg = colors.crust, bg = "none" },
        StatusLineNC = { fg = colors.mantle, bg = "none" },

        -- HACK: version 2.0 color changes
        -- https://github.com/catppuccin/nvim/pull/804#pullrequestreview-3080755868
        ["@variable.member"] = { fg = colors.lavender }, -- For fields.
        ["@module"] = { fg = colors.lavender, style = options.styles.miscs or { "italic" } }, -- For identifiers referring to modules and namespaces.
        ["@string.special.url"] = { fg = colors.rosewater, style = { "italic", "underline" } }, -- urls, links and emails
        ["@type.builtin"] = { fg = colors.yellow, style = options.styles.properties or { "italic" } }, -- For builtin types.
        ["@property"] = { fg = colors.lavender, style = options.styles.properties or {} }, -- Same as TSField.
        ["@constructor"] = { fg = colors.sapphire }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
        ["@keyword.operator"] = { link = "Operator" }, -- For new keyword operator
        ["@keyword.export"] = { fg = colors.sky, style = options.styles.keywords },
        ["@markup.strong"] = { fg = colors.maroon, style = { "bold" } }, -- bold
        ["@markup.italic"] = { fg = colors.maroon, style = { "italic" } }, -- italic
        ["@markup.heading"] = { fg = colors.blue, style = { "bold" } }, -- titles like: # Example
        ["@markup.quote"] = { fg = colors.maroon, style = { "bold" } }, -- block quotes
        ["@markup.link"] = { link = "Tag" }, -- text references, footnotes, citations, etc.
        ["@markup.link.label"] = { link = "Label" }, -- link, reference descriptions
        ["@markup.link.url"] = { fg = colors.rosewater, style = { "italic", "underline" } }, -- urls, links and emails
        ["@markup.raw"] = { fg = colors.teal }, -- used for inline code in markdown and for doc in python (""")
        ["@markup.list"] = { link = "Special" },
        ["@tag"] = { fg = colors.mauve }, -- Tags like html tag names.
        ["@tag.attribute"] = { fg = colors.teal, style = options.styles.miscs or { "italic" } }, -- Tags like html tag names.
        ["@tag.delimiter"] = { fg = colors.sky }, -- Tag delimiter like < > /
        ["@property.css"] = { fg = colors.lavender },
        ["@property.id.css"] = { fg = colors.blue },
        ["@type.tag.css"] = { fg = colors.mauve },
        ["@string.plain.css"] = { fg = colors.peach },
        ["@constructor.lua"] = { fg = colors.flamingo }, -- For constructor calls and definitions: = { } in Lua.
        -- typescript
        ["@property.typescript"] = { fg = colors.lavender, style = options.styles.properties or {} },
        ["@constructor.typescript"] = { fg = colors.lavender },
        -- TSX (Typescript React)
        ["@constructor.tsx"] = { fg = colors.lavender },
        ["@tag.attribute.tsx"] = { fg = colors.teal, style = options.styles.miscs or { "italic" } },
        ["@type.builtin.c"] = { fg = colors.yellow, style = {} },
        ["@type.builtin.cpp"] = { fg = colors.yellow, style = {} },
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
