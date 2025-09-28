{ pkgs, ... }:

let
  lockScreenTimeout = 600; # seconds
  powerOffMonitorTimeout = lockScreenTimeout + 1; # seconds
in
{
  programs.hyprlock.enable = true;

  # https://github.com/YaLTeR/niri/wiki/Example-systemd-Setup
  systemd.user.services.idle-and-lock = {
    enable = true;
    path = with pkgs; [ hyprlock ];

    wantedBy = [ "graphical-session.target" ];

    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w timeout ${toString powerOffMonitorTimeout} 'niri msg action power-off-monitors' timeout ${toString lockScreenTimeout} 'hyprlock' before-sleep 'hyprlock'
      '';
      Restart = "on-failure";
    };
  };
}
