{ pkgs, config, dotfiles, ... }:
let
  symlinkDotfiles = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles.directory}/${path}";
in
{
  xdg.configFile = {
    "niri".source = symlinkDotfiles "config/niri";
    "waybar".source = symlinkDotfiles "config/waybar";
  };

  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = true;
    settings =
      let
        sendLockSignal = "${pkgs.systemd}/bin/loginctl lock-session";
      in
      {
        general = {
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "${sendLockSignal}";
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "${sendLockSignal}";
          }
          {
            timeout = 630;
            on-timeout = "${pkgs.niri-unstable}/bin/niri msg action power-off-monitors";
          }
        ];
      };
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
