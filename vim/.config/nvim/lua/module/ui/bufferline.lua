return function()
  local fill = { attribute = "bg", highlight = "TabLineFill" }
  local gray = { attribute = "fg", highlight = "FoldColumn" }
  local normal = require("core.utils").get_hl("Normal")

  -- base: others
  local base = {
    fg = gray,
    bg = fill,
  }

  -- base_visible: current, no focused
  local visible = {
    fg = gray,
    bg = normal.bg,
    bold = true,
  }

  -- base_selected: current, focused
  local selected = {
    fg = normal.fg,
    bg = normal.bg,
    bold = true,
  }

  -- modify indicator
  local modify = {
    fg = { attribute = "fg", highlight = "String" },
    bg = normal.bg,
    bold = true,
  }

  -- separator
  local separator_slant = {
    fg = fill,
    bg = normal.bg,
  }
  local separator_other = {
    fg = fill,
    bg = fill,
  }

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
      separator_style = "slant",
      always_show_bufferline = true,
      sort_by = "insert_after_current",
    },
    highlights = require("catppuccin.groups.integrations.bufferline").get(),

    -- highlights = {
    --   background = base,
    --   buffer_visible = visible,
    --   buffer_selected = selected,
    --   close_button = base,
    --   close_button_selected = selected,
    --   close_button_visible = selected,
    --   duplicate = base,
    --   duplicate_visible = visible,
    --   duplicate_selected = selected,
    --   modified = base,
    --   modified_visible = modify,
    --   modified_selected = modify,
    --   separator = separator_other,
    --   separator_visible = separator_slant,
    --   separator_selected = separator_slant,
    -- }
  }
end
