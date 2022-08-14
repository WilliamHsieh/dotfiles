return function()
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
      always_show_bufferline = true,
      sort_by = "insert_after_current",
    },
    -- from https://github.com/Mofiqul/vscode.nvim
    highlights = {
      fill = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLineNC" },
      },
      background = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      buffer_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      buffer_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      separator = {
        fg = { attribute = "bg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      separator_selected = {
        fg = { attribute = "fg", highlight = "Special" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      separator_visible = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLineNC" },
      },
      close_button = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      close_button_selected = {
        fg = { attribute = "fg", highlight = "normal" },
        bg = { attribute = "bg", highlight = "normal" },
      },
      close_button_visible = {
        fg = { attribute = "fg", highlight = "normal" },
        bg = { attribute = "bg", highlight = "normal" },
      },
      duplicate = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      duplicate_selected = {
        fg = { attribute = "fg", highlight = "Normal" },
        bg = { attribute = "bg", highlight = "Normal" },
      },
      modified = {
        bg = { attribute = "bg", highlight = "StatusLine" },
      },
      modified_visible = {
        bg = { attribute = "bg", highlight = "normal" },
      },
      modified_selected = {
        bg = { attribute = "bg", highlight = "normal" },
      },
    },
  }
end
