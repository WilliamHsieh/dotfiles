local M = {
  "goolord/alpha-nvim",
  priority = 500,
}

local function setup()
  local dashboard = require("alpha.themes.dashboard")

  local function get_buttons()
    local icons = require("mini.icons")
    return {
      dashboard.button("i", icons.get("default", "file") .. "  New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("r", "  Recent files", ":FzfLua oldfiles<CR>"),
      dashboard.button("s", icons.get("directory", ".git") .. "  Find session", ":SessionManager load_session<CR>"),
      dashboard.button("l", "  Leetcode", ":Leet<CR>"),
      dashboard.button("c", icons.get("filetype", "config") .. "  Config", ":e ~/.config/dotfiles<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
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
