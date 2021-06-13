#|   _____    _                        __ _         |#
#|  |__  /___| |__     ___ ___  _ __  / _(_) __ _   |#
#|    / // __| '_ \   / __/ _ \| '_ \| |_| |/ _` |  |#
#|   / /_\__ \ | | | | (_| (_) | | | |  _| | (_| |  |#
#|  /____|___/_| |_|  \___\___/|_| |_|_| |_|\__, |  |#
#|                                          |___/   |#

# Default options
# {{{
	# auto attach to tmux
	if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
		$(tmux has-session 2> /dev/null) && tmux a
	fi

	# add ~/.local.zsh to load platform specific settings
	[[ -e ~/.local.zsh ]] && source ~/.local.zsh

	# If you come from bash you might have to change your $PATH.
	export PATH=$HOME/bin:/usr/local/bin:$PATH

	# Path to your oh-my-zsh installation.
	export ZSH=~/.oh-my-zsh

	# Set name of the theme to load. Optionally, if you set this to "random"
	# it'll load a random theme each time that oh-my-zsh is loaded.
	# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
	ZSH_THEME="steeef"

	# Uncomment the following line to use case-sensitive completion.
	# CASE_SENSITIVE="true"

	# Uncomment the following line to use hyphen-insensitive completion. Case
	# sensitive completion must be off. _ and - will be interchangeable.
	HYPHEN_INSENSITIVE="true"

	# Uncomment the following line to disable bi-weekly auto-update checks.
	# DISABLE_AUTO_UPDATE="true"

	# Uncomment the following line to change how often to auto-update (in days).
	export UPDATE_ZSH_DAYS=30

	# Uncomment the following line to disable colors in ls.
	# DISABLE_LS_COLORS="true"

	# Uncomment the following line to disable auto-setting terminal title.
	DISABLE_AUTO_TITLE="true"

	# Uncomment the following line to enable command auto-correction.
	# ENABLE_CORRECTION="true"

	# Uncomment the following line to display red dots whilst waiting for completion.
	COMPLETION_WAITING_DOTS="true"

	# Uncomment the following line if you want to disable marking untracked files
	# under VCS as dirty. This makes repository status check for large repositories
	# much, much faster.
	# DISABLE_UNTRACKED_FILES_DIRTY="true"

	# Uncomment the following line if you want to change the command execution time
	# stamp shown in the history command output.
	# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
	# HIST_STAMPS="mm/dd/yyyy"

	# Would you like to use another custom folder than $ZSH/custom?
	# ZSH_CUSTOM=/path/to/new-custom-folder

	# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
	# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
	# Example format: plugins=(rails git textmate ruby lighthouse)
	# Add wisely, as too many plugins slow down shell startup.
	plugins=(git extract z cp docker colored-man-pages gitignore)
	zstyle ':completion:*:*:docker:*' option-stacking yes
	zstyle ':completion:*:*:docker-*:*' option-stacking yes

	source $ZSH/oh-my-zsh.sh

	# export MANPATH="/usr/local/man:$MANPATH"

	# You may need to manually set your language environment
	# export LANG=en_US.UTF-8

	# Preferred editor for local and remote sessions
	export EDITOR='vim'
	# if [[ -n $SSH_CONNECTION ]]; then
	#   export EDITOR='vim'
	# else
	#   export EDITOR='mvim'
	# fi

	# Compilation flags
	# export ARCHFLAGS="-arch x86_64"

	# ssh
	# export SSH_KEY_PATH="~/.ssh/rsa_id"
# }}}


# Aliases
# {{{
	alias rm="rm -i"
	alias ls='LC_COLLATE=C ls -h --color --group-directories-first'
	alias pythonServer="python3 -m http.server"
	alias true_colors="sh ~/dotfiles/scripts.sh true_colors"

	alias vimconfig="vim ~/.vimrc"
	alias zshconfig="vim ~/.zshrc"
	alias tmuxconfig="vim ~/.tmux.conf"
	alias alaconfig="vim ~/dotfiles/.alacritty.yml"

	# based on platform
	if uname -r | grep -i -q 'microsoft'; then
		alias cmd="cmd.exe"
		alias open="explorer.exe"
		alias pbcopy="clip.exe"
		alias pbpaste="powershell.exe Get-Clipboard"
	elif uname | grep -i -q 'Linux'; then
		alias pbcopy="sh ~/dotfiles/scripts.sh yank"
	elif uname | grep -i -q 'Darwin'; then
		#brew install coreutils
		alias date="gdate"
		alias ls='LC_COLLATE=C gls -h --color --group-directories-first'
	fi
# }}}


# Others
# {{{
	# make sure the cursor is constantly block
	cursor_shape="\e[2 q"
	if [ -n "$TMUX" ]; then
		echo -ne "\ePtmux;\e$cursor_shape\e\\"
	else
		echo -ne $cursor_shape
	fi

	# export DISPLAY for wsl2
	if uname -r | grep -i -q 'microsoft'; then
		export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
		export LIBGL_ALWAYS_INDIRECT=1
	fi

	# https://gist.github.com/knadh/123bca5cfdae8645db750bfb49cb44b0
	function preexec() {
		timer=$(($(date +%s%0N)/1000000))
	}

	function precmd() {
		if [ $timer ]; then
			now=$(($(date +%s%0N)/1000000))
			elapsed=$(($now-$timer))
			[[ $elapsed -gt 1000 ]] && msg=$(($elapsed/1000)) || msg="${elapsed}m"

			export RPROMPT="%F{cyan}${msg}s %{$reset_color%}"
			unset timer
		fi
	}
# }}}


# Notes
# {{{
#	Ctrl-x, Ctrl-e open vim as command editor
# }}}
