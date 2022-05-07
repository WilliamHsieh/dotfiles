-- TODO: using new autocmd api
vim.cmd [[
" ExtraWhitespace and cursorline
hi ExtraWhitespace cterm=underline ctermbg=NONE ctermfg=yellow
augroup Theme
  autocmd!
  " Highlight trailing spaces | spaces before tabs TODO: not working
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/

  " Cursorline
  au InsertEnter * set nocursorline
  au InsertLeave * set cursorline
augroup END

" *last-position-jump*  >
autocmd BufRead * autocmd FileType <buffer> ++once
\ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif

  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
    autocmd CmdWinEnter * quit
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
    autocmd User AlphaReady set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
  augroup end

  augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi link illuminatedWord LspReferenceText
  augroup END

  autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]]

-- Autoformat
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- augroup end
