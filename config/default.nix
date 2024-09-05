{
  home = {
    username = "william";
    fullname = "William Hsieh";
    email = "wh31110@gmail.com";
    dotDir = "dotfiles"; # path relative to $HOME, this example represents `~/dotfiles`
    wsl = false;
    gui = false;
  };

  nixos = {
    # enable = true;
    hostname = "nixos-local";
    system = "x86_64-linux";
  };

  darwin = {
    # enable = true;
    hostname = "macos-local";
    system = "aarch64-darwin";
  };
}
