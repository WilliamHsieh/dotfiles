local M = {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  dependencies = {
    "sindrets/diffview.nvim",
    "rhysd/conflict-marker.vim",
  },
}

function M.config()
  require("neogit").setup {
    disable_commit_confirmation = true,
    disable_insert_on_commit = false,
    integrations = {
      diffview = true
    },
    mappings = {
      status = {
        ['<cr>'] = "Toggle",
        ['o'] = "GoToFile",
      }
    }
  }
end

return M
