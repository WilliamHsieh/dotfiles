-- NOTE: ultimately, what i want is open a project with cwd set, and open files from harpoon list (or marks)
-- do this after harpoon2 is release and stable

local M = {
  "Shatur/neovim-session-manager",
  cmd = "SessionManager",
  event = "LazyFile",
}

M.init = function()
  vim.opt.sessionoptions = "curdir,tabpages,winsize,globals,buffers"
end

M.config = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "SessionLoadPost",
    callback = vim.schedule_wrap(function()
      -- HACK: this is a workaround for a race condition from `focus` plugin (resizer.lua)
      -- it will set `cmdheight` to 1, when loading a session
      vim.o.cmdheight = 0
    end),
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "SessionSavePost",
    callback = vim.schedule_wrap(function()
      require("plugins.lsp.utils").stop_lsp()
    end),
  })

  require("session_manager").setup {
    autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
    -- autosave_last_session = false,
  }

  local group = vim.api.nvim_create_augroup("dotfiles_session_manager", {})

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      vim.cmd.ProjectRoot()
      require("session_manager").save_current_session()
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "SessionSavePost",
    group = group,
    callback = function()
      -- so switching between projects doesn't mess up lsp related stuff (e.g. semantic tokens)
      pcall(vim.cmd.LspStop)
    end,
  })
end

return M
