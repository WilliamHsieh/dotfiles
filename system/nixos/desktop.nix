{ inputs, pkgs, ... }:

{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    # These modules are still unavailable on stable.
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/wayland/noctalia.nix"
    "${inputs.nixpkgs-unstable}/nixos/modules/services/display-managers/noctalia-greeter.nix"
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mcbopomofo
      fcitx5-material-color
    ];
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    package = pkgs.unstable.noctalia-greeter;
    cursorTheme = {
      package = pkgs.xcursor-pro;
      name = "XCursor-Pro-Dark";
    };
    settings = {
      cursor.size = 16;
      keyboard.layout = "us";
    };
  };

  programs.noctalia = {
    enable = true;
    package = pkgs.unstable.noctalia;
    recommendedServices.enable = true;
  };

  programs.niri = {
    enable = true;
  };

  # Noctalia provides the session authentication agent; retain the system authority.
  security.polkit.enable = true;

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland
    cava # console audio visualizer
    libnotify # notification library
    xwayland-satellite
    pulseaudio
    brightnessctl
  ];
}
