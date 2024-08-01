local M = {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  dependencies = {
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewFileHistory", "DiffviewOpen" },
      opts = {
        keymaps = {
          file_history_panel = {
            ["q"] = "<cmd>tabclose<cr>",
          },
          file_panel = {
            ["q"] = "<cmd>tabclose<cr>",
          },
        },
      },
    },
  },
}

M.opts = {
  disable_commit_confirmation = true,
  disable_insert_on_commit = false,
  console_timeout = 5000,
  commit_editor = {
    kind = "vsplit",
  },
  popup = {
    kind = "vsplit",
  },
  integrations = {
    diffview = true
  },
  sections = {
    unpulled_pushRemote = {
      folded = false
    },
    unmerged_upstream = {
      folded = false
    },
    recent = {
      folded = false
    },
  },
}

M.config = function(_, opts)
  vim.api.nvim_create_autocmd("User", {
    pattern = { "NeogitStatusRefreshed" },
    callback = function()
      pcall(vim.cmd.NvimTreeRefresh)
    end,
  })

  require("neogit").setup(opts)
end

return M
