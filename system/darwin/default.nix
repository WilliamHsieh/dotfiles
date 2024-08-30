{ inputs, config, pkgs, ... }:
let
  username = (import ../../home/config.nix).user;
in
{
  environment.systemPackages =
    [
      pkgs.spotify
      pkgs.discord
      pkgs.xquartz
    ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = (import ../config.nix).host;

  services.karabiner-elements.enable = true;

  users.users."${username}" = {
    description = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # for login shell
  programs.zsh.enable = true; # default shell on catalina

  homebrew = {
    enable = true;
    casks = [
      "google-chrome"
      "google-drive"
      "raycast"
      "rectangle"
      "logi-options+"
      "vmware-fusion"
      "hammerspoon"
      "skype"
      "arc"
    ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "JetBrainsMono"
        "CodeNewRoman"
        "Meslo"
        "FiraCode"
        "DroidSansMono"
      ];
    })
  ];

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        "com.apple.keyboard.fnState" = true;
      };
      dock = {
        largesize = 100;
        magnification = true;
        mru-spaces = false;
        persistent-others = [
          "/Users/${username}/Documents"
          "/Users/${username}/Downloads"
        ];
      };
      trackpad = {
        Dragging = true;
      };
      finder.FXPreferredViewStyle = "icnv";
      # universalaccess = {
      #   closeViewScrollWheelToggle = true;
      #   closeViewZoomFollowsFocus = true;
      # };
    };

    # how to only apply internal keyboard?
    keyboard = {
      enableKeyMapping = true;
      # swapLeftCommandAndLeftAlt = true;
      # swapLeftCtrlAndFn = true;
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
