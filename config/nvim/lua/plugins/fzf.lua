-- TODO: blacklist *.min.js
local M = {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "TODOs" },
  },
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
      ["alt-p"] = function(...)
        require("overlook.api").peek_cursor()
        require("fzf-lua.actions").file_edit(...)
      end,
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
