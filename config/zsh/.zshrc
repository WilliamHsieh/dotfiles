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
    [[ -d ~/.cargo/bin ]] && export PATH=~/.cargo/bin:$PATH

    # auto attach to tmux
    # FIX: add condition to determine when TMUX is disabled through F10
    tmux_can_attach=$( [ -n "$PS1" ] && [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ] && [ $SHLVL = 1 ] && echo 1 || echo 0 )
    tmux_has_session=$(tmux has-session 2> /dev/null && echo 1 || echo 0)
    if (( $tmux_can_attach )) && (( $tmux_has_session )); then
      __tmux_auto_attach() {
        add-zsh-hook -d precmd __tmux_auto_attach
        [[ -t 0 ]] && tmux a
      }
      add-zsh-hook precmd __tmux_auto_attach
    fi

    # HACK: https://github.com/chisui/zsh-nix-shell/issues/19
    if [[ -n $IN_NIX_SHELL && -n $VIRTUAL_ENV ]]; then
      typeset -U PATH
      export PATH="$VIRTUAL_ENV/bin:$PATH"
    fi
# }}}


# Plugins
# {{{
    function zvm_after_init() {
      zvm_bindkey viins '^[f' forward-word
      zvm_bindkey viins '^[b' backward-word
      zvm_bindkey viins '^[[1;3C' forward-word
      zvm_bindkey viins '^[[1;3D' backward-word
      zvm_bindkey viins '^d' delete-char
      zvm_bindkey viins '^[d' kill-word
      bindkey '^f' live_grep

      zvm_bindkey viins '^T' skim-file-widget
      zvm_bindkey viins '^R' skim-history-widget
      zvm_bindkey viins '^[c' skim-cd-widget

      # navi cheatsheet widget (Ctrl-g)
      eval "$(navi widget zsh)"
      bindkey '^g' _navi_widget

      # fuzzy job control (Alt+W = fg, Alt+S = bg)
      zvm_bindkey viins '^[w' _fj_fg_widget
      zvm_bindkey viins '^[s' _fj_bg_widget

      autopair-init
    }

    # zvm_after_init 在 re-source 時不會重新執行，所以在外面也綁一次
    bindkey '^f' live_grep
    eval "$(navi widget zsh)"
    bindkey '^g' _navi_widget
    bindkey '^[w' _fj_fg_widget
    bindkey '^[s' _fj_bg_widget

    function zvm_config() {
      ZVM_KEYTIMEOUT=0.05
    }

    # TODO: shlvl ❯❯❯❯❯
    # https://github.com/romkatv/powerlevel10k/issues/2178

    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0 '
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
    typeset -g POWERLEVEL9K_NIX_SHELL_INFER_FROM_PATH=true
    # typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir

    # NOTE: temporary fix for
    # https://github.com/romkatv/powerlevel10k/issues/2584, https://github.com/romkatv/powerlevel10k/issues/1554
    # waiting for https://github.com/zsh-users/zsh-autosuggestions/pull/753
    unset ZSH_AUTOSUGGEST_USE_ASYNC

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


# Fuzzy job control (skim)
# {{{
    _fj_fg_widget() {
      local tmpfile=${TMPDIR:-/tmp}/.zsh_jobs_$$
      jobs > "$tmpfile" 2>/dev/null
      local job
      job=$(sk --height 40% --reverse < "$tmpfile" | grep -oP '^\[\K\d+')
      command rm -f "$tmpfile"
      if [[ -n "$job" ]]; then
        BUFFER="fg %$job"
        zle accept-line
      fi
      zle reset-prompt
    }
    zle -N _fj_fg_widget

    _fj_bg_widget() {
      local tmpfile=${TMPDIR:-/tmp}/.zsh_jobs_$$
      jobs > "$tmpfile" 2>/dev/null
      local job
      job=$(sk --height 40% --reverse < "$tmpfile" | grep -oP '^\[\K\d+')
      command rm -f "$tmpfile"
      if [[ -n "$job" ]]; then
        BUFFER="bg %$job"
        zle accept-line
      fi
      zle reset-prompt
    }
    zle -N _fj_bg_widget
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
        alias pbcopy="bash ~/.config/dotfiles/config/zsh/autoload/yank"
        alias open="xdg-open"
    fi

    function tmux_mark_pane() {
        [[ -v TMUX_PANE ]] || return

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
