

"+========================+"
"| My vimrc configuration |"
"+========================+"


" TODO
"{{{
"	1. add the surrond method (ex: ys<, cs", ds', viwS[, etc)
"	2. bulk rename in vim (ranger.vim)
"	3. terminal bell in zsh (without going to tmux)
"	4. Osc52Yank
"	5. blink the yank text
"	6. clipboard behavior (linux && sync with remote machine)
"	7. support for true color within vim (https://lotabout.me/2018/true-color-for-tmux-and-vim/)
"}}}


" General
"{{{
	" Auto Reload .vimrc After Saving
	"{{{
		" add `nested` keyword to allow other autocommands to be triggered by this event
		autocmd! bufwritepost .vimrc nested source %
	"}}}

	" Basic
	"{{{
		set number			" show line numbers
		set relativenumber	" show relativenumber
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
		set scrolloff=3		" preserve 5 line after scrolling
		set modeline
		set autochdir		" change the working directory to the directory of the file you opened
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
	" Modified theme
	"{{{
		function! MyHighlights() abort
			" cursorline color
			set cursorline
			hi CursorLine cterm=NONE ctermbg=237
			hi CursorLineNr cterm=none

			" statusline color
			hi NormalStatusColor ctermfg=15 ctermbg=8 cterm=none
			hi! link statusline NormalStatusColor

			" tab bar color
			hi TabLineSel cterm=NONE ctermbg=8 ctermfg=white
			hi TabLine cterm=NONE ctermbg=black ctermfg=darkgray
			hi TabLineFill ctermfg=black

			" parentheses color
			if &ft == 'c' || &ft == 'cpp'
				syn match parens /[{}]/ | hi parens ctermfg=red
			endif
			hi MatchParen cterm=none ctermbg=magenta ctermfg=black

			" others
			hi Search ctermfg=0 ctermbg=124
			hi Folded ctermbg=black ctermfg=241
			hi VertSplit cterm=none ctermfg=0 ctermbg=237
		endfunction

		function! InsertStatuslineColor(mode)
			if a:mode == 'i'
				hi statusline ctermfg=0 ctermbg=2 cterm=none
			elseif a:mode == 'r'
				hi statusline ctermfg=0 ctermbg=1 cterm=none
			endif
		endfunction
	"}}}

	" Theme & stuff
	"{{{
		set t_Co=256			" vim color
		set background=dark		" background
		syntax enable

		augroup Theme
			autocmd!
			au ColorScheme * call MyHighlights()
			au InsertEnter * call InsertStatuslineColor(v:insertmode)
			au InsertLeave * hi! link statusline NormalStatusColor
		augroup END
		colo peachpuff
	"}}}

	" Cursor
	"{{{
		" Cursorline
		au InsertEnter * set nocursorline
		au InsertLeave * set cursorline

		" Change cursor in different mode
		if exists('$TMUX')
			let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
			let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\\"
		else
			let &t_EI = "\e[2 q"	"normal mode
			"let &t_SR = "\e[4 q"	"replace mode TODO: only some terminal support
			let &t_SI = "\e[6 q"	"insert mode
		endif
		"ref: https://unix.stackexchange.com/questions/553227/how-to-enable-underlines-and-other-formattings-on-a-color-tty

		"Other options (replace the number after \e[):
		"Ps = 0 -> blinking block.
		"Ps = 1 -> blinking block (default).
		"Ps = 2 -> steady block.
		"Ps = 3 -> blinking underline.
		"Ps = 4 -> steady underline.
		"Ps = 5 -> blinking bar (xterm).
		"Ps = 6 -> steady bar (xterm).
	"}}}

	" Make the 81th column stand out
	"{{{
		hi ColorColumn80 ctermbg=magenta ctermfg=black
		call matchadd('ColorColumn80', '\%81v', -1)
		" -1 means that any search highlighting will override the match highlighting
	"}}}

	" Highlight trailing spaces | spaces before tabs
	"{{{
		hi ExtraWhitespace cterm=underline ctermbg=NONE ctermfg=yellow
		au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
		au InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/
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
		imap <C-j> <down>
		imap <C-k> <up>
		nmap <C-j> 4jzz
		vmap <C-j> 4jzz
		nmap <C-k> 4kzz
		vmap <C-k> 4kzz

		" Navigate between tabs
		nmap gc :tabnew<CR>

		" switch between resent buffer, which is equivalent to <C-^>
		nmap <space><space> :e #<CR>

		" Useful short cut
		" nmap ; :
		imap <C-a> <esc>^i
		imap <C-e> <end>
		cmap <C-a> <home>
		cmap <C-e> <end>
		nmap <C-f> /
		nmap <silent><F2> :up<CR>:!clear && make<CR>
		nmap <S-k> k<S-j>
		nmap Y y$
	"}}}
"}}}


" Something Fancy
"{{{
	" Statusline
	"{{{
		set laststatus=2								" show two statusline
		set statusline=[%{expand('%:F')}]\ 				" path and file name
		set statusline+=[%{strlen(&fenc)?&fenc:'none'}  " file encoding
		set statusline+=,\ %{&ff}						" file format
		set statusline+=,\ %{strlen(&ft)?&ft:'plain'}]	" filetype
		set statusline+=\ %m							" modified flag
		set statusline+=\ %h							" help file flag
		set statusline+=\ %r							" read only flag
		set statusline+=\ %=							" align left
		set statusline+=Line:%l/%L[%p%%]				" line X of Y [percent of file]
		set statusline+=\ Col:[%c]						" current column
		set statusline+=\ ASCII:[%b]					" ASCII code under cursor
" 		set statusline+=\ Buf:[%n]						" Buffer number
	"}}}

	" Blink search matches
	"{{{
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

		" NOW WE CAN:
		" - :edit a folder to open a file browser
		" - <CR>/v/t to open in an h-split/v-split/tab
		" - check |netrw-browse-maps| for more mappings
	"}}}

	" Warning message
	"{{{
		function! EchoMsg(msg)
			redraw
			echohl WarningMsg
			echo a:msg
			echohl None
		endfunction
	"}}}

	" Copy to clipboard
	"{{{
		function! GetPlatform()
			let uname = substitute(system('uname'),'\n','','')
			if system("uname -r | grep -i microsoft") != ""
				return 'wsl'
			elseif uname == 'Linux'
				return 'linux'
			elseif uname == 'Darwin'
				return 'mac'
			else
				return 'unknown'
			endif
		endfunction

		function! Osc52Yank(msg)
			let buffer=system('base64 -w0', @0)
			let buffer='\ePtmux;\e\e]52;c;'.buffer.'\a\e\\'
			if exists("$SSH_TTY")
				exe "!printf ".shellescape(buffer)." > $SSH_TTY"
			elseif exists("$TMUX")
				let pane_tty=system("tmux list-panes -F '#{pane_active} #{pane_tty}' | awk '$1==1 { print $2 }'")
				exe "!printf ".shellescape(buffer)." > ".pane_tty
			else
				exe "!printf ".shellescape(buffer)
			endif
			call EchoMsg(a:msg)
		endfunction

		function! ClipboardBehavior()
			let platform = GetPlatform()
			if platform == 'wsl'
				nmap <F12> :w !clip.exe<CR><CR>:call EchoMsg('File "'.@%.'" copied to clipboard!')<CR>
			elseif platform == 'mac'
				nmap <F12> :w !pbcopy<CR><CR>:call EchoMsg('File "'.@%.'" copied to clipboard!')<CR>
			else
				nmap <F12> :%y<CR>:call Osc52Yank('[OSC] File "'.@%.'" copied to clipboard!')<CR><CR>
			endif
			vmap <F12> y:call Osc52Yank('[OSC] Copied to clipboard!')<CR><CR>
		endfunction

		set pastetoggle=<F12>
		nnoremap <silent><leader>y :call Osc52Yank('[OSC] Copied to clipboard!')<CR><CR>
	"}}}
"}}}


" Based On Filetype
"{{{
	" Folding
	"{{{
		" Custom folding expression
		"{{{
			function! CustomFoldExpr(cmt)
				let thisline = getline (v:lnum)
				let tmp = a:cmt
				if a:cmt == '//'
					let tmp = tmp.' '
				endif
				if thisline =~ '\v^\s*$'	"empty line
					return '-1'
				elseif thisline =~ '^'.tmp.'###'
					return '>3'
				elseif thisline =~ '^'.tmp.'##'
					return '>2'
				elseif thisline =~ '^'.tmp.'#'
					return '>1'
				else
					return '='
				endif
			endfunction
		"}}}

		" Custom folding text
		"{{{
			function! CustomFoldText(cmt)
				let thisline = getline (v:foldstart)
				let foldsize = (v:foldend-v:foldstart)
				let tmp = a:cmt
				if a:cmt == '//'
					let tmp = tmp.' '
				endif
				if thisline =~ '^'.tmp.'###'
					return '    '. '    '. getline(v:foldstart). ' ('.foldsize.' lines)'
				elseif thisline =~ '^'.tmp.'##'
					return '    '. getline(v:foldstart). ' ('.foldsize.' lines)'
				elseif thisline =~ '^'.tmp.'#'
					return getline(v:foldstart). ' ('.foldsize.' lines)'
				else
					return getline(v:foldstart). ' ('.foldsize.' lines)'
				endif
			endfunction
		"}}}

		" Folding based on filetype
		"{{{
		" <zf> to create, <zx> <za> to fold and expand
			function! CustomFolding()
				set foldlevel=0
				set foldnestmax=3
				if &ft == 'c' || &ft == 'cpp' || &ft == 'rust' || &ft == 'go'
					set foldmethod=expr
					set foldexpr=CustomFoldExpr('//')
					set foldtext=CustomFoldText('//')
				elseif &ft == 'python' || &ft == 'make'
					set foldmethod=expr
					set foldexpr=CustomFoldExpr('#')
					set foldtext=CustomFoldText('#')
				else
					set foldmethod=marker
				endif
			endfunction
		"}}}
	"}}}

	" Commenting
	"{{{
		" Toggle comment method
		"{{{
			function! ToggleCommentMethod(cmt)
				let line = getline('.')
				if line =~ '[^\s]'
					if matchstr(line, '^\s*'.a:cmt.'.*$') == ''
						exec 'normal! 0i'.a:cmt
					else
						exec 's:'.a:cmt.'::g'
					endif
				endif
			endfunction
		"}}}

		" Comment based on filetype
		"{{{
			function! ToggleComment()
				if &ft == 'c' || &ft == 'cpp' || &ft == 'rust' || &ft == 'go'
					map <silent> <C-c> :call ToggleCommentMethod('//')<cr>
				elseif &ft == 'python' || &ft == 'make'
					map <silent> <C-c> :call ToggleCommentMethod('# ')<cr>
				elseif &ft == 'vim'
					map <silent> <C-c> :call ToggleCommentMethod('" ')<cr>
				endif
			endfunction
		"}}}
	"}}}

	" Compiling and running for various filetypes
	"{{{
		function! HandleFiletypes()
			if &ft == 'c' || &ft == 'cpp'
				set cindent		"enable smart indent in c language
				nmap <silent><F5> :up<CR>:!clear && g++ % -lm --std=c++17 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out < in<CR>
				nmap <silent><F9> :up<CR>:!clear && g++ % -lm --std=c++17 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out<CR>
			elseif &ft == 'rust'
				" TODO: format file after save
				nmap <silent><F5> :up<CR>:!clear && rustc % && echo "> Running" && ./%< < in<CR>
				nmap <silent><F9> :up<CR>:!clear && rustc % && echo "> Running" && ./%<<CR>
				set errorformat=\ -->\ src/%f:%l:%c		"for quickfix
			elseif &ft == 'go'
				nmap <silent><F5> :up<CR>:!clear && echo "> Running " && go run % < in<CR>
				nmap <silent><F9> :up<CR>:!clear && echo "> Running " && go run %<CR>
			elseif &ft == 'java'
				nmap <silent><F5> :up<CR>:!clear && javac % && echo "> Running " && java -cp "%:p:h" "%:t:r" < in<CR>
				nmap <silent><F9> :up<CR>:!clear && javac % && echo "> Running " && java -cp "%:p:h" "%:t:r"<CR>
			elseif &ft == 'python'
				nmap <silent><F5> :up<CR>:!clear && python3 % < in<CR>
				nmap <silent><F9> :up<CR>:!clear && python3 %<CR>
			endif
		endfunction
	"}}}

	" Initial setup after loading vim
	"{{{
		augroup Init
			autocmd!
			au VimEnter * call CustomFolding()
			au VimEnter * call ToggleComment()
			au VimEnter * call HandleFiletypes()
			au VimEnter * call ClipboardBehavior()
		augroup END
	"}}}
"}}}


" NOTE:
"{{{
	" Normal mode
	"{{{
	"	1. m for mark, `'` to jump to the mark (ex: mq, 'q)
	"	2. `gv` to re-select previous visual selection
	"	3. `{` and `}` to jump to next/previous empty line
	"	4. `ZZ` to save and quit
	"	5. `gn` to select next highlight text (ex: `cgn` to change the next
	"		highlight word, and use `.` to replace the next match)
	"	6. `gi` start insert mode on last insert position
	"	7. `C-w o` close all splits, but current one
	"	8. `gf` go to file under cursor, `gj` `gk` is like j, k in wrap line
	"	9. `!!` in normal mode will insert external command on cursor position
	"	10. `q:, q/, q?` open command-line window with the credit option.
	"}}}

	" Command mode
	"{{{
	"	1. :cw to open quickfix window
	"	2. :mksession or :mks can store current vim buffer (& tabs) into
	"		Session.vim, and can be reload using `vim -S Session.vim`
	"	3. select text with visual mode, then type :normal to append
	"		normal command, (ex: `:'<,'>normal ^dW`)
	"	4. :ab can set word for abbreviation, ex: `:ab la ls -la`
	"	5. when writing to read only file, use `:w !sudo tee %`
	"}}}

	" Other notes
	"{{{
	"	NOTE:, TODO, FIXME, are default keywords
	"}}}
"}}}




