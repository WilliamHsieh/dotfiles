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
map("n", "<leader>/", require("Comment.api").toggle_current_linewise, "Comment")
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
map("n", "<leader>pp", "<cmd>PackerProfile<cr>", "Profile")
--}}}

-- <leader>f: find{{{
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", "Find files")
map("n", "<leader>fF", "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text")
map("n", "<leader>fB", require("telescope.builtin").git_branches, "Checkout branch")
map("n", "<leader>fc", require("telescope.builtin").colorscheme, "Colorscheme")
map("n", "<leader>fC", require("telescope.builtin").commands, "Commands")
map("n", "<leader>fh", require("telescope.builtin").help_tags, "Help")
map("n", "<leader>fl", require("telescope.builtin").resume, "Last Search")
map("n", "<leader>fM", require("telescope.builtin").man_pages, "Man Pages")
map("n", "<leader>fr", require("telescope.builtin").oldfiles, "Recent File")
map("n", "<leader>fk", require("telescope.builtin").keymaps, "Keymaps")
map("n", "<leader>fp", require('telescope').extensions.projects.projects, "Projects")
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", "TODOs")
--}}}

-- <leader>h: hop{{{
map("n", "<leader>hh", "<cmd>HopChar2<cr>", "Hop 2 characters")
map("n", "<leader>hw", "<cmd>HopWord<cr>", "Hop word")
--}}}

-- <leader>g: git{{{
map("n", "<leader>gj", require('gitsigns').next_hunk, "Next Hunk")
map("n", "<leader>gk", require('gitsigns').prev_hunk, "Prev Hunk")
map("n", "<leader>gB", require('gitsigns').toggle_current_line_blame, "Blame")
map("n", "<leader>gp", require('gitsigns').preview_hunk, "Preview Hunk")
map("n", "<leader>gr", require('gitsigns').reset_hunk, "Reset Hunk")
map("n", "<leader>gR", require('gitsigns').reset_buffer, "Reset Buffer")
map("n", "<leader>gs", require('gitsigns').stage_hunk, "Stage Hunk")
map("n", "<leader>gu", require('gitsigns').undo_stage_hunk, "Undo Stage Hunk")
map("n", "<leader>go", require("telescope.builtin").git_status, "git status")
map("n", "<leader>gb", require("telescope.builtin").git_branches, "Checkout branch")
map("n", "<leader>gc", require("telescope.builtin").git_commits, "Checkout commit")
map("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", "Diff")
--}}}

-- <leader>l: lsp{{{
map("n", "K", "<cmd>Lspsaga hover_doc<cr>","hover document")
map("i", "<C-k>", vim.lsp.buf.signature_help, "signature_help")
map("n", "gd", vim.lsp.buf.definition, "go to definition")
map("n", "gD", vim.lsp.buf.declaration, "go to declaration")
map("n", "gr", vim.lsp.buf.references, "go to references")
map("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", "Code Action")
map("n", "<leader>ld", "<cmd>TroubleToggle<cr>", "Diagnostics")
map("n", "<leader>lf", vim.lsp.buf.formatting, "Format")
map("n", "<leader>lF", "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat")
map("n", "<leader>li", "<cmd>LspInfo<cr>", "Info")
map("n", "<leader>lI", "<cmd>LspInstallInfo<cr>", "Installer Info")
-- map("n", "<leader>ll", vim.lsp.codelens.run, "CodeLens Action")
map("n", "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<cr>", "Hover diagnostics")
map("n", "<leader>lj", "<cmd>Lspsaga diagnostic_jump_next<CR>", "next diagnostic")
map("n", "<leader>lk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "prev diagnostic")
map("n", "<leader>lp", "<cmd>Lspsaga preview_definition<cr>", "preview definition")
map("n", "<leader>lo", "<cmd>TagbarToggle<cr>", "Outline(tagbar)")
map("n", "<leader>lO", "<cmd>SymbolsOutline<cr>", "Outline(SymbolsOutline)")
map("n", "<leader>lq", vim.lsp.diagnostic.set_loclist, "Quickfix")
map("n", "<leader>lr", '<cmd>Lspsaga rename<cr>', "Rename")
map("n", "<leader>lR", "<cmd>TroubleToggle lsp_references<cr>", "References")
map("n", "<leader>ls", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
map("n", "<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
map("n", "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics")
map("n", "<leader>ln", "<cmd>Lspsaga lsp_finder<cr>","Lsp finder (definition, reference)")
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
map("n", "<leader>tg", function() TOGGLE_FLOAT('lazygit') end, "lazygit")
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
