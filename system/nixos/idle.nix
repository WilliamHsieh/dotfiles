{ pkgs, ... }:

let
  lockScreenTimeout = 600; # seconds
  powerOffMonitorTimeout = lockScreenTimeout + 1; # seconds

  powerOffMonitorCmd = "niri msg action power-off-monitors";
  lockCmd = "pidof hyprlock || hyprlock";
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
        ${pkgs.swayidle}/bin/swayidle -w timeout ${toString powerOffMonitorTimeout} '${powerOffMonitorCmd}' timeout ${toString lockScreenTimeout} '${lockCmd}' before-sleep '${lockCmd}'
      '';
      Restart = "on-failure";
    };
  };
}
