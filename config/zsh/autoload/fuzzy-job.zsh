# Fuzzy job control — pick a suspended job with sk (skim) and fg / bg it.
# Bindings: Alt+W = fg, Alt+S = bg.
#
# Sourced from both home-config/.zshrc (non-nix) and config/zsh/.zshrc (nix)
# so the binding behaves the same on every machine. Requires `sk` on PATH.

_fj_pick_job() {
  local tmpfile=${TMPDIR:-/tmp}/.zsh_jobs_$$
  jobs > "$tmpfile" 2>/dev/null
  sk --height 40% --reverse < "$tmpfile" | grep -oP '^\[\K\d+'
  command rm -f "$tmpfile"
}

_fj_fg_widget() {
  local job
  job=$(_fj_pick_job)
  if [[ -n "$job" ]]; then
    BUFFER="fg %$job"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N _fj_fg_widget

_fj_bg_widget() {
  local job
  job=$(_fj_pick_job)
  if [[ -n "$job" ]]; then
    BUFFER="bg %$job"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N _fj_bg_widget

# Bind across keymaps because zsh-vi-mode + oh-my-zsh switch the active keymap
# at different points during startup.
for _fj_km in main viins vicmd emacs; do
  bindkey -M $_fj_km '^[w' _fj_fg_widget
  bindkey -M $_fj_km '^[s' _fj_bg_widget
done
unset _fj_km
