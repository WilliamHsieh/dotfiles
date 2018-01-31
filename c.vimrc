

"+=====================+"
"| Configuration for c |"
"+=====================+"


" Compile option
"{{{
	nmap <silent><F2> :w<CR> :!clear && gcc % && echo "> Running " && ./a.out<CR>
	nmap <silent><F5> :w<CR> :!clear && g++ % -static -lm --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out < in<CR>
	nmap <silent><F9> :w<CR> :!clear && g++ % -static -lm --std=c++11 -Wall -Wextra -Wshadow && echo "> Running " && ./a.out<CR>
"}}}

" Tweak
"{{{
	set cindent		"enable smart indent in c language
	" hi Number ctermfg=183
	hi cConstant ctermfg=177
	hi cStructure ctermfg=216
	" hi cStatement ctermfg=216
	hi MatchParen ctermbg=4
"}}}


