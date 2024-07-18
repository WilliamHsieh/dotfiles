return {
  {
    "mrjones2014/smart-splits.nvim",
    opts = {},
    event = "VeryLazy",
    keys = {
      -- stylua: ignore start
      { '<C-Up>',    function() require('smart-splits').resize_up() end,         mode = { "", "!" }, desc = "resize up" },
      { '<C-Down>',  function() require('smart-splits').resize_down() end,       mode = { "", "!" }, desc = "resize down" },
      { '<C-Left>',  function() require('smart-splits').resize_left() end,       mode = { "", "!" }, desc = "resize left" },
      { '<C-Right>', function() require('smart-splits').resize_right() end,      mode = { "", "!" }, desc = "resize right" },
      { '<M-k>',     function() require('smart-splits').move_cursor_up() end,    mode = { "", "!" }, desc = "move cursor up" },
      { '<M-j>',     function() require('smart-splits').move_cursor_down() end,  mode = { "", "!" }, desc = "move cursor down" },
      { '<M-h>',     function() require('smart-splits').move_cursor_left() end,  mode = { "", "!" }, desc = "move cursor left" },
      { '<M-l>',     function() require('smart-splits').move_cursor_right() end, mode = { "", "!" }, desc = "move cursor right" },
      -- stylua: ignore end
    },
  },

  {
    "levouh/tint.nvim",
    event = "WinNew",
    opts = {
      window_ignore_function = function(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buftype = vim.bo[bufid].buftype
        local filetype = vim.bo[bufid].filetype
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

        -- tint everything else
        local buftype_blacklist = { "terminal" }
        local filetype_blacklist = { "NvimTree", "undotree", "trouble" }
        return floating
            or vim.tbl_contains(buftype_blacklist, buftype)
            or vim.tbl_contains(filetype_blacklist, filetype)
      end,
    },
  },

  {
    "nvim-focus/focus.nvim",
    event = "WinNew",
    opts = {
      ui = {
        cursorline = false,
        signcolumn = false,
      },
    },
    config = function(_, opts)
      vim.o.equalalways = false

      -- https://github.com/nvim-focus/focus.nvim?tab=readme-ov-file#disabling-focus
      local ignore_filetypes = { "NvimTree", "qf", "toggleterm", "trouble" }
      local ignore_buftypes = { "nofile", "prompt", "popup" }
      local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

      vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        callback = function(_)
          vim.w.focus_disable = vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        end,
        desc = "Disable focus autoresize for BufType",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function(_)
          vim.b.focus_disable = vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
        end,
        desc = "Disable focus autoresize for FileType",
      })

      require("focus").setup(opts)
    end,
  },
}
