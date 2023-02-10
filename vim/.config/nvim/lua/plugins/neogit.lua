local M = {
  "TimUntersberger/neogit",
  cmd = "Neogit",
  dependencies = {
    "sindrets/diffview.nvim",
    "rhysd/conflict-marker.vim",
  },
}

-- TODO: don't fold the stage / unstage changes, or use za to open fold?
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
    stashes = {
      folded = false
    },
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
  mappings = {
    status = {
      ['<cr>'] = "Toggle",
      ['o'] = "GoToFile",
    }
  }
}

return M
