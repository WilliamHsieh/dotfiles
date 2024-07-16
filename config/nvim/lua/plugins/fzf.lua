-- TODO: blacklist *.min.js
local M = {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
}

M.opts = {
  "default-title",
  keymap = {
    builtin = {
      true,
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    },
  },
  actions = {
    files = {
      true,
      ["ctrl-h"] = function(...)
        require("fzf-lua.actions").toggle_hidden(...)
      end,
    },
  },
  previewers = {
    -- FIX: the preview is not ideal, escape sequences are screwed
    man = {
      cmd = "man %s | col -bx",
    },
  },
  grep = {
    rg_glob = true,
    winopts = {
      preview = {
        layout = "vertical",
        vertical = "up:60%",
      },
    },
  },
}

return M
