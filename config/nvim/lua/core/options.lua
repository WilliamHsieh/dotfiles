local options = {
  backup = false, -- creates a backup file
  completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = "a", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 250, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 300, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

  tabstop = 2, -- insert 2 spaces for a tab
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  expandtab = true, -- convert tabs to spaces
  shiftround = true, -- Round indent to multiple of 'shiftwidth'.  Applies to > and <

  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  laststatus = 3, -- global statusline
  cmdheight = 0, -- FIX: something is changing this, probably from snacks
  relativenumber = true, -- set relative numbered lines
  numberwidth = 4, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 8, -- is one of my fav
  sidescrolloff = 8,
  virtualedit = "block",
  showmode = false,
  mousemoveevent = true,
  fixendofline = false,
  grepprg = "rg --vimgrep --smart-case",
  splitkeep = "cursor",
  showcmdloc = "statusline",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.shortmess:append("c")
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.diffopt:append { "algorithm:histogram", "linematch:60" } -- enable linematch diff algorithm
vim.opt.fillchars:append {
  -- HACK: https://vi.stackexchange.com/a/34849
  stl = " ",
  eob = " ",
}

vim.g.mapleader = " "

require("core.utils").on_tmux_active(function()
  local load_buffer = { "tmux", "load-buffer", "-" }
  local save_buffer = { "tmux", "save-buffer", "-" }

  vim.g.clipboard = {
    name = "tmux_buffer",
    copy = {
      ["+"] = load_buffer,
      ["*"] = load_buffer,
    },
    paste = {
      ["+"] = save_buffer,
      ["*"] = save_buffer,
    },
    cache_enabled = 1,
  }

  vim.o.clipboard = "unnamedplus"
end)
