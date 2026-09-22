{
  pkgs,
  config,
  dotfiles,
  ...
}:
let
  symlinkDotfiles = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles.directory}/${path}";
in
{
  # Preserve the terminal previously selected in Fuzzel for Terminal=true apps.
  home.sessionVariables.TERMINAL = "${pkgs.alacritty}/bin/alacritty";

  xdg.configFile = {
    "niri".source = symlinkDotfiles "config/niri";
    # GUI changes are kept separately by Noctalia in ~/.local/state/noctalia.
    "noctalia/config.toml".source = (pkgs.formats.toml { }).generate "noctalia.toml" {
      shell.polkit_agent = true;
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
      };
      idle.behavior = {
        lock = {
          enabled = true;
          timeout = 600;
          action = "lock";
        };
        screen-off = {
          enabled = true;
          timeout = 630;
          action = "screen_off";
        };
      };
    };
    # Keep the standalone Bluetooth manager available without a duplicate tray icon.
    "autostart/blueman.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Blueman Applet
      Hidden=true
    '';
    "autostart/nm-applet.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=NetworkManager Applet
      Hidden=true
    '';
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
}
