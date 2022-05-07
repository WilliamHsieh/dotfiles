-- each of these are documented in `:help nvim-tree.OPTION_NAME`
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_icons = {
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

require('nvim-tree').setup {
  -- TODO: is this the right option?
  hijack_directories = {
    enable = false,
  },
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
  },
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
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
}
