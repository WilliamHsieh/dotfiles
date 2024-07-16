-- TODO: blacklist *.min.js
local M = {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
}

M.opts = {
  "default-title",
  keymap = {
    -- These override the default tables completely
    -- no need to set to `false` to disable a bind
    -- delete or modify is sufficient
    builtin = {
      -- neovim `:tmap` mappings for the fzf win
      ["<F1>"] = "toggle-help",
      ["<F2>"] = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"] = "toggle-preview-wrap",
      ["<F4>"] = "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"] = "toggle-preview-ccw",
      ["<F6>"] = "toggle-preview-cw",
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
      ["<C-h>"] = "preview-page-reset",
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
