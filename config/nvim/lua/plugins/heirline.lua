local M = {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
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
    host = " 󰒋 ",
    dir = "  ",
    tree = "  ",
    macro = "  ",
    search = "  ",
    lsp = "  ",
    git = " ",
    settings = "  ",
    search_forward = "  ",
    search_backward = "  ",
  }

  local function wrap_tmux_highlight(color_bg, component)
    if not require("core.utils").is_tmux_active() then
      return component
    end
    local settings = {
      { "#{?client_prefix,", "Prefix", "pink" },
      { "#{?pane_in_mode,", "Copy", "yellow" },
      { "#{?pane_synchronized,", "Sync", "green" },
    }
    local res = {}
    for _, s in pairs(settings) do
      res[#res + 1] = {
        provider = s[1] .. (color_bg and assets.tmux .. s[2] .. " " or assets.right_separator) .. ",",
        hl = color_bg and { bg = s[3] } or { fg = s[3] },
      }
    end
    return {
      hl = color_bg and { fg = 'bg' } or { bg = 'purple' },
      res,
      component,
      {
        provider = "}}}",
      }
    }
  end

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

    hl = { bold = true },

    wrap_tmux_highlight(true, {
      provider = function(self)
        return assets.vim .. self.mode_alias[self.mode] .. ' '
      end,
      hl = function(self)
        return {
          fg = 'bg',
          bg = self.mode_color[self.short_mode],
        }
      end,
    }),

    wrap_tmux_highlight(false, {
      provider = assets.right_separator,
      hl = function(self)
        return {
          fg = self.mode_color[self.short_mode],
          bg = 'purple',
        }
      end
    }),
  }

  local Macro = {
    condition = function(self)
      self.reg = vim.fn.reg_recording()
      return self.reg ~= ""
    end,
    provider = function(self)
      return assets.macro .. 'recording @' .. self.reg
    end,
    update = {
      "RecordingEnter",
      "RecordingLeave",
    }
  }

  local Dir = {
    provider = function()
      return assets.dir .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ' '
    end,
    update = "DirChanged"
  }

  local FileType = {
    provider = function()
      local ft = vim.bo.filetype
      local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(ft, { default = true })
      return ' ' .. icon .. ' ' .. ft
    end,
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = " ",
    },
  }

  local Macro_Filetype = {
    hl = {
      fg = 'bg',
      bg = 'purple',
    },
    {
      fallthrough = false,
      Macro, FileType
    },
    Space,
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
    hl = { fg = "gray", bg = "bg" },
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
    {
      provider = function(self)
        return self.errors > 0 and (self.icons.Error .. " " .. self.errors .. " ")
      end,
      hl = { fg = "red", bg = "bg" },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.icons.Warning .. " " .. self.warnings .. " ")
      end,
      hl = { fg = "yellow", bg = "bg" },
    },
    update = { "DiagnosticChanged", "BufEnter" },
  }

  local Treesitter = {
    condition = function()
      return package.loaded['nvim-treesitter'] and require("nvim-treesitter.parsers").has_parser()
    end,
    provider = assets.tree,
    hl = { fg = "green", bg = "bg" },
  }

  local LSPActive = {
    condition = conditions.lsp_attached,
    provider  = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return assets.lsp .. table.concat(names, " ")
    end,
    hl = { fg = "gray", bg = "bg" },
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

  local TmuxSession = {
    condition = function()
      return require("core.utils").is_tmux_active()
    end,
    provider = assets.settings .. "#S "
  }

  local SearchCount_TmuxSession_Dir = {
    {
      Space, Space,
      hl = { fg = "bg", bg = "bg" },
    },
    {
      provider = assets.left_separator,
      hl = { fg = "red", bg = "bg" }
    },
    {
      fallthrough = false,
      hl = { fg = "bg", bg = "red" },
      SearchCount, TmuxSession, Dir
    },
    {
      provider = assets.left_separator,
      hl = { fg = "flamingo", bg = "red" }
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

  local ShowCmd = {
    provider = "%S ",
    hl = { fg = "gray", bg = "bg" },
  }

  local StatusLine = {
    Mode, Macro_Filetype, Git, Diagnostics,
    Align,
    ShowCmd, Treesitter, LSPActive, SearchCount_TmuxSession_Dir, Hostname,
  }

  require("heirline").setup {
    statusline = StatusLine,
    opts = {
      colors = setup_colors(),
    }
  }
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      utils.on_colorscheme(setup_colors)
    end,
  })

  if require("core.utils").is_tmux_active() then
    require("plugins.tpipeline").setup()
    require("lazy").load { plugins = { "vim-tpipeline" } }
  end
end

return M
