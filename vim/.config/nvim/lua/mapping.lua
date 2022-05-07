local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
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

-- Normal --
keymap("n", "<C-j>", "4jzz", opts)
keymap("n", "<C-k>", "4kzz", opts)
keymap("v", "<C-j>", "4jzz", opts)
keymap("v", "<C-k>", "4kzz", opts)
keymap("n", "H", "<cmd>BufferLineCyclePrev<CR>", opts)
keymap("n", "L", "<cmd>BufferLineCycleNext<CR>", opts)
keymap("n", "]q", "<cmd>cnext<CR>", opts)
keymap("n", "[q", "<cmd>cprev<CR>", opts)

keymap("!", "<C-a>", "<Home>", opts)
keymap("!", "<C-e>", "<End>", opts)

-- Resize with arrows
-- TODO: smart split plugin
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Insert --
keymap("i", "kj", "<ESC>", opts)

-- Visual --

-- Move text up and down
keymap("v", "<S-h>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "<S-l>", ":m '>+1<CR>gv=gv", opts)
-- keymap("v", "p", '"_dP', opts)

-- Terminal --
keymap('t', '<esc>', [[<C-\><C-n>]], opts)
keymap('t', 'kj', [[<C-\><C-n>]], opts)

-- Custom
keymap("n", "Q", "<cmd>Bdelete<CR>", opts)
keymap("n", "<F7>", "<cmd>TSHighlightCapturesUnderCursor<cr>", opts)
keymap(
  "n",
  "<C-p>",
  "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
  opts
)
keymap("n", "<C-t>", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", opts)
keymap("n", "gx", [[:silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)

-- Seamless navigation between vim and tmux
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
