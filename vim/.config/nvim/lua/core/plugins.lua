local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "--single-branch", "https://github.com/folke/lazy.nvim.git", lazypath }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    colorscheme = { "catppuccin", "habamax" },
  },
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      event = "",
      ft = "",
      init = "",
      keys = "",
      plugin = "",
      runtime = "",
      source = "",
      start = "",
      task = "✔ ",
      lazy = "鈴 ",
    },
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "matchit",
        "matchparen",
        "netrwPlugin",
      },
    },
  },
})
