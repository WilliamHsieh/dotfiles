local options = {
  backup = false,                          -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 250,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

  tabstop = 2,                             -- insert 2 spaces for a tab
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  expandtab = true,                        -- convert tabs to spaces
  shiftround = true,

  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  laststatus = 3,                          -- global statusline
  cmdheight = 0,
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                            -- display lines as one long line
  scrolloff = 8,                           -- is one of my fav
  sidescrolloff = 8,
  virtualedit = 'block',
  showmode = false,
  mousemoveevent = true,
  fixendofline = false,
  grepprg = "rg --vimgrep --smart-case",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
vim.opt.shortmess:append "c"
vim.opt.whichwrap:append "<,>,[,],h,l"

local globals = {
  netrw_banner = 0,        -- disable banner
  netrw_liststyle = 3,     -- tree view
  netrw_bufsettings = 'noma nomod nonu nowrap ro buflisted', -- buflisted, fix bufferline wierdness
  mapleader = " "
}
for k, v in pairs(globals) do
  vim.g[k] = v
end

if vim.fn.exists("$TMUX") == 1 then
  vim.g.clipboard = {
    name = 'tmux_buffer',
    copy = {
      ['+'] = {'tmux', 'load-buffer', '-'},
      ['*'] = {'tmux', 'load-buffer', '-'},
    },
    paste = {
      ['+'] = {'tmux', 'save-buffer', '-'},
      ['*'] = {'tmux', 'save-buffer', '-'},
    },
    cache_enabled = 1,
  }
end
