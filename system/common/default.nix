{ inputs, dotfiles, ... }:
{
  home-manager = {
    users.${dotfiles.username} = import ../../home;

    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs dotfiles;
      isSystemConfig = true;
    };

    backupFileExtension = "nix-generated-backup";
  };

  nixpkgs.hostPlatform = dotfiles.system;
  networking.hostName = dotfiles.hostname;

  # for default login shell
  programs.zsh.enable = true;
  # compinit only run by home-manager once (home/zsh.nix completionInit)
  programs.zsh.enableCompletion = false;
}
