-- TODO: smart split plugin
-- FIX: telescope config is not properly loaded: <C-p>

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, {
    silent = true,
    desc = desc,
  })
end

local function yank()
  if vim.fn.mode() == 'n' then
    vim.cmd('%y')
  else
    vim.cmd('normal! y')
  end
  vim.fn.system('bash ~/dotfiles/scripts.sh yank', vim.fn.getreg('0'))
  vim.notify("copied to clipboard")
end

-- Modes
--   "n": normal_mode
--   "i": insert_mode
--   "v": visual_mode
--   "x": visual_block_mode
--   "t": term_mode
--   "c": command_mode
--   "!": insert_command_mode

-- <leader>: normal mode{{{
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", "Explorer")
map("n", "<leader>w", "<cmd>w<CR>", "Save")
map("n", "<leader>q", "<cmd>q<CR>", "Quit")
map("n", "<leader>/", '<cmd>lua require("Comment.api").toggle_current_linewise()<CR>', "Comment")
map("n", "<leader>z", "<cmd>ZenMode<cr>", "Zen mode")
map("n", "<leader>y", function() yank() end, "copy to clipboard")
--}}}

-- <leader>b: buffer{{{
map("n", "<leader>bb", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>", "Buffers")
map("n", "<leader>b>", "<cmd>BufferLineMoveNext<CR>", "Move right")
map("n", "<leader>b<", "<cmd>BufferLineMovePrev<CR>", "Move left")
--}}}

-- <leader>p: packer{{{
map("n", "<leader>pc", "<cmd>PackerCompile<cr>", "Compile")
map("n", "<leader>pi", "<cmd>PackerInstall<cr>", "Install")
map("n", "<leader>ps", "<cmd>PackerSync<cr>", "Sync")
map("n", "<leader>pS", "<cmd>PackerStatus<cr>", "Status")
map("n", "<leader>pu", "<cmd>PackerUpdate<cr>", "Update")
--}}}

-- <leader>f: find{{{
map("n", "<leader>fB", "<cmd>Telescope git_branches<cr>", "Checkout branch")
map("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", "Colorscheme")
map("n", "<leader>fC", "<cmd>Telescope commands<cr>", "Commands")
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", "Find files")
map("n", "<leader>fF", "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text")
map("n", "<leader>fs", "<cmd>HopChar2<cr>", "Hop 2 characters")
map("n", "<leader>fS", "<cmd>HopWord<cr>", "Hop word")
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", "TODOs")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", "Help")
map("n", "<leader>fl", "<cmd>Telescope resume<cr>", "Last Search")
map("n", "<leader>fM", "<cmd>Telescope man_pages<cr>", "Man Pages")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", "Recent File")
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", "Keymaps")
map("n", "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects")
--}}}

-- <leader>g: git{{{
map("n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk")
map("n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk")
map("n", "<leader>gB", "<cmd>:Gitsigns toggle_current_line_blame<cr>", "Blame")
map("n", "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk")
map("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk")
map("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer")
map("n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk")
map("n", "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk")
map("n", "<leader>go", "<cmd>Telescope git_status<cr>", "git status")
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", "Checkout branch")
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", "Checkout commit")
map("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", "Diff")
--}}}

-- <leader>l: lsp{{{
map("n", "K", "<cmd>Lspsaga hover_doc<cr>","hover document")
map("i", "<C-k>", vim.lsp.buf.signature_help, "signature_help")
map("n", "go", vim.diagnostic.open_float, "Hover diagnostics")
map("n", "gd", vim.lsp.buf.definition, "go to definition")
map("n", "gD", vim.lsp.buf.declaration, "go to declaration")
map("n", "gr", vim.lsp.buf.references, "go to references")
map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")
map("n", "<leader>ld", "<cmd>TroubleToggle<cr>", "Diagnostics")
map("n", "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics")
map("n", "<leader>lf", vim.lsp.buf.formatting, "Format")
map("n", "<leader>lF", "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat")
map("n", "<leader>li", "<cmd>LspInfo<cr>", "Info")
map("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", "Installer Info")
map("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>")
map("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>")
map("n", "<leader>lp", "<cmd>Lspsaga preview_definition<cr>", "preview definition")
map("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action")
map("n", "<leader>lo", "<cmd>TagbarToggle<cr>", "Outline(tagbar)")
map("n", "<leader>lO", "<cmd>SymbolsOutline<cr>", "Outline(SymbolsOutline)")
map("n", "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix")
map("n", "<leader>lr", '<cmd>Lspsaga rename<cr>', "Rename")
map("n", "<leader>lR", "<cmd>TroubleToggle lsp_references<cr>", "References")
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols")
map("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols")
--}}}

