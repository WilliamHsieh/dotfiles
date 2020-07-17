#!/bin/bash

# backup old config files
function backup() {
	backup_dir=~/dotfiles_backup
	files=".vimrc .zshrc .tmux.conf"

	mkdir -p $backup_dir
	printf "\n"

	for file in $files; do
		if [ -f ~/$file ]; then
			echo "Moving existing $file from ~ to $backup_dir"
			mv ~/$file $backup_dir
		fi
	done

	echo ""
	echo "source ~/dotfiles/.vimrc" > ~/.vimrc
	echo "------- .vimrc updated. -------"

	echo "source ~/dotfiles/.zshrc" > ~/.zshrc
	echo "------- .zshrc updated. -------"

	echo "source ~/dotfiles/.tmux.conf" > ~/.tmux.conf
	echo "----- .tmux.conf updated. -----"
	printf "\ndone.\n"
}

# cli args
if [ $# == 0 ]; then
	read -p "Existing dotfiles will be moved to '~/dotfiles_backup'.
Do you want to start the process?  (y/n) " -n 1;

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo ""
		backup;
	elif [[ $REPLY =~ ^[Nn]$ ]]; then
		printf "\n\n----- terminated -----\n\n"
	else
		printf "\n\n----- unknown command -----\n\n"
	fi
else
	if [[ "$1" == "-y" ]]; then
		backup;
	else
		printf "\n\n----- unknown command -----\n\n"
	fi
fi;
