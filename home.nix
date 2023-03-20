{ pkgs, ... }: {
  home = {
    username = "william";
    homeDirectory = "/home/william";
    stateVersion = "22.11";
    packages = with pkgs; [
      # essential
      git

      # editor
      neovim
      ripgrep
      fd
      unzip

      # shell
      zsh
      starship
      exa
      trash-cli

      # terminal multiplexer
      tmux
      fzf

      # common tools
      direnv
      jq
      bat
      delta
      comma
      htop
    ];
  };

  programs.home-manager.enable = true;

  programs.direnv.enable = true;

  programs.git = {
    enable = true;
    userName = "William Hsieh";
    userEmail = "wh31110@gmail.com";
    delta = {
      enable = true;
      options = {
        true-color = "always";
        syntax-theme = "base16-256";
      };
    };
    ignores = [
      "*.swp"
      ".DS_Store"
    ];
    extraConfig = {
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      pull = {
        rebase=true;
      };
      mergetool.prompt = "false";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      # TODO: https://github.com/catppuccin/bat
      theme = "base16-256";
    };
  };
}
