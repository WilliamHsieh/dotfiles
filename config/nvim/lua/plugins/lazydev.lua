return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "luvit-meta/library", words = { "vim%.loop" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },

  -- optional `vim.uv` typings
  {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
}
