return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- TODO: change to vim.uv
        { path = "luvit-meta/library", words = { "vim%.loop" } },
      },
    },
  },

  -- optional `vim.uv` typings
  {
    "Bilal2453/luvit-meta",
    lazy = true
  },
}
