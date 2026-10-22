{
  config,
  pkgs,
  dotfiles,
  ...
}:
let
  # Apply only to gaming processes, leaving the desktop on the AMD iGPU.
  nvidiaOffloadEnv = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    # Mesa's implicit device-selection layer otherwise puts the AMD iGPU first.
    NODEVICE_SELECT = "1";
  };
in
{
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${dotfiles.username}/.steam/root/compatibilitytools.d";
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraEnv = nvidiaOffloadEnv; };
    gamescopeSession = {
      enable = true;
      env = nvidiaOffloadEnv;
    };
  };

  programs.gamemode.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    # The GA401 hardware module supplies the AMD/NVIDIA PCI bus IDs.
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # RTX 2060 Max-Q (Turing) does not support NVIDIA Dynamic Boost.
    dynamicBoost.enable = false;
  };

  # Out-of-tree modules must be built for the selected kernel, including Zen.
  boot.extraModulePackages = [ config.boot.kernelPackages.xone ];
}
