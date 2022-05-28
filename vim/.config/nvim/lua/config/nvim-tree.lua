local icons = require("icons")

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
        { key = "l", action = "edit" },
        { key = "h", action = "close_node" },
        { key = "K", action = "toggle_file_info" },
        { key = "?", action = "toggle_help" },
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
