

	"+==========================+"
	"| Configuration for python |"
	"+==========================+"


" Compile option
"{{{
	nmap <silent><F9> :w<CR> :!clear && echo "> Running" && python3 % <CR>
	nmap <silent><F5> :w<CR> :!clear && echo "> Running" && python3 % < in<CR>
"}}}


" Other
"{{{
	colo slate
	" Cursorline
		hi CursorLine  cterm=NONE ctermbg=237
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
