local alpha = require "alpha"
local icons = require "icons"
local dashboard = require "alpha.themes.dashboard"

dashboard.section.buttons.val = {
  dashboard.button("i", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("f", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
  dashboard.button("F", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
  dashboard.button("p", icons.git.Repo .. " Find project", ":Telescope projects <CR>"),
  dashboard.button("c", icons.ui.Gear .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", icons.diagnostics.Error .. " Quit", ":qa<CR>"),
}

dashboard.section.header.val = function()
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

dashboard.section.footer.val = function()
  local cnt = #vim.fn.globpath(vim.fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1)
  return cnt .. " plugins loaded"
end

dashboard.section.header.opts.hl = "Include"
dashboard.section.footer.opts.hl = "Type"
dashboard.section.buttons.opts.hl = "Keyword"

alpha.setup(dashboard.opts)
