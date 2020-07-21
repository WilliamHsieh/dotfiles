#!/bin/sh

# backup old config files && create symlink
function backup() {
	backup_dir=~/dotfiles_backup
	files=".vimrc .zshrc .tmux.conf"

	printf "\n"
	for file in $files; do
		if [ -f ~/$file ]; then
			echo "Moving existing $file from ~ to $backup_dir"
			mkdir -p $backup_dir
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

	printf "\ndone.\n\n"
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
