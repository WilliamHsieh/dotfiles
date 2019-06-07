

"+=======================+"
"| Configuration for sql |"
"+=======================+"


" Compile option
"{{{
"}}}


" Tweak
"{{{
"}}}


" Toggle Comment
"{{{
	vmap <silent> <C-c> :call ToggleComment()<cr>
	nmap <silent> <C-c> :call ToggleComment()<cr>

	function! ToggleComment()
		if matchstr(getline(line(".")),'^\s*\-\-.*$') == ''
			:execute "s:^:--:"
		else
			:execute "s:^\s*--::"
		endif
	endfunction
"}}}


" Folding method
"{{{
	" folding markdown
	function! MarkdownFolds()
		let thisline = getline (v:lnum)
		if match (thisline, '^-- ###') >= 0
			return '>3'
		elseif match (thisline, '^-- ##') >= 0
			return '>2'
		elseif match (thisline, '^-- #') >= 0
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
		return getline(v:foldstart). ' ('.foldsize.' lines) '
	endfunction

	setlocal foldtext=MarkdownFoldText()
"}}}




