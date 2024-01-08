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

    # export
    export LANG=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
    export VISUAL="$(command -v nvim 2>/dev/null || command -v vim)"
    export EDITOR="$VISUAL"
    export MANPAGER='nvim +Man!'
# }}}


# Plugins
# {{{
    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0 '
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
    typeset -g POWERLEVEL9K_NIX_SHELL_INFER_FROM_PATH=true
    # typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir

    setopt auto_cd
    setopt auto_pushd
    setopt pushd_ignore_dups
    setopt pushdminus

    function d () {
      if [[ -n $1 ]]; then
        dirs "$@"
      else
        dirs -v | head -n 10
      fi

    }
    compdef _dirs d
# }}}


# Others
# {{{
    # platform specific
    if uname -r | grep -i -q 'microsoft'; then
        alias cmd="cmd.exe"
        alias open="explorer.exe"
        alias pbcopy="clip.exe"
        alias pbpaste="powershell.exe Get-Clipboard"

        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
        export LIBGL_ALWAYS_INDIRECT=1
    elif uname | grep -i -q 'Linux'; then
        alias pbcopy="bash ~/dotfiles/config/zsh/autoload/yank"
        alias open="xdg-open"
    fi

    # ring the bell before every command
    precmd () {
        echo -ne '\a' #tput bel
    }
# }}}


# Notes
# {{{
#   Ctrl-x, Ctrl-e open vim as command editor
#   Ctrl-_ is undo!
# }}}
