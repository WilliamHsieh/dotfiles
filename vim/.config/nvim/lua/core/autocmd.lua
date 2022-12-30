local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("config_group", { clear = true })

autocmd("FileType", {
  desc = "filetype settings",
  pattern = { "qf", "help", "man", "LspsagaHover" },
  group = "config_group",
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = "close buffer", buffer = 0 })
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

-- TODO: using new autocmd api
vim.cmd [[
  augroup Theme
    autocmd!
    au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    au InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/

    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
  augroup END
]]
