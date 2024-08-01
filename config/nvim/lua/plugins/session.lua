-- NOTE: ultimately, what i want is open a project with cwd set, and open files from harpoon list (or marks)
-- do this after harpoon2 is release and stable

local M = {
  "Shatur/neovim-session-manager",
  cmd = "SessionManager",
}

M.config = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "SessionLoadPost",
    callback = vim.schedule_wrap(function()
      pcall(require("nvim-tree.api").tree.toggle, false, true)
    end),
  })

  require("session_manager").setup {
    autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
  }
end

return M
