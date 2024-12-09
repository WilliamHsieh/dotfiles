{ inputs, config, pkgs, dotfiles, ... }:
let
  inherit (dotfiles.home) username;
in
{
  environment.systemPackages =
    [
      pkgs.spotify
      pkgs.discord
      pkgs.xquartz
    ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = dotfiles.darwin.hostname;

  services.karabiner-elements.enable = true;

  users.users."${username}" = {
    description = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # for login shell
  programs.zsh.enable = true; # default shell on catalina

  nix-homebrew = {
    enable = true;
    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;
    user = dotfiles.home.username;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    casks = [
      "arc"
      "google-chrome"
      "google-drive"
      "raycast"
      "heptabase"
      "logi-options+"
      "vmware-fusion"
      "utm"
      "hammerspoon"
    ];
    # only work if the app is already acquired by your apple id
    masApps = {
      "Dropover - Easier Drag & Drop" = 1355679052;
      "Hand Mirror" = 1502839586;
    };
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
      finder.FXPreferredViewStyle = "clmv";
      universalaccess = {
        # NOTE: require permission for alacritty: System Preferences > Security & Privacy > Privacy > Full Disk Access
        closeViewScrollWheelToggle = true;
        closeViewZoomFollowsFocus = true;
      };
    };

    # how to only apply internal keyboard?
    keyboard = {
      enableKeyMapping = true;
      # swapLeftCommandAndLeftAlt = true;
      # swapLeftCtrlAndFn = true;
    };

    activationScripts.postActivation.text = ''
      # Disable the sound effects on boot
      sudo nvram SystemAudioVolume=" "
    '';
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
