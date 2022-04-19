require("bufferline").setup {
  options = {
    numbers = "none",
    close_command = "Bdelete %d",
    right_mouse_command = "Bdelete %d",
    diagnostics = "nvim_lsp",
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
}
