local M = {
  "vimpostor/vim-tpipeline",
  cond = vim.env.TMUX ~= nil
}

function M.config()
  vim.g.tpipeline_cursormoved = 1
  vim.g.tpipeline_restore = 1
  vim.g.tpipeline_clearstl = 1
  vim.g.tpipeline_size = 300

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

  vim.api.nvim_create_augroup("Heirline", { clear = true })
  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "FocusGained" }, {
    callback = function()
      if not vim.g.tmux_status_style then
        vim.g.tmux_status_style = vim.fn.system { "tmux", "show-options", "-gv", "status-style" }
      end
      vim.defer_fn(function()
        local bg = require("core.utils").get_hl("Normal").bg
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
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      vim.fn.system { "tmux", "setw", "automatic-rename", "on" }
    end,
    group = "Heirline",
  })
end

return M
