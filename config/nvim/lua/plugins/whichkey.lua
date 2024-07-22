local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

M.opts = {
  preset = "modern",
  show_help = false,
  spec = {
    { "]", group = "Navigate next" },
    { "[", group = "Navigate previous" },
    { "<leader>", group = "Leader" },
    { "<leader>c", group = "Compile" },
    { "<leader>b", group = "Buffer" },
    { "<leader>p", group = "Plugin" },
    { "<leader>f", group = "Find" },
    { "<leader>l", group = "LSP" },
    { "<leader>t", group = "Terminal" },
    { "<leader>h", group = "Hop" },
    {
      mode = { "n", "v" },
      { "<leader>g", group = "Git" },
    },
  },
}

return M
