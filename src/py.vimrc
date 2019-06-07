

"+==========================+"
"| Configuration for python |"
"+==========================+"


" Compile option
"{{{
	nmap <silent><F9> :w<CR>:!clear && echo "> Running" && python3 % <CR>
	nmap <silent><F5> :w<CR>:!clear && echo "> Running" && python3 % < in<CR>
"}}}


" Tweak
"{{{
	hi pythonImport ctermfg=1
	hi pythonBuiltin cterm=NONE ctermfg=121
	hi pythonStatement ctermfg=11
	hi pythonComment ctermfg=242
	hi pythonFunction ctermfg=121
	hi pythonRepeat ctermfg=216
	hi pythonOperator ctermfg=3
	hi pythonConditional ctermfg=216

	" so that I won't type the stupid semicolon
	imap ; <nop>
	source ~/dotfiles/src/sharp.vimrc

" let python_highlight_all = 1

"}}}


" Comment
"{{{
	vmap <silent> <C-c> :call ToggleComment()<cr>
	nmap <silent> <C-c> :call ToggleComment()<cr>

	function! ToggleComment()
		if matchstr(getline(line(".")),'^\s*\#\ .*$') == ''
			:execute "s:^:# :"
		else
			:execute "s:^\s*# ::"
		endif
	endfunction
"}}}


" Folding method
"{{{
	" folding markdown
	function! MarkdownFolds()
		let thisline = getline (v:lnum)
		if match (thisline, '^####') >= 0
			return '>3'
		elseif match (thisline, '^###') >= 0
			return '>2'
		elseif match (thisline, '^##') >= 0
			return '>1'
		else
			return '='
		endif
	endfunction
	
	setlocal foldmethod=expr
	setlocal foldexpr=MarkdownFolds()

	" text display on folding
	function! MarkdownFoldText()
		let thisline = getline (v:foldstart)
		let foldsize = (v:foldend-v:foldstart)
		if match (thisline, '^####') >= 0
			return '    '. '    '. getline(v:foldstart). ' ('.foldsize.' lines)'
		elseif match (thisline, '^###') >= 0
			return '    '. getline(v:foldstart). ' ('.foldsize.' lines)'
		elseif match (thisline, '^##') >= 0
			return getline(v:foldstart). ' ('.foldsize.' lines)'
		else
			return getline(v:foldstart). ' ('.foldsize.' lines)'
		endif
	endfunction

	setlocal foldtext=MarkdownFoldText()
"}}}




