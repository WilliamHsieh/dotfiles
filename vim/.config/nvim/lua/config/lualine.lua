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
