# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, dotfiles, ... }:

{
  imports = [
    ./hardware.nix
    ./logiops.nix
    inputs.niri.nixosModules.niri
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Limit the number of boot entries
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  security.pki.certificateFiles = [
    ./synology-intranet.pem
  ];

  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_TW.UTF-8";
    LC_IDENTIFICATION = "zh_TW.UTF-8";
    LC_MEASUREMENT = "zh_TW.UTF-8";
    LC_MONETARY = "zh_TW.UTF-8";
    LC_NAME = "zh_TW.UTF-8";
    LC_NUMERIC = "zh_TW.UTF-8";
    LC_PAPER = "zh_TW.UTF-8";
    LC_TELEPHONE = "zh_TW.UTF-8";
    LC_TIME = "zh_TW.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mcbopomofo
      fcitx5-material-color
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${dotfiles.username} = {
    isNormalUser = true;
    description = dotfiles.fullname;
    extraGroups = [
      "wheel" # For sudo access
      "networkmanager" # For network management
      "video" # For display/graphics access
      "input" # For keyboard/mouse access from waybar
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      discord
      spotify
    ];
  };

  # for running nearly every binaries
  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
  };

  # AppImage files can be invoked directly as if they were normal programs
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.waybar = {
    enable = true;
    # using unstable for niri support
    package = pkgs.unstable.waybar;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kitty
    wezterm

    firefox
    google-chrome
    thunderbird
    xwayland

    gnome-tweaks
    gnome-shell-extensions

    # window managers (niri)
    cava # console audio visualizer
    fuzzel # fuzzy launcher
    libnotify # notification library
    xwayland-satellite
    networkmanagerapplet
    pulseaudio
    pavucontrol
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = (import ../../lib { inherit inputs; }).stateVersion;
}
