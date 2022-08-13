local ok, impatient = pcall(require, "impatient")
if ok then
  impatient.enable_profile()
else
  IMPATIENT_ERROR = true
end

require "core.setting"
require "core.plugins"
require "core.autocmd"
require "core.mapping"

-- FIX: speed up the startuptime!!
-- FIX: disable treesitter, ftplugin when file is too large
-- FIX: typing tab in insert mode is jumping everywhere
-- FIX: "C-a" and C-e in command line mode feels wierd
-- FIX: bufferline is showing strange buffer when entering netrw
-- FIX: make lualine x optional when there's no more space to display
-- FIX: default behavior for tab (happens when actually trying to type a tab)
-- TODO: smart split plugin
-- TODO: make <S-k> show vim document in lua/.vimrc file
-- TODO: simplified chinese is not properly shown
-- TODO: auto cd into current file (issue: tmuxconfig will not show branch on lualine properly)
-- TODO: how did makefile keep track of file update since last compilation?
-- NOTE: https://github.com/AstroNvim/AstroNvim
-- NOTE: https://github.com/nvim-lua/kickstart.nvim
-- TODO: execute previous command in termexec
-- TODO: feline
-- TODO: disable highlight under cursor in toggleterm filetype
-- NOTE: try barbar.nvim
-- NOTE: ui selection: https://github.com/stevearc/dressing.nvim
