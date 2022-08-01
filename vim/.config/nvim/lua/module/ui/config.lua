local config = {}

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

function config.lualine()
  local icons = require "icons"
  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  }

  local progress = function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    return current_line .. "/" .. total_lines
  end

  local function lsp_progress()
    local Lsp = vim.lsp.util.get_progress_messages()[1]
    if not Lsp then
      return ""
    end

    local spinners = { "", "", "" }
    local frame = math.floor(vim.loop.hrtime() / 1000000 / 120) % #spinners
    local title = Lsp.title or ""
    local msg = Lsp.message or ""
    local percentage = Lsp.percentage or 0

    return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
  end

  local function lsp_name()
    local clients = vim.lsp.buf_get_clients()
    if next(clients) == nil then
      return ""
    end

    local names = {}
    for _, client in pairs(clients) do
      if client.name ~= "null-ls" then
        table.insert(names, client.name)
      end
    end
    return table.concat(names, ", ")

    -- TODO: formatters and linters
  end

  local function treesitter_status()
    local b = vim.api.nvim_get_current_buf()
    if next(vim.treesitter.highlighter.active[b]) then
      return "綠TS"
    end
    return ""
  end

  require("lualine").setup {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha" },
      always_divide_middle = true,
    },
    sections = {
      lualine_b = { 'branch' },
      lualine_c = { diagnostics, 'filename' },
      lualine_x = {
        lsp_progress,
        {
          lsp_name,
          icon = "",
        },
        treesitter_status,
        "filetype",
      },
      lualine_y = { progress },
      lualine_z = { "progress" },
    },
    tabline = {},
    extensions = {"nvim-tree", "toggleterm", "quickfix", "symbols-outline"}
  }
end

function config.feline()
  local icons = require "icons"
  local function get_hl(group, prop)
    local color = vim.api.nvim_get_hl_by_name(group, true)[prop]
    return string.format("#%06x", color)
  end

  local function spacer(n)
    return string.rep(" ", n or 1)
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
    -- TODO: add brigt color to this: https://raw.githubusercontent.com/AstroNvim/astronvim.github.io/main/static/img/overview.png
    colored = false,
    update_in_insert = false,
    always_visible = false,
  }

  local progress = function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    return current_line .. "/" .. total_lines
  end

  local function lsp_progress()
    local Lsp = vim.lsp.util.get_progress_messages()[1]
    if not Lsp then
      return ""
    end

    local msg = Lsp.message or ""
    local percentage = Lsp.percentage or 0
    local title = Lsp.title or ""

    local spinners = { "", "", "" }
    local success_icon = { "", "", "" }

    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners

    if percentage >= 70 then
      return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
    end
    return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
  end

  local function treesitter_status()
    local b = vim.api.nvim_get_current_buf()
    if next(vim.treesitter.highlighter.active[b]) then
      return "綠TS"
    end
    return ""
  end

  require("feline").setup {
    components = {
      active = {
        {
          {
            provider = 'vi_mode',
            hl = function()
              return {
                name = require('feline.providers.vi_mode').get_mode_highlight_name(),
                fg = require('feline.providers.vi_mode').get_mode_color(),
                style = 'bold'
              }
            end,
            right_sep = ' ',
            icon = ''
          },
          { provider = "git_branch" },
          { provider = spacer() },
          { provider = "diagnostic_errors" },
          { provider = "diagnostic_warnings" },
          { provider = "diagnostic_info" },
          { provider = "diagnostic_hints" },
          { provider = spacer(2) },
          { provider = "file_info" },
        },
        {
          { provider = lsp_progress },
          { provider = spacer(2) },
          { provider = "lsp_client_names" },
          { provider = spacer(2) },
          { provider = treesitter_status },
          { provider = spacer(2) },
          { provider = "line_percentage" },
          { provider = spacer() },
          { provider = "scroll_bar" }
        },
      },
    },
  }
end

return config
