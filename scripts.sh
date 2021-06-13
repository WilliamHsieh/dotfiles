#!/bin/bash

## Backup old config files
function backup_impl() {
	backup_dir=~/dotfiles_backup
	files=".vimrc .zshrc .tmux.conf"

	printf "\n"
	for file in $files; do
		if [ -f ~/$file ]; then
			echo "Moving existing $file from '$HOME' to '$backup_dir'"
			[ -d "$backup_dir" ] || mkdir -p $backup_dir
			mv ~/$file $backup_dir
		fi
	done
	printf "\n"

	ln -s ~/dotfiles/.vimrc ~/.vimrc
	echo "------- .vimrc updated. -------"

	ln -s ~/dotfiles/.zshrc ~/.zshrc
	echo "------- .zshrc updated. -------"

	ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
	echo "----- .tmux.conf updated. -----"

	printf "\ndone.\n"
}

function backup() {
	if [ $# == 0 ]; then
		read -p "Existing dotfiles will be moved to '~/dotfiles_backup'.
Do you want to start the process? (y/n) " -n 1;
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo ""
			backup_impl;
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			printf "\n\n----- terminated -----\n"
		else
			printf "\n\n----- unknown command -----\n"
		fi
	else
		if [[ "$1" == "-y" ]]; then
			backup_impl;
		else
			printf "\n----- unknown command -----\n"
		fi
	fi
}

## True colors
function true_colors() {
	# Based on: https://gist.github.com/XVilka/8346728
	awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
		s="/\\";
		for (colnum = 0; colnum<term_cols; colnum++) {
			r = 255-(colnum*255/term_cols);
			g = (colnum*510/term_cols);
			b = (colnum*255/term_cols);
			if (g>255) g = 510-g;
			printf "\033[48;2;%d;%d;%dm", r,g,b;
			printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
			printf "%s\033[0m", substr(s,colnum%2+1,1);
		}
		printf "\n";
	}'
}

## Yank
function yank() {
	buf=$(cat "$@")
	seq="\033]52;c;$( printf %s "$buf" | base64 -w0 )\a"
	seq="\033Ptmux;\033$seq\033\\"
	[[ ! -z "${SSH_TTY}" ]] && [[ ! -z "${TMUX}" ]] && export $(tmux showenv SSH_TTY)

	if [[ ! -z "${SSH_TTY}" ]]; then
		printf "$seq" > "$SSH_TTY"
	elif [[ ! -z "${TMUX}" ]]; then
		pane_active_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
		printf "$seq" > "$pane_active_tty"
	else
		printf "$seq"
	fi
}

"$@"
