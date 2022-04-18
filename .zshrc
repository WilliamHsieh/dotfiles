#|   _____    _                        __ _         |#
#|  |__  /___| |__     ___ ___  _ __  / _(_) __ _   |#
#|    / // __| '_ \   / __/ _ \| '_ \| |_| |/ _` |  |#
#|   / /_\__ \ | | | | (_| (_) | | | |  _| | (_| |  |#
#|  /____|___/_| |_|  \___\___/|_| |_|_| |_|\__, |  |#
#|                                          |___/   |#

# General
# {{{
    # auto attach to tmux
    [ -n "$PS1" ] && [ -z "$TMUX" ] && $(tmux has-session 2> /dev/null) && tmux a

    # zinit
    [[ -e ~/.local/share/zinit ]] || sh -c "$(curl -fsSL https://git.io/zinit-install)"
    source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit

    # export
    export PATH=$HOME/.local/bin:$PATH
    export LANG=en_US.UTF-8
    export LC_ALL=C.UTF-8

    # prompt
    [ -x "$(command -v starship)" ] || BIN_DIR="$HOME/.local/bin" sh -c "$(curl -fsSL https://starship.rs/install.sh)"
    source <(starship init zsh --print-full-init)

    # load platform specific settings
    [[ -e ~/.local.zsh ]] && source ~/.local.zsh
# }}}


# Plugins
# {{{
    zinit light-mode for OMZL::history.zsh

    # turbo mode
    zinit wait lucid light-mode for \
        atinit"zicompinit; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
        atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
        blockf atclone"zinit creinstall -q ." atpull"%atclone" zsh-users/zsh-completions \
        agkozak/zsh-z \
        felixr/docker-zsh-completion \
        as"completion" https://github.com/felixr/docker-zsh-completion/blob/master/_docker \
        atload'
            bindkey -M menuselect "h" vi-backward-char
            bindkey -M menuselect "j" vi-down-line-or-history
            bindkey -M menuselect "k" vi-up-line-or-history
            bindkey -M menuselect "l" vi-forward-char
            zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
        ' OMZL::completion.zsh \
        OMZL::theme-and-appearance.zsh \
        OMZL::key-bindings.zsh \
        OMZL::directories.zsh \
        OMZP::cp \
        OMZP::git \
        OMZP::extract \
        as="completion" OMZP::extract/_extract \
        as="completion" OMZP::pip/_pip \
        atclone"pip3 install --user thefuck; thefuck --alias > init.zsh" \
            atpull"%atclone" src"init.zsh" OMZP::thefuck
# }}}


# Others
# {{{
    alias mv='mv -i'
    alias cp='cp -i'
    alias rm="trash"

    alias pythonServer="python3 -m http.server"
    alias true_colors="bash ~/dotfiles/scripts.sh true_colors"

    alias vimconfig="vim ~/.vimrc"
    alias zshconfig="vim ~/.zshrc"
    alias tmuxconfig="vim ~/.tmux.conf"
    alias alaconfig="vim ~/dotfiles/.alacritty.yml"

    # platform specific
    if uname -r | grep -i -q 'microsoft'; then
        alias cmd="cmd.exe"
        alias open="explorer.exe"
        alias pbcopy="clip.exe"
        alias pbpaste="powershell.exe Get-Clipboard"

        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
        export LIBGL_ALWAYS_INDIRECT=1
    elif uname | grep -i -q 'Linux'; then
        alias pbcopy="bash ~/dotfiles/scripts.sh yank"
    else
        source <(gdircolors)
    fi

    # make sure the cursor is constantly block
    cursor_shape="\e[2 q"
    if [ -n "$TMUX" ]; then
        echo -ne "\ePtmux;\e$cursor_shape\e\\"
    else
        echo -ne $cursor_shape
    fi

    # ring the bell before every command
    precmd () {
        echo -ne '\a' #tput bel
    }
# }}}


# Notes
# {{{
#   Ctrl-x, Ctrl-e open vim as command editor
# }}}
