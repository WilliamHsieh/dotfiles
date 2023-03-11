{ pkgs, ... }: {
  home = {
    username = "william";
    homeDirectory = "/home/william";
    stateVersion = "22.11";
    packages = with pkgs; [
      git
      exa
      trash-cli

      neovim
      ripgrep
      fd
      unzip

      zsh
      starship

      tmux
      fzf
    ];
  };

  programs.home-manager.enable = true;
}
