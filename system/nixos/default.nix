# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, dotfiles, ... }:

{
  imports = [
    ./hardware.nix
    ./logiops.nix
    ./gaming.nix
    ./idle.nix
    inputs.niri.nixosModules.niri
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401
    inputs.flatpak.nixosModules.nix-flatpak
  ];

  boot = {
    # FIX: new nvidia drivers are not backported to stable branches, the driver build might fail when kernel is updated to newer version
    # https://github.com/NixOS/nixpkgs/issues/429624
    # kernelPackages = pkgs.linuxPackages_zen;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Limit the number of boot entries
      };
      efi.canTouchEfiVariables = true;
    };
  };

  swapDevices = [{
    device = "/var/swapfile";
    size = 16 * 1024; # 16GB
  }];

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

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

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
    package = pkgs.waybar;
  };
  # check waybar service log with: `journalctl --user --follow -u waybar`
  # check waybar service status with: `systemctl --user status waybar`
  systemd.user.services.waybar.path = [
    "${pkgs.fuzzel}"
    "${pkgs.pulseaudio}"
    "${pkgs.pavucontrol}"
  ];

  # HACK: seems like 2060 max-q does not support Dynamic Boost
  systemd.services.nvidia-powerd.enable = false;

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  environment.systemPackages = with pkgs; [
    # essentials
    kitty
    firefox
    xwayland

    # tools
    localsend

    # window managers (niri)
    cava # console audio visualizer
    fuzzel # fuzzy launcher
    libnotify # notification library
    xwayland-satellite
    networkmanagerapplet
    pulseaudio
    pavucontrol
    brightnessctl
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.google.Chrome"
      "net.blix.BlueMail"
      "com.obsproject.Studio"
      "dev.vencord.Vesktop"
      "com.usebottles.bottles"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # not sure who is setting this, nix-hardware?
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # show firewall status by
  # sudo nixos-firewall-tool show
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53317 # localsend
    ];
    allowedUDPPorts = [
      53317 # localsend
    ];
  };

  system.stateVersion = "25.05";
}
