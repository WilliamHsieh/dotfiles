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
  callback = function()
    require('focus').focus_autoresize()
  end
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

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionLoadPost",
  group = "config_group",
  callback = vim.schedule_wrap(function()
    pcall(require("nvim-tree.api").tree.toggle, false, true)
  end)
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

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = "config_group",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end

    local file = vim.loop.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")

    ---@diagnostic disable-next-line: param-type-mismatch
    if not vim.loop.fs_stat(dir) then
      local ok = vim.fn.mkdir(dir, "p")
      vim.notify(
        ("Missing directory [%s]%s"):format(dir, ok and " created." or ""),
        ok and "warn" or "error"
      )
    end
  end,
})

-- auto detach LSP after timeout
vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function(args)
    local lsp_detach_group = vim.api.nvim_create_augroup("lsp_detach", { clear = true })
    local timer = vim.loop.new_timer()
    local timeout = 1000 * 60 * 60 * 24

    vim.api.nvim_create_autocmd("FocusLost", {
      group = lsp_detach_group,
      callback = function()
        timer:start(timeout, 0, vim.schedule_wrap(function()
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "LspStop")
        end))
      end
    })

    vim.api.nvim_create_autocmd("FocusGained", {
      group = lsp_detach_group,
      callback = function()
        if not timer:is_active() then
          ---@diagnostic disable-next-line: param-type-mismatch
          pcall(vim.cmd, "LspStart")
        end
        timer:stop()
      end
    })
  end,
})
