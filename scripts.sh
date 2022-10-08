#!/bin/bash

## Initial install script
function install() {
  ZINIT_DIR=~/.local/share/zinit
  if [ ! -e "$ZINIT_DIR" ]; then
    echo "$ZINIT_DIR not found"
    echo "installing zinit..."
    sh -c "$(curl -fsSL https://git.io/zinit-install)"
  fi

  TPM_DIR=~/.tmux/plugins/tpm
  if [ ! -e "$TPM_DIR" ]; then
    echo "$TPM_DIR not found"
    echo "installing tpm..."
    git clone https://github.com/tmux-plugins/tpm $TPM_DIR
  fi
}

function tmux_navigation() {
	cmd=$(tmux display -p '#{pane_current_command}')
	if [[ $cmd =~ vim$ ]]; then
    tmux send-keys "M-$1"
  else
    tmux select-pane "-$(echo "$1" | tr "hjkl" "LDUR")"
  fi
}

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
# TODO: seems like I might be able to yank even more chars?
# https://github.com/ojroques/vim-oscyank
function yank() {
	seq="$(cat "$@" | base64 | tr -d "\r\n")"
	seq="\ePtmux;\e\e]52;c;$seq\a\e\\"

	if [[ ! -z "${SSH_TTY}" ]]; then
		[[ ! -z "${TMUX}" ]] && export $(tmux showenv SSH_TTY)
		printf "$seq" > "$SSH_TTY"
	elif [[ ! -z "${TMUX}" ]]; then
		pane_active_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
		printf "$seq" > "$pane_active_tty"
	else
		#TODO: not working
		printf "$seq" > "$TTY"
	fi
}

"$@"
