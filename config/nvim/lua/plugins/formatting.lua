return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = "BufWritePre",
    cmd = "ConformInfo",

    keys = {
      {
        "<leader>lf",
        function()
          vim.g.autoformat = not vim.g.autoformat
          vim.notify("Format on save: " .. (vim.g.autoformat and "on" or "off"))
          if vim.g.autoformat then
            require("conform").format()
          end
        end,
        desc = "toggle auto formatting",
      },
    },

    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { "stylua", lsp_format = "never" },
        sh = { "shfmt" },
        sql = { "sqlfluff" },
      },
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      format_on_save = function()
        if not vim.g.autoformat then
          return
        end
        return {}
      end,
    },
  },
}
