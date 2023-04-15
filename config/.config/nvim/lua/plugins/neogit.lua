local M = {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  dependencies = {
    "sindrets/diffview.nvim",
    "rhysd/conflict-marker.vim",
  },
}

M.opts = {
  disable_commit_confirmation = true,
  disable_insert_on_commit = false,
  console_timeout = 5000,
  commit_popup = {
    kind = "vsplit",
  },
  popup = {
    kind = "vsplit",
  },
  integrations = {
    diffview = true
  },
  sections = {
    unpulled = {
      folded = false
    },
    unmerged = {
      folded = false
    },
    recent = {
      folded = false
    },
  },
}

return M
