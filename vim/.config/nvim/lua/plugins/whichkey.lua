local M = {
  "williamhsieh/which-key.nvim",
  keys = { "<leader>", '"', "'", "g", "m", "z" },
}

function M.config()
  local which_key = require("which-key")

  which_key.setup {
    plugins = {
      spelling = {
        enabled = true,
      },
      presets = {
        operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
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
