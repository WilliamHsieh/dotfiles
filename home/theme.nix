{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    glow
  ];

  home.sessionVariables = {
    # HACK: https://github.com/sharkdp/bat/issues/2578
    LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p";
  };

  xdg.configFile = {
    "glow/glow.yml".text = /* yaml */ ''
      # style name or JSON path (default "auto")
      style: ${builtins.fetchurl {
        url = "https://github.com/catppuccin/glamour/releases/download/v1.0.0/mocha.json";
        sha256 = "190p7z2hacpd63r7iq2j92h9hj3akfc631zaaxhhrqwbsx19y7ag";
      }}
      # show local files only; no network (TUI-mode only)
      local: false
      # mouse support (TUI-mode only)
      mouse: true
      # use pager to display markdown
      pager: true
      # word-wrap at width
      width: 100
    '';
  };

  programs.bat = {
    enable = true;
    themes =
      let
        catppuccin-theme = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "b19bea35a85a32294ac4732cad5b0dc6495bed32";
          sha256 = "sha256-POoW2sEM6jiymbb+W/9DKIjDM1Buu1HAmrNP0yC2JPg=";
        };
        getTheme = style: {
          "catppuccin-${lib.toLower style}" = {
            src = catppuccin-theme;
            file = "themes/Catppuccin ${style}.tmTheme";
          };
        };
        getThemes = styles:
          builtins.foldl' (acc: style: acc // (getTheme style)) { } styles;
      in
      getThemes [ "Frappe" "Latte" "Macchiato" "Mocha" ];
    config = {
      theme = "catppuccin-macchiato";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };
}
