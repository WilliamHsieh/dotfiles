

"+==========================+"
"| Configuration for python |"
"+==========================+"


" Compile option
"{{{
	nmap <silent><F9> :w<CR> :!clear && echo "> Running" && python3 % <CR>
	nmap <silent><F5> :w<CR> :!clear && echo "> Running" && python3 % < in<CR>
"}}}


" Tweak
"{{{
" 	hi pythonInclude ctermfg=141
	hi pythonBuiltin cterm=NONE ctermfg=121
	hi pythonStatement ctermfg=13
	hi pythonComment ctermfg=242
	hi pythonFunction ctermfg=172
"}}}


" Comment
"{{{
	vmap <silent> <C-c> :call ToggleComment()<cr>
	nmap <silent> <C-c> :call ToggleComment()<cr>

	function! ToggleComment()
		if matchstr(getline(line(".")),'^\s*\#.*$') == ''
			:execute "s:^:#:"
		else
			:execute "s:^\s*#::"
		endif
	endfunction
"}}}


" Folding method
"{{{
	" folding markdown
	function! MarkdownFolds()
		let thisline = getline (v:lnum)
		if match (thisline, '^###') >= 0
			return '>3'
		elseif match (thisline, '^##') >= 0
			return '>2'
		elseif match (thisline, '^#') >= 0
			return '>1'
		else
			return '='
		endif
	endfunction
	
	setlocal foldmethod=expr
	setlocal foldexpr=MarkdownFolds()

	" text display on folding
	function! MarkdownFoldText()
		let foldsize = (v:foldend-v:foldstart)
		return getline(v:foldstart). ' ('.foldsize.' lines)'
	endfunction

	setlocal foldtext=MarkdownFoldText()
"}}}




