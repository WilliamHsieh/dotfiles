require "core.setting"
require "core.plugins"
require "core.autocmd"

-- TODO: set nofoldenable

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    require "core.mapping"
  end
})

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldenable = false
--
-- 
-- TODO: migrate everything to github ISSUE

-- HACK: ultimate mode(modal.nvim?): https://github.com/doomemacs/doomemacs/tree/screenshots#mode-line

-- HACK: plugin idea: create tmux component from vim! https://github.com/edkolev/tmuxline.vim
-- 0. write your tmux status with your favorite nvim plugin / lua!
-- 1. one config for neovim / tmux, so no duplicate setup for both tmux and neovim
-- 2. works well for neovim, tmux, neovim + tmux, w/out tpipeline
-- 3. source tmux status directly from nvim --headless -c "Vimuxline tmux"
-- 4. don't re-invent the wheel if some features are already done by other plugins
-- 5. impl: search for NORMAL and replace on mode change, or use #{prefix-highlight}
-- 6. cache the rendered tmux statusline in .cache/Vimuxline/tmux_status
-- 7. tmux-status.nvim, tmuxstatus.nvim, status-mode.nvim, tmux-mode.nvim, tmuxline.nvim
-- 8. how to implement tmux native component, e.g. time
-- 9. doc(feat): meta status mode indicator, showing lsp status on tmux
-- 10. use neovim statusline plugins to write tmux status? (prefix-highlight placeholder? and use neovim to update the value directly)
-- 11. custom component placeholder #{tmode-mode} #{tmode-dir}
-- 12. sync (or other mode) overlapped with vim-mode can be concealed to a icon
-- 13. tmux prefix, vim mode, macro recording, search count, etc
-- FIX: catppuccin: cache is not reload properly when updating
-- FIX: ❯ zinit creinstall -q /home/william/.local/share/zinit/snippets
-- FIX: ❯ zinit creinstall -q /home/william/.local/share/zinit/plugins/
-- FIX: default behavior for tab (happens when actually trying to type a tab)
-- FIX: deduplicate entries
--      nvim_create_namespace(name)                                Function
--      nvim_create_augroup(name, opts)                            Function
--      nvim_create_autocmd(event, opts)                           Function
--      nvim_create_buf(listed, scratch)                           Function
--      nvim_create_user_command(name, command, opts)              Function
--      nvim_create_buf                                            Function
--      nvim_create_autocmd                                        Function
--      nvim_create_augroup                                        Function
--      nvim_create_namespace                                      Function
--      nvim_create_user_command                                   Function
-- FIX: alacritty not show chinese font box on macos
-- XXX: (lazy): `K` on plugin name will open two browser window
-- XXX: (lazy): support folding in commit view
-- XXX: (lazy): log is not showing when plugins are not updated yet
-- XXX: (lazy): reload lockfile on lockfile change, lockfile isn't valided when startup (maybe it's using old cache?)
--      repro: checkout to old commit with old lockfile(maybe with new plugins missing), open nvim make sure everything sync, and checkout to new commit, lockfile isn't loaded properly
--      reload lockfile before check and restore and install and update (if fs_stat change)
-- XXX: dap-zero
-- XXX: (lspconfig): auto map `q` and `esc` to the document pane
-- XXX: (alacritty): alacritty cross line URL detection
-- XXX: (noice): options for accumulating warnings and errors into (#cnts)
-- XXX: (catppuccin): separate custom_kind (symbol outline / lspsaga)
-- XXX: (fsread): make {"n", "v"} mapping available (see gitsigns)
-- XXX: (lazy): make commit toggleable / foldable (both check and log) (sometimes the commit log is huge)
-- XXX: (lazy): deduplicate the ui: https://github.com/folke/lazy.nvim/issues/361#issuecomment-1377268839
--       idea: changing Tasks: xx/xx plugins to Install/Update/Sync/Clean/Check/Restore:
-- ISSUE: lazy: `K` on not loaded plugin name will result in wrong url
-- ISSUE: noice will not show the same message again after notification dissapear (only for <C-G>?)
-- ISSUE: bug(noice): first echo message (or lua =) is not shown in NoiceHistory
-- ISSUE: bug(noice): icons in noice history doesn't follow cursor position
-- ISSUE: lspsaga: repro: <space>lj -> Q, the diagnostics will not dissapear
-- TODO: nvim-tree open on startup: https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
-- TODO: lazy load bufferline and feline
-- TODO: diffview: change <C-U> <C-D> to scroll the view
-- TODO: horizontal split border
-- TODO: notify is causing cursor to shiver, change to a non shivering animation?
-- TODO: uniform UI (cmp border, whichkey border and bg) like LunarVim
-- TODO: mason: show install success message even ui isn't opened: https://github.com/williamboman/mason.nvim/blob/main/lua/mason/ui/instance.lua#L598
-- TODO: notify, vimtex: a spinner for vimtex compilation (VimtexEventCompiling)
-- TODO: todo comment: comments_only
-- TODO: close autocmd to buftype=notype
-- TODO: lazy (kyazdani42 -> nvim-tree)
-- TODO: hop to leap
-- TODO: cmp icon: https://github.com/nyoom-engineering/nyoom.nvim
-- TODO: add nvim lsp completion to nvim-cmp commandline
-- TODO: auto call script.sh install when enter tmux, clone each thing in seperate tmux pane
-- TODO: script.sh bootstrap to check all the requires binarys
-- TODO: telescope send_to_loclist
-- TODO: tmux hook: job finished in xxx session (if not in current session)
-- TODO: neogit stage panel keyword(modified, delete) is not colored as git status
-- TODO: !! in toggleterm to execute previous command
-- TODO: don't show full LSP name (maybe just a icon) when on laptop
-- TODO: smart split plugin
-- TODO: use @resurrect-hook-post-save-all to ":SessionManager save_current_session"
--       also test tmux kill-server
--       also inform the user what's previous vim session (or restore strategy)
--       https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/hooks.md
-- TODO: mergetool for conflicts
--       https://github.com/sindrets/diffview.nvim
--       https://github.com/rhysd/conflict-marker.vim
--       https://github.com/tpope/vim-fugitive/
--       http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/
--       https://github.com/samoshkin/vim-mergetool
-- NOTE: https://github.com/ajeetdsouza/zoxide
-- NOTE: https://github.com/kevinhwang91/nvim-fundo
-- NOTE: https://github.com/mvllow/modes.nvim
-- NOTE: https://github.com/AstroNvim/AstroNvim
-- NOTE: https://github.com/nvim-lua/kickstart.nvim
-- NOTE: https://github.com/NvChad/NvChad
-- NOTE: https://github.com/Pocco81/true-zen.nvim
-- NOTE: https://github.com/kevinhwang91/nvim-ufo
-- NOTE: https://github.com/ThePrimeagen/harpoon
-- NOTE: https://github.com/shaunsingh/nord.nvim
-- NOTE: https://github.com/abzcoding/lvim/commit/8c3f785d820107cff922360f1626e0d8004d5881
-- NOTE: https://github.com/anuvyklack/hydra.nvim (for git / dap)
-- NOTE: https://github.com/dccsillag/magma-nvim
-- NOTE: https://github.com/toppair/peek.nvim
-- NOTE: https://github.com/hyiltiz/vim-plugins-profile
-- NOTE: https://github.com/echasnovski/mini.nvim
-- NOTE: https://github.com/petertriho/nvim-scrollbar
-- NOTE: https://github.com/LunarVim/LunarVim/blob/1b179a8586e72ab5334e62ddf541e9ca972e8fd3/README.md#automatic-lsp-support
--       https://github.com/LunarVim/LunarVim/blob/ccb80e41ee929505c97e682749c74f8db4609d61/lua/lvim/lsp/manager.lua#L93
-- NOTE: https://github.com/onsails/lspkind.nvim
-- NOTE: https://youtu.be/_1ijgc7G3pg?t=229

