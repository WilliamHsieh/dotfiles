

"+========================+"
"| My vimrc configuration |"
"+========================+"


" TODO
"{{{
"	1. add the surrond method (ex: ys<, cs", ds', viwS[, etc)
"	2. bulk rename in vim(ranger.vim)
"	3. compile in a new tab (or anywhere else, eg: bottom)
"	4. stop changing line automatically
"	5. terminal bell in zsh (without going to tmux)
"	6. change each file extension tweak to function call
"	7. combine all filetype config (currently they're all over the place)
"	8. Osc52Yank
"}}}


" General
"{{{
	" Auto Reload .vimrc After Saving
	"{{{
		autocmd! bufwritepost .vimrc source %
	"}}}

	" Basic
	"{{{
		set number			" show line numbers
		set relativenumber	" show relativenumber
		" set showbreak=###	" wrap-broken line prefix
		set nowrap			" wrap line which is too long
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
		set incsearch		" Highlight result while searching
		set smartcase		" Enable smart-case search
		set gdefault		" Always substitute all matches in a line
		set ignorecase		" Always case-insensitive
	"}}}

	" Priorty Of Encoding When Opening File
	"{{{
		set fileencodings=utf-8,big5,utf-16,gb2312,gbk,gb18030,euc-jp,euc-kr,latin1
		set encoding=utf-8
	"}}}
"}}}


" Color
"{{{
	" Theme
	"{{{
		set t_Co=256			" vim color
		set background=dark		" background
		colo peachpuff
		syntax enable
		hi VertSplit cterm=none ctermfg=0 ctermbg=237
	"}}}

	" Cursor
	"{{{
		" Cursorline
		set cursorline
		hi CursorLine cterm=NONE ctermbg=237
		au ColorScheme * hi CursorLine cterm=NONE ctermbg=237
		au InsertEnter * set nocursorline
		au InsertLeave * set cursorline

		" Change cursor in different mode
		let &t_EI = "\e[2 q"	"normal mode
		let &t_SI = "\e[6 q"	"insert mode
		" Other options (replace the number after \e[):
		"Ps = 0 -> blinking block.
		"Ps = 1 -> blinking block (default).
		"Ps = 2 -> steady block.
		"Ps = 3 -> blinking underline.
		"Ps = 4 -> steady underline.
		"Ps = 5 -> blinking bar (xterm).
		"Ps = 6 -> steady bar (xterm).
	"}}}

	" Folding
	"{{{
		" <zf> to create, <zx> <za> to fold and expand
		set foldmethod=marker
		set foldlevel=0
		set foldnestmax=3
		hi Folded ctermbg=black ctermfg=241
	"}}}

	" Make the 81th column stand out
	"{{{
		hi ColorColumn80 ctermbg=magenta
		call matchadd('ColorColumn80', '\%81v', -1)
		" -1 means that any search highlighting will override the match highlighting
	"}}}

	" Highlight trailing spaces | spaces before tabs | extra spaces
	"{{{
		hi ExtraWhitespace cterm=underline ctermbg=NONE ctermfg=yellow
		au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
		au InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t\|  \+/
	"}}}

	" Tab bar color
	"{{{
		hi TabLineSel cterm=NONE ctermbg=gray ctermfg=black
		hi TabLine cterm=NONE ctermbg=black ctermfg=white
		hi TabLineFill ctermfg=black
	"}}}

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
"}}}


