

"+======================+"
"| Configuration for go |"
"+======================+"


" Compile option
"{{{
	nmap <silent><F5> :up<CR>:!clear && echo "> Running " && go run % < in<CR>
	nmap <silent><F9> :up<CR>:!clear && echo "> Running " && go run %<CR>
"}}}


" Tweak
"{{{
	" so that I won't type the stupid semicolon
	imap ; <nop>
	source ~/dotfiles/src/slash.vimrc
	syn match parens /[{}]/ | hi parens ctermfg=red
"}}}




