local M = {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "rhysd/conflict-marker.vim",
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

return M
