local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("config_group", { clear = true })

autocmd("FileType", {
  desc = "filetype settings",
  pattern = { "qf", "help", "man", "LspsagaHover" },
  group = "config_group",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = "close buffer", buffer = event.buf })
  end
})

autocmd("TextYankPost", {
  desc = "blink highlight text",
  pattern = "*",
  group = "config_group",
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 200,
    }
  end
})

autocmd("VimResized", {
  desc = "auto resize",
  pattern = "*",
  group = "config_group",
  command = "tabdo wincmd ="
})

autocmd("BufReadPost", {
  desc = "goto previous position",
  group = "config_group",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("User", {
  pattern = "AlphaReady",
  group = "config_group",
  callback = function()
    local pre_showtabline = vim.o.showtabline
    local pre_laststatus = vim.o.laststatus
    vim.o.showtabline = 0
    vim.o.laststatus = 0
    autocmd("BufUnload", {
      pattern = "<buffer>",
      group = "config_group",
      once = true,
      callback = function()
        vim.o.showtabline = pre_showtabline
        vim.o.laststatus = pre_laststatus
        vim.cmd.Lazy("load bufferline.nvim")
      end
    })
  end
})

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionLoadPost",
  group = "config_group",
  callback = function()
    require("nvim-tree").toggle(false, true)
  end
})

vim.api.nvim_create_autocmd('User', {
  pattern = { 'NeogitStatusRefreshed' },
  group = "config_group",
  callback = function()
    pcall(vim.cmd.NvimTreeRefresh)
  end
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = "config_group",
  callback = function()
    vim.cmd.match("ExtraWhitespace", [[/\s\+\%#\@<!$/]])
    vim.o.cursorline = false
  end
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = "config_group",
  callback = function()
    if vim.o.filetype ~= "toggleterm" then
      vim.cmd.match("ExtraWhitespace", [[/\s\+$\| \+\ze\t/]])
      vim.o.cursorline = true
    end
  end
})
