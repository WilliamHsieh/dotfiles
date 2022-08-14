local config = {}

function config.vscode()
  local c = require("vscode.colors")
  require("vscode").setup {
    group_overrides = {
      cppTSKeyword = { fg = c.vscBlue },
      cppTSConstMacro = { fg = c.vscPink },
      NvimTreeFolderName = { fg = c.vscBlue },
      NvimTreeOpenedFolderName = { fg = c.vscBlue },
    }
  }
end

function config.alpha()
  local alpha = require "alpha"
  local icons = require "icons"
  local dashboard = require "alpha.themes.dashboard"

  dashboard.section.buttons.val = {
    dashboard.button("i", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("f", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("F", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("p", icons.git.Repo .. " Find project", ":Telescope projects <CR>"),
    dashboard.button("c", icons.ui.Gear .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("q", icons.diagnostics.Error .. " Quit", ":qa<CR>"),
  }

  dashboard.section.header.val = function()
    -- https://manytools.org/hacker-tools/ascii-banner/
    local banner = {
      "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }

    local height = vim.fn.winheight(0)
    local content = #banner + 2 * #dashboard.section.buttons.val + 5
    local cnt = vim.fn.max{1, vim.fn.floor((height - content) * 0.4)}

    local res = {}
    for _ = 1, cnt do
      table.insert(res, "")
    end
    for _, v in pairs(banner) do
      table.insert(res, v)
    end
    return res
  end

  dashboard.section.footer.val = function()
    local cnt = #vim.fn.globpath(vim.fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1)
    return cnt .. " plugins loaded"
  end

  dashboard.section.header.opts.hl = "Include"
  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.buttons.opts.hl = "Keyword"

  alpha.setup(dashboard.opts)
end

function config.tree()
  local icons = require "icons"
  require('nvim-tree').setup {
    ignore_ft_on_setup = { "alpha" },
    update_cwd = true,
    diagnostics = {
      enable = true,
      icons = {
        hint = icons.diagnostics.Hint,
        info = icons.diagnostics.Information,
        warning = icons.diagnostics.Warning,
        error = icons.diagnostics.Error,
      },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
    },
    git = {
      enable = true,
      ignore = true,
      timeout = 500,
    },
    view = {
      width = 30,
      height = 30,
      hide_root_folder = false,
      side = "left",
      mappings = {
        custom_only = false,
        list = {
          { key = "?", action = "toggle_help" },
          { key = "l", action = "edit" },
          { key = "h", action = "close_node" },
          { key = "K", action = "toggle_file_info" },
          { key = "y", action = "copy" },
          { key = "<C-k>", action = "" },
        },
      },
      number = false,
      relativenumber = false,
    },
    renderer = {
      group_empty = true,
      icons = {
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "M",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            deleted = "",
            untracked = "U",
            ignored = "◌",
          },
          folder = {
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
          },
        }
      }
    },
  }
end

function config.bufferline()
  require("bufferline").setup {
    options = {
      numbers = "none",
      close_command = "Bdelete %d",
      right_mouse_command = "Bdelete %d",
      diagnostics = false,
      diagnostics_update_in_insert = false,
      offsets = { { filetype = "NvimTree", text = "", padding = 0 } },
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      separator_style = "thin",
      enforce_regular_tabs = true,
      always_show_bufferline = true,
      sort_by = "insert_after_current" -- "insert_at_end"
    },
    -- from https://github.com/Mofiqul/vscode.nvim
    highlights = {
      fill = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "StatusLineNC" },
      },
      background = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "StatusLine" },
      },
      buffer_visible = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "Normal" },
      },
      buffer_selected = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "Normal" },
      },
      separator = {
        guifg = { attribute = "bg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "StatusLine" },
      },
      separator_selected = {
        guifg = { attribute = "fg", highlight = "Special" },
        guibg = { attribute = "bg", highlight = "Normal" },
      },
      separator_visible = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "StatusLineNC" },
      },
      close_button = {
        guifg = { attribute = "fg", highlight = "Normal" },
        guibg = { attribute = "bg", highlight = "StatusLine" },
      },
      close_button_selected = {
        guifg = { attribute = "fg", highlight = "normal" },
        guibg = { attribute = "bg", highlight = "normal" },
      },
      close_button_visible = {
        guifg = { attribute = "fg", highlight = "normal" },
        guibg = { attribute = "bg", highlight = "normal" },
      },
      modified = {
        guibg = { attribute = "bg", highlight = "StatusLine" },
      },
      modified_visible = {
        guibg = { attribute = "bg", highlight = "normal" },
      },
      modified_selected = {
        guibg = { attribute = "bg", highlight = "normal" },
      },
    },
  }
end

function config.feline()
  local function get_hl(group)
    local hl = vim.api.nvim_get_hl_by_name(group, true)
    local function to_hex(color)
      return color and string.format("#%06x", color) or ''
    end
    return { fg = to_hex(hl.foreground), bg = to_hex(hl.background) }
  end

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

  local vi_mode = require("feline.providers.vi_mode")
  local vi_mode_color = 'info'

  require("feline").setup {
    theme = {
      info = get_hl('DiagnosticInfo').fg,
    },
    components = {
      active = {
        {
          {
            provider = function() return ' ' .. vi_mode.get_vim_mode() .. ' ' end,
            hl = { fg = 'bg', bg = vi_mode_color, style = 'bold' },
            right_sep = ' ',
          },
          { provider = 'git_branch', icon = ' ', right_sep = '  ', hl = { fg = vi_mode_color } },
          {
            provider = {
              name = 'file_info',
              opts = {
                colored_icon = false,
                type = "unique",
                file_modified_icon = "[+]"
              }
            },
            icon = '',
          },
        },
        {
          -- lsp
          { provider = "diagnostic_errors", hl = 'DiagnosticError' },
          { provider = "diagnostic_warnings", hl = 'DiagnosticWarn' },
          { provider = lsp_progress },
          { provider = 'lsp_client_names', left_sep = '  ', right_sep = ' ' },

          -- treesitter
          { provider = treesitter_status, left_sep = ' ', right_sep = ' ' },

          -- filetype
          {
            provider = {
              name = 'file_type',
              opts = {
                filetype_icon = true,
                case = "lowercase",
              }
            },
            left_sep = ' ',
            right_sep = ' ',
          },

          -- position
          { provider = 'position', left_sep = ' ', right_sep = ' ', hl = { fg = vi_mode_color } },
          { provider = 'line_percentage',
            hl = { fg = 'bg', bg = vi_mode_color, style = 'bold' },
            left_sep = { str = ' ', hl = { fg = 'bg', bg = vi_mode_color }},
            right_sep = { str = ' ', hl = { fg = 'bg', bg = vi_mode_color }}
          },
        }
      },
    },
  }
end

return config
