{ pkgs, dotfiles, ... }:

{
  environment.systemPackages = with pkgs; [
    protonup-ng
    # lutris
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${dotfiles.username}/.steam/root/compatibilitytools.d";
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;
}
