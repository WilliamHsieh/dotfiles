{ pkgs, ... }: {
  home = {
    username = "william";
    homeDirectory = "/home/william";
    stateVersion = "22.11";
    packages = [
      pkgs.cowsay
    ];
  };

  programs.home-manager.enable = true;
}
