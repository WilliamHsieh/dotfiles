

"+=====================+"
"| Configuration for c |"
"+=====================+"


" Compile option
"{{{
	nmap <silent><F2> :w<CR> :!clear && g++ -g % && echo "> Compiled with Debug info ... "<CR>
	nmap <silent><F5> :w<CR> :!clear && g++ % -static -lm --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out < in<CR>
	nmap <silent><F9> :w<CR> :!clear && g++ % -static -lm --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out<CR>
"}}}


" Tweak
"{{{
	set cindent		"enable smart indent in c language
	hi cConstant ctermfg = 14
	hi cStructure ctermfg = 216
	hi MatchParen ctermbg = 4
	" hi Number ctermfg = 183
	" hi cStatement ctermfg = 216
"}}}


" Toggle Comment
"{{{
	vmap <silent> <C-c> :call ToggleComment()<cr>
	nmap <silent> <C-c> :call ToggleComment()<cr>

	function! ToggleComment()
		if matchstr(getline(line(".")),'^\s*\/\/.*$') == ''
			:execute "s:^://:"
		else
			:execute "s:^\s*//::"
		endif
	endfunction
"}}}


" Folding method
"{{{
	" folding markdown
	function! MarkdownFolds()
		let thisline = getline (v:lnum)
		if match (thisline, '^////') >= 0
			return '>3'
		elseif match (thisline, '^///') >= 0
			return '>2'
		elseif match (thisline, '^//') >= 0
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




