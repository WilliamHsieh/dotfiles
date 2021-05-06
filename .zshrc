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
	plugins=(git extract z cp docker docker-compose colored-man-pages gitignore)

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
	# Set personal aliases, overriding those provided by oh-my-zsh libs,
	# plugins, and themes. Aliases can be placed here, though oh-my-zsh
	# users are encouraged to define aliases within the ZSH_CUSTOM folder.
	# For a full list of active aliases, run `alias`.

	alias rm="rm -i"
	alias ls='LC_COLLATE=C ls -h --color --group-directories-first'

	alias vimconfig="vim ~/.vimrc"
	alias zshconfig="vim ~/.zshrc"
	alias tmuxconfig="vim ~/.tmux.conf"
	alias alaconfig="vim ~/dotfiles/.alacritty.yml"

	alias pythonServer="python3 -m http.server"
	alias phpServer="php -S 127.0.0.1:8000"
	alias kaggle="~/.local/bin/kaggle"

	# based on platform
	if uname -r | grep -i -q 'microsoft'; then
		alias cmd="cmd.exe"
		alias open="explorer.exe"
		alias pbcopy="clip.exe"
		alias pbpaste="powershell.exe Get-Clipboard"
	elif uname | grep -i -q 'Linux'; then
		function pbcopy() {
			# get data either from stdin or from file
			buf=$(cat "$@")
			buflen=$( printf %s "$buf" | wc -c )

			# warn if exceeds maxlen
			maxlen=74994
			if [ "$buflen" -gt "$maxlen" ]; then
				printf "input is %d bytes too long" "$(( buflen - maxlen ))" >&2
			fi

			# build up OSC 52 ANSI escape sequence
			seq="\033]52;c;$( printf %s "$buf" | base64 -w0 )\a"
			seq="\033Ptmux;\033$seq\033\\"
			[[ ! -z "${SSH_TTY}" ]] && [[ ! -z "${TMUX}" ]] && export $(tmux showenv)

			# print sequence based on enviornment
			if [[ ! -z "${SSH_TTY}" ]]; then
				printf "$seq" > "$SSH_TTY"
			elif [[ ! -z "${TMUX}" ]]; then
				pane_active_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
				printf "$seq" > "$pane_active_tty"
			else
				printf "$seq"
			fi
		}
	elif uname | grep -i -q 'Darwin'; then
		alias date="gdate" #brew install coreutils
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

	# Based on: https://gist.github.com/XVilka/8346728
	function true_colors() {
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
