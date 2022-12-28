local M = {
  'feline-nvim/feline.nvim',
}

function M.config()
  -- TODO: using custom_providers
  local vi_mode = require("feline.providers.vi_mode")

  local function vi_mode_color()
    local m = vim.fn.mode():sub(1, 1)
    local color = 'blue'
    if m == 'R' then
      color = 'red'
    elseif m == 'c' then
      color = 'orange'
    elseif string.find("sSvV", m) or vi_mode.get_vim_mode() == 'BLOCK' then
      color = 'peach'
    elseif m == 'i' then
      color = 'green'
    elseif m == 'r' then
      color = 'purple'
    end
    return color
  end

  local assets = {
    left_separator = '',
    right_separator = '',
    mode = '',
    dir = '',
    tree = '',
  }

  local mode = {
    provider = function()
      local cur_mode = vi_mode.get_vim_mode()
      if cur_mode == 'INSERT' and vim.o.paste == true then
        cur_mode = 'PASTE'
      end
      if vim.env.TMUX then
        cur_mode = "#{?client_prefix,Prefix," .. cur_mode .. "}"
        -- cur_mode = "#{?client_prefix,Prefix,#{?pane_in_mode,Copy,#{?pane_synchronized,Sync," .. cur_mode .. "}}}"
      end
      return cur_mode .. ' '
    end,
    hl = function()
      return {
        fg = 'bg',
        bg = vi_mode_color(),
        style = 'bold',
      }
    end,
    icon = '  ',
    right_sep = {
      str = assets.right_separator,
      hl = function()
        return {
          fg = vi_mode_color(),
          bg = 'purple',
        }
      end,
    },
  }

  local cwd = {
    provider = function()
      local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      return ' ' .. assets.dir .. ' ' .. dir_name .. " "
    end,
    hl = {
			fg = 'bg',
			bg = 'purple',
    },
    right_sep = {
      str = assets.right_separator .. '  ',
      hl = {
        fg = 'purple',
        bg = 'bg',
      },
    },
  }

  local git_branch = {
    provider = 'git_branch',
    icon = ' ',
    right_sep = ' ',
    hl = {
      fg = 'gray'
    }
  }

  local function lsp_progress()
    local lsp = vim.lsp.util.get_progress_messages()[1]
    if not lsp then
      return ""
    end

    local spinners = { "", "", "" }
    local idx = math.floor(vim.loop.hrtime() / 12e7) % 3 + 1

    return string.format(" %%<%s %s %s (%s%%%%)",
      spinners[idx],
      lsp.title or "",
      lsp.message or "",
      lsp.percentage or 0
    )
  end

  local diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = {
      fg = 'red',
    }
  }
  local diagnostic_warnings = {
    provider = "diagnostic_warnings",
    hl = {
      fg = 'yellow',
    }
  }

  local lsp_client = {
    provider = 'lsp_client_names',
    hl = {
      fg = 'gray',
    },
    left_sep = ' ',
    right_sep = ' '
  }

  local treesitter_status = {
    provider = function()
      local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
      return (ts_avail and ts.has_parser()) and assets.tree or ""
    end,
    hl = {
      fg = 'green',
    },
    left_sep = ' ',
    right_sep = ' ',
  }

  local filetype = {
    provider = {
      name = 'file_type',
      opts = {
        filetype_icon = true,
        colored_icon = false,
        case = "lowercase",
      }
    },
    hl = {
      fg = 'bg',
      bg = 'red',
    },
    right_sep = {
      str = ' ',
      hl = {
        bg = 'red',
      },
    },
    left_sep = {
      {
        str = ' ' .. assets.left_separator,
        hl = {
          fg = 'red',
        },
      },
      {
        str = ' ',
        hl = {
          bg = 'red',
        },
      }
    },
  }

  local hostname = {
    provider = ' ' .. assets.mode .. ' ' .. vim.fn.hostname() .. ' ',
    hl = {
      fg = 'bg',
      bg = 'peach',
      style = 'bold',
    },
    left_sep = {
      str = assets.left_separator,
      hl = {
        fg = 'peach',
        bg = 'red',
      },
    },
  }

  -- https://github.com/feline-nvim/feline.nvim/blob/master/USAGE.md#themes
  local colors = require("catppuccin.palettes").get_palette()
  local catppuccin_theme = {
    bg = colors.base,
    red = colors.maroon,
    orange = colors.peach,
    yellow = colors.yellow,
    peach = colors.flamingo,
    green = colors.green,
    blue = colors.lavender,
    purple = colors.mauve,
    gray = colors.overlay1,
  }

  local feline = require("feline")

  -- statusline
  feline.setup {
    theme = catppuccin_theme,
    disable = {
      filetypes = {
        '^alpha$',
      },
    },
    force_inactive = {},
    components = {
      active = {
        {
          mode,
          cwd,
          git_branch,
          diagnostic_errors,
          diagnostic_warnings,
        },
        {
          { provider = lsp_progress, enabled = function() return vim.fn.exists("$TMUX") == 0 end },
        },
        {
          treesitter_status,
          lsp_client,
          filetype,
          hostname,
        }
      }
    }
  }
end

return M
