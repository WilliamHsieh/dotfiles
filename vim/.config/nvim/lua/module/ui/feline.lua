return function()
  local get_hl = require("core.utils").get_hl
  local vi_mode = require("feline.providers.vi_mode")

  local function vi_mode_color(is_bg)
    return function()
      local m = vim.fn.mode():sub(1, 1)
      local color = 'blue'
      if m == 'R' then
        color = 'red'
      elseif m == 'c' then
        color = 'orange'
      elseif string.find("sSvV", m) or vi_mode.get_vim_mode() == 'BLOCK' then
        color = 'yellow'
      elseif m == 'i' then
        color = 'green'
      elseif m == 'r' then
        color = 'purple'
      end

      return {
        name = vi_mode.get_mode_highlight_name(),
        fg = is_bg and 'bg' or color,
        bg = is_bg and color or "bg",
        style = is_bg and "bold" or "NONE"
      }
    end
  end

  local mode = {
    provider = function() return ' ' .. vi_mode.get_vim_mode() .. ' ' end,
    hl = vi_mode_color(true),
    right_sep = ' ',
  }

  local git_branch = {
    provider = 'git_branch',
    icon = ' ',
    right_sep = '  ',
    hl = vi_mode_color(false)
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

  local function treesitter_status()
    local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
    return (ts_avail and ts.has_parser()) and "綠TS" or ""
  end

  local hostname = {
    provider = vim.fn.hostname(),
    hl = vi_mode_color(false),
    left_sep = { str = ' ' },
    right_sep = { str = ' ' },
  }

  local line_percentage = {
    provider = 'line_percentage',
    hl = vi_mode_color(true),
    left_sep = { str = ' ', hl = vi_mode_color(true) },
    right_sep = { str = ' ', hl = vi_mode_color(true) },
  }

  local feline = require("feline")

  -- statusline
  feline.setup {
    theme = {
      bg = get_hl('Directory').bg,
      red = get_hl('Error').fg,
      orange = get_hl('String').fg,
      yellow = get_hl('Todo').fg,
      green = get_hl('TSNote').fg,
      blue = get_hl('Directory').fg,
      purple = get_hl('Keyword').fg,
    },
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
          git_branch,
          { provider = "diagnostic_errors", hl = 'DiagnosticError' },
          { provider = "diagnostic_warnings", hl = 'DiagnosticWarn' },
        },
        {
          { provider = lsp_progress, enabled = function() return not vim.fn.exists("$TMUX") end, left_sep = ' ' },
          { provider = 'lsp_client_names', left_sep = '  ', right_sep = ' ' },
          { provider = treesitter_status, left_sep = ' ', right_sep = ' ' },
          hostname,
          line_percentage,
        }
      }
    }
  }

  -- winbar
  local file_info = {
    provider = {
      name = 'file_info',
      opts = {
        type = "unique",
        file_modified_icon = ""
      }
    },
    hl = {
      style = 'bold',
    }
  }

  local modified_icon = {
    provider = "●",
    enabled = function()
      return vim.bo.modified
    end,
    left_sep = ' ',
    hl = { fg = 'orange' }
  }

  local winbar = {
    {
      file_info,
      modified_icon,
      {
        provider = function()
          local info = require("nvim-navic").get_location()
          return #info == 0 and "" or ' > ' .. info
        end,
        enabled = function()
          return require("nvim-navic").is_available()
        end,
      },
    }
  }
  feline.winbar.setup {
    disable = {
      filetypes = {
        '^alpha$',
        '^NvimTree$',
      },
    },
    components = {
      active = winbar,
      inactive = winbar,
    }
  }
end
