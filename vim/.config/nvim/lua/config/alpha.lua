local alpha = require "alpha"
local icons = require "icons"

local function footer()
  local plugins_cnt = #vim.fn.globpath(vim.fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1)
  return plugins_cnt .. " plugins loaded"
end

local dashboard = require "alpha.themes.dashboard"

-- https://manytools.org/hacker-tools/ascii-banner/
dashboard.section.header.val = {
  "", "", "", "", "", "",
  "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

dashboard.section.buttons.val = {
  dashboard.button("i", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
  dashboard.button("f", icons.documents.Files .. " Find file", ":Telescope find_files <CR>"),
  dashboard.button("F", icons.ui.List .. " Find text", ":Telescope live_grep <CR>"),
  dashboard.button("p", icons.git.Repo .. " Find project", ":Telescope projects <CR>"),
  dashboard.button("c", icons.ui.Gear .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", icons.diagnostics.Error .. " Quit", ":qa<CR>"),
}

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
