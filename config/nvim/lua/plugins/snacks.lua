return {
  "folke/snacks.nvim",
  priority = 1000,

  ---@type snacks.config
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 12, total = 210 },
      },
    },
    input = { enabled = true },
    indent = {
      indent = {
        enabled = true,
        char = "▏",
        hl = "IblIndent",
      },
      scope = {
        char = "▏",
        hl = "IblScope",
      },
    },
    zen = {
      on_open = function()
        vim.system { "tmux", "set", "status", "off" }
      end,
      on_close = function()
        vim.system { "tmux", "set", "status", "on" }
      end,
    },
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
