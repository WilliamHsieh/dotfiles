local M = {
  "goolord/alpha-nvim",
  priority = 500
}

local function setup()
  local dashboard = require "alpha.themes.dashboard"

  local function get_buttons()
    local icons = require "core.icons"
    return {
      dashboard.button("i", icons.ui.NewFile .. "  New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("r", icons.ui.History .. "  Recent files", ":FzfLua oldfiles<CR>"),
      dashboard.button("p", icons.git.Repo .. "  Find project", ":Telescope projects theme=dropdown<CR>"),
      dashboard.button("s", icons.misc.Watch .. "  Find session", ":SessionManager load_session<CR>"),
      dashboard.button("l", icons.ui.Fire .. "  Leetcode", ":Leet<CR>"),
      dashboard.button("c", icons.ui.Gear .. "  Config", ":e ~/dotfiles<CR>"),
      dashboard.button("q", icons.diagnostics.Error .. "  Quit", ":qa<CR>"),
    }
  end

  local function get_header()
    local banner = {
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
    }

    local height = vim.fn.winheight(0)
    local content = #banner + 2 * #dashboard.section.buttons.val + 5
    local cnt = vim.fn.max { 1, vim.fn.floor((height - content) * 0.4) }

    -- U+00A0
    local no_break_space = " "
    for _ = 1, cnt do
      table.insert(banner, 1, no_break_space)
    end
    return banner
  end

  local function get_footer()
    local v = vim.version()
    ---@diagnostic disable-next-line: need-check-nil
    return string.format("NVIM v%d.%d.%d", v.major, v.minor, v.patch)
  end

  dashboard.section.buttons.val = get_buttons()
  dashboard.section.header.val = get_header()
  dashboard.section.footer.val = get_footer()

  require("alpha").setup(dashboard.opts)
end

function M.config()
  if vim.o.filetype == "lazy" then
    vim.cmd.close()
    setup()
    require("lazy").show()
  else
    setup()
  end
end

return M
