{ pkgs, config, dotfiles, ... }:
let
  symlinkDotfiles = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles.directory}/${path}";
in
{
  xdg.configFile = {
    "niri".source = symlinkDotfiles "config/niri";
    "waybar".source = symlinkDotfiles "config/waybar";
  };

  programs.fuzzel = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      main = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        layer = "overlay";
      };
      border = {
        width = 2;
      };
      # TODO: how to overwrite the default config?
      colors = {
        background = "#1E1E2Eff";
      };
    };
  };

  # gtk.font

  home.pointerCursor = {
    enable = pkgs.stdenv.isLinux;
    package = pkgs.xcursor-pro;
    name = "XCursor-Pro-Dark";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  services.mako = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      default-timeout = 10000;
      anchor = "top-center";
    };
  };

  services.swayosd.enable = true;
}
