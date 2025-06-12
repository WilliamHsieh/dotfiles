{ pkgs, inputs, dotfiles, ... }:
{
  home-manager = {
    users.${dotfiles.username} = import ../../home;

    useGlobalPkgs = true;
    # useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs dotfiles;
      isSystemConfig = true;
    };
  };

  nixpkgs.hostPlatform = dotfiles.system;
  networking.hostName = dotfiles.hostname;

  # for default login shell
  programs.zsh.enable = true;
}
