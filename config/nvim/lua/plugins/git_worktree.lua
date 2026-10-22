local M = {
  "polarmutex/git-worktree.nvim",
  keys = {
    {
      "<leader>gb",
      function()
        local git_root_path = require("plenary.job"):new {
          command = "git",
          args = { "rev-parse", "--show-toplevel" }
        }:sync()[1]
        vim.cmd.cd(git_root_path)
        require('session_manager').save_current_session()
        pcall(require("nvim-tree.api").tree.toggle, false, true)

        vim.schedule(function()
          vim.cmd("Telescope git_worktree theme=dropdown")
        end)
      end,
      desc = "Checkout branch (worktree)"
    },
  },
}

function M.config()
  require("core.utils").on_load("telescope.nvim", function()
    require("telescope").load_extension("git_worktree")
  end)

  local worktree = require("git-worktree")
  worktree.on_tree_change(function(op, metadata)
    if op == worktree.Operations.Switch then
      vim.cmd("%bdelete")
      vim.cmd.cd(metadata.path)
      require('session_manager').load_current_dir_session()
      vim.schedule(function()
        vim.notify("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
      end)
    end
  end)
end

return M
