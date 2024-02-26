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

        -- Do not tint `terminal` or floating windows, tint everything else
        return buftype == "terminal" or floating or filetype == "NvimTree"
      end
    }
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
      local ignore_filetypes = { 'NvimTree', 'qf' }
      local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

      local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        callback = function(_)
          ---@diagnostic disable-next-line: inject-field
          vim.w.focus_disable = vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        end,
        desc = 'Disable focus autoresize for BufType',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
          ---@diagnostic disable-next-line: inject-field
          vim.b.focus_disable = vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
        end,
        desc = 'Disable focus autoresize for FileType',
      })

      require("focus").setup(opts)
    end,
  }
}
