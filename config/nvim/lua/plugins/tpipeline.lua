local M = {
  "vimpostor/vim-tpipeline",
  lazy = true,
}

function M.setup()
  vim.g.tpipeline_cursormoved = 1
  vim.g.tpipeline_restore = 1
  vim.g.tpipeline_clearstl = 1
  vim.g.tpipeline_size = 300

  -- https://github.com/vimpostor/vim-tpipeline/issues/19#issuecomment-1000844167
  vim.opt.fillchars:append {
    stl = "─",
    stlnc = "─",
  }
end

function M.config()
  -- update statusline
  vim.api.nvim_create_autocmd({ 'DiagnosticChanged', "RecordingEnter" }, {
    desc = "update tpipeline",
    command = "call tpipeline#update()"
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
