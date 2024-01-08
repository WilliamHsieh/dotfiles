{ inputs, pkgs, config, lib, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
in
{
  programs.zsh = {
    enable = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    autocd = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    initExtraFirst = ''
      # p10k instant prompt
      echo ""
      if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # source nix profile
      if [[ -r "${config.xdg.stateHome}/nix/profiles/profile/etc/profile.d/nix.sh" ]]; then
        source "${config.xdg.stateHome}/nix/profiles/profile/etc/profile.d/nix.sh"
      fi
    '';
    shellAliases = {
      ls = "eza";
      l = "eza -l";
      la = "eza -lag --icons=auto";
      ll = "eza -lag --icons=auto -X";

      gst = "git status";
      gco = "git checkout";
      glgg = "git log --graph";

      mv = "mv -i";
      cp = "cp -i";
      rm = "trash";
      pythonServer = "python3 -m http.server";
    };
    initExtraBeforeCompInit = ''
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions
      fpath+=${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/extract
      fpath+=${dotfilesDir}/config/zsh/autoload
      autoload -Uz true_colors

      # HACK: https://github.com/zsh-users/zsh-syntax-highlighting/issues/67#issuecomment-1728953
      autoload -Uz select-word-style
      select-word-style bash
    '';
    # TODO: change to -i?
    completionInit = "autoload -Uz compinit && compinit -u";
    initExtra = with pkgs; ''
      # zsh-defer
      source ${zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh

      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/${config.programs.zsh.dotDir}/.p10k.zsh

      zsh-defer source ${oh-my-zsh}/share/oh-my-zsh/lib/completion.zsh
      zsh-defer zstyle ":completion:*" list-colors "''${(s.:.)LS_COLORS}"

      zsh-defer source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      zsh-defer source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      zsh-defer source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

      zsh-defer source ${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      zsh-defer autopair-init

      zsh-defer source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      zsh-defer source ${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh

      zsh-defer source ${zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      ZVM_VI_INSERT_ESCAPE_BINDKEY=kj

      # HACK: https://github.com/jeffreytse/zsh-vi-mode/issues/242
      ZVM_INIT_MODE=sourcing

      # HACK: https://github.com/jeffreytse/zsh-vi-mode/issues/237
      function dotfiles_fzf_history_widget() {
        fzf-history-widget "$@";
        zle .reset-prompt; # This is the workaround
      }
      zsh-defer zvm_define_widget dotfiles_fzf_history_widget;
      zsh-defer zvm_bindkey viins '^R' dotfiles_fzf_history_widget;

      source ${dotfilesDir}/config/zsh/.zshrc
    '';
  };
}
