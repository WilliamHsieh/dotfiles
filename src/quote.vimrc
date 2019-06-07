

"+=================================+"
"| Configuration for quote comment |"
"+=================================+"


" Comment
"{{{
	vmap <silent> <C-c> :call ToggleComment()<cr>
	nmap <silent> <C-c> :call ToggleComment()<cr>

	function! ToggleComment()
		if matchstr(getline(line(".")),'^\s*\"\ .*$') == ''
			:execute "s:^:" :"
		else
			:execute "s:^\s*" ::"
		endif
	endfunction
"}}}




