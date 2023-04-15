#|   _____    _                        __ _         |#
#|  |__  /___| |__     ___ ___  _ __  / _(_) __ _   |#
#|    / // __| '_ \   / __/ _ \| '_ \| |_| |/ _` |  |#
#|   / /_\__ \ | | | | (_| (_) | | | |  _| | (_| |  |#
#|  /____|___/_| |_|  \___\___/|_| |_|_| |_|\__, |  |#
#|                                          |___/   |#

# General
# {{{
    # load platform specific settings
    [[ -e ~/.local.zsh ]] && source ~/.local.zsh

    # auto attach to tmux
    [ -n "$PS1" ] && [ -z "$TMUX" ] && $(tmux has-session 2> /dev/null) && tmux a

    # zinit
    source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

    # export
    export PATH=$HOME/.local/bin:$PATH
    export LANG=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
    export VISUAL="$(command -v nvim 2>/dev/null || command -v vim)"
    export EDITOR="$VISUAL"
    export MANPAGER='nvim +Man!'

    # prompt
    source <(starship init zsh --print-full-init)
# }}}


# Plugins
# {{{
    zinit light-mode for \
      OMZL::key-bindings.zsh \
      OMZL::history.zsh

    # turbo mode
    zinit wait lucid light-mode for \
        atinit"zicompinit; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
        atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
        blockf atclone"zinit creinstall -q ." atpull"%atclone" zsh-users/zsh-completions \
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
        atload'
          command -v exa &> /dev/null && alias ls="exa"
          alias l="ls -l"
          alias la="ls -lag --icons"
          alias ll="\ls -Llah"
        ' OMZL::directories.zsh \
        OMZP::cp \
        OMZP::git \
        OMZP::extract \
        as="completion" OMZP::extract/_extract \
        as="completion" OMZP::pip/_pip
# }}}


# Others
# {{{
    alias mv='mv -i'
    alias cp='cp -i'
    alias rm="trash"

    alias pythonServer="python3 -m http.server"
    alias true_colors="bash ~/dotfiles/scripts.sh true_colors"

    # key-bindings
    bindkey -s "^f" "history | fzf^M"

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
        alias open="xdg-open"
    else
        source <(gdircolors)
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
