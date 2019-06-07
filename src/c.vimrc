

"+=====================+"
"| Configuration for c |"
"+=====================+"


" Compile option
"{{{
	nmap <silent><F5> :up<CR>:!clear && g++ % -static -lm --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out < in<CR>
	nmap <silent><F9> :up<CR>:!clear && g++ % -static -lm --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out<CR>
"}}}


" Tweak
"{{{
	source ~/dotfiles/src/slash.vimrc
	syn match parens /[{}]/ | hi parens ctermfg=red
	set autochdir	"change the working directory to the directory of the file you opened"
	set cindent		"enable smart indent in c language

	hi cConstant ctermfg = 14
	hi cStructure ctermfg = 216
	hi MatchParen ctermbg = 4
	" hi Number ctermfg = 183
	" hi cStatement ctermfg = 216
"}}}