" Mapping
"{{{
	" Copy to clipboard
	"{{{
		set pastetoggle=<F12>
		nmap <silent><F12> :!cat % \|clip.exe<CR><CR>:echo 'copy "'.@%.'" to clipboard!'<CR>
		vmap <F12> :'<,'>w !clip.exe<CR><CR>:echo "copy to clipboard!"<CR>
		nmap <silent><leader>y :call system('clip.exe', @0)<CR>:echo "copy to clipboard!"<CR>

		" the `xclip` way
		"nmap <F12> :up<CR>:!xclip -i -selection clipboard % <CR><CR>
		"vmap <F12> :'<,'>w !xclip<CR><CR>
		"nmap <silent><leader>c :call system('xclip', @0)<CR>

		function! Osc52Yank()
			let buffer=system('base64 -w0', @0)
			let buffer='\ePtmux;\e\e]52;c;'.buffer.'\x07\e\\'
			let pane_tty=system("tmux list-panes -F '#{pane_active} #{pane_tty}' | awk '$1==1 { print $2 }'")
			"let pane_tty='/dev/pts/3'
			silent exe "!echo -ne ".shellescape(buffer)." > ".shellescape(pane_tty)
		endfunction
		"nnoremap <leader>y :call Osc52Yank()<CR>
	"}}}

	" Auto complete
	"{{{
		inoremap {<CR> {<CR>}<Esc>ko
	"}}}

	" Other stuff
	"{{{
		" Leader key
		let mapleader = ","
		nmap <leader>l :noh<CR>
		nmap <leader><space> :up<CR>
		nmap <leader><leader> :Vexplore<CR>
		vmap <leader>s :sort<CR>
		nmap <leader>r :source ~/.vimrc<CR>

		" Esc
		imap jj <esc>
		imap kk <esc>

		" Moving the cursor
		imap <C-h> <left>
		imap <C-j> <down>
		imap <C-k> <up>
		imap <C-l> <right>
		nmap <C-j> 4jzz
		vmap <C-j> 4jzz
		nmap <C-k> 4kzz
		vmap <C-k> 4kzz

		" Navigate between splits/tabs
		nmap <C-h> <C-w><C-h>
		nmap <C-l> <C-w><C-l>
		nmap gc :tabnew<CR>

		" Useful short cut
		nmap ; :
		imap <C-a> <esc>^i
		imap <C-e> <end>
		cmap <C-a> <home>
		cmap <C-e> <end>
		nmap <C-f> /
		nmap <silent><F2> :up<CR>:!clear && make<CR>
		nmap <S-k> k<S-j>
		nmap Y y$
		" vmap > >gv
		" vmap < <gv
	"}}}
"}}}


" Something Fancy
"{{{
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
			set statusline+=\ Col:[%c]						" current column
			set statusline+=\ ASCII:[%b]\ 					" ASCII code under cursor
			" set statusline+=\ Buf:%						" Buffer number
			" set statusline+=\ [0x%B]\						" byte code under cursor
		"}}}

		" Change the color of statusline
		"{{{
			" Different color in different mode
			function! InsertStatuslineColor(mode)
				if a:mode == 'i'
					hi statusline ctermfg=2 ctermbg=0
				elseif a:mode == 'r'
					hi statusline ctermfg=1 ctermbg=0
				endif
			endfunction
			au InsertEnter * call InsertStatuslineColor(v:insertmode)
			au InsertLeave * hi statusline ctermfg=8 ctermbg=15

			" Default the statusline to DarkGrey when entering Vim
			hi statusline ctermfg=8 ctermbg=15
		"}}}
	"}}}

	" Blink search matches
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
		nmap <silent> n n:call HINext(0.15)<cr>
		nmap <silent> N N:call HINext(0.15)<cr>
	"}}}

	" File searching
	"{{{
		set path+=**		" search down into subfolder,also enable tab to complete
		set wildmenu		" Display all matching files; use * to make it fussy
		set wildignore+=node_modules/*
	"}}}

	" File browsing(netrw)
	"{{{
		let g:netrw_banner=0		" disable annoying banner
		let g:netrw_liststyle=3		" tree view
		let g:netrw_browse_split=4	" open in prior window
		let g:netrw_altv=1			" open splits to the right
		let g:netrw_winsize = 16	" the percentage of the size
		let g:netrw_preview = 1		" use 'p' to preview the file in netRW
" 		let g:netrw_list_hide=netrw_gitignore#Hide()
" 		let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

		" open netrw automatically
" 		augroup ProjectDrawer
" 			autocmd!
" 			autocmd VimEnter * :Vexplore
" 		augroup END

		" NOW WE CAN:
		" - :edit a folder to open a file browser
		" - <CR>/v/t to open in an h-split/v-split/tab
		" - check |netrw-browse-maps| for more mappings
	"}}}
"}}}


" Based On Filetype
"{{{
	au filetype asm		source ~/dotfiles/src/sharp.vimrc
	au filetype make	source ~/dotfiles/src/sharp.vimrc

	au filetype vim		source ~/dotfiles/src/quote.vimrc

	au filetype verilog	source ~/dotfiles/src/slash.vimrc
	au filetype pccts	source ~/dotfiles/src/slash.vimrc

	au filetype java	source ~/dotfiles/src/java.vimrc
	au filetype python	source ~/dotfiles/src/py.vimrc
	au filetype c		source ~/dotfiles/src/c.vimrc
	au filetype cpp		source ~/dotfiles/src/c.vimrc
	au filetype sql		source ~/dotfiles/src/sql.vimrc
	au filetype matlab	source ~/dotfiles/src/matlab.vimrc
	au filetype go		source ~/dotfiles/src/go.vimrc
	au filetype rust	source ~/dotfiles/src/rust.vimrc
"}}}




