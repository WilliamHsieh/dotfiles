{ pkgs, lib, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };
      env = {
        TERM = "xterm-256color";
        LANG = "C.UTF-8";
      };
      font = {
        normal.family = "MesloLGMDZ Nerd Font Mono";
        size = 10.5;
      };
      window = {
        dynamic_padding = true;
        decorations = "None";
      };
      colors = {
        indexed_colors = [
          { index = 18; color = "#274d7a"; }
        ];
      };
      keyboard = {
        # NOTE: showkey -a
        bindings = [
          { key = "C"; mods = "Control|Shift"; action = "Copy"; }
          { key = "V"; mods = "Control|Shift"; action = "Paste"; }
          { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
          { key = "W"; mods = "Control|Shift"; chars = "\\u001BK"; }
          { key = "T"; mods = "Control|Shift"; chars = "\\u001BT\\u001B[21~"; }
          { key = "Tab"; mods = "Control"; chars = "\\u001B)"; }
          { key = "Tab"; mods = "Control|Shift"; chars = "\\u001B("; }
          { key = "P"; mods = "Control|Shift"; chars = "\\u0002\\u001BOS"; } # C-b f4
        ] ++ lib.optional pkgs.stdenv.isDarwin [
          { key = "B"; mods = "Command"; chars = "\\u001Bb"; } # one word left
          { key = "F"; mods = "Command"; chars = "\\u001Bf"; } # one word right
          { key = "D"; mods = "Command"; chars = "\\u001Bd"; } # delete one word right
          { key = "H"; mods = "Command"; chars = "\\u001Bh"; } # M-h
          { key = "J"; mods = "Command"; chars = "\\u001Bj"; } # M-j
          { key = "K"; mods = "Command"; chars = "\\u001Bk"; } # M-k
          { key = "L"; mods = "Command"; chars = "\\u001Bl"; } # M-l
        ];
      };
    };
  };
}
