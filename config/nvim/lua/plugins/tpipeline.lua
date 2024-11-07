local M = {
  "vimpostor/vim-tpipeline",
  lazy = true,
  commit = "5f663e863df6fba9749ec6db0a890310ba4ad0a9",
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
  local augroup = vim.api.nvim_create_augroup("dotfiles_tpipeline_integration", { clear = true })

  -- cache status-bg
  local neovim_status_style = nil
  local function update_status_bg()
    local bg = require("core.utils").get_hl("Normal").bg
    neovim_status_style = string.format("bg=%s,fg=%s", bg, bg)
  end
  vim.schedule(update_status_bg)

  -- cache tmux status-style
  local tmux_status_style = nil
  vim.system({ "tmux", "show-options", "-gv", "status-style" }, { text = true }, function(obj)
    tmux_status_style = obj.stdout:match("([^\n]*)")
  end)

  -- update tmux status style based on current colorscheme
  local function set_tmux_status_style(style)
    -- default to set session option
    vim.system { "tmux", "set-option", "status-style", style }
  end

  -- unset tmux option to the one set in tmux.conf
  local function unset_tmux_option(opt)
    vim.system { "tmux", "set-option", "-u", opt }
  end

  -- set window name to current directory
  local function set_tmux_window_name_to_cwd()
    local ok, cwd = pcall(vim.fn.fnamemodify, vim.uv.cwd(), ":t")
    if ok and cwd then
      vim.system { "tmux", "rename-window", cwd }
    end
  end

  -- update tmux status by neovim statusline
  vim.api.nvim_create_autocmd({ "DiagnosticChanged", "RecordingEnter" }, {
    desc = "update tpipeline",
    command = "call tpipeline#update()",
    group = augroup,
  })

  -- update tmux status style cache based on current colorscheme
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      update_status_bg()
    end,
    group = augroup,
  })

  -- matched tmux status style and statusline
  vim.api.nvim_create_autocmd({ "ColorScheme", "FocusGained" }, {
    callback = function()
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        once = true,
        group = vim.api.nvim_create_augroup("dotfiles_force_update_tpipeline", { clear = true }),
        callback = function()
          -- color
          if tmux_status_style ~= neovim_status_style then
            set_tmux_status_style(neovim_status_style)
          end

          -- window name
          set_tmux_window_name_to_cwd()

          -- statusline
          vim.fn["tpipeline#forceupdate"]()
        end,
      })
    end,
    group = augroup,
  })

  -- reset tmux status style
  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function()
      if tmux_status_style ~= neovim_status_style then
        unset_tmux_option("status-style")
      end
    end,
    group = augroup,
  })

  -- rename tmux window with CWD
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = set_tmux_window_name_to_cwd,
    group = augroup,
  })

  -- reset tmux options set by neovim
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      vim.system { "tmux", "setw", "automatic-rename", "on" }
      unset_tmux_option("status-left")
      unset_tmux_option("status-right")
      unset_tmux_option("status-style")
    end,
    group = augroup,
  })
end

return M
