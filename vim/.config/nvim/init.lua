local ok, impatient = pcall(require, "impatient")
if not ok then
  vim.notify('impatient is not setup properly')
else
  impatient.enable_profile()
end

-- TODO: simplified chinese is not properly shown
-- TODO: C-a and C-e in command line mode feels wierd
-- TODO: sessionloadpost open nvimtree: https://github.com/Shatur/neovim-session-manager
-- TODO: lazy load cmp until insertenter
-- TODO: lazy load treesitter
-- TODO: auto cd into current file (issue: tmuxconfig will not show branch on lualine properly)
-- FIX: typing tab in insert mode is jumping everywhere
-- NOTE: https://github.com/AstroNvim/AstroNvim
-- NOTE: https://github.com/nvim-lua/kickstart.nvim

require "setting"
require "plugins"
require "autocmd"
require "mapping"

-- autocmd FocusGained * silent !tmux set status off
-- autocmd VimLeave,FocusLost * silent !tmux set status on
