

"+========================+"
"| Configuration for java |"
"+========================+"


" Compile option
"{{{
	nmap <silent><F5> :w<CR>:!clear && javac % && echo "> Running " && java -cp "%:p:h" "%:t:r" < in<CR>
	nmap <silent><F9> :w<CR>:!clear && javac % && echo "> Running " && java -cp "%:p:h" "%:t:r"<CR>
"}}}


" Tweak
"{{{
	source ~/dotfiles/src/slash.vimrc
"}}}




