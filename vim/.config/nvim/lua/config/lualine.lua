local lualine = require "lualine"
local icons = require "icons"

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
  colored = false,
  update_in_insert = false,
  always_visible = false,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local progress = function()
  local current_line = vim.fn.line "."
  local total_lines = vim.fn.line "$"
  return current_line .. "/" .. total_lines
end

lualine.setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "tagbar", "toggleterm" },
    always_divide_middle = true,
  },
  sections = {
    lualine_b = { branch, diagnostics },
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    -- lualine_x = { diff, spaces, "encoding", filetype },
    lualine_y = { progress },
    lualine_z = { "progress" },
  },
  tabline = {},
  extensions = {"nvim-tree", "toggleterm", "quickfix", "symbols-outline"}
}
