" ------------------------- My vimrc config ------------------------- "

" Auto reload .vimrc after saving
"{{{
	autocmd! bufwritepost .vimrc source %
"}}}

" General
"{{{
	set number			" Show line numbers
	set relativenumber	" Show relativenumber
	"set showbreak=###	" Wrap-broken line prefix
	set nocompatible	" set not compatible with vi
	set textwidth=80	" Line wrap (number of cols)
	set autoindent		" Auto-indent new lines
	set smartindent		" Enable smart-indent
	set cindent			" Enable smart-indent with c language
	set undolevels=100	" Number of undo levels
	set backspace=2		" Backspace behaviour
	set confirm			" ask confirm instead of block
	set showcmd			" show the last used command
	set mouse=n			" mouse control (a == all)
	set scrolloff=5		" preserve 5 line after scrolling
	set t_Co=256		" vim color
	set background=dark " background
	colo torte			" color theme
	syntax on
	filetype plugin on
"}}}

" Fussy file search
"{{{
	set path+=**		" search down into subfolder,also enable tab to complete
	set wildmenu		" Display all matching files; use * to make it fussy
"}}}

" Tab
"{{{
	set tabstop=4		" Number of spaces per Tab
	set softtabstop=4	" Number of spaces per Tab(virtual tab width)
	set smarttab		" Enable smart-tabs
	set shiftwidth=4	" Number of auto-indent spaces
"}}}

" Search and replace
"{{{
	set showmatch		" Highlight matching brace
	set hlsearch		" Highlight all search results
	set smartcase		" Enable smart-case search
	set gdefault		" Always substitute all matches in a line
	set ignorecase		" Always case-insensitive
"}}}

" Hightlight matches when jumping to next
"{{{
	hi Search ctermfg=0 ctermbg=124
	function! HINext(blinktime)
		" zz
		let target_pat = '\c\%#'.@/
		let blinks = 2
		for n in range(1, blinks)
			let ring = matchadd('ErrorMsg', target_pat, 101)
			redraw
			exec 'sleep' . float2nr(a:blinktime / (2*blinks) * 600) . 'm'
			call matchdelete(ring)
			redraw
			exec 'sleep' . float2nr(a:blinktime / (2*blinks) * 600) . 'm'
		endfor
	endfunction
	nmap <silent> n n:call HINext(0.4)<cr>
	nmap <silent> N N:call HINext(0.4)<cr>
"}}}

" Cursorline
"{{{
	set cursorline
	hi CursorLine  cterm=NONE ctermbg=237
	autocmd InsertEnter,InsertLeave * set cursorline!
 "}}}

" Change cursor in different mode
"{{{
	let &t_SI = "\e[6 q"
	let &t_EI = "\e[2 q"
	"Other options (replace the number after \e[):
	"Ps = 0  -> blinking block.
	"Ps = 1  -> blinking block (default).
	"Ps = 2  -> steady block.
	"Ps = 3  -> blinking underline.
	"Ps = 4  -> steady underline.
	"Ps = 5  -> blinking bar (xterm).
	"Ps = 6  -> steady bar (xterm).
"}}}

" Priorty of encoding when opening file
"{{{
	filetype indent on
	set fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
	set encoding=utf-8
"}}}

" Leader key
"{{{
	let mapleader = ","
"}}}

" Mapping
"{{{
	imap jj <esc>
	imap kk <esc>
	nmap <C-j> 4jzz
	vmap <C-j> 4jzz
	nmap <C-k> 4kzz
	vmap <C-k> 4kzz
	nmap <leader>/ ^i//<ESC>$
	nmap <leader>" ^i" <ESC>$
	nmap <leader># ^i# <ESC>$
	nmap cmd ^xx$
	nmap <leader>l :noh<CR>
	nmap <leader><space> :w<CR>
	nmap <silent><leader>c :w <CR> :!xclip -i -selection clipboard % <CR><CR>
	nmap <silent><leader>v :set paste!<CR>:set paste?<CR>
	nmap <leader><leader> :find ~<CR>
	nmap ; :
	cmap <C-a> <home>
	cmap <C-e> <end>
	"}}}

" Auto complete
"{{{
	"inoremap ( ()<Esc>i
	"inoremap ) <Esc>la
	"inoremap " ""<Esc>i
	"inoremap ' ''<Esc>i
	"inoremap {{ {}<ESC>i
	inoremap {<CR> {<CR>}<Esc>ko
"}}}

" Make the 81th column stand out
"{{{
	hi colorculumn ctermbg=magenta
	call matchadd('ColorColumn','\%81v',100)
"}}}

" Statusline
"{{{
	" show two line of statusline
	set laststatus=2								

	" change the color of statusline
	function! InsertStatuslineColor(mode)			
		if a:mode == 'i'
			hi statusline guibg=Cyan ctermfg=2 guifg=Black ctermbg=0
		elseif a:mode == 'r'
			hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
		else
			hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
		endif
	endfunction
	au InsertEnter * call InsertStatuslineColor(v:insertmode)
	au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

	" Default the statusline to DarkGrey when entering Vim
	hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15
"}}}

" Info showed on statusline:
"{{{
	set statusline=[%{expand('%:F')}]\ 				" path and file name
	set statusline+=[%{strlen(&fenc)?&fenc:'none'}  " file encoding
	set statusline+=,\ %{&ff}						" file format
	set statusline+=,\ %{strlen(&filetype)?&filetype:'plain'}]	" filetype
	set statusline+=\ %m							" modified flag
	set statusline+=\ %h							" help file flag
	set statusline+=\ %r							" read only flag
	set statusline+=\ %=							" align left
	set statusline+=Line:%l/%L[%p%%]				" line X of Y [percent of file]
	" set statusline+=\ Col:%c						" current column
	set statusline+=\ ASCII:[%b]\ 					" ASCII code under cursor
	" set statusline+=\ Buf:%						" Buffer number
	" set statusline+=\ [0x%B]\						" byte code under cursor
"}}}

" File browsing
"{{{
	" Tweaks for browsing
		let g:netrw_banner=0        " disable annoying banner
		let g:netrw_browse_split=4  " open in prior window
		let g:netrw_altv=1          " open splits to the right
		let g:netrw_liststyle=3     " tree view
		let g:netrw_list_hide=netrw_gitignore#Hide()
		let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

	" NOW WE CAN:
	" - :edit a folder to open a file browser
	" - <CR>/v/t to open in an h-split/v-split/tab
	" - check |netrw-browse-maps| for more mappings
"}}}

" Folding
	"{{{
	" <zf> to create, <zx>||<za> to fold and expand
	set foldmethod=marker
	set foldlevel=0
	set foldnestmax=3
	" set nofoldenable
	highlight Folded ctermbg=black ctermfg=240
	"}}}

" Compiler option
"{{{
	nmap <silent><F9> :w<CR> :!clear && g++ % --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out<CR>
	nmap <silent><F5> :w<CR> :!clear && g++ % --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out < in<CR>
"}}}

