local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("config_group", { clear = true })

autocmd("FileType", {
  desc = "filetype settings",
  pattern = { "qf", "help", "man", "LspsagaHover" },
  group = "config_group",
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = "close buffer" })
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
  pattern = "PackerCompileDone",
  group = "config_group",
  callback = function()
    vim.notify("packer compiled")
  end
})

autocmd("User", {
  pattern = "AlphaReady",
  group = "config_group",
  callback = function()
    vim.o.showtabline = 0
    autocmd("BufUnload", {
      pattern = "<buffer>",
      group = "config_group",
      callback = function()
        vim.o.showtabline = 2
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
