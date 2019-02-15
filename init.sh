#!/bin/bash

function init() {
	backup_dir=~/dotfiles_backup
	files=".vimrc .zshrc .tmux.conf"

	mkdir -p $backup_dir
	printf "\n\n"

	for file in $files; do
		if [ -f ~/$file ]; then
			echo "Moving existing $file from ~ to $backup_dir"
			mv ~/$file $backup_dir
		fi
	done

	echo ""
	echo "source ~/dotfiles/main.vimrc" > ~/.vimrc
	echo "------- .vimrc updated. -------"

	echo "source ~/dotfiles/.zshrc" > ~/.zshrc
	echo "------- .zshrc updated. -------"

	echo "source ~/dotfiles/.tmux.conf" > ~/.tmux.conf
	echo "----- .tmux.conf updated. -----"
	printf "\ndone.\n"
}

read -p "Existing dotfiles will be moved to '~/dotfiles_backup'.
Do you want to start the process?  (y/n) " -n 1;	

if [[ $REPLY =~ ^[Yy]$ ]]; then			
	init;
else
	echo "----- terminated. -----"
fi;
