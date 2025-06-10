return {
  "folke/snacks.nvim",
  priority = 1000,

  ---@type snacks.config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    words = {
      enabled = true,
      debounce = 150,
    },
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    scope = {
      enabled = true,
    },
    input = { enabled = true },
    indent = {
      indent = {
        enabled = true,
        char = "▏",
        hl = "IblIndent",
      },
      scope = {
        char = "▏",
        hl = "IblScope",
      },
    },
    zen = {
      on_open = function()
        vim.system { "tmux", "set", "status", "off" }
      end,
      on_close = function()
        vim.system { "tmux", "set", "status", "on" }
      end,
    },
  },

  init = function()
    local snacks = require("snacks")

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        snacks.rename.on_rename_file(event.data.from, event.data.to)
      end,
    })

    local set_jump_words_keymap = function(buffer)
      local opts = buffer and { buffer = buffer } or nil
      vim.keymap.set({ "n", "t" }, "]]", function()
        snacks.words.jump(vim.v.count1)
      end, opts)
      vim.keymap.set({ "n", "t" }, "[[", function()
        snacks.words.jump(-vim.v.count1)
      end, opts)
    end

    vim.schedule(set_jump_words_keymap)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        set_jump_words_keymap(buffer)
      end,
    })
  end,
}
