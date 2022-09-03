local config = {}

function config.notify()
  local icons = require "icons"
  vim.notify = require("notify")

  vim.notify.setup {
    stages = "fade_in_slide_out",
    minimum_width = 10,
    icons = {
      ERROR = icons.diagnostics.Error,
      WARN = icons.diagnostics.Warning,
      INFO = icons.diagnostics.Information,
      DEBUG = icons.ui.Bug,
      TRACE = icons.ui.Pencil,
    },
  }
end

function config.comment()
  require("Comment").setup {
    mappings = false,
    pre_hook = function(ctx)
      local U = require "Comment.utils"

      local location = nil
      if ctx.ctype == U.ctype.blockwise then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring {
        key = ctx.ctype == U.ctype.linewise and '__default' or '__multiline',
        location = location,
      }
    end,
  }
end

function config.toggleterm()
  require('toggleterm').setup {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    on_stdout = function(term, _, data, _)
      if term:is_open() then return end
      for _, s in pairs(data) do
        local pos, _ = string.find(s, "❯")
        if pos and s:sub(-1) ~= ' ' then
          local res = s:sub(pos - 3, pos - 2) == "32" and {"Success", "info"} or {"Failed", "error"}
          vim.notify("Job finished: " .. res[1] .. "!", res[2], { title = term.name })
        end
      end
    end,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  }
end

function config.whichkey()
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
    p = { name = "Packer" },
    f = { name = "Find" },
    g = { name = "Git" },
    l = { name = "LSP" },
    s = { name = "SnipRun" },
    t = { name = "Terminal" },
    h = { name = "Hop" },
  }

  which_key.register(mappings, opts)
end

return config
