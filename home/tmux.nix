{ pkgs, pkgs-unstable, config, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
  dataHome = "${config.xdg.dataHome}/tmux";
in
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    terminal = "xterm-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = prefix-highlight;
        extraConfig = "source-file ${dotfilesDir}/config/tmux/tmux.conf";
      }
      {
        plugin = pkgs-unstable.tmuxPlugins.fingers;
        extraConfig = "set -g @fingers-key C-f";
      }
      {
        plugin = pkgs-unstable.tmuxPlugins.t-smart-tmux-session-manager;
        extraConfig = "set -g @t-bind 'F4'";
      }
      {
        plugin = extrakto;
        extraConfig = ''
          set -g @extrakto_copy_key "ctrl-y"
          set -g @extrakto_insert_key "enter"
          set -g @extrakto_clip_tool "bash ${dotfilesDir}/config/zsh/autoload/yank"
        '';
      }
      {
        plugin = logging;
        extraConfig = ''
          set -g @save-complete-history-path "${dataHome}/log"
          set -g @save-complete-history-key 'P'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-default-processes "ssh"
          set -g @resurrect-capture-pane-contents "on"
          set -g @resurrect-dir "${dataHome}/resurrect"
        '';
      }
      tmux-fzf
    ];
  };
}
