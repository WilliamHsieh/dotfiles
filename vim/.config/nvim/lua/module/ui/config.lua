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
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', { fg = c.vscYellow, bg = "NONE", underline = true })
end

function config.catppuccin()
  require("catppuccin").setup {
    flavour = "macchiato",
    term_colors = true,
    dim_inactive = {
      enabled = true,
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      hop = true,
      illuminate = true,
      leap = true,
      lsp_saga = true,
      lsp_trouble = true,
      markdown = true,
      mason = true,
      neogit = true,
      noice = true,
      notify = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = false,
      },
      native_lsp = {
        enabled = true,
      },
      navic = {
        enabled = false,
        custom_bg = "NONE",
      },
    }
  }
  vim.api.nvim_command "colorscheme catppuccin"
end

function config.alpha()
  local alpha = require "alpha"
  local icons = require "core.icons"
  local dashboard = require "alpha.themes.dashboard"

  dashboard.section.buttons.val = {
    dashboard.button("i", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("f", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("F", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("p", icons.git.Repo .. " Find project", ":Telescope projects <CR>"),
    dashboard.button("s", icons.misc.Watch .. " Find session", "<cmd>SessionManager load_session<cr>"),
    dashboard.button("c", icons.ui.Gear .. " Config", ":e ~/dotfiles<cr>"),
    dashboard.button("q", icons.diagnostics.Error .. " Quit", ":qa<CR>"),
  }

  local function get_header()
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

  local function get_footer()
    local v = vim.version()
    return string.format("NVIM v%d.%d.%d", v.major, v.minor, v.patch)
  end

  dashboard.section.header.val = get_header()
  dashboard.section.footer.val = get_footer()
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.buttons.opts.hl = "Keyword"

  alpha.setup(dashboard.opts)
end

function config.tree()
  local icons = require "core.icons"
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

function config.tpipeline()
  vim.g.tpipeline_cursormoved = 1
  vim.g.tpipeline_restore = 1
  vim.g.tpipeline_clearstl = 1
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    command = "call tpipeline#update()"
  })
end

return config
