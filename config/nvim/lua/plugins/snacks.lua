return {
  "folke/snacks.nvim",
  priority = 1000,

  ---@type snacks.config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 12, total = 210 },
      },
    },
    input = { enabled = true },
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        require("snacks").rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,
}
