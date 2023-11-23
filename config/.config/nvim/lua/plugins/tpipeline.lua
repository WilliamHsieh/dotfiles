local M = {
  "vimpostor/vim-tpipeline",
  lazy = true,
  cond = require("core.utils").is_tmux_active()
}

function M.init()
  vim.g.tpipeline_cursormoved = 1
  vim.g.tpipeline_restore = 1
  vim.g.tpipeline_clearstl = 1
  vim.g.tpipeline_size = 300

  -- https://github.com/vimpostor/vim-tpipeline/issues/19#issuecomment-1000844167
  vim.opt.fillchars:append {
    stl = "─",
    -- HACK: https://github.com/neovim/neovim/pull/25941
    stlnc = "-",
    horiz = '─',
    horizup = '┴',
    horizdown = '┬',
    vert = '│',
    verthoriz = '┼',
  }
end

function M.config()
  -- update statusline
  vim.api.nvim_create_autocmd({ 'DiagnosticChanged', "RecordingEnter" }, {
    desc = "update tpipeline",
    command = "call tpipeline#update()"
  })

  -- update statusline on vim-matchup
  vim.api.nvim_create_autocmd("User", {
    pattern = "MatchupOffscreenEnter",
    callback = function()
      if not string.find(vim.g.tpipeline_statusline, "matchup") then
        vim.g.sl = vim.g.tpipeline_statusline
      end
      if string.find(vim.o.stl, "matchup") then
        vim.g.tpipeline_statusline = vim.o.stl
      end
      vim.fn["tpipeline#update"]()
    end
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "MatchupOffscreenLeave",
    callback = function()
      vim.g.tpipeline_statusline = vim.g.sl
      vim.fn["tpipeline#update"]()
    end
  })

  -- update tmux status style based on current colorscheme
  local function set_tmux_style(style)
    vim.fn.system { "tmux", "set", "status-style", style }
  end

  local utils = require("core.utils")

  vim.api.nvim_create_augroup("Heirline", { clear = true })
  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "FocusGained" }, {
    callback = function()
      if not vim.g.tmux_status_style then
        vim.g.tmux_status_style = utils.get_tmux_option("status-style")
      end
      vim.defer_fn(function()
        vim.fn["tpipeline#forceupdate"]()
        local bg = utils.get_hl("Normal").bg
        set_tmux_style(("bg=%s,fg=%s"):format(bg, bg))
      end, 50)
    end,
    group = "Heirline",
  })
  vim.api.nvim_create_autocmd({ "FocusLost", "VimLeave" }, {
    callback = function()
      set_tmux_style(vim.g.tmux_status_style)
    end,
    group = "Heirline",
  })

  -- rename tmux window with CWD
  vim.api.nvim_create_autocmd({ "DirChanged", "FocusGained" }, {
    callback = function()
      vim.fn.system { "tmux", "rename-window", vim.fn.fnamemodify(vim.fn.getcwd(), ":t") }
    end,
    group = "Heirline",
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      vim.fn.system { "tmux", "setw", "automatic-rename", "on" }
    end,
    group = "Heirline",
  })
end

return M
