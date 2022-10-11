local autocmd = vim.api.nvim_create_autocmd
vim.api.nvim_create_augroup("config_group", { clear = true })

autocmd("FileType", {
  desc = "filetype settings",
  pattern = { "qf", "help", "man", "lspinfo", "LspsagaHover" },
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
autocmd("FileType", {
  desc = "don't show qf in buffer",
  pattern = "qf",
  group = "config_group",
  callback = function()
    vim.opt_local.buflisted = false
  end
})
autocmd("VimResized", {
  desc = "auto resize",
  pattern = "*",
  group = "config_group",
  command = "tabdo wincmd ="
})
autocmd("BufEnter", {
  desc = "close nvim-tree if it's the last buffer",
  pattern = "*",
  group = "config_group",
  nested = true,
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.fn.bufname() == 'NvimTree_' .. vim.fn.tabpagenr() then
      vim.cmd("quit")
    end
  end
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
    vim.opt.showtabline = 0
    autocmd("BufUnload", {
      pattern = "<buffer>",
      group = "config_group",
      callback = function()
        vim.opt.showtabline = 2
      end
    })
  end
})

autocmd("FileType", {
  pattern = "markdown",
  group = "config_group",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
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
