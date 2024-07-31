return {
  {
    "nvimtools/none-ls.nvim",
    opts = {
      border = "rounded",
      on_attach = function(client, bufnr)
        require("core.utils").setup_formatting(client, bufnr)
      end,
    },
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      automatic_installation = true,
      handlers = {},
    },
  },
}
