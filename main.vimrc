

"+========================+"
"| My vimrc configuration |"
"+========================+"


" Auto Reload .vimrc After Saving
"{{{
	autocmd! bufwritepost .vimrc source %
"}}}


" General
"{{{
	" Basic
	"{{{
		set number			" show line numbers
		set relativenumber	" show relativenumber
		" set showbreak=###	" wrap-broken line prefix
		set nocompatible	" set not compatible with vi
		set textwidth=80	" line wrap (number of cols)
		set autoindent		" auto-indent new lines
		set smartindent		" enable smart-indent
		set history=500
		set undolevels=500	" number of undo levels (default = 1000)
		set backspace=2		" backspace behaviour
		set confirm			" ask confirm instead of block
		set showcmd			" show the last used command
		set mouse=n			" mouse control (a == all)
		set scrolloff=5		" preserve 5 line after scrolling
		set modeline
		filetype plugin on
		filetype indent on
		filetype indent plugin on
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
	" File searching
	"{{{
		set path+=**		" search down into subfolder,also enable tab to complete
		set wildmenu		" Display all matching files; use * to make it fussy
	"}}}
	" Theme && Color
	"{{{
		" Show syntax highlighting groups && color of word under cursor
		"{{{
			nmap <C-S-P> :call <SID>SynStack()<CR>
			function! <SID>SynStack()
				if !exists("*synstack")
					return
				endif
				echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")
			endfunc
			"}}}
		" Others
		"{{{
			set t_Co=256		" vim color
			set background=dark " background
			colo torte			" color theme
			syntax on
			hi Identifier cterm=NONE ctermfg=14
			"}}}
		"}}}
	" Priorty Of Encoding When Opening File
	"{{{
		filetype indent on
		set fileencodings=utf-8,utf-16,big5,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
		set encoding=utf-8
	"}}}
"}}}


" Folding
"{{{
	" <zf> to create, <zx>||<za> to fold and expand
	set foldmethod=marker
	set foldlevel=0
	set foldnestmax=3
	" set nofoldenable
	hi Folded ctermbg=black ctermfg=240
"}}}


" Mapping
"{{{
	" Toggle Comment
	"{{{
		vmap <silent> <C-c> :call ToggleComment()<cr>
		nmap <silent> <C-c> :call ToggleComment()<cr>

		function! ToggleComment()
			if matchstr(getline(line(".")),'^\s*\"\ .*$') == ''
				:execute 's:^:" :'
			else
				:execute 's:^\s*" ::'
			endif
		endfunction
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
	" Other stuff
	"{{{
		" Leader key
		let mapleader = ","

		" Esc
		imap jj <esc>
		imap kk <esc>

		" Moving the cursor
		nmap <C-j> 4jzz
		vmap <C-j> 4jzz
		nmap <C-k> 4kzz
		vmap <C-k> 4kzz

		" Useful short cut
		nmap ; :
		cmap <C-a> <home>
		cmap <C-e> <end>
		nmap <leader>l :noh<CR>
		nmap <leader><space> :w<CR>
		nmap <leader><leader> :find ~<CR>
		nmap <F8> :w <CR> :!xclip -i -selection clipboard % <CR><CR>
		set pastetoggle=<F12>
		vmap <leader>s :sort<CR>
		" vmap > >gv
		" vmap < <gv
	"}}}
"}}}


" Something Fancy
"{{{
	" Cursor
	"{{{
		" Cursorline
		set cursorline
		hi CursorLine  cterm=NONE ctermbg=237
		autocmd InsertEnter,InsertLeave * set cursorline!

		" Change cursor in different mode
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
	" Statusline
	"{{{
		" Info showed on statusline
		"{{{
			set laststatus=2								" show two statusline
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
		" Change the color of statusline
		"{{{
			" Different color in different mode
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
	" Make the 81th column stand out
	"{{{
		hi colorculumn ctermbg=magenta
		call matchadd('ColorColumn','\%81v',100)
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
"}}}


" Based On Filetype
"{{{
	au filetype java source ~/.dotfile/java.vimrc
	au filetype python source ~/.dotfile/py.vimrc
	au BufEnter,BufNew *.c* source ~/.dotfile/c.vimrc
	au BufEnter,BufNew *.c* syn match parens /[{}]/ | hi parens ctermfg=red
	" au BufEnter,BufNew *.c* syn match blocks /[()]/ | hi blocks ctermfg=3
"}}}




