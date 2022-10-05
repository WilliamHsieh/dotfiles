vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   "n": normal_mode
--   "i": insert_mode
--   "v": visual_mode
--   "x": visual_block_mode
--   "t": term_mode
--   "c": command_mode
--   "!": insert_command_mode

-- helper functions{{{
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

local function terminal(cmd)
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({ cmd = cmd, hidden = true }):toggle()
end
--}}}

-- <leader>: normal mode{{{
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", "Explorer")
map("n", "<leader>w", "<cmd>up<cr>", "Save")
map("n", "<leader>q", "<cmd>q<cr>", "Quit")
map("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end, "Comment")
map("n", "<leader>y", function() yank() end, "copy to clipboard")
map("n", "<leader><space>", ":e #<cr>", "swap buffer")
--}}}

-- <leader>b: buffer{{{
map("n", "<leader>bb", function() require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false}) end, "Buffers")
map("n", "<leader>b>", "<cmd>BufferLineMoveNext<cr>", "Move right")
map("n", "<leader>b<", "<cmd>BufferLineMovePrev<cr>", "Move left")
map("n", "<leader>bs", "<cmd>so %|lua vim.notify('Buffer sourced.')<cr>", "Source this buffer")
map("n", "<leader>bz", "<cmd>ZenMode<cr>", "Zen mode")
map("n", "<leader>br", "<cmd>%s/.*/mv & &/<cr>", "bulk rename")
map("n", "<leader>bu", function() require("cinnamon").setup() end, "activate smooth scrolling") -- TODO: make it toggleable
--}}}

-- <leader>c: compile{{{
local function termexec(cmd)
  vim.cmd("write")
  vim.cmd('TermExec cmd="' .. cmd .. '"')
  vim.cmd("startinsert")
end

local function compile()
  local ft = vim.bo.filetype
  local fname = " %:t"
  local cmd = ""
  if ft == "python" then
    cmd = "python" .. fname
  elseif ft == "lua" then
    cmd = "echo success"
  elseif ft == "cpp" then
    cmd = "g++ --std=c++17 -O2 -g3 -Wall -Wextra -Wshadow -DLOCAL " .. fname .. " && ./a.out"
  else
    vim.notify(ft .. " filetype not supported")
    return
  end
  termexec(cmd)
end

local function make()
  termexec("make -j")
end

local function previous_command()
  vim.notify("todo")
end

map("n", "<leader>cc", compile, "Compile and run")
map("n", "<leader>cm", make, "Make")
map("n", "<leader>cp", previous_command, "Previous command")
--}}}

-- <leader>p: packer{{{
map("n", "<leader>pc", "<cmd>PackerCompile<cr>", "Compile")
map("n", "<leader>ps", "<cmd>PackerSync<cr>", "Sync")
map("n", "<leader>pS", "<cmd>PackerStatus<cr>", "Status")
map("n", "<leader>pp", "<cmd>PackerProfile<cr>", "Profile")
--}}}

-- <leader>f: find{{{
-- telescope
map("n", "<C-p>", function() require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false}) end)
map("n", "<leader>fb", "<cmd>Telescope vim_bookmarks all<cr>", "Bookmarks")
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", "Find files")
map("n", "<leader>fF", "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text")
map("n", "<leader>fB", "<cmd>Telescope git_branches<cr>", "Checkout branch")
map("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", "Colorscheme")
map("n", "<leader>fC", "<cmd>Telescope commands<cr>", "Commands")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", "Help")
map("n", "<leader>fl", "<cmd>Telescope resume<cr>", "Last Search")
map("n", "<leader>fM", "<cmd>Telescope man_pages<cr>", "Man Pages")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", "Recent File")
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", "Keymaps")
map("n", "<leader>fp", "<cmd>Telescope projects<cr>", "Projects")
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", "TODOs")
map("n", "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search in current buffer")
--}}}

-- <leader>h: hop{{{
map("n", "<leader>hh", "<cmd>HopChar2<cr>", "Hop 2 characters")
map("n", "<leader>hw", "<cmd>HopWord<cr>", "Hop word")
--}}}

