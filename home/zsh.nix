{ inputs, pkgs, config, lib, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
in
{
  home.shellAliases = {
    ls = "eza --group-directories-first";
    l = "ls -l";
    la = "ls -lag --icons=auto";
    ll = "ls -lag --icons=auto -X";
    tree = "ls --tree";

    gst = "git status";
    gco = "git checkout";
    glgg = "git log --graph";

    mv = "mv -i";
    cp = "cp -i";
    rm = "trash";
    pythonServer = "python3 -m http.server";
  };

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
    initExtraFirst = /* bash */ ''
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
    initExtraBeforeCompInit = /* bash */ ''
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions
      fpath+=${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/extract
      fpath+=${dotfilesDir}/config/zsh/autoload
      autoload -Uz true_colors
      autoload -Uz yank
      autoload -Uz live_grep
      zle -N live_grep

      # HACK: https://github.com/zsh-users/zsh-syntax-highlighting/issues/67#issuecomment-1728953
      autoload -Uz select-word-style
      select-word-style bash
    '';
    # TODO: change to -i?
    completionInit = "autoload -Uz compinit && compinit -u";
    initExtra = with pkgs; /* bash */''
      # zsh-defer
      source ${zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh

      # theme
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/${config.programs.zsh.dotDir}/.p10k.zsh

      # completion
      zsh-defer source ${oh-my-zsh}/share/oh-my-zsh/lib/completion.zsh
      zsh-defer zstyle ":completion:*" list-colors "''${(s.:.)LS_COLORS}"
      zsh-defer source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # plugins
      zsh-defer source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      zsh-defer source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      zsh-defer source ${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      zsh-defer source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      zsh-defer source ${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh

      # vi-mode
      ZVM_VI_ESCAPE_BINDKEY=kj
      zsh-defer source ${zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # other settings
      source ${dotfilesDir}/config/zsh/.zshrc
    '';
  };
}
