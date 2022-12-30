local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}

function M.config()
  require("indent_blankline").setup {
    enable = true,
    char = "▏",
    context_char = "▏",
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = true,
    buftype_exclude = {
      "terminal",
      "nofile",
    },
    filetype_exclude = {
      "help",
      "dashboard",
      "packer",
      "NvimTree",
      "Trouble",
    },
    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^while",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
  }
end

return M
