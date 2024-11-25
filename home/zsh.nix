{ inputs, pkgs, config, lib, dotfiles, isSystemConfig, ... }:
let
  dotDir = "${config.home.homeDirectory}/${dotfiles.home.dotDir}";
  aliases = {
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

    sudo = ''sudo -E env "PATH=$PATH" '';
    pythonServer = "python3 -m http.server";
    cpcmd = "fc -ln -1 | awk '{$1=$1}1' | tee /dev/fd/2 | yank";

    dotswitch =
      let
        cmd = (
          if isSystemConfig then
            (if pkgs.stdenv.isLinux then "sudo nixos-rebuild" else "darwin-rebuild")
          else
            "home-manager"
        );
      in
      "${cmd} switch --flake ${dotDir} --show-trace";
  };
in
{
  home.shellAliases = pkgs.lib.mkMerge [
    aliases
    (pkgs.lib.mkIf pkgs.stdenv.isLinux {
      visudo = "${pkgs.sudo}/bin/visudo";
    })
    (pkgs.lib.mkIf pkgs.stdenv.isDarwin {
      ldd = "otool -L";
    })
  ];

  home.packages = [
    pkgs.zsh-forgit
  ];

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
    initExtraFirst =
      let
        instantPrompt = "${config.xdg.cacheHome}/p10k-instant-prompt-\${(%):-%n}.zsh";
        nixProfile = "${config.home.profileDirectory}/etc/profile.d/nix.sh";
        sourceIfExists = file: "[[ -r ${file} ]] && source ${file}";
      in
        /* bash */ ''
        # p10k instant prompt
        echo ""
        ${sourceIfExists "${instantPrompt}"}

        # source nix profile
        ${sourceIfExists "${nixProfile}"}
      '';
    initExtraBeforeCompInit = /* bash */ ''
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions
      fpath+=${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/extract
      fpath+=${dotDir}/config/zsh/autoload
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
    initExtra = with pkgs; /* bash */ ''
      # completion
      source ${oh-my-zsh}/share/oh-my-zsh/lib/completion.zsh
      zstyle ":completion:*" list-colors "''${(s.:.)LS_COLORS}"
      source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # plugins
      source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      source ${zsh-abbr}/share/zsh/zsh-abbr/abbr.plugin.zsh
      source ${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      source ${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh

      # vi-mode
      ZVM_VI_ESCAPE_BINDKEY=kj
      source ${zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # theme
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/${config.programs.zsh.dotDir}/.p10k.zsh

      # other settings
      source ${dotDir}/config/zsh/.zshrc
    '';
  };

  xdg.configFile = {
    "zsh/abbreviations".text = /* bash */ ''
      abbr "s"="sudo"
      abbr "b"="bat"
      abbr "n"="nvim"
      abbr "g"="git"
      abbr "gf"="git forgit"
      abbr -g "-h"="--help"
    '';
  };
}
