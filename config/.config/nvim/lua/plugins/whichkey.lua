local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local which_key = require("which-key")

  which_key.setup {
    plugins = {
      spelling = {
        enabled = true,
      },
    },
    layout = {
      align = "center",
    },
    show_help = false,
  }

  local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  }

  local mappings = {
    c = { name = "Compile" },
    b = { name = "Buffer" },
    p = { name = "Plugin" },
    f = { name = "Find" },
    g = { name = "Git" },
    l = { name = "LSP" },
    s = { name = "SnipRun" },
    t = { name = "Terminal" },
    h = { name = "Hop" },
  }

  local vopts = {
    mode = 'v',
    prefix = '<leader>',
  }

  local vmappings = {
    g = { name = "Git" },
  }

  which_key.register(mappings, opts)
  which_key.register(vmappings, vopts)
end

return M
