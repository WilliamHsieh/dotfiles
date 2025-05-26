{ pkgs, dotfiles, ... }:
let
  inherit (dotfiles) username;
in
{
  environment.systemPackages = [
    pkgs.xquartz
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = dotfiles.hostname;

  users.users."${username}" = {
    description = dotfiles.fullname;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  # for login shell
  programs.zsh.enable = true; # default shell on catalina

  nix-homebrew = {
    enable = true;
    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;
    user = dotfiles.username;
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
      "mcbopomofo"
      "spotify"
      "discord"
      "karabiner-elements"
      "chatgpt"

      "jordanbaird-ice"
      "itsycal"
      "battery"

      "vmware-fusion"
      "utm"
    ];
    # only work if the app is already acquired by your apple id
    masApps = {
      "Dropover - Easier Drag & Drop" = 1355679052;
      "Hand Mirror" = 1502839586;
      "RunCat" = 1429033973;
    };
  };

  # NOTE: some of the value are not reflected instantly
  # check the value by 'defaults read NSGlobalDomain InitialKeyRepeat'
  # re-login to apply config https://github.com/LnL7/nix-darwin/issues/1207
  system = {
    primaryUser = username;
    defaults = {
      NSGlobalDomain = {
        # hold 'ctrl+command' to activate, additional 'option' to tile the window
        NSWindowShouldDragOnGesture = true;

        KeyRepeat = 2;
        InitialKeyRepeat = 15;

        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        "com.apple.keyboard.fnState" = true;
        "com.apple.trackpad.scaling" = 2.8;
        "com.apple.mouse.tapBehavior" = 1;
      };
      controlcenter = {
        Bluetooth = true;
        # Weather = true;
      };
      dock = {
        tilesize = 56;
        largesize = 100;
        magnification = true;
        mru-spaces = false;
        scroll-to-open = true;
        persistent-others = [
          "/Users/${username}/Documents"
          "/Users/${username}/Downloads"
        ];
      };
      trackpad = {
        Dragging = true;
        Clicking = true;
        TrackpadThreeFingerDrag = true;
        TrackpadThreeFingerTapGesture = 2;
      };
      finder = {
        FXPreferredViewStyle = "clmv";
        NewWindowTarget = "Home";
      };
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

      # set `AppleFontSmoothing` to 0
      # ref: https://github.com/alacritty/alacritty/commit/2a676dfad837d1784ed0911d314bc263804ef4ef
      defaults write -g AppleFontSmoothing -int 0
    '';
  };

  # TODO: move this setting to `nix.nix`
  nix.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