-- <leader>g: git{{{
map("n", "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", "Next Hunk")
map("n", "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk")
map("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", "Blame")
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk")
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer")
map({'n', 'v'}, "<leader>gs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
map({'n', 'v'}, "<leader>gr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo staged hunk")
map("n", "<leader>go", "<cmd>Telescope git_status<cr>", "git status")
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", "Checkout branch")
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", "Checkout commit")
map("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", "Diff")
map("n", "<leader>gg", function() terminal('lazygit') end, "lazygit")
map("n", "<leader>gn", "<cmd>NvimTreeRefresh<cr>", "refresh nvim-tree")
--}}}

-- <leader>l: lsp{{{
map("n", "K", "<cmd>Lspsaga hover_doc<cr>","hover document")
map("i", "<C-k>", vim.lsp.buf.signature_help, "signature_help")
map("n", "gd", vim.lsp.buf.definition, "go to definition")
map("n", "gD", vim.lsp.buf.declaration, "go to declaration")
map("n", "gr", vim.lsp.buf.references, "go to references")
map("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", "Code Action")
map("n", "<leader>ld", "<cmd>TroubleToggle<cr>", "Diagnostics")
map("n", "<leader>lf", function () vim.lsp.buf.format { async = true } end, "Format")
map("n", "<leader>lF", "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat")
map("n", "<leader>li", "<cmd>LspInfo<cr>", "LSP info")
map("n", "<leader>lI", "<cmd>Mason<cr>", "LSP installer Info")
map("n", "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<cr>", "Hover diagnostics")
map("n", "<leader>lj", "<cmd>Lspsaga diagnostic_jump_next<cr>", "next diagnostic")
map("n", "<leader>lk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "prev diagnostic")
map("n", "<leader>lp", "<cmd>Lspsaga preview_definition<cr>", "preview definition")
map("n", "<leader>lo", "<cmd>TagbarToggle<cr>", "Outline(tagbar)")
map("n", "<leader>lO", "<cmd>SymbolsOutline<cr>", "Outline(SymbolsOutline)")
map("n", "<leader>lq", vim.diagnostic.setloclist, "Quickfix")
map("n", "<leader>lr", '<cmd>Lspsaga rename<cr>', "Rename")
map("n", "<leader>lR", "<cmd>TroubleToggle lsp_references<cr>", "References")
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols")
map("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols")
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
map('t', '<esc>', [[<C-\><C-n>]])
map('t', 'kj', [[<C-\><C-n>]])
map('n', [[<c-\>]], "<cmd>ToggleTerm<cr>", "Toggleterm")

map("n", "<leader>tt", function()
  local cmd = "ToggleTerm"
  if vim.bo.filetype ~= "toggleterm" then
    cmd = vim.fn.bufnr() .. cmd
  end
  vim.cmd(cmd)
end, "Float terminal for each buffer")

map("n", [[<leader>t-]], "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal")
map("n", [[<leader>t\]], "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical")
map("n", "<leader>th", function() terminal('htop') end, "Htop")
map("n", "<leader>tu", function() terminal('ncdu') end, "NCDU")
map("n", "<leader>tp", function() terminal('python3') end, "Python")
--}}}

-- <leader>: visual mode{{{
map("v", "<leader>/", '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<cr>', "Comment")
map("v", "<leader>s", "<esc><cmd>'<,'>SnipRun<cr>", "Run range")
map("v", "<leader>y", function() yank() end, "copy to clipboard")
--}}}

-- m: mark mappings{{{
map("n", "ma", "<cmd>BookmarkAnnotate<cr>", "Annotate")
map("n", "mc", "<cmd>BookmarkClear<cr>", "Clear")
map("n", "mm", "<cmd>BookmarkToggle<cr>", "Toggle")
map("n", "mn", "<cmd>BookmarkNext<cr>", "Next")
map("n", "mp", "<cmd>BookmarkPrev<cr>", "Prev")
map("n", "ms", function() require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title="bookmarks", shorten_path=false }) end, "Show")
map("n", "mx", "<cmd>BookmarkClearAll<cr>", "Clear All")
--}}}

-- others{{{
map("i", "kj", "<esc>")

-- quickfix
map("n", "]q", "<cmd>cnext<cr>", "quickfix next")
map("n", "[q", "<cmd>cprev<cr>", "quickfix prev")

-- Move text up and down
map("v", "<S-h>", ":m '<-2<cr>gv=gv")
map("v", "<S-l>", ":m '>+1<cr>gv=gv")

-- bufferline
map("n", "H", "<cmd>BufferLineCyclePrev<cr>")
map("n", "L", "<cmd>BufferLineCycleNext<cr>")
map("n", "Q", "<cmd>Bdelete<cr>")

-- navigation
map({"n", "v"}, "<C-j>", "4jzz")
map({"n", "v"}, "<C-k>", "4kzz")
map("!", "<C-a>", "<Home>")
map("!", "<C-e>", "<End>")

-- TODO: change into lua function
vim.cmd [[
  function! Navigation_vim_tmux(vim_dir)
    let pre_winnr=winnr()
    silent exe "wincmd ".a:vim_dir
    if exists('$TMUX') && pre_winnr == winnr()
      call system("tmux select-pane -".tr(a:vim_dir, 'hjkl', 'LDUR'))
    endif
  endfunction

  nnoremap <silent><M-h> :call Navigation_vim_tmux("h")<cr>
  nnoremap <silent><M-j> :call Navigation_vim_tmux("j")<cr>
  nnoremap <silent><M-k> :call Navigation_vim_tmux("k")<cr>
  nnoremap <silent><M-l> :call Navigation_vim_tmux("l")<cr>
]]
--}}}
