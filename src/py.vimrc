

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




