return {
  {
    "echasnovski/mini.files",
    keys = {
      {
        "<leader>e",
        function()
          if not require("mini.files").close() then
            require("mini.files").open()
          end
        end,
        desc = "File Explorer: last used state",
      },
      {
        "<leader>E",
        function()
          if not require("mini.files").close() then
            require("mini.files").open(vim.api.nvim_buf_get_name(0))
          end
        end,
        desc = "File Explorer: directory of current file",
      },
    },
    opts = {
      mappings = {
        synchronize = "<leader>w",
        go_in_plus = "<CR>",
      },
    },
  },
}