-- <leader>s: sniprun{{{
map("n", "<leader>sc", "<cmd>SnipClose<cr>", "Close")
map("n", "<leader>sf", "<cmd>%SnipRun<cr>", "Run File")
map("n", "<leader>si", "<cmd>SnipInfo<cr>", "Info")
map("n", "<leader>sm", "<cmd>SnipReplMemoryClean<cr>", "Mem Clean")
map("n", "<leader>sr", "<cmd>SnipReset<cr>", "Reset")
map("n", "<leader>st", "<cmd>SnipRunToggle<cr>", "Toggle")
map("n", "<leader>sx", "<cmd>SnipTerminate<cr>", "Terminate")
--}}}

-- <leader>t: terminal{{{
map("n", "<leader>t1", ":1ToggleTerm<cr>", "1")
map("n", "<leader>t2", ":2ToggleTerm<cr>", "2")
map("n", "<leader>t3", ":3ToggleTerm<cr>", "3")
map("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", "Float")
map("n", "<leader>th", function() TOGGLE_FLOAT('htop') end, "Htop")
map("n", "<leader>tu", function() TOGGLE_FLOAT('ncdu') end, "NCDU")
map("n", "<leader>tp", function() TOGGLE_FLOAT('python3') end, "Python")
map("n", "<leader>t-", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal")
map("n", [[<leader>t\]], "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical")
--}}}

-- <leader>: visual mode{{{
map("v", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment")
map("v", "<leader>s", "<esc><cmd>'<,'>SnipRun<cr>", "Run range")
map("v", "<leader>y", function() yank() end, "copy to clipboard")
--}}}

-- m: mark mappings{{{
map("n", "ma", "<cmd>BookmarkAnnotate<cr>", "Annotate")
map("n", "mc", "<cmd>BookmarkClear<cr>", "Clear")
map("n", "mm", "<cmd>BookmarkToggle<cr>", "Toggle")
map("n", "mn", "<cmd>BookmarkNext<cr>", "Next")
map("n", "mp", "<cmd>BookmarkPrev<cr>", "Prev")
map("n", "ms", "<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>", "Show")
map("n", "mx", "<cmd>BookmarkClearAll<cr>", "Clear All")
--}}}

-- others{{{
map("i", "kj", "<ESC>")

-- quickfix
map("n", "]q", "<cmd>cnext<CR>", "quickfix next")
map("n", "[q", "<cmd>cprev<CR>", "quickfix prev")

-- Move text up and down
map("v", "<S-h>", ":m '<-2<CR>gv=gv")
map("v", "<S-l>", ":m '>+1<CR>gv=gv")

-- terminal
map('t', '<esc>', [[<C-\><C-n>]])
map('t', 'kj', [[<C-\><C-n>]])

-- telescope
map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>")

-- bufferline
map("n", "H", "<cmd>BufferLineCyclePrev<CR>")
map("n", "L", "<cmd>BufferLineCycleNext<CR>")
map("n", "Q", "<cmd>Bdelete<CR>")

-- navigation
map("n", "<C-j>", "4jzz")
map("n", "<C-k>", "4kzz")
map("v", "<C-j>", "4jzz")
map("v", "<C-k>", "4kzz")
map("!", "<C-a>", "<Home>")
map("!", "<C-e>", "<End>")
vim.cmd [[
  function! Navigation_vim_tmux(vim_dir)
    let pre_winnr=winnr()
    silent exe "wincmd ".a:vim_dir
    if exists('$TMUX') && pre_winnr == winnr()
      call system("tmux select-pane -".tr(a:vim_dir, 'hjkl', 'LDUR'))
    endif
  endfunction

  nnoremap <silent><M-h> :call Navigation_vim_tmux("h")<CR>
  nnoremap <silent><M-j> :call Navigation_vim_tmux("j")<CR>
  nnoremap <silent><M-k> :call Navigation_vim_tmux("k")<CR>
  nnoremap <silent><M-l> :call Navigation_vim_tmux("l")<CR>
]]
--}}}
