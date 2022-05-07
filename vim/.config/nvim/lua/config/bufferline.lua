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
