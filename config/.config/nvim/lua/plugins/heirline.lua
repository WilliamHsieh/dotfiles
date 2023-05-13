local M = {
  "rebelot/heirline.nvim"
}

function M.config()
  local conditions = require("heirline.conditions")
  local utils = require("heirline.utils")

  local assets = {
    left_separator = '',
    right_separator = '',
    terminal = "  ",
    tmux = "  ",
    vim = "  ",
    host = "  ",
    dir = "  ",
    tree = "  ",
    macro = "  ",
    search = "  ",
    lsp = "  ",
    git = " ",
    search_forward = "  ",
    search_backward = "  ",
  }

  local setup_colors = function()
    return {
      bg = utils.get_highlight("Normal").bg,
      green = utils.get_highlight("String").fg,
      blue = utils.get_highlight("Function").fg,
      gray = utils.get_highlight("Conceal").fg,
      orange = utils.get_highlight("Constant").fg,
      purple = utils.get_highlight("Statement").fg,
      pink = utils.get_highlight("Special").fg,
      yellow = utils.get_highlight("DiagnosticWarn").fg,
      red = utils.get_highlight("@parameter").fg,
      cyan = utils.get_highlight("DiagnosticHint").fg,

      lavender = utils.get_highlight("CursorLineNR").fg,
      flamingo = utils.get_highlight("Identifier").fg,
    }
  end

  local Space = { provider = " " }
  local Align = {
    provider = "%=",
    hl = { bg = "bg" }
  }

  local Mode = {
    init = function(self)
      -- vim.api.nvim_get_mode().mode
      self.mode = vim.fn.mode(1)
      self.short_mode = self.mode:sub(1, 1)
    end,
    static = {
      mode_alias = {
        ['n'] = 'NORMAL',
        ['no'] = 'OP',
        ['nov'] = 'OP',
        ['noV'] = 'OP',
        ['no'] = 'OP',
        ['niI'] = 'NORMAL',
        ['niR'] = 'NORMAL',
        ['niV'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['vs'] = 'VISUAL',
        ['V'] = 'LINES',
        ['Vs'] = 'LINES',
        [''] = 'BLOCK',
        ['s'] = 'BLOCK',
        ['s'] = 'SELECT',
        ['S'] = 'SELECT',
        [''] = 'BLOCK',
        ['i'] = 'INSERT',
        ['ic'] = 'INSERT',
        ['ix'] = 'INSERT',
        ['R'] = 'REPLACE',
        ['Rc'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['Rx'] = 'REPLACE',
        ['c'] = 'COMMAND',
        ['cv'] = 'COMMAND',
        ['ce'] = 'COMMAND',
        ['r'] = 'ENTER',
        ['rm'] = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        ['t'] = 'TERM',
        ['nt'] = 'TERM',
        ['null'] = 'NONE',
      },

      mode_color = {
        ["n"] = "lavender",
        ["i"] = "green",
        ["v"] = "flamingo",
        ["V"] = "flamingo",
        [""] = "flamingo",
        ["c"] = "orange",
        ["s"] = "green",
        ["S"] = "green",
        [""] = "flamingo",
        ["R"] = "red",
        ["r"] = "red",
        ["!"] = "lavender",
        ["t"] = "lavender",
      }
    },

    provider = function(self)
      return assets.vim .. self.mode_alias[self.mode] .. " "
    end,

    {
      provider = assets.right_separator,
      hl = function(self)
        return {
          fg = self.mode_color[self.short_mode],
          bg = "purple",
        }
      end
    },

    hl = function(self)
      return {
        fg = "bg",
        bg = self.mode_color[self.short_mode],
        bold = true,
      }
    end,

    -- Re-evaluate the component only on ModeChanged event!
    -- Also allows the statusline to be re-evaluated when entering operator-pending mode
    -- update = {
    --   "ModeChanged",
    --   pattern = "*:*",
    --   callback = vim.schedule_wrap(function()
    --     vim.cmd("redrawstatus")
    --   end),
    -- },
  }

  local Macro = {
    condition = function()
      return vim.fn.reg_recording() ~= ""
    end,
    provider = function()
      return assets.macro .. 'recording @' .. vim.fn.reg_recording() .. ' '
    end,
    update = {
      "RecordingEnter",
      "RecordingLeave",
    }
  }

  local cwd = {
    provider = function()
      local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      return assets.dir .. dir_name .. ' '
    end
  }

  local Macro_cwd = {
    hl = {
      fg = 'bg',
      bg = 'purple',
    },
    {
      fallthrough = false,
      Macro, cwd
    },
    {
      provider = assets.right_separator .. '  ',
      hl = {
        fg = "purple",
        bg = "bg",
      },
    },
  }

  local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
      ---@diagnostic disable-next-line: undefined-field
      self.status_dict = vim.b.gitsigns_status_dict
    end,

    hl = { fg = "gray" },

    {
      provider = function(self)
        return assets.git .. self.status_dict.head
      end,
    },

    Space, Space
  }

  local Diagnostics = {
    condition = conditions.has_diagnostics,

    static = {
      icons = require("core.icons").diagnostics
    },

    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    {
      provider = function(self)
        return self.errors > 0 and (self.icons.Error .. " " .. self.errors .. " ")
      end,
      hl = { fg = "red" },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.icons.Warning .. " " .. self.warnings .. " ")
      end,

      hl = { fg = "yellow" },
    },
  }

  local Treesitter = {
    condition = function()
      return package.loaded['nvim-treesitter'] and require("nvim-treesitter.parsers").has_parser()
    end,
    provider = assets.tree,
    hl = {
      fg = "green",
    },
  }

  local LSPActive = {
    condition = conditions.lsp_attached,
    update = {'LspAttach', 'LspDetach'},

    provider  = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return assets.lsp .. table.concat(names, " ")
    end,
    hl = { fg = "gray" },
  }

  local SearchCount = {
    condition = function(self)
      if vim.v.hlsearch ~= 0 then
        local ok, res = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
        if ok and res.total then
          self.search = res
          return true
        end
      end
      return false
    end,
    provider = function(self)
      local direction = vim.v.searchforward == 1 and assets.search_forward or assets.search_backward
      local res = self.search
      if res.incomplete == 1 then
        return ('%s?/??%s'):format(assets.search, direction)
      else
        local stat = res.incomplete
        return ('%s%s%d/%s%d%s'):format(
          assets.search,
          (stat == 2 and res.current > res.maxcount) and ">" or "",
          res.current,
          stat == 2 and ">" or "",
          res.total,
          direction
        )
      end
    end,
  }

  local FileType = {
    provider = function ()
      local ft = vim.bo.filetype
      local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(ft, { default = true })
      ---@diagnostic disable-next-line: undefined-field
      if ft == "tex" and vim.b.vimtex.compiler.status == 1 then
        local spinners = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
        local idx = math.floor(vim.loop.hrtime() / 12e7) % #spinners + 1
        ft = ft .. string.format(" %%<%s ", spinners[idx])
      end
      return ' ' .. icon .. ' ' .. ft .. ' '
    end,
  }

  local SearchCount_FileType = {
    Space, Space,
    {
      provider = assets.left_separator,
      hl = {
        fg = "red",
      }
    },
    {
      fallthrough = false,
      hl = {
        fg = "bg",
        bg = "red",
      },
      SearchCount, FileType
    },
    {
      provider = assets.left_separator,
      hl = {
        fg = "flamingo",
        bg = "red",
      }
    },
  }

  local Hostname = {
    provider = assets.host .. vim.fn.hostname() .. ' ',
    hl = {
      fg = 'bg',
      bg = 'flamingo',
      bold = true,
    },
    update = { "BufEnter" },
  }

  local statusline = {
    Mode,
    Macro_cwd,
    Git,
    Diagnostics,

    Align,

    Treesitter,
    LSPActive,
    SearchCount_FileType,
    Hostname,
  }

  require("heirline").setup {
    statusline = statusline,
    opts = {
      colors = setup_colors(),
    }
  }

  vim.api.nvim_create_augroup("Heirline", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      utils.on_colorscheme(setup_colors)
    end,
    group = "Heirline",
  })
end

return M
