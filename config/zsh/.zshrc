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
    [[ -d ~/.local/bin ]] && export PATH=~/.local/bin:$PATH

    # auto attach to tmux
    tmux_can_attach=$( [ -n "$PS1" ] && [ -z "$TMUX" ] && [ $SHLVL = 1 ] && echo 1 || echo 0 )
    tmux_has_session=$(tmux has-session 2> /dev/null && echo 1 || echo 0)
    (( $tmux_can_attach )) && (( $tmux_has_session )) && tmux a
# }}}


# Plugins
# {{{
    function zvm_after_init() {
      bindkey "^[f" forward-word
      bindkey "^[b" backward-word
      bindkey "^d" delete-char

      zvm_bindkey viins '^R' fzf-history-widget;

      autopair-init
    }

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

    function tmux_mark_pane() {
        (( $tmux_has_session )) || return

        if (( ! $(tmux display-message -p '#{session_attached}') )); then
            tmux display-message -N -d 2000 "[#S] job finished."
            tmux select-pane -m -t $TMUX_PANE
        fi
    }

    function precmd () {
        # ring the bell before every command
        echo -ne '\a' #tput bel

        tmux_mark_pane
    }

    function TRAPUSR1() {
      tmux_mark_pane
    }
# }}}


# Notes
# {{{
#   Ctrl-x, Ctrl-e open vim as command editor
#   Ctrl-_ is undo!
# }}}
