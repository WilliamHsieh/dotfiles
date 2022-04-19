-- local status_ok, lualine = pcall(require, "lualine")
-- if not status_ok then
--   return
-- end
--
-- local status_gps_ok, gps = pcall(require, "nvim-gps")
-- if not status_gps_ok then
--   return
-- end
local lualine = require "lualine"
local gps = require "nvim-gps"

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

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

local diff = {
  "diff",
  colored = false,
  symbols = { added = icons.git.Add .. " ", modified = icons.git.Mod .. " ", removed = icons.git.Remove .. " " }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line "."
  local total_lines = vim.fn.line "$"
  return current_line .. "/" .. total_lines
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local nvim_gps = function()
  local gps_location = gps.get_location()
  if gps_location == "error" then
    return ""
  else
    return gps.get_location()
  end
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
    -- lualine_c = { _gps },
    lualine_c = {
      { nvim_gps, cond = hide_in_width },
    },
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    -- lualine_x = { diff, spaces, "encoding", filetype },
    lualine_y = { progress },
    lualine_z = { "progress" },
  },
  tabline = {},
  extensions = {"nvim-tree", "toggleterm", "quickfix", "symbols-outline"}
}
