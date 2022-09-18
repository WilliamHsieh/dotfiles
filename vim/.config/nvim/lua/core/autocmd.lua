local autocmd = vim.api.nvim_create_autocmd
local augroup = function (name)
  vim.api.nvim_create_augroup(name, { clear = true })
end

augroup("general_settings")
autocmd("FileType", {
  desc = "filetype settings",
  pattern = { "qf", "help", "man", "lspinfo", "LspsagaHover" },
  group = "general_settings",
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { desc = "close buffer" })
  end
})
autocmd("TextYankPost", {
  desc = "blink highlight text",
  pattern = "*",
  group = "general_settings",
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 200,
    }
  end
})
autocmd("FileType", {
  desc = "don't show qf in buffer",
  pattern = "qf",
  group = "general_settings",
  callback = function()
    vim.opt_local.buflisted = false
  end
})
autocmd("vimresized", {
  desc = "auto resize",
  pattern = "*",
  group = "general_settings",
  command = "tabdo wincmd ="
})

augroup("packer_settings")
autocmd("User", {
  pattern = "PackerCompileDone",
  group = "packer_settings",
  callback = function()
    vim.notify("packer compiled")
  end
})

augroup("alpha_settings")
autocmd("User", {
  pattern = "AlphaReady",
  group = "alpha_settings",
  callback = function()
    vim.opt.showtabline = 0
    vim.opt.laststatus = 0
    autocmd("BufUnload", {
      pattern = "<buffer>",
      group = "alpha_settings",
      callback = function()
        vim.opt.showtabline = 2
        vim.opt.laststatus = 3
      end
    })
  end
})

augroup("markdown_settings")
autocmd("FileType", {
  pattern = "markdown",
  group = "markdown_settings",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
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
